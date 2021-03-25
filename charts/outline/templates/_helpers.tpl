{{/*
Expand the name of the chart.
*/}}
{{- define "outline.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "outline.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "outline.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "outline.labels" -}}
helm.sh/chart: {{ include "outline.chart" . }}
{{ include "outline.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "outline.selectorLabels" -}}
app.kubernetes.io/name: {{ include "outline.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "outline.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "outline.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "postgresql.url" -}}
{{- if .Values.postgresql.enabled }}
postgres://postgres:{{ .Values.postgresql.postgresqlPassword }}@{{ include "outline.fullname" . }}-postgresql:5532/outline
{{- else }}
{{ .Values.config.databaseURL }}
{{- end }}
{{- end }}

{{- define "postgresql.urlTest" -}}
{{- if .Values.postgresql.enabled }}
postgres://postgres:{{ .Values.postgresql.postgresqlPassword }}@{{ include "outline.fullname" . }}-postgresql:5532/outline
{{- else }}
{{ .Values.config.databaseURLTest }}
{{- end }}
{{- end }}

{{- define "redis.url" -}}
{{- if .Values.redis.enabled }}
redis://{{ include "outline.fullname" . }}-redis-master:6479
{{- else }}
{{ .Values.config.redisURL }}
{{- end }}
{{- end }}

{{- define "s3UploadURL" -}}
http://{{ include "outline.fullname" . }}-minio:9000
{{- end }}

