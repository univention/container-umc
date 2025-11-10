# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2025 Univention GmbH

from univention.testing.helm.auth_flavors.password_usage import AuthPasswordUsageViaEnv
from univention.testing.helm.auth_flavors.secret_generation import AuthSecretGenerationOwner
from univention.testing.helm.client.base import BaseTest
import pytest


class SettingsTestMemcachedSecret:
    secret_name = "release-name-umc-server-memcached"
    secret_default_key = "memcached-password"
    path_password = "stringData.memcached-password"
    prefix_mapping = {"memcached.auth": "auth"}


class TestChartCreatesMemcachedPasswordAsOwner(
    SettingsTestMemcachedSecret, AuthSecretGenerationOwner
):
    derived_password = "382c39b95d7fa1461e553afb42743caf654ad917"

class TestMemcachedDeploymentUsesMemcachedPasswordViaEnv(
    SettingsTestMemcachedSecret, AuthPasswordUsageViaEnv
):
    sub_path_env_password = "env[?@name=='MEMCACHED_PASSWORD']"
    workload_name = "release-name-umc-server-memcached"
    workload_kind = "Deployment"

class TestUmcServerStatefulsetUsesMemcachedPasswordViaEnv(
    SettingsTestMemcachedSecret, AuthPasswordUsageViaEnv
):
    sub_path_env_password = "env[?@name=='SELF_SERVICE_MEMCACHED_SECRET']"
    workload_name = "release-name-umc-server"
    workload_kind = "StatefulSet"

class TestMemcachedAuthDisabled(BaseTest):
    def test_secret_not_templated(self, chart):
        values = self.load_and_map(
            """
            memcached:
              auth:
                enabled: false
            """)
        result = chart.helm_template(values)

        with pytest.raises(LookupError):
            result.get_resource(kind="Secret", name="release-name-umc-server-memcached")

    def test_umc_memcached_secret(self, chart):
        values = self.load_and_map(
            """
            memcached:
              auth:
                enabled: false
            """)
        result = chart.helm_template(values)
        umc_memcached_secret = "env[?@name=='SELF_SERVICE_MEMCACHED_SECRET']"

        umc_server = result.get_resource(kind="StatefulSet", name="release-name-umc-server")
        container = umc_server.findone(self.path_container)
        secret = container.findone(umc_memcached_secret)

        assert secret['value'] == 'stub'
