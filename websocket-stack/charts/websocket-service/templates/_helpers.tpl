{{/*
Expand the name of the chart.
*/}}
{{- define "websocket-service.name" -}}
{{- .Values.global.services.websocketService.name | default (printf "%s-websocket-service" .Release.Name) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "websocket-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "websocket-service.labels" -}}
helm.sh/chart: {{ include "websocket-service.chart" . }}
{{ include "websocket-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "websocket-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "websocket-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

