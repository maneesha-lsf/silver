{{- define "postfix.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "postfix.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Stable, release-independent Service name (matches raven/rspamd/opendkim), so
in-cluster references resolve regardless of the release name. Deliberately NOT
postfix.fullname — the Deployment and ConfigMap keep the release-prefixed name. */}}
{{- define "postfix.serviceName" -}}
{{- (((.Values.global).serviceNames).postfix) | default "postfix" -}}
{{- end -}}

{{- define "postfix.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "postfix.labels" -}}
helm.sh/chart: {{ include "postfix.chart" . }}
app.kubernetes.io/name: {{ include "postfix.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "postfix.selectorLabels" -}}
app.kubernetes.io/name: {{ include "postfix.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
