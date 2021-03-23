#!/bin/sh

# Replaces /usr/share/univention-lib/all.sh to install dpkg-packages
# without side-effects in Docker.
# Sourced by /var/lib/dpkg/info/univention-management-console-server.postinst

echo "Faking to source all.sh script from $0 (parameters \"$*\")" 1>&2

# [EOF]
