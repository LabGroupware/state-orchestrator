#!/bin/bash

export AWS_DEFAULT_PROFILE=terraform
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
# export AWS_REGION="ap-northeast-1"
export AWS_REGION="us-east-1"
export ECR_PASSWORD=$(aws ecr get-login-password --region $AWS_REGION)
# export CLUSTER_NAME="LGStateApNortheast1Prod"
export CLUSTER_NAME="LGStateUsEast1Prod"

kubectl apply -f ./base

./secret_template/create_secret.sh auth-secrets ./secret/auth-secret.json auth-sa auth-service $CLUSTER_NAME $AWS_REGION
./secret_template/create_secret.sh websocket-secrets ./secret/websocket-secret.json websocket-sa websocket-service $CLUSTER_NAME $AWS_REGION
./secret_template/create_secret.sh job-secrets ./secret/job-secret.json job-sa job-service $CLUSTER_NAME $AWS_REGION
./secret_template/create_secret.sh user-profile-secrets ./secret/user-profile-secret.json user-profile-sa user-profile-service $CLUSTER_NAME $AWS_REGION
./secret_template/create_secret.sh user-preference-secrets ./secret/user-preference-secret.json user-preference-sa user-preference-service $CLUSTER_NAME $AWS_REGION
./secret_template/create_secret.sh team-secrets ./secret/team-secret.json team-sa team-service $CLUSTER_NAME $AWS_REGION
./secret_template/create_secret.sh organization-secrets ./secret/organization-secret.json organization-sa organization-service $CLUSTER_NAME $AWS_REGION
./secret_template/create_secret.sh plan-secrets ./secret/plan-secret.json plan-sa plan-service $CLUSTER_NAME $AWS_REGION
./secret_template/create_secret.sh storage-secrets ./secret/storage-secret.json storage-sa storage-service $CLUSTER_NAME $AWS_REGION

kubectl apply -f ./secret/manifests
