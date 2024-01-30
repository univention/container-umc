# -*- coding: utf-8 -*-
# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2023 Univention GmbH

import requests


def test_umc_server_requires_authentication(umc_server_url):
    response = requests.get(umc_server_url)
    assert response.status_code == requests.codes.forbidden


def test_umc_server_provides_json_answer(umc_server_url):
    response = requests.get(umc_server_url)
    data = response.json()
    assert data["status"] == 403
