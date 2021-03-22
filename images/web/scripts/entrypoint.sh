#!/bin/bash
set -euxo pipefail
umask 077

PID_PATH=/var/run/umc-web-server.pid

if [[ -f "${PID_PATH}" ]]; then
  echo "Removing stale pid ${PID_PATH}"
  rm "${PID_PATH}"
fi

exec /usr/sbin/univention-management-console-web-server "$@"

exit 0

# [EOF]
