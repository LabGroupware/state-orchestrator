{{/*
Expand the name of the chart.
*/}}
{{- define "job-service.name" -}}
{{- .Values.global.services.jobService.name | default (printf "%s-job-service" .Release.Name) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "job-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "job-service.labels" -}}
helm.sh/chart: {{ include "job-service.chart" . }}
{{ include "job-service.selectorLabels" . }}
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
{{- define "job-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "job-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

