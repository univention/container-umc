# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2025 Univention GmbH

from univention.testing.helm.auth_flavors.password_usage import \
    AuthPasswordUsageViaVolume
from univention.testing.helm.auth_flavors.secret_generation import \
    AuthSecretGenerationUser


class SettingsTestLdapSecret:
    secret_name = "release-name-umc-server-ldap"
    prefix_mapping = {"ldap.auth": "auth"}

    # for tests around AuthPasswordUsageViaVolume
    volume_name = "secret-ldap"
    workload_name = "release-name-umc-server"
    workload_kind = "StatefulSet"


class TestChartCreatesLdapSecretAsUser(SettingsTestLdapSecret, AuthSecretGenerationUser):
    pass


class TestUmcServerUsesLdapCredentialsByVolume(SettingsTestLdapSecret, AuthPasswordUsageViaVolume):
    pass
