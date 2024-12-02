#!/bin/bash

export AWS_DEFAULT_PROFILE=terraform
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
export AWS_REGION="ap-northeast-1"
export ECR_PASSWORD=$(aws ecr get-login-password --region $AWS_REGION)

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

helmfile delete -f environments/prod/service-helmfile.yaml
helmfile delete -f environments/prod/helmfile.yaml

kubectl delete -f ./secret/manifests

./secret_template/cleanup_secret.sh auth-secrets auth-sa auth-service LGStateApNortheast1Prod $AWS_REGION
./secret_template/cleanup_secret.sh websocket-secrets websocket-sa websocket-service LGStateApNortheast1Prod $AWS_REGION
./secret_template/cleanup_secret.sh job-secrets job-sa job-service LGStateApNortheast1Prod $AWS_REGION
./secret_template/cleanup_secret.sh user-profile-secrets user-profile-sa user-profile-service LGStateApNortheast1Prod $AWS_REGION
./secret_template/cleanup_secret.sh user-preference-secrets user-preference-sa user-preference-service LGStateApNortheast1Prod $AWS_REGION
./secret_template/cleanup_secret.sh team-secrets team-sa team-service LGStateApNortheast1Prod $AWS_REGION
./secret_template/cleanup_secret.sh organization-secrets organization-sa organization-service LGStateApNortheast1Prod $AWS_REGION
./secret_template/cleanup_secret.sh plan-secrets plan-sa plan-service LGStateApNortheast1Prod $AWS_REGION
./secret_template/cleanup_secret.sh storage-secrets storage-sa storage-service LGStateApNortheast1Prod $AWS_REGION

kubectl delete -f ./base