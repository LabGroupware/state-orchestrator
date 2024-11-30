#!/bin/bash

REPO_NAME="$1"

if [ "$REPO_NAME" == "" ]; then
  echo "リポジトリ名を指定してください。"
  exit 1
fi

OUTPUT_FILE=$(helm package $REPO_NAME -d ./chart/$REPO_NAME | awk '{print $NF}')

REGION="ap-northeast-1"
export AWS_DEFAULT_PROFILE=terraform

# リポジトリの存在を確認
EXISTING_REPO=$(aws ecr describe-repositories \
  --repository-names $REPO_NAME \
  --region $REGION \
  --query "repositories[?repositoryName=='$REPO_NAME'] | [0].repositoryName" \
  --output text 2>/dev/null)

echo "EXISTING_REPO: $EXISTING_REPO"

if [ "$EXISTING_REPO" == "" ]; then
  echo "リポジトリ $REPO_NAME は存在しません。作成を実行します..."
  aws ecr create-repository \
    --repository-name $REPO_NAME \
    --region $REGION
  echo "リポジトリ $REPO_NAME を作成しました。"
else
  echo "リポジトリ $REPO_NAME は既に存在します。"
fi

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

aws ecr get-login-password \
     --region $REGION | helm registry login \
     --username AWS \
     --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

helm push $OUTPUT_FILE oci://$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/

aws ecr describe-images \
     --repository-name $REPO_NAME \
     --region $REGION