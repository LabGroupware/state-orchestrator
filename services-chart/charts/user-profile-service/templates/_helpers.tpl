{{/*
Expand the name of the chart.
*/}}
{{- define "user-profile-service.name" -}}
{{- .Values.global.services.userProfileService.name | default (printf "%s-user-profile-service" .Release.Name) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "user-profile-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "user-profile-service.labels" -}}
helm.sh/chart: {{ include "user-profile-service.chart" . }}
{{ include "user-profile-service.selectorLabels" . }}
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
{{- define "user-profile-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "user-profile-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

