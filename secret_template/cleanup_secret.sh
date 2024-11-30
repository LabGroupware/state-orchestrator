#!/bin/bash

# 引数チェック
if [ "$#" -ne 5 ]; then
  echo "Usage: $0 <secret-name> <service-account-name> <namespace> <clustername> <region>"
  exit 1
fi

SECRET_NAME="$1"
SERVICE_ACCOUNT_NAME="$2"
NAMESPACE="$3"
CLUSTERNAME="$4"
REGION="$5"

# 1. EKSサービスアカウントの削除
echo "Deleting EKS service account $SERVICE_ACCOUNT_NAME in namespace $NAMESPACE from cluster $CLUSTERNAME..."

if ! eksctl delete iamserviceaccount --name "$SERVICE_ACCOUNT_NAME" --region "$REGION" --namespace "$NAMESPACE" --cluster "$CLUSTERNAME"; then
  echo "Failed to delete EKS service account."
  exit 1
fi

echo "EKS service account $SERVICE_ACCOUNT_NAME deleted successfully."

# 2. IAMポリシーの削除
POLICY_NAME="${SECRET_NAME}-access-policy"
POLICY_ARN=$(aws --region "$REGION" iam list-policies --query "Policies[?PolicyName=='$POLICY_NAME'].Arn" --output text)

if [ -n "$POLICY_ARN" ]; then
echo "IAM policy exists. Deleting policy versions..."

  POLICY_VERSIONS=$(aws --region "$REGION" iam list-policy-versions --policy-arn "$POLICY_ARN" --query "Versions[?IsDefaultVersion==\`false\`].VersionId" --output text)

  for VERSION_ID in $POLICY_VERSIONS; do
    echo "Deleting policy version $VERSION_ID..."
    if ! aws --region "$REGION" iam delete-policy-version --policy-arn "$POLICY_ARN" --version-id "$VERSION_ID"; then
      echo "Failed to delete policy version $VERSION_ID."
      exit 1
    fi
  done

  echo "All non-default policy versions deleted. Deleting the policy..."

  if ! aws --region "$REGION" iam delete-policy --policy-arn "$POLICY_ARN"; then
    echo "Failed to delete IAM policy."
    exit 1
  fi

  echo "IAM policy $POLICY_NAME deleted successfully."
else
  echo "IAM policy $POLICY_NAME does not exist."
fi

# 3. AWS Secrets Managerからシークレットを削除
SECRET_EXISTS=$(aws --region "$REGION" secretsmanager describe-secret --secret-id "$SECRET_NAME" --query 'ARN' --output text 2>/dev/null)

if [ "$SECRET_EXISTS" != "None" ] && [ -n "$SECRET_EXISTS" ]; then
  echo "Secret exists. Scheduling for deletion..."

  # シークレットを削除スケジュールに設定
  if ! aws --region "$REGION" secretsmanager delete-secret --secret-id "$SECRET_NAME" --force-delete-without-recovery; then
    echo "Failed to delete secret in AWS Secrets Manager."
    exit 1
  fi

  echo "Secret $SECRET_NAME scheduled for deletion."
else
  echo "Secret $SECRET_NAME does not exist."
fi