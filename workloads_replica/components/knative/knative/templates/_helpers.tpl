{{/*
Expand the name of the chart.
*/}}
{{- define "knative.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "knative.namespace" -}}
{{- if .Values.namespaceOverride }}
{{- .Values.namespaceOverride }}
{{- else }}
{{- .Release.Namespace }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "knative.fullname" -}}
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
{{- define "knative.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart version as used by the chart label.
*/}}
{{- define "knative.version" -}}
{{- if .Values.serving.version -}}
{{- if eq .Values.serving.version .Chart.AppVersion -}}
{{- .Chart.AppVersion -}}
{{- else -}}
{{- .Values.serving.version -}}
{{- end -}}
{{- else -}}
{{- .Chart.AppVersion -}}
{{- end -}}
{{- end }}

{{/*
Common labels
*/}}
{{- define "knative.labels" -}}
helm.sh/chart: {{ include "knative.chart" . }}
{{ include "knative.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ include "knative.version" . | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "knative.selectorLabels" -}}
app.kubernetes.io/name: {{ include "knative.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "knative.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "knative.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "installer-envs" -}}
- name: foo
  value: bar
{{- if .Values.proxy.enabled }}
- name: HTTP_PROXY
  value: {{ .Values.proxy.httpProxy }}
- name: HTTPS_PROXY
  value: {{ .Values.proxy.httpsProxy }}
- name: NO_PROXY
  value: {{ .Values.proxy.noProxy }}
{{- end }}
{{- end }}
