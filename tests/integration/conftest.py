# -*- coding: utf-8 -*-
# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2023 Univention GmbH

"""
Module providing command-line argument parser
and common fixtures for use in integration tests.
"""
import pytest


def pytest_addoption(parser: pytest.Parser):
    """
    Allow customizing global options of the tests,
    e.g. where to find the UMC Server container and how to connect.
    """
    parser.addoption(
        "--umc-server-url",
        action="store",
        default="http://localhost:8090/",
        help="The URL via which the test suite can reach the UMC Server.",
    )
    parser.addoption(
        "--username",
        action="store",
        default="Administrator",
        help="Username to authenticate with the UMC Server.",
    )
    parser.addoption(
        "--password",
        action="store",
        default="univention",
        help="Password to authenticate with the UMC Server.",
    )


@pytest.fixture(scope="session")
def umc_server_url(pytestconfig):
    """Base URL of the UMC Server."""
    return pytestconfig.getoption("--umc-server-url")
