# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2025 Univention GmbH

from univention.testing.helm.client.ldap import AuthPassword, SecretViaVolume


class TestAuth(SecretViaVolume, AuthPassword):

    secret_name = "release-name-umc-server-ldap"
    workload_kind = "StatefulSet"
