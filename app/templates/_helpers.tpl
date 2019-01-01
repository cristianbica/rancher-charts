{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}



{{- define "app.vars" }}
env:
- name: APP_HOST
  value: {{ .Values.web.host }}
{{- if .Values.db.enabled }}
- name: DATABASE_URL
  value: "{{ .Values.db.type }}://{{ .Values.db.username }}:{{ .Values.db.password }}@{{ .Values.db.host }}/{{ .Values.db.name }}"
{{- end}}
{{- if .Values.redis.enabled }}
- name: REDIS_URL
  value: "redis://{{ .Values.redis.name }}:6379/0"
{{- end}}
{{- if .Values.cache.enabled }}
- name: CACHE_URL
  value: "redis://{{ .Values.cache.name }}:6379/0"
{{- end}}
{{- range $key, $value := .Values.env }}
{{- if and $value.name $value.value }}
- name: {{ $value.name }}
  value: {{ $value.value | quote }}
{{- end }}
{{- end }}
{{- end }}
