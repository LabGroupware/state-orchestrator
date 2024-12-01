#!/bin/bash

RELEASE_NAME="$1"

if [ -z "$RELEASE_NAME" ]; then
  echo "Helmリリース名を指定してください。"
  exit 1
fi

NAMESPACE="$2"

if [ -z "$NAMESPACE" ]; then
  echo "Helmリリースの名前空間を指定してください。"
  exit 1
fi

TIMEOUT=600  # 秒
SLEEP_INTERVAL=3

end=$((SECONDS + TIMEOUT))
while [ $SECONDS -lt $end ]; do
  STATUS=$(helm status $RELEASE_NAME --namespace $NAMESPACE -o json | jq -r '.info.status')
  
  if [ "$STATUS" == "deployed" ]; then
    echo "Helmリリース '$RELEASE_NAME' は正常にデプロイされました。"
    exit 0
  fi

  echo "現在のステータス: $STATUS。待機中..."
  sleep $SLEEP_INTERVAL
done

echo "タイムアウト: Helmリリース '$RELEASE_NAME' のデプロイが完了しませんでした。"
exit 1
