# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2025 Univention GmbH

from univention.testing.helm.auth_flavors.password_usage import \
    AuthPasswordUsageViaVolume
from univention.testing.helm.auth_flavors.secret_generation import \
    AuthSecretGenerationUser


class SettingsTestOidcSecret:
    secret_name = "release-name-umc-server-oidc"
    prefix_mapping = {"umcServer.oidcClient.auth": "auth"}

    # for tests around AuthPasswordUsageViaVolume
    volume_name = "oidc-client-secret"
    workload_name = "release-name-umc-server"
    workload_kind = "StatefulSet"


class TestChartCreatesOidcSecretAsUser(SettingsTestOidcSecret, AuthSecretGenerationUser):
    pass


class TestUmcServerUsesOidcCredentialsByVolume(SettingsTestOidcSecret, AuthPasswordUsageViaVolume):
    pass
