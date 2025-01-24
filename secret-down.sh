#!/bin/bash

export AWS_DEFAULT_PROFILE=terraform
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
# export AWS_REGION="ap-northeast-1"
export AWS_REGION="us-east-1"
export ECR_PASSWORD=$(aws ecr get-login-password --region $AWS_REGION)
# export CLUSTER_NAME="LGStateApNortheast1Prod"
export CLUSTER_NAME="LGStateUsEast1Prod"

echo "AWS_ACCOUNT_ID: $AWS_ACCOUNT_ID"

kubectl delete -f ./secret/manifests

./secret_template/cleanup_secret.sh auth-secrets auth-sa auth-service $CLUSTER_NAME $AWS_REGION
./secret_template/cleanup_secret.sh websocket-secrets websocket-sa websocket-service $CLUSTER_NAME $AWS_REGION
./secret_template/cleanup_secret.sh job-secrets job-sa job-service $CLUSTER_NAME $AWS_REGION
./secret_template/cleanup_secret.sh user-profile-secrets user-profile-sa user-profile-service $CLUSTER_NAME $AWS_REGION
./secret_template/cleanup_secret.sh user-preference-secrets user-preference-sa user-preference-service $CLUSTER_NAME $AWS_REGION
./secret_template/cleanup_secret.sh team-secrets team-sa team-service $CLUSTER_NAME $AWS_REGION
./secret_template/cleanup_secret.sh organization-secrets organization-sa organization-service $CLUSTER_NAME $AWS_REGION
./secret_template/cleanup_secret.sh plan-secrets plan-sa plan-service $CLUSTER_NAME $AWS_REGION
./secret_template/cleanup_secret.sh storage-secrets storage-sa storage-service $CLUSTER_NAME $AWS_REGION

kubectl delete -f ./base