#!/bin/bash

{
    agent -ver
} || {
    source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1.2beta.linux64_conf.txt)
}

if [[ $# -ge 0 ]]; then
    agent $@
    exit 0
fi

source <(wget -O - https://ec-release.github.io/sdk/scripts/api/ng-webui/ng.sh)
