{{- /*
SPDX-FileCopyrightText: 2024 Univention GmbH
SPDX-License-Identifier: AGPL-3.0-only
*/}}

{{- /*
These template definitions are only used in this chart and do not relate to templates defined elsewhere.
*/}}

{{- define "umc-server.configMapUcrDefaults" -}}
{{- $nubusDefaultConfigMapUcrDefaults := printf "%s-stack-data-ums-ucr" .Release.Name -}}
{{- coalesce .Values.configMapUcrDefaults .Values.global.configMapUcrDefaults $nubusDefaultConfigMapUcrDefaults (.Values.global.configMapUcrDefaults | required ".Values.global.configMapUcrDefaults must be defined.") -}}
{{- end -}}

{{- define "umc-server.configMapUcr" -}}
{{- $nubusDefaultConfigMapUcr := printf "%s-stack-data-ums-ucr" .Release.Name -}}
{{- coalesce .Values.configMapUcr .Values.global.configMapUcr $nubusDefaultConfigMapUcr -}}
{{- end -}}

{{- define "umc-server.configMapUcrForced" -}}
{{- coalesce .Values.configMapUcrForced .Values.global.configMapUcrForced | default "" -}}
{{- end -}}

{{- define "umc-server.tlsSecretTemplate" -}}
{{- if (index . 2).Release.Name -}}
{{- $secretName := printf "%s-%s-tls" (index . 2).Release.Name (index . 0) -}}
{{- if (index . 1).name -}}
{{- (index . 1).name -}}
{{- else if (index . 2).Values.global.nubusDeployment -}}
{{- $secretName -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "umc-server.secretTemplate" -}}
{{- if (index . 2).Release.Name -}}
{{- $secretName := printf "%s-%s-credentials" (index . 2).Release.Name (index . 0) -}}
{{- if (index . 1).name -}}
{{- (index . 1).name -}}
{{- else if (index . 2).Values.global.nubusDeployment -}}
{{- $secretName -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "umc-server.ldap.credentialSecret.name" -}}
{{- include "umc-server.secretTemplate" (list "umc-server-ldap" .Values.ldap.credentialSecret .) -}}
{{- end -}}

{{- define "umc-server.ldap.tlsSecret.name" -}}
{{- include "umc-server.tlsSecretTemplate" (list "umc-server-ldap" .Values.ldap.tlsSecret .) -}}
{{- end -}}

{{- define "umc-server.smtp.credentialSecret.name" -}}
{{- include "umc-server.secretTemplate" (list "umc-server-smtp" .Values.smtp.credentialSecret .) -}}
{{- end -}}

{{- define "umc-server.postgresql.auth.credentialSecret.name" -}}
{{- if .Values.postgresql.auth.credentialSecret.name -}}
{{- .Values.postgresql.auth.credentialSecret.name -}}
{{- else if .Values.global.nubusDeployment -}}
{{- printf "%s-umc-server-postgresql-credentials" .Release.Name -}}
{{- else -}}
{{- include "umc-server.secretTemplate" (list "umc-server-postgresql" .Values.postgresql.auth.credentialSecret .) -}}
{{- end -}}
{{- end -}}

{{- define "umc-server.postgresql.auth.credentialSecret.key" -}}
{{- if .Values.postgresql.auth.credentialSecret.key -}}
{{- .Values.postgresql.auth.credentialSecret.key -}}
{{- else if .Values.global.nubusDeployment -}}
password
{{- else -}}
{{- include "umc-server.secretTemplate" (list "umc-server-postgresql" .Values.postgresql.auth.credentialSecret .) -}}
{{- end -}}
{{- end -}}

{{- define "umc-server.memcached.auth.credentialSecret.name" -}}
{{- if .Values.memcached.auth.credentialSecret.name -}}
{{- .Values.memcached.auth.credentialSecret.name -}}
{{- else if and .Values.global.nubusDeployment .Values.memcached.bundled .Values.memcached.auth .Values.memcached.auth.enabled -}}
{{- if .Values.memcached.auth.existingPasswordSecret -}}
{{- tpl .Values.memcached.auth.existingPasswordSecret . -}}
{{- else -}}
{{- printf "%s-memcached" (include "common.names.fullname" .) -}}
{{- end -}}
{{- else -}}
{{- include "umc-server.secretTemplate" (list "umc-server-memcached" .Values.memcached.auth.credentialSecret .) -}}
{{- end -}}
{{- end -}}


{{- define "umc-server.memcached.auth.credentialSecret.key" -}}
{{- if .Values.memcached.auth.credentialSecret.key -}}
{{- .Values.memcached.auth.credentialSecret.key -}}
{{- else if and .Values.global.nubusDeployment .Values.memcached.bundled .Values.memcached.auth .Values.memcached.auth.enabled -}}
memcached-password
{{- else -}}
{{- include "umc-server.secretTemplate" (list "umc-server-memcached" .Values.memcached.auth.credentialSecret .) -}}
{{- end -}}
{{- end -}}
