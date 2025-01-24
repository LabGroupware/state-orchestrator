## LabGroupware for API Composition + State Based Pattern Implementation

### Prerequire
- [asdf](./setup_asdf.md)


### Setup
#### コマンドセットアップ
``` sh
asdf plugin add terraform
asdf plugin add awscli
asdf plugin add kubectl
asdf plugin add helm
asdf plugin add istioctl
asdf install
```

### Debug
``` sh
kubectl run debug-pod --rm -it --image=alpine:latest -- sh
```

```sh
apk add --no-cache curl wget net-tools iproute2 bind-tools busybox-extras go
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
export PATH=$PATH:$(go env GOPATH)/bin

grpcurl --plaintext -d '{}' job-service.job-service:9090 job.v1.JobService/CreateJob
```

### Helm Push

#### Service
```sh
./helm-push.sh services-chart
```

#### Debezium Connector
``` sh
./helm-push.sh debezium-connector
```

#### Auth Server
```sh
./helm-push.sh auth-server
```

#### Kafka Stack
```sh
./helm-push.sh kafka-stack
```

#### Gateway Stack
```sh
./helm-push.sh gateway-stack
```

#### Job Stack
```sh
./helm-push.sh job-stack
```

#### Websocket Stack
```sh
./helm-push.sh websocket-stack
```

### Set
``` sh
export AWS_DEFAULT_PROFILE=terraform
aws sts get-caller-identity
export REGION=us-east-1
export SHORT_REGION=use1
export CLUSTER_NAME=LGStateUsEast1Prod
```

### Deploy
```sh
helm plugin install https://github.com/databus23/helm-diff
./prod-deploy.sh
```

### Reset
```sh
kubectl delete pods --all -n user-profile-service & pid1=$!
kubectl delete pods --all -n user-preference-service & pid2=$!
kubectl delete pods --all -n organization-service & pid3=$!
kubectl delete pods --all -n  team-service & pid4=$!
kubectl delete pods --all -n storage-service & pid5=$!
kubectl delete pods --all -n plan-service & pid6=$!
kubectl delete pods --all -n job-service & pid7=$!
kubectl delete pods --all -n web-gateway & pid8=$!
# kubectl delete pods --all -n ws-service

wait $pid1 && wait $pid2 && wait $pid3 && wait $pid4 && wait $pid5 && \
wait $pid6 && wait $pid7 && wait $pid8

kubectl delete po -n kafka kafka-connect-*
kubectl get po -n kafka

# kubectl delete po -n user-profile-service user-profile-postgres-postgresql-0 && \
# kubectl delete po -n user-preference-service user-preference-postgres-postgresql-0 && \
# kubectl delete po -n organization-service organization-postgres-postgresql-0 && \
# kubectl delete po -n team-service team-postgres-postgresql-0 && \
# kubectl delete po -n storage-service storage-postgres-postgresql-0 && \
# kubectl delete po -n plan-service plan-postgres-postgresql-0

select count(*) from user_preferences where theme is not null;

delete from team_user where team_user_id not in (select team_user_id from team_user order by created_at asc limit 20000);

# delete from team_user where user_id != 'a02a00aaa201e938c3bb0ae515451104';

kubectl exec user-profile-postgres-postgresql-0 -n user-profile-service -it -- psql -U postgres -d user_profile
kubectl exec user-preference-postgres-postgresql-0 -n user-preference-service -it -- psql -U postgres -d user_preference
kubectl exec organization-postgres-postgresql-0 -n organization-service -it -- psql -U postgres -d organization
kubectl exec team-postgres-postgresql-0 -n team-service -it -- psql -U postgres -d team
kubectl exec plan-postgres-postgresql-0 -n plan-service -it -- psql -U postgres -d plan
kubectl exec storage-postgres-postgresql-0 -n storage-service -it -- psql -U postgres -d storage

kubectl exec user-profile-postgres-postgresql-0 -n user-profile-service -- psql -U postgres -d user_profile -c "delete from user_profiles where user_id not in (select user_id from user_profiles order by created_at asc limit 10001);" && \
kubectl exec user-preference-postgres-postgresql-0 -n user-preference-service -- psql -U postgres -d user_preference -c "delete from user_preferences where user_id not in (select user_id from user_preferences order by created_at asc limit 10001);" && \
kubectl exec organization-postgres-postgresql-0 -n organization-service -- psql -U postgres -d organization -c " delete from organization_user where organization_id not in (select organization_id from organizations order by created_at asc limit 10000); delete from organizations where organization_id not in (select organization_id from organizations order by created_at asc limit 10000);" && \
kubectl exec team-postgres-postgresql-0 -n team-service -- psql -U postgres -d team -c " delete from team_user where team_id not in (select team_id from teams order by created_at asc limit 10000); delete from teams where team_id not in (select team_id from teams order by created_at asc limit 10000);" && \
kubectl exec plan-postgres-postgresql-0 -n plan-service -- psql -U postgres -d plan -c " delete from task_attachments where task_id not in (select task_id from tasks order by created_at asc limit 10000); delete from tasks where task_id not in (select task_id from tasks order by created_at asc limit 10000);" && \
kubectl exec storage-postgres-postgresql-0 -n storage-service -- psql -U postgres -d storage -c "delete from file_objects where file_object_id not in (select file_object_id from file_objects order by created_at asc limit 10000);"

helm uninstall auth-postgres -n auth-service && \
helm uninstall job-service -n job-service && \
helm uninstall user-profile-postgres -n user-profile-service && \
helm uninstall user-preference-postgres -n user-preference-service && \
helm uninstall organization-postgres -n organization-service && \
helm uninstall team-postgres -n team-service && \
helm uninstall storage-postgres -n storage-service && \
helm uninstall plan-postgres -n plan-service 
```