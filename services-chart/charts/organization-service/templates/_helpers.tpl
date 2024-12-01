{{/*
Expand the name of the chart.
*/}}
{{- define "organization-service.name" -}}
{{- .Values.global.services.organizationService.name | default (printf "%s-organization-service" .Release.Name) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "organization-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "organization-service.labels" -}}
helm.sh/chart: {{ include "organization-service.chart" . }}
{{ include "organization-service.selectorLabels" . }}
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
{{- define "organization-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "organization-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

