# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2025 Univention GmbH

from univention.testing.helm.auth_flavors.password_usage import (
    AuthPasswordUsageViaEnv, AuthPasswordUsageViaVolume)
from univention.testing.helm.auth_flavors.secret_generation import \
    AuthSecretGenerationUser


class SettingsTestSelfservicePostgresqlSecret:
    secret_name = "release-name-umc-server-postgresql-selfservice"
    prefix_mapping = {"postgresql.selfservice.auth": "auth"}

    # for tests around AuthPasswordUsageViaVolume
    volume_name = "secret-postgresql-selfservice"
    workload_name = "release-name-umc-server"
    workload_kind = "StatefulSet"

    # for tests around AuthPasswordUsageViaEnv
    sub_path_env_password = "env[?@name=='SELF_SERVICE_DB_SECRET']"


class TestChartCreatesSelfservicePostgresqlSecretAsUser(SettingsTestSelfservicePostgresqlSecret, AuthSecretGenerationUser):
    pass


class TestUmcServerUsesSelfservicePostgresqlCredentialsByVolume(SettingsTestSelfservicePostgresqlSecret, AuthPasswordUsageViaVolume):
    pass


class TestUmcServerUsesSelfservicePostgresqlCredentialsByEnv(SettingsTestSelfservicePostgresqlSecret, AuthPasswordUsageViaEnv):
    pass


class SettingsTestPostgresqlSecret:
    secret_name = "release-name-umc-server-postgresql-auth-session"
    prefix_mapping = {"postgresql.authSession.auth": "auth"}

    # for tests around AuthPasswordUsageViaEnv
    workload_name = "release-name-umc-server"
    workload_kind = "StatefulSet"
    sub_path_env_password = "env[?@name=='UMC_SQL_CONNECTION_PASSWORD']"


class TestChartCreatesPostgresqlSecretAsUser(SettingsTestPostgresqlSecret, AuthSecretGenerationUser):
    pass


class TestUmcServerUsesPostgresqlCredentialsByEnv(SettingsTestPostgresqlSecret, AuthPasswordUsageViaEnv):
    pass
