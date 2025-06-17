# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2025 Univention GmbH

import pytest

from univention.testing.helm.client.ldap import Auth


class TestAuth(Auth):

    secret_name = "release-name-umc-server-ldap"
    workload_kind = "StatefulSet"

    @pytest.mark.skip(reason="The UMC discovers the bind dn via UCR")
    def test_auth_bind_dn_is_required():
        pass

    @pytest.mark.skip(reason="The UMC discovers the bind dn via UCR")
    def test_auth_bind_dn_has_default():
        pass

    @pytest.mark.skip(reason="The UMC discovers the bind dn via UCR")
    def test_auth_plain_values_bind_dn_is_templated():
        pass

    @pytest.mark.skip(reason="The UMC discovers the bind dn via UCR")
    def test_auth_plain_values_provide_bind_dn():
        pass
