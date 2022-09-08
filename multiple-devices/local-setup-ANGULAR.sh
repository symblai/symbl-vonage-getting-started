#!/bin/bash

# Copyright 2022 Symbl.ai contributors. All Rights Reserved.
# SPDX-License-Identifier: MIT

# set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

set +x

API_KEY="${API_KEY:-""}"
API_SECRET="${API_SECRET:-""}"
APP_ID="${APP_ID:-""}"
APP_SECRET="${APP_SECRET:-""}"

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo " "
echo " "
echo "If you haven't done this already, you want to export the following things before proceeding:"
echo " "
echo "Vonage API secrets:"
echo "-----------------------------"
echo "export API_KEY=AAAAA"
echo "export API_SECRET=BBBBB"
echo " "
echo "Symbl API secrets:"
echo "-----------------------------"
echo "export APP_ID=XXXXX"
echo "export APP_SECRET=YYYYY"
echo " "

if [[ -z "${API_KEY}" ]]; then
    echo " "
    echo "The Vonage API_KEY is not set"
    exit 1
fi
if [[ -z "${API_SECRET}" ]]; then
    echo " "
    echo "The Vonage API_SECRET is not set"
    exit 1
fi
if [[ -z "${APP_ID}" ]]; then
    echo " "
    echo "The Symbl APP_ID is not set"
    exit 1
fi
if [[ -z "${APP_SECRET}" ]]; then
    echo " "
    echo "The Symbl APP_SECRET is not set"
    exit 1
fi

if [[ -z "$(command -v node)" ]]; then
    echo " "
  echo "Please make sure node is installed."
  exit 1
fi

# SERVER component
pushd "${MY_DIR}/learning-opentok-node" || exit 1

    if [[ ! -f ".env" ]]; then
        echo " "
        echo "Setting up ENV file for SERVER"
        echo "TOKBOX_API_KEY=${API_KEY}" > .env
        echo "TOKBOX_SECRET=${API_SECRET}" >> .env 
    else
        echo "The .env for SERVER already exists. Skipping."
    fi

    if [[ ! -d "node_modules" ]]; then
        echo " "
        echo "Getting node project dependencies!"
        set -x
        npm install
        set +x
    fi

    # kill level over SERVER from previous run
    if [[ "$(ps | grep -v grep | grep "bin/www")" != "" ]]; then
        echo " "
        echo "Killing previous SERVER component"
        kill -9 "$(ps | grep -v grep | grep "bin/www" | cut -d" " -f1)"
    fi
    npm start &

popd || exit 1

# CLIENT component
pushd "${MY_DIR}/opentok-web-samples/Angular-Basic-Video-Chat" || exit 1

    if [[ ! -d "node_modules" ]]; then
        echo " "
        echo "Getting node project dependencies!"
        set -x
        npm install
        set +x
    fi

    echo " "
    echo "Running sample Vonage-Symbl for use on a single device..."
    echo " "

    # kill left over CLIENT from previous run
    if [[ "$(ps | grep -v grep | grep "npm run start")" != "" ]]; then
        echo " "
        echo "Killing previous run of CLIENT npm command"
        kill -9 "$(ps | grep -v grep | grep "npm run start" | cut -d" " -f1)"
    fi

    set -x

    npm run start

popd || exit 1
