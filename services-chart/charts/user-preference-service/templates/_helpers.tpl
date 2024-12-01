{{/*
Expand the name of the chart.
*/}}
{{- define "user-preference-service.name" -}}
{{- .Values.global.services.userPreferenceService.name | default (printf "%s-user-preference-service" .Release.Name) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "user-preference-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "user-preference-service.labels" -}}
helm.sh/chart: {{ include "user-preference-service.chart" . }}
{{ include "user-preference-service.selectorLabels" . }}
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
{{- define "user-preference-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "user-preference-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

