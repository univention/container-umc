# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2025 Univention GmbH

import pytest

from univention.testing.helm.client.memcached import (
    Auth,
    SecretUsageViaEnv,
    SecretUsageViaVolume,
)


class AuthSkipUsername(Auth):
    @pytest.mark.skip(reason="UMC uses the memcached username from UCR")
    def test_auth_plain_values_provide_username():
        pass

    @pytest.mark.skip(reason="UMC uses the memcached username from UCR")
    def test_auth_plain_values_username_is_templated():
        pass

    @pytest.mark.skip(reason="UMC uses the memcached username from UCR")
    def test_auth_username_is_required():
        pass

    @pytest.mark.skip(reason="UMC uses the memcached username from UCR")
    def test_auth_username_has_default():
        pass


class TestAuth(SecretUsageViaVolume, AuthSkipUsername):

    secret_name = "release-name-umc-server-memcached"
    workload_kind = "StatefulSet"


class TestAuthViaEnv(SecretUsageViaEnv, AuthSkipUsername):

    secret_name = "release-name-umc-server-memcached"
    workload_kind = "StatefulSet"

    sub_path_env_password = "env[?@name=='SELF_SERVICE_MEMCACHED_SECRET']"


class TestAuthContainerPrepareConfig(SecretUsageViaVolume, AuthSkipUsername):

    secret_name = "release-name-umc-server-memcached"
    workload_kind = "StatefulSet"

    path_main_container = "spec.template.spec.initContainers[?@.name=='prepare-config']"
