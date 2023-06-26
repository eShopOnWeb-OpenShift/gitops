{{/* vim: set filetype=mustache: */}}

{{- define "acs-admin-password" -}}
{{- trunc 16 (sha256sum (cat .Values.masterKey "acs-admin-password")) -}}
{{- end -}}

{{- define "github-tekton-webhook-secret" -}}
{{- trunc 32 (sha256sum (cat .Values.masterKey "github-tekton-webhook-secret")) -}}
{{- end -}}
