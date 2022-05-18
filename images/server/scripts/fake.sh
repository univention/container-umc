#!/bin/sh

# Used to replace calls from dpkg-postinst scripts

echo 'Faking "'"$(basename "$0")"'" with parameters: "'"$*"'"' 1>&2

exit 0

# [EOF]
