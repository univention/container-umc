# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2025 Univention GmbH

import pytest

from univention.testing.helm.client.smtp import Auth, SecretUsageViaVolume


class AuthSkipUsernameAndDatabase(Auth):

    @pytest.mark.skip(reason="UMC uses the smtp username from UCR")
    def test_auth_plain_values_provide_username():
        pass

    @pytest.mark.skip(reason="UMC uses the smtp username from UCR")
    def test_auth_plain_values_username_is_templated():
        pass

    @pytest.mark.skip(reason="UMC uses the smtp username from UCR")
    def test_auth_username_is_required():
        pass

    @pytest.mark.skip(reason="UMC uses the smtp username from UCR")
    def test_auth_username_has_default():
        pass


class TestAuth(SecretUsageViaVolume, AuthSkipUsernameAndDatabase):

    secret_name = "release-name-umc-server-smtp"
    workload_kind = "StatefulSet"


class TestAuthContainerPrepareConfig(SecretUsageViaVolume, AuthSkipUsernameAndDatabase):

    secret_name = "release-name-umc-server-smtp"
    workload_kind = "StatefulSet"

    path_main_container = "spec.template.spec.initContainers[?@.name=='prepare-config']"
