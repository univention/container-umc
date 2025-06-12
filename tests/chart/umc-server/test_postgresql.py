# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2025 Univention GmbH

import pytest

from univention.testing.helm.client.postgresql import PostgresqlAuth, PostgresqlAuthSecretUsageViaVolume


class TestPostgresqlAuth(PostgresqlAuthSecretUsageViaVolume, PostgresqlAuth):
    secret_name = "release-name-umc-server-postgresql"
    workload_kind = "StatefulSet"

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
