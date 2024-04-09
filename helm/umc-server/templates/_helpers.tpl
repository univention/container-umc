{{- /*
SPDX-FileCopyrightText: 2024 Univention GmbH
SPDX-License-Identifier: AGPL-3.0-only
*/}}
{{- /*
These template definitions relate to the use of this Helm chart as a sub-chart of the Nubus Umbrella Chart.
Templates defined in other Helm sub-charts are imported to be used to configure this chart.
If the value .Values.global.nubusDeployment equates to true, the defined templates are imported.
*/}}
{{- define "templates.ldapUri" -}}
{{- if .Values.global.nubusDeployment -}}
{{- $protocol := include "nubusTemplates.ldap.protocol" . -}}
{{- $serviceName := include "nubusTemplates.ldap.serviceName" . | default (printf "%s-ldap-server" .Release.Name) -}}
{{- printf "%s://%s" $protocol $serviceName -}}
{{- else -}}
{{- required "Either .Values.udmRestApi.ldap.uri or .Values.global.ldap.uri must be set" (coalesce .Values.udmRestApi.ldap.uri .Values.global.ldap.uri) -}}
{{- end -}}
{{- end -}}

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

{{- define "umc-server.ldapCredentialSecret.name" -}}
{{- include "umc-server.secretTemplate" (list "umc-server-ldap" .Values.umcServer.ldapCredentialSecret .) -}}
{{- end -}}

{{- define "umc-server.smtpCredentialSecret.name" -}}
{{- include "umc-server.secretTemplate" (list "umc-server-smtp" .Values.umcServer.smtpCredentialSecret .) -}}
{{- end -}}

{{- define "umc-server.postgresql.auth.credentialSecret.name" -}}
{{- include "umc-server.secretTemplate" (list "umc-server-postgresql" .Values.postgresql.auth.credentialSecret .) -}}
{{- end -}}

{{- define "umc-server.postgresql.auth.credentialSecret.key" -}}
{{- include "umc-server.secretTemplate" (list "umc-server-postgresql" .Values.postgresql.auth.credentialSecret .) -}}
{{- end -}}

{{- define "umc-server.memcached.auth.credentialSecret.name" -}}
{{- if .Values.memcached.auth.credentialSecret.name -}}
{{- .Values.memcached.auth.credentialSecret.name -}}
{{- else if and .Values.global.nubusDeployment .Values.memcached.bundled .Values.memcached.auth .Values.memcached.auth.enabled -}}
{{- printf "%s-memcached" (include "common.names.fullname" .) -}}
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
