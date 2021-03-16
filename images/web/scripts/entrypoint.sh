#!/bin/bash
set -euxo pipefail
umask 077

/usr/sbin/univention-management-console-web-server "$@"

exit 0

# [EOF]
