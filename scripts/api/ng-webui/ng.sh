#!/bin/bash

source <(wget -O - https://ec-release.github.io/sdk/scripts/api/ng-webui/ng_conf.sh)

# refresh the hash
export EC_PPS=${CA_PPRS}
export EC_PPS=$(agent -hsh)
printf '\n\nEC_PPS%s\n\n' $EC_PPS
# PORT indicating a custom environment
if [[ ! -z "${PORT}" ]]; then
  EC_PORT=:$PORT
fi


cd ~/.ec/api && ls -al
agent -cfg ./conf/api.yaml &
sleep 5 && tail -f $(ls -t ~/.ec/*.log | head -1) 
