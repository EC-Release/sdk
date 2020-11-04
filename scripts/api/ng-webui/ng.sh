#!/bin/bash
if [ ! -f "~/.ec/agent" ]; then
    source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1.2beta.linux64_conf.txt)
fi

source <(wget -O - https://ec-release.github.io/sdk/scripts/api/ng-webui/ng_conf.sh)

# refresh the hash
export EC_PPS=${CA_PPRS}
export EC_PPS=$(agent -hsh)
printf "\n ****** EC_PPS: %s\n\n", $EC_PPS

agent -cfg .ec/api/conf/api.yaml
