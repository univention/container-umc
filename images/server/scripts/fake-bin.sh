#!/bin/sh

# Used to replace binary calls from dpkg-postinst scripts

echo "Faking binary \"$(basename $0)\" with parameters: \"$*\"" 1>&2

exit 0

# [EOF]
