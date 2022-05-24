#!/bin/bash

while [[ $(type -t getAdmHash) != function ]]
do
  source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/cipher/crypto.sh)
  sleep 1
done

source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdr/svc/svc1.1_conf.sh)

if [[ ! -z "${PORT}" ]]; then
  export EC_PORT=":$PORT"
fi

brev="1.2-b"
snHost=$(getURLHostnameAndPortAndScheme "$EC_SEED_NODE")
sdHost=$(getURLHostnameAndPortAndScheme "$EC_API_OA2")
shHost=$(getURLHostnameAndPortAndScheme "$EC_SEED_HOST")

EC_PPS_BK="$EC_PPS"

export \
EC_SEED_NODE=$(printf "%s/%s/%s" "$snHost" "$brev" "$EC_API_APP_NAME") \
EC_SEED_NODE_T=$(printf "%s/%s/%s/term" "$snHost" "$brev" "$EC_API_APP_NAME") \
EC_SEED_NODE_D=$(printf "%s/%s/term" "$sdHost" "$brev") \
EC_SEED_HOST=$(printf "%s/%s/%s" "$shHost" "$brev" "$EC_API_APP_NAME") \
EC_PPS=$(getAdmHash "$EC_PPS")

node ./app.js &

while true; do
  if [[ "$EC_DBG" == "true" ]]; then
    echo "        |_ launching background cipher svc .. [dbg]"
    dev -cfg "$HOME/.ec/svc/conf/svc.yaml"
  else
    echo "        |_ launching background cipher svc .."
    svc -cfg "$HOME/.ec/svc/conf/svc.yaml"
  fi
  
  sleep 1
  export EC_PPS=$(getAdmHash "$EC_PPS_BK")
done
