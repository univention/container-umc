# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2025 Univention GmbH

from univention.testing.helm.client.generic_client import AuthPasswordSecret, AuthPasswordUsage, SecretViaVolume


class TestOidcAuth(AuthPasswordSecret):
    prefix_mapping = {"umcServer.oidcClient.auth": "auth"}
    secret_name = "release-name-umc-server-oidc"
    path_password = "stringData.password"

class TestOidcAuthViaProjectedVolume(SecretViaVolume, AuthPasswordUsage):
    workload_kind = "StatefulSet"
    secret_name = "release-name-umc-server-oidc-client-secret"

    path_volume= "..spec.template.spec.volumes[?@.name=='oidc-client-secret']"
    sub_path_volume_mount = "volumeMounts[?@.name=='oidc-client-secret']"

    prefix_mapping = {"umcServer.oidcClient.auth": "auth"}
