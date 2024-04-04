{{- /*
SPDX-FileCopyrightText: 2024 Univention GmbH
SPDX-License-Identifier: AGPL-3.0-only
*/}}
{{- /*
These template definitions are only used in this chart and do not relate to templates defined elsewhere.
*/}}

{{- define "udm-rest-api.configMapUcrDefaults" -}}
{{- $nubusDefaultConfigMapUcrDefaults := printf "%s-stack-data-ums-ucr" .Release.Name -}}
{{- coalesce .Values.configMapUcrDefaults .Values.global.configMapUcrDefaults $nubusDefaultConfigMapUcrDefaults (.Values.global.configMapUcrDefaults | required ".Values.global.configMapUcrDefaults must be defined.") -}}
{{- end -}}

{{- define "udm-rest-api.configMapUcr" -}}
{{- $nubusDefaultConfigMapUcr := printf "%s-stack-data-ums-ucr" .Release.Name -}}
{{- coalesce .Values.configMapUcr .Values.global.configMapUcr $nubusDefaultConfigMapUcr -}}
{{- end -}}

{{- define "udm-rest-api.configMapUcrForced" -}}
{{- coalesce .Values.configMapUcrForced .Values.global.configMapUcrForced "null" -}}
{{- end -}}
