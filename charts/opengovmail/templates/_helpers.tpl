{{/*
Expand the name of the chart.
*/}}
{{- define "opengovmail.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "opengovmail.fullname" -}}
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
Common labels
*/}}
{{- define "opengovmail.labels" -}}
helm.sh/chart: {{ include "opengovmail.name" . }}-{{ .Chart.Version }}
app.kubernetes.io/name: {{ include "opengovmail.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "opengovmail.selectorLabels" -}}
app.kubernetes.io/name: {{ include "opengovmail.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Mail domain (single source of truth).
*/}}
{{- define "opengovmail.domain" -}}
{{- required "global.domain is required (e.g. --set global.domain=example.com)" .Values.global.domain -}}
{{- end }}

{{/*
Mail hostname, defaults to mail.<domain>.
*/}}
{{- define "opengovmail.mailHostname" -}}
{{- default (printf "mail.%s" (include "opengovmail.domain" .)) .Values.global.mailHostname -}}
{{- end }}

{{/*
cert-manager TLS Secret name, defaults to the mail.<domain> cert minted by certificate.yaml
(<domain-dashed>-tls).
*/}}
{{- define "opengovmail.tlsSecretName" -}}
{{- default (printf "%s-tls" (include "opengovmail.mailHostname" . | replace "." "-")) .Values.global.tlsSecretName -}}
{{- end }}

{{/*
Issuer reference helper
*/}}
{{- define "opengovmail.issuerRef" -}}
name: {{ .Values.global.tls.issuer }}
kind: ClusterIssuer
{{- end }}