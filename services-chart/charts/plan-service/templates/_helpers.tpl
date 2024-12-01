{{/*
Expand the name of the chart.
*/}}
{{- define "plan-service.name" -}}
{{- .Values.global.services.planService.name | default (printf "%s-plan-service" .Release.Name) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "plan-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "plan-service.labels" -}}
helm.sh/chart: {{ include "plan-service.chart" . }}
{{ include "plan-service.selectorLabels" . }}
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
{{- define "plan-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "plan-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

