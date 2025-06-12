# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2025 Univention GmbH

import pytest

from univention.testing.helm.client.postgresql import Auth, SecretUsageViaEnv, SecretUsageViaVolume


class AuthSkipUsernameAndDatabase(Auth):

    @pytest.mark.skip(reason="UMC uses the postgresql username from UCR")
    def test_auth_plain_values_provide_username():
        pass

    @pytest.mark.skip(reason="UMC uses the postgresql username from UCR")
    def test_auth_plain_values_username_is_templated():
        pass

    @pytest.mark.skip(reason="UMC uses the postgresql username from UCR")
    def test_auth_username_is_required():
        pass

    @pytest.mark.skip(reason="UMC uses the postgresql username from UCR")
    def test_auth_username_has_default():
        pass

    @pytest.mark.skip(reason="UMC uses the postgresql database from UCR")
    def test_auth_database_is_required():
        pass

    @pytest.mark.skip(reason="UMC uses the postgresql database from UCR")
    def test_auth_database_has_default():
        pass

    @pytest.mark.skip(reason="UMC uses the postgresql database from UCR")
    def test_auth_database_is_templated():
        pass


class TestAuth(SecretUsageViaVolume, AuthSkipUsernameAndDatabase):

    secret_name = "release-name-umc-server-postgresql"
    workload_kind = "StatefulSet"


class TestAuthViaEnv(SecretUsageViaEnv, AuthSkipUsernameAndDatabase):

    secret_name = "release-name-umc-server-postgresql"
    workload_kind = "StatefulSet"

    sub_path_env_db_password = "env[?@name=='SELF_SERVICE_DB_SECRET']"


class TestAuthContainerPrepareConfig(SecretUsageViaVolume, AuthSkipUsernameAndDatabase):

    secret_name = "release-name-umc-server-postgresql"
    workload_kind = "StatefulSet"

    path_main_container = "spec.template.spec.initContainers[?@.name=='prepare-config']"
