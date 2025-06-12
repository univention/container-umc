# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2025 Univention GmbH

import pytest

from univention.testing.helm.best_practice.labels import Labels


class TestLabels(Labels):

    @pytest.mark.skip(reason="TODO: Fix the label handling for the proxy resources")
    def test_additional_labels_modify_a_common_label():
        pass
