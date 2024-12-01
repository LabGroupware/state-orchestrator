{{/*
Expand the name of the chart.
*/}}
{{- define "team-service.name" -}}
{{- .Values.global.services.teamService.name | default (printf "%s-team-service" .Release.Name) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "team-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "team-service.labels" -}}
helm.sh/chart: {{ include "team-service.chart" . }}
{{ include "team-service.selectorLabels" . }}
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
{{- define "team-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "team-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

