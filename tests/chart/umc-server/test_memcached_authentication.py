# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2025 Univention GmbH

import pytest

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

    def load_and_map(self, values):
        result = super().load_and_map(values)
        result.setdefault("memcached", {})
        result["memcached"].setdefault("bundled", True)
        result["memcached"].setdefault("auth", {})
        result["memcached"]["auth"].setdefault("enabled", True)
        return result


class TestChartCreatesMemcachedSecretAsUser(SettingsTestMemcachedSecret, AuthSecretGenerationUser):

    @pytest.mark.skip(reason="The memcached password is auto-generated if not provided")
    def test_auth_plain_values_password_is_required(self, chart):
        pass

    def test_auth_plain_values_password_is_auto_generated(self, chart):
        values = self.load_and_map(
            """
            auth:
              username: "stub-username"
              password: null
              existingSecret:
                name: null
            """)
        result = chart.helm_template(values)
        secret = result.get_resource(kind="Secret", name=self.secret_name)
        password = secret.findone("stringData.password")
        assert password is not None
        assert password != ""


class TestUmcServerUsesMemcachedCredentialsByVolume(SettingsTestMemcachedSecret, AuthPasswordUsageViaVolume):
    pass

class TestUmcServerUsesMemcachedCredentialsByEnv(SettingsTestMemcachedSecret, AuthPasswordUsageViaEnv):
    pass
