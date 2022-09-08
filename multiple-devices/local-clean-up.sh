#!/bin/bash

# Copyright 2022 Symbl.ai contributors. All Rights Reserved.
# SPDX-License-Identifier: MIT

# set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

set +x

# This directory
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# SERVER component
if [[ "$(ps | grep -v grep | grep "bin/www")" != "" ]]; then
    echo " "
    echo "Killing previous SERVER component"
    kill -9 "$(ps | grep -v grep | grep "bin/www" | cut -d" " -f1)"
fi

pushd "${MY_DIR}/learning-opentok-node" || exit 1
    # git reset --hard
    rm -rf "${MY_DIR}/learning-opentok-node/node_modules"
popd || exit 1


# CLIENT component
if [[ "$(ps | grep -v grep | grep "npm run start")" != "" ]]; then
    echo " "
    echo "Killing previous run of CLIENT npm command"
    kill -9 "$(ps | grep -v grep | grep "npm run start" | cut -d" " -f1)"
fi

pushd "${MY_DIR}/opentok-web-samples" || exit 1
    # git reset --hard
    rm -rf "./Angular-Basic-Video-Chat/node_modules"
    rm -rf "./React-Basic-Video-Chat/node_modules"
    rm -rf "./Vue-Basic-Video-Chat/.env"
    rm -rf "./Vue-Basic-Video-Chat/node_modules"
popd || exit 1

echo "Succeeded!"
