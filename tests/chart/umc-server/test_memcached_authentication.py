# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2025 Univention GmbH

from univention.testing.helm.auth_flavors.password_usage import (
    AuthPasswordUsageViaEnv, AuthPasswordUsageViaVolume)
from univention.testing.helm.auth_flavors.secret_generation import \
    AuthSecretGenerationUser


class SettingsTestMemcachedSecret:
    secret_name = "release-name-umc-server-memcached"
    prefix_mapping = {"memcached.auth": "auth"}

    # for tests around AuthPasswordUsageViaVolume
    volume_name = "secret-memcached"
    workload_name = "release-name-umc-server"
    workload_kind = "StatefulSet"

    # for tests around AuthPasswordUsageViaEnv
    sub_path_env_password = "env[?@name=='SELF_SERVICE_MEMCACHED_SECRET']"


class TestChartCreatesMemcachedSecretAsUser(SettingsTestMemcachedSecret, AuthSecretGenerationUser):
    pass


class TestUmcServerUsesMemcachedCredentialsByVolume(SettingsTestMemcachedSecret, AuthPasswordUsageViaVolume):
    pass

class TestUmcServerUsesMemcachedCredentialsByEnv(SettingsTestMemcachedSecret, AuthPasswordUsageViaEnv):
    pass
