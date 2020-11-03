#!/bin/bash
if [ ! -f "~/.ec/agent" ]; then
    source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1.2beta.linux64_conf.txt)
fi

source <(wget -O - https://ec-release.github.io/sdk/scripts/api/ng-webui/ng_conf.sh)

if [ "$#" -ne 1 ]; then
    agent -cfg ~/.ec/api/conf/api.yaml
    exit 0
fi

agent $@
