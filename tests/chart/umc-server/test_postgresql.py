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


class TestSelfserviceAuth(SecretUsageViaVolume, AuthSkipUsernameAndDatabase):

    prefix_mapping = {"postgresql.selfservice": "postgresql"}
    path_volume = "..spec.template.spec.volumes[?@.name=='secret-postgresql-selfservice']"
    sub_path_volume_mount = "volumeMounts[?@.name=='secret-postgresql-selfservice']"

    secret_name = "release-name-umc-server-postgresql-selfservice"
    workload_kind = "StatefulSet"


class TestSelfserviceAuthViaEnv(SecretUsageViaEnv, AuthSkipUsernameAndDatabase):

    prefix_mapping = {"postgresql.selfservice": "postgresql"}
    secret_name = "release-name-umc-server-postgresql-selfservice"
    workload_kind = "StatefulSet"

    sub_path_env_db_password = "env[?@name=='SELF_SERVICE_DB_SECRET']"


class TestAuthSessionAuthViaEnv(SecretUsageViaEnv, AuthSkipUsernameAndDatabase):

    prefix_mapping = {"postgresql.authSession": "postgresql"}
    secret_name = "release-name-umc-server-postgresql-auth-session"
    workload_kind = "StatefulSet"

    sub_path_env_db_password = "env[?@name=='UMC_SQL_CONNECTION_PASSWORD']"
