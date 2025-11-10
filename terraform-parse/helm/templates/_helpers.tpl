{{/*
Expand the name of the chart.
*/}}
{{- define "tripla-apps.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a fully qualified app name.
*/}}
{{- define "tripla-apps.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end -}}

{{/*
Chart name and version label.
*/}}
{{- define "tripla-apps.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
{{- end -}}

{{/*
Common labels.
*/}}
{{- define "tripla-apps.labels" -}}
helm.sh/chart: {{ include "tripla-apps.chart" . }}
app.kubernetes.io/name: {{ include "tripla-apps.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels.
*/}}
{{- define "tripla-apps.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tripla-apps.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
