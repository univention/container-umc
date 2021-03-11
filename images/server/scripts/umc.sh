#!/bin/sh
# -*- coding: utf-8 -*-

# Replaces /usr/share/univention-lib/umc.sh to install dpkg-packages
# without side-effects in Docker.
# Sourced by /var/lib/dpkg/info/univention-management-console-server.postinst

echo "Faking to source umc.sh script from $0 (parameters \"$*\")" 1>&2

umc_frontend_new_hash () {
        echo "Faking umc_frontend_new_hash function from $0 (parameters \"$*\")"
}

# [EOF]
