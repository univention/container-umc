{{- /*
SPDX-FileCopyrightText: 2024-2025 Univention GmbH
SPDX-License-Identifier: AGPL-3.0-only
*/}}

{{- /*
These template definitions are only used in this chart and do not relate to templates defined elsewhere.
*/}}

{{- define "umc-server.configMapUcr" -}}
{{- $nubusConfigMapUcr := printf "%s-stack-data-ums-ucr" .Release.Name -}}
{{- tpl (coalesce .Values.configMapUcr .Values.global.configMapUcr $nubusConfigMapUcr) . -}}
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

{{- define "umc-server.ldap.tlsSecret.name" -}}
{{- include "umc-server.tlsSecretTemplate" (list "umc-server-ldap" .Values.ldap.tlsSecret .) -}}
{{- end -}}

{{- define "umc-server.ingress.tls.secretName" -}}
{{- if .Values.ingress.tls.secretName -}}
{{- tpl .Values.ingress.tls.secretName . -}}
{{- else if .Values.global.nubusDeployment -}}
{{- printf "%s-portal-tls" .Release.Name -}}
{{- else -}}
{{- required ".Values.ingress.tls.secretName must be defined" .Values.ingress.tls.secretName -}}
{{- end -}}
{{- end -}}

{{- define "umc-server.memcached.host" -}}
{{- if and .Values.memcached (hasKey .Values.memcached "bundled") -}}
  {{- if .Values.memcached.bundled -}}
    {{- printf "%s-memcached" (include "common.names.fullname" .) -}}
  {{- else -}}
    {{- tpl .Values.memcached.connection.host . -}}
  {{- end -}}
{{- else -}}
  {{- /* Backward compatibility: if bundled is not set, assume bundled=true for old Bitnami chart */ -}}
  {{- if and .Values.memcached .Values.memcached.nameOverride -}}
    {{- printf "%s-%s" .Release.Name .Values.memcached.nameOverride -}}
  {{- else -}}
    {{- printf "%s-memcached" (include "common.names.fullname" .) -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{- define "umc-server.memcached.port" -}}
{{- if and .Values.memcached (hasKey .Values.memcached "bundled") -}}
  {{- if .Values.memcached.bundled -}}
    {{- .Values.memcached.service.port | default 11211 -}}
  {{- else -}}
    {{- tpl .Values.memcached.connection.port . -}}
  {{- end -}}
{{- else -}}
  {{- /* Backward compatibility: default to 11211 */ -}}
  {{- 11211 -}}
{{- end -}}
{{- end -}}
