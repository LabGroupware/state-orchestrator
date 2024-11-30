#!/bin/bash

export AWS_DEFAULT_PROFILE=terraform
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
export AWS_REGION="ap-northeast-1"
export ECR_PASSWORD=$(aws ecr get-login-password --region $AWS_REGION)

kubectl apply -f ./base

./secret_template/create_secret.sh auth-secrets ./secret/auth-secret.json auth-sa auth-service LGStateApNortheast1Prod $AWS_REGION

kubectl apply -f ./secret/manifests

echo "AWS_ACCOUNT_ID: $AWS_ACCOUNT_ID"

helmfile apply -f environments/prod/helmfile.yaml