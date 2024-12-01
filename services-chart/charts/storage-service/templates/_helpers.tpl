{{/*
Expand the name of the chart.
*/}}
{{- define "storage-service.name" -}}
{{- .Values.global.services.storageService.name | default (printf "%s-storage-service" .Release.Name) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "storage-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "storage-service.labels" -}}
helm.sh/chart: {{ include "storage-service.chart" . }}
{{ include "storage-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
{{- end }}

{{/*
Selector labels
*/}}
{{- define "storage-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "storage-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

