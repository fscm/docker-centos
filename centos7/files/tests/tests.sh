#!/bin/bash
#
# Shell script to test the CentOS Docker image.
#
# Copyright 2016-2019, Frederico Martins
#   Author: Frederico Martins <http://github.com/fscm>
#
# SPDX-License-Identifier: MIT
#
# This program is free software. You can use it and/or modify it under the
# terms of the MIT License.
#

/bin/echo "=== Docker Build Test ==="

/bin/echo -n "[TEST] Check if yum command is installed... "
rpm -q yum &>/dev/null
if [[ "$?" -eq "0" ]]; then
  /bin/echo 'OK'
else
  /bin/echo 'Failed'
  exit 1
fi

/bin/echo -n "[TEST] Check package installation with yum... "
yum -y -q install less &>/dev/null && less --help &>/dev/null
if [[ "$?" -eq "0" ]]; then
  /bin/echo 'OK'
else
  /bin/echo 'Failed'
  exit 2
fi

/bin/echo -n "[TEST] Check if packages are correctly installed... "
MISSING=$(yum -q --assumeno install $(rpm -qa --qf "%{name} ") &>/dev/null; echo $?)
if [[ "${MISSING}" -eq "0" ]]; then
  /bin/echo 'OK'
else
  /bin/echo 'Failed'
  exit 3
fi

exit 0
