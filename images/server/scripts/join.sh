#!/bin/sh
# -*- coding: utf-8 -*-

# Replaces /usr/share/univention-lib/join.sh to install dpkg-packages
# without side-effects in Docker.
# Sourced by /var/lib/dpkg/info/univention-management-console-module-udm.postinst

echo "Faking to source join.sh script from $0 (parameters \"$*\")" 1>&2

# [EOF]
