{{- define "arc-buildkit.name" -}}
{{- .Values.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "arc-buildkit.namespace" -}}
{{- .Values.namespace | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "arc-buildkit.labels" -}}
app.kubernetes.io/name: {{ include "arc-buildkit.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end -}}
