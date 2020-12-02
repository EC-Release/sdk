#!/bin/bash

source <(wget -O - https://ec-release.github.io/sdk/scripts/api/ng-webui/ng_conf.sh)

if [[ -z "${EC_PPS}" ]]; then
    export EC_PPS=$CA_PPRS    
fi
  
export EC_PPS=$(agent -hsh)
printf "\n\nEC_PPS: %s\n\n" $EC_PPS
# PORT indicating a custom environment
if [[ ! -z "${PORT}" ]]; then
  EC_PORT=:$PORT
fi


cd ~/.ec/api && ls -al
agent -cfg ./conf/api.yaml &
#EC_PPS=$EC_PPS agent -mod api -app ec -apt $EC_PORT -oa2 $EC_API_OA2 -cid $EC_API_DEV_ID -sed $EC_SEED_NODE -dbg
sleep 5 && tail -f $(ls -t ~/.ec/*.log | head -1)
