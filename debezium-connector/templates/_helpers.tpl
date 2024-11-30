{{- define "getAuthSecret" -}}
{{ printf "$(kubectl get secret %s -o jsonpath='{.data.%s}' | base64 --decode)" .Values.connector.database.passwordSecrets .Values.connector.database.passwordSecretKey }}
{{- end -}}