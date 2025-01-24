#!/bin/bash

export AWS_DEFAULT_PROFILE=terraform
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
# export AWS_REGION="ap-northeast-1"
export AWS_REGION="us-east-1"
export ECR_PASSWORD=$(aws ecr get-login-password --region $AWS_REGION)
# export CLUSTER_NAME="LGStateApNortheast1Prod"
export CLUSTER_NAME="LGStateUsEast1Prod"

echo "AWS_ACCOUNT_ID: $AWS_ACCOUNT_ID"

export ORIGIN_AUTH_PASSWORD=$(kubectl get secret --namespace "auth-service" auth-db-secrets -o jsonpath="{.data.password}" | base64 -d)
export ORIGIN_WEBSOCKET_PASSWORD=$(kubectl get secret --namespace "websocket-service" websocket-db-secrets -o jsonpath="{.data.password}" | base64 -d)
export ORIGIN_JOB_PASSWORD=$(kubectl get secret --namespace "job-service" job-db-secrets -o jsonpath="{.data.password}" | base64 -d)
export ORIGIN_USER_PROFILE_PASSWORD=$(kubectl get secret --namespace "user-profile-service" user-profile-db-secrets -o jsonpath="{.data.password}" | base64 -d)
export ORIGIN_USER_PREFERENCE_PASSWORD=$(kubectl get secret --namespace "user-preference-service" user-preference-db-secrets -o jsonpath="{.data.password}" | base64 -d)
export ORIGIN_TEAM_PASSWORD=$(kubectl get secret --namespace "team-service" team-db-secrets -o jsonpath="{.data.password}" | base64 -d)
export ORIGIN_ORGANIZATION_PASSWORD=$(kubectl get secret --namespace "organization-service" organization-db-secrets -o jsonpath="{.data.password}" | base64 -d)
export ORIGIN_PLAN_PASSWORD=$(kubectl get secret --namespace "plan-service" plan-db-secrets -o jsonpath="{.data.password}" | base64 -d)
export ORIGIN_STORAGE_PASSWORD=$(kubectl get secret --namespace "storage-service" storage-db-secrets -o jsonpath="{.data.password}" | base64 -d)

helmfile delete -f environments/prod/service-helmfile.yaml && \
helmfile delete -f environments/prod/connect-helmfile.yaml && \
helmfile delete -f environments/prod/db-helmfile.yaml && \
helmfile delete -f environments/prod/kafka-helmfile.yaml && \
helm uninstall core-kafka-operator --namespace kafka && \
helm upgrade \
--install core-kafka-operator \
strimzi/strimzi-kafka-operator \
--namespace kafka \
--wait && \
helmfile apply -f environments/prod/kafka-helmfile.yaml && \
helmfile apply -f environments/prod/db-helmfile.yaml && \
helmfile apply -f environments/prod/connect-helmfile.yaml && \
helmfile apply -f environments/prod/service-helmfile.yaml
