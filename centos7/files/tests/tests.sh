#!/bin/sh
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

echo "=== Docker Build Test ==="

echo -n "[TEST] Check if yum command is installed... "
rpm -q yum > /dev/null 2>&1
if [[ "$?" -eq "0" ]]; then
  echo 'OK'
else
  echo 'Failed'
  exit 1
fi

echo -n "[TEST] Check package installation with yum... "
yum -y -q install less > /dev/null 2>&1 && less --version > /dev/null 2>&1
if [[ "$?" -eq "0" ]]; then
  echo 'OK'
else
  echo 'Failed'
  exit 2
fi

echo -n "[TEST] Check if packages are correctly installed... "
MISSING=$(yum -q --assumeno install $(rpm -qa --qf "%{name} ") > /dev/null 2>&1; echo $?)
if [[ "${MISSING}" -eq "0" ]]; then
  echo 'OK'
else
  echo 'Failed'
  exit 3
fi

exit 0
