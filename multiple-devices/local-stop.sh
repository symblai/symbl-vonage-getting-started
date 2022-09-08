#!/bin/bash

# Copyright 2022 Symbl.ai contributors. All Rights Reserved.
# SPDX-License-Identifier: MIT

# set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

set +x

if [[ "$(ps | grep -v grep | grep "bin/www")" != "" ]]; then
    echo " "
    echo "Killing previous SERVER component"
    kill -9 "$(ps | grep -v grep | grep "bin/www" | cut -d" " -f1)"
fi
if [[ "$(ps | grep -v grep | grep "npm run serv")" != "" ]]; then
    echo " "
    echo "Killing previous run of CLIENT npm command"
    kill -9 "$(ps | grep -v grep | grep "npm run start" | cut -d" " -f1)"
fi

echo " "
echo "Succeeded!"

set -x
