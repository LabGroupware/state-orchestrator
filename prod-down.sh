#!/bin/bash

export AWS_DEFAULT_PROFILE=terraform
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
export AWS_REGION="ap-northeast-1"
export ECR_PASSWORD=$(aws ecr get-login-password --region $AWS_REGION)

echo "AWS_ACCOUNT_ID: $AWS_ACCOUNT_ID"

helmfile delete -f environments/prod/helmfile.yaml

kubectl delete -f ./secret/manifests

./secret_template/cleanup_secret.sh auth-secrets auth-sa auth-service LGStateApNortheast1Prod $AWS_REGION

kubectl delete -f ./base