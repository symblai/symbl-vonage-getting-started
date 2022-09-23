#!/bin/bash

# Copyright 2022 Symbl.ai contributors. All Rights Reserved.
# SPDX-License-Identifier: MIT

# set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

set +x

# Reguired environment variables
API_KEY="${API_KEY:-""}"
API_SECRET="${API_SECRET:-""}"
APP_ID="${APP_ID:-""}"
APP_SECRET="${APP_SECRET:-""}"

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

if [[ -z "$(command -v heroku)" ]]; then
    echo " "
  echo "Please make sure the Heroku CLI is installed."
  exit 1
fi

# Globals
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_REPO=$(git rev-parse --show-toplevel)

# dynamically determine if your GitHub fork exists
GITHUB_USERNAME=$(git config user.name)
if [[ -z "${GITHUB_USERNAME}" ]]; then
    echo "In order for this script to work correctly, this repo must be `git clone`d from GitHub."
    exit 1
fi

# has we replaced the gitmodules with the forks?
HAS_BEEN_REPLACED=$(grep "git@github.com:dvonthenen" "${ROOT_REPO}/.gitmodules")
if [[ "${HAS_BEEN_REPLACED}" != "" ]]; then

    FORK_SERVER_EXISTS=$(curl -LIs https://github.com/${GITHUB_USERNAME}/learning-opentok-node | grep "HTTP/2" | cut -d" " -f2)
    if [[ "${FORK_SERVER_EXISTS}" == 200 ]]; then
        echo " "
        echo "Replacing learning-opentok-node repo with fork from ${GITHUB_USERNAME}"
        echo " "
        sed -i.bak -e "s|git@github.com:dvonthenen/learning-opentok-node|git@github.com:${GITHUB_USERNAME}/learning-opentok-node|g" "${ROOT_REPO}/.gitmodules" && rm "${ROOT_REPO}/.gitmodules.bak"
    fi
    FORK_CLIENT_EXISTS=$(curl -LIs https://github.com/${GITHUB_USERNAME}/opentok-web-samples | grep "HTTP/2" | cut -d" " -f2)
    if [[ "${FORK_CLIENT_EXISTS}" == 200 ]]; then
        echo " "
        echo "Replacing opentok-web-samples repo with fork from ${GITHUB_USERNAME}"
        echo " "
        sed -i.bak -e "s|git@github.com:dvonthenen/opentok-web-samples|git@github.com:${GITHUB_USERNAME}/opentok-web-samples|g" "${ROOT_REPO}/.gitmodules" && rm "${ROOT_REPO}/.gitmodules.bak"
    fi

    # update the submodules with the new forks
    pushd "${ROOT_REPO}" || exit 1
        echo " "
        echo "Updating git submodule(s) with new hash value(s)"
        echo " "
        git submodule update --init --recursive --remote
    popd || exit 1

fi

# component names
SERVER_NAME="${USER}-symbl-vonage-server"
CLIENT_NAME="${USER}-symbl-vonage-client"

# SERVER component
pushd "${MY_DIR}/learning-opentok-node" || exit 1

    # Globals
    SERVER_BRANCH=$(git branch | grep "*" | cut -d" " -f2)
    SERVER_REMOTE=$(git remote -v | grep heroku-symbl-vonage-server)

    # have we created the heroku remote
    if [[ "${SERVER_REMOTE}" == "" ]]; then
        echo " "
        echo "Setting up Symbl-Vonage SERVER..."
        heroku create "${SERVER_NAME}"
        heroku git:remote -a "${SERVER_NAME}"
        git remote rename heroku heroku-symbl-vonage-server
    fi

    # Add in environment varibales
    GET_VALUE=$(heroku config:get --app="${SERVER_NAME}" NODE_ENV)
    if [[ "${GET_VALUE}" == "" ]]; then
        echo " "
        echo "WARNING: Setting SERVER's NODE_ENV to development to use free Heroku Account"
        echo " "
        heroku config:set --app="${SERVER_NAME}" NODE_ENV="development" >/dev/null 2>&1
    fi
    GET_VALUE=$(heroku config:get --app="${SERVER_NAME}" TOKBOX_API_KEY)
    if [[ "${GET_VALUE}" == "" ]]; then
        heroku config:set --app="${SERVER_NAME}" TOKBOX_API_KEY="${API_KEY}" >/dev/null 2>&1
    fi
    GET_VALUE=$(heroku config:get --app="${SERVER_NAME}" API_SECRET)
    if [[ "${GET_VALUE}" == "" ]]; then
        heroku config:set --app="${SERVER_NAME}" TOKBOX_SECRET="${API_SECRET}" >/dev/null 2>&1
    fi

    set -x
    git push heroku-symbl-vonage-server "${SERVER_BRANCH}:main"
    set +x

popd || exit 1

# CLIENT component
pushd "${MY_DIR}/opentok-web-samples/React-Basic-Video-Chat" || exit 1

    # globals
    CLIENT_BRANCH=$(git branch | grep "*" | cut -d" " -f2)
    CLIENT_REMOTE=$(git remote -v | grep heroku-symbl-vonage-client)

    # have we created the heroku remote
    if [[ "${CLIENT_REMOTE}" == "" ]]; then
        echo " "
        echo "Setting up Symbl-Vonage CLIENT..."
        heroku create "${CLIENT_NAME}"
        heroku git:remote -a "${CLIENT_NAME}"
        git remote rename heroku heroku-symbl-vonage-client
    fi

    # Add in the environment variables
    GET_VALUE=$(heroku config:get --app="${CLIENT_NAME}" NODE_ENV)
    if [[ "${GET_VALUE}" == "" ]]; then
        echo " "
        echo "WARNING: Setting CLIENT's NODE_ENV to development to use free Heroku Account"
        echo " "
        heroku config:set --app="${CLIENT_NAME}" NODE_ENV="development" >/dev/null 2>&1
    fi
    GET_VALUE=$(heroku config:get --app="${CLIENT_NAME}" APP_ID)
    if [[ "${GET_VALUE}" == "" ]]; then
        heroku config:set --app="${CLIENT_NAME}" APP_ID="${APP_ID}" >/dev/null 2>&1
    fi
    GET_VALUE=$(heroku config:get --app="${CLIENT_NAME}" APP_SECRET)
    if [[ "${GET_VALUE}" == "" ]]; then
        heroku config:set --app="${CLIENT_NAME}" APP_SECRET="${APP_SECRET}" >/dev/null 2>&1
    fi
    GET_VALUE=$(heroku config:get --app="${CLIENT_NAME}" SAMPLE_SERVER_BASE_URL)
    if [[ "${GET_VALUE}" == "" ]]; then
        heroku config:set --app="${CLIENT_NAME}" SAMPLE_SERVER_BASE_URL="https://${SERVER_NAME}.herokuapp.com" >/dev/null 2>&1
    fi

    # Debug
    # heroku logs --app=${USER}-symbl-vonage-client --tail
    # heroku run bash --app=${USER}-symbl-vonage-client

    # deploy the server
    heroku buildpacks:clear --app="${CLIENT_NAME}"
    heroku buildpacks:set --app="${CLIENT_NAME}" https://github.com/dvonthenen/subdir-heroku-buildpack
    heroku config:set --app="${CLIENT_NAME}" PROJECT_PATH=React-Basic-Video-Chat
    heroku buildpacks:add --app="${CLIENT_NAME}" heroku/nodejs
    git push heroku-symbl-vonage-client "${CLIENT_BRANCH}:main"

    set -x

popd || exit 1

echo " "
echo " "
echo "Successfully deployed!"
