#!/bin/bash

# Copyright 2022 Symbl.ai contributors. All Rights Reserved.
# SPDX-License-Identifier: MIT

# set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

set +x

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ -z "$(command -v heroku)" ]]; then
    echo " "
  echo "Please make sure node is installed."
  exit 1
fi

# SERVER component
pushd "${MY_DIR}/learning-opentok-node" || exit 1

    APP_NAME="${USER}-symbl-vonage-server"

    git remote remove heroku-symbl-vonage-server
    heroku apps:destroy --app="${APP_NAME}" --confirm="${APP_NAME}"

popd || exit 1

# CLIENT component
pushd "${MY_DIR}/opentok-web-samples" || exit 1

    APP_NAME="${USER}-symbl-vonage-client"

    git remote remove heroku-symbl-vonage-client
    heroku apps:destroy --app="${APP_NAME}" --confirm="${APP_NAME}"

popd || exit 1

echo "Successfully cleaned up!"
