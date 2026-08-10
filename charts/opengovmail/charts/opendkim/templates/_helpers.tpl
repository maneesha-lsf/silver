{{- define "opendkim.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "opendkim.fullname" -}}
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

{{- define "opendkim.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Stable Service name so Postfix resolves the DKIM milter (decoupled from the
release-prefixed fullname, matching raven's pattern). */}}
{{- define "opendkim.serviceName" -}}
{{- (((.Values.global).serviceNames).opendkim) | default "opendkim" -}}
{{- end -}}

{{/*
The list of domains to sign for. Empty (the default) derives a single entry from
global.domain, so a one-command install signs for the domain being deployed
instead of a value baked into this chart. Override `domains` to sign for several.
*/}}
{{- define "opendkim.domains" -}}
{{- if .Values.domains -}}
{{- toJson .Values.domains -}}
{{- else -}}
{{- toJson (list (dict "domain" (required "opendkim: set global.domain, or list opendkim.domains explicitly" ((.Values.global).domain)))) -}}
{{- end -}}
{{- end -}}

{{- define "opendkim.labels" -}}
helm.sh/chart: {{ include "opendkim.chart" . }}
app.kubernetes.io/name: {{ include "opendkim.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "opendkim.selectorLabels" -}}
app.kubernetes.io/name: {{ include "opendkim.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "opendkim.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "opendkim.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}
