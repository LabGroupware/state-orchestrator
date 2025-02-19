#!/bin/bash

export AWS_DEFAULT_PROFILE=terraform
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
# export AWS_REGION="ap-northeast-1"
export AWS_REGION="us-east-1"
export ECR_PASSWORD=$(aws ecr get-login-password --region $AWS_REGION)
# export CLUSTER_NAME="LGStateApNortheast1Prod"
export CLUSTER_NAME="LGStateUsEast1Prod"

kubectl apply -f ./base

./secret_template/create_secret.sh auth-secrets ./secret/auth-secret.json auth-sa auth-service $CLUSTER_NAME $AWS_REGION & pid1=$!
# ./secret_template/create_secret.sh websocket-secrets ./secret/websocket-secret.json websocket-sa websocket-service $CLUSTER_NAME $AWS_REGION
./secret_template/create_secret.sh job-secrets ./secret/job-secret.json job-sa job-service $CLUSTER_NAME $AWS_REGION & pid2=$!
./secret_template/create_secret.sh user-profile-secrets ./secret/user-profile-secret.json user-profile-sa user-profile-service $CLUSTER_NAME $AWS_REGION & pid3=$!
./secret_template/create_secret.sh user-preference-secrets ./secret/user-preference-secret.json user-preference-sa user-preference-service $CLUSTER_NAME $AWS_REGION & pid4=$!
./secret_template/create_secret.sh team-secrets ./secret/team-secret.json team-sa team-service $CLUSTER_NAME $AWS_REGION & pid5=$!
./secret_template/create_secret.sh organization-secrets ./secret/organization-secret.json organization-sa organization-service $CLUSTER_NAME $AWS_REGION & pid6=$!
./secret_template/create_secret.sh plan-secrets ./secret/plan-secret.json plan-sa plan-service $CLUSTER_NAME $AWS_REGION & pid7=$!
./secret_template/create_secret.sh storage-secrets ./secret/storage-secret.json storage-sa storage-service $CLUSTER_NAME $AWS_REGION & pid8=$!

wait $pid1
echo "auth-secrets created"
wait $pid2
echo "job-secrets created"
wait $pid3
echo "user-profile-secrets created"
wait $pid4
echo "user-preference-secrets created"
wait $pid5
echo "team-secrets created"
wait $pid6
echo "organization-secrets created"
wait $pid7
echo "plan-secrets created"
wait $pid8
echo "storage-secrets created"

kubectl apply -f ./secret/manifests

echo "AWS_ACCOUNT_ID: $AWS_ACCOUNT_ID"

ORIGIN_AUTH_PASSWORD=$(kubectl get secret --namespace "auth-service" auth-db-secrets -o jsonpath="{.data.password}" | base64 -d)
ORIGIN_WEBSOCKET_PASSWORD=$(kubectl get secret --namespace "websocket-service" websocket-db-secrets -o jsonpath="{.data.password}" | base64 -d)
ORIGIN_JOB_PASSWORD=$(kubectl get secret --namespace "job-service" job-db-secrets -o jsonpath="{.data.password}" | base64 -d)
ORIGIN_USER_PROFILE_PASSWORD=$(kubectl get secret --namespace "user-profile-service" user-profile-db-secrets -o jsonpath="{.data.password}" | base64 -d)
ORIGIN_USER_PREFERENCE_PASSWORD=$(kubectl get secret --namespace "user-preference-service" user-preference-db-secrets -o jsonpath="{.data.password}" | base64 -d)
ORIGIN_TEAM_PASSWORD=$(kubectl get secret --namespace "team-service" team-db-secrets -o jsonpath="{.data.password}" | base64 -d)
ORIGIN_ORGANIZATION_PASSWORD=$(kubectl get secret --namespace "organization-service" organization-db-secrets -o jsonpath="{.data.password}" | base64 -d)
ORIGIN_PLAN_PASSWORD=$(kubectl get secret --namespace "plan-service" plan-db-secrets -o jsonpath="{.data.password}" | base64 -d)
ORIGIN_STORAGE_PASSWORD=$(kubectl get secret --namespace "storage-service" storage-db-secrets -o jsonpath="{.data.password}" | base64 -d)

if [ -z "$ORIGIN_AUTH_PASSWORD" ]; then
  echo "ORIGIN_AUTH_PASSWORD is empty"
  ORIGIN_AUTH_PASSWORD="EMPTY"
fi

if [ -z "$ORIGIN_WEBSOCKET_PASSWORD" ]; then
  echo "ORIGIN_WEBSOCKET_PASSWORD is empty"
  ORIGIN_WEBSOCKET_PASSWORD="EMPTY"
fi

if [ -z "$ORIGIN_JOB_PASSWORD" ]; then
  echo "ORIGIN_JOB_PASSWORD is empty"
  ORIGIN_JOB_PASSWORD="EMPTY"
fi

if [ -z "$ORIGIN_USER_PROFILE_PASSWORD" ]; then
  echo "ORIGIN_USER_PROFILE_PASSWORD is empty"
  ORIGIN_USER_PROFILE_PASSWORD="EMPTY"
fi

if [ -z "$ORIGIN_USER_PREFERENCE_PASSWORD" ]; then
  echo "ORIGIN_USER_PREFERENCE_PASSWORD is empty"
  ORIGIN_USER_PREFERENCE_PASSWORD="EMPTY"
fi

if [ -z "$ORIGIN_TEAM_PASSWORD" ]; then
  echo "ORIGIN_TEAM_PASSWORD is empty"
  ORIGIN_TEAM_PASSWORD="EMPTY"
fi

if [ -z "$ORIGIN_ORGANIZATION_PASSWORD" ]; then
  echo "ORIGIN_ORGANIZATION_PASSWORD is empty"
  ORIGIN_ORGANIZATION_PASSWORD="EMPTY"
fi

if [ -z "$ORIGIN_PLAN_PASSWORD" ]; then
  echo "ORIGIN_PLAN_PASSWORD is empty"
  ORIGIN_PLAN_PASSWORD="EMPTY"
fi

if [ -z "$ORIGIN_STORAGE_PASSWORD" ]; then
  echo "ORIGIN_STORAGE_PASSWORD is empty"
  ORIGIN_STORAGE_PASSWORD="EMPTY"
fi

export ORIGIN_AUTH_PASSWORD
export ORIGIN_WEBSOCKET_PASSWORD
export ORIGIN_JOB_PASSWORD
export ORIGIN_USER_PROFILE_PASSWORD
export ORIGIN_USER_PREFERENCE_PASSWORD
export ORIGIN_TEAM_PASSWORD
export ORIGIN_ORGANIZATION_PASSWORD
export ORIGIN_PLAN_PASSWORD
export ORIGIN_STORAGE_PASSWORD

helm repo add strimzi https://strimzi.io/charts/
helm repo update

helm upgrade \
--install core-kafka-operator \
strimzi/strimzi-kafka-operator \
--namespace kafka \
--wait && \
helmfile apply -f environments/prod/kafka-helmfile.yaml && \
helmfile apply -f environments/prod/db-helmfile.yaml && \
helmfile apply -f environments/prod/connect-helmfile.yaml && \
helmfile apply -f environments/prod/service-helmfile.yaml
