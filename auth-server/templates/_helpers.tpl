{{/*
Expand the name of the chart.
*/}}
{{- define "auth-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "auth-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "auth-server.labels" -}}
helm.sh/chart: {{ include "auth-server.chart" . }}
{{ include "auth-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "auth-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "auth-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

