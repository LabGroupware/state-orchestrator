{{/*
Expand the name of the chart.
*/}}
{{- define "web-gateway.name" -}}
{{- .Values.global.services.webGateway.name | default (printf "%s-web-gateway" .Release.Name) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "web-gateway.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "web-gateway.labels" -}}
helm.sh/chart: {{ include "web-gateway.chart" . }}
{{ include "web-gateway.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "web-gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "web-gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

