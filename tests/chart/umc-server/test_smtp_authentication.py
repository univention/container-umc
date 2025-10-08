# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2025 Univention GmbH

from univention.testing.helm.auth_flavors.password_usage import \
    AuthPasswordUsageViaVolume
from univention.testing.helm.auth_flavors.secret_generation import \
    AuthSecretGenerationUser


class SettingsTestSmtpSecret:
    secret_name = "release-name-umc-server-smtp"
    prefix_mapping = {"smtp.auth": "auth"}

    # for tests around AuthPasswordUsageViaVolume
    volume_name = "secret-smtp"
    workload_name = "release-name-umc-server"
    workload_kind = "StatefulSet"


class TestChartCreatesSmtpSecretAsUser(SettingsTestSmtpSecret, AuthSecretGenerationUser):
    pass


class TestUmcServerUsesSmtpCredentialsByVolume(SettingsTestSmtpSecret, AuthPasswordUsageViaVolume):
    pass
