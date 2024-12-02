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

### Deploy
```sh
helm plugin install https://github.com/databus23/helm-diff
./prod-deploy.sh
```