#!/bin/bash

source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/api/portal1.x/portal_conf.sh)

if [[ -z "${EC_PPS}" ]]; then
    export EC_PPS=$CA_PPRS    
fi

export EC_PPS=$(agent -hsh -smp)
# PORT indicating a custom environment
if [[ ! -z "${PORT}" ]]; then
  EC_PORT=:$PORT
fi

cd ~/.ec/api && ls -al
agent -cfg ./conf/api.yaml
#agent -cfg ./conf/api.yaml &
#sleep 5 && tail -f $(ls -t ~/.ec/*.log | head -1)
