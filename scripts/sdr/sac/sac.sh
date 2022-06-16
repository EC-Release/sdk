#!/bin/bash

while [[ $(type -t getAdmHash) != function ]]
do
  source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/cipher/crypto.sh)
  sleep 1
done

source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdr/sac/sac_conf.sh)

if [[ ! -z "${PORT}" ]]; then
  export EC_PORT=":$PORT"
fi

if [[ -f ".hash" ]]; then
  export EC_CSC=$(cat ".hash")
else
  echo " ! exiting due to missing client secret .."
  exit 1
fi

hn0=$(getURLHostname "$EC_API_OA2")
pn0=$(getURLPort "$EC_API_OA2")      

h=$(tcpHealthCheck "$hn0" "$pn0")
echo "       [-] sac master health probe via tcp. ${h}"
until [[ "$h" == "OK" ]]
do
  echo "       [-] re-try sac master health probe via tcp. ${h}"
  sleep 3
  h=$(tcpHealthCheck "$hn0" "$pn0")
done


snHost=$(getURLHostnameAndPortAndScheme "$EC_SEED_NODE")
shHost=$(getURLHostnameAndPortAndScheme "$EC_SEED_HOST")

EC_PPS_BK="$EC_PPS"
  
export \
EC_SEED_NODE=$(printf "%s/1.2-b/%s" "$snHost" "$EC_API_APP_NAME") \
EC_SEED_HOST=$(printf "%s/1.2-b/%s" "$shHost" "$EC_API_APP_NAME") \
EC_PPS=$(getAdmHash "$EC_PPS")

echo "    |_ setting db permission .."
if [[ -f "$HOME/.ec/.db" ]]; then
  chmod 666 "$HOME/.ec/.db"
  #give room for launching another process
  sleep 1
fi

while true; do
  if [[ "$EC_DBG" == "true" ]]; then
    echo "     |_ launching sac slave .. [dbg]"
    dev -cfg "$HOME/.ec/sac-slav/conf/sac.yaml"
  else
    echo "     |_ launching sac slave .. "
    sac -cfg "$HOME/.ec/sac-slav/conf/sac.yaml"
  fi
  
  sleep 1
  export EC_PPS=$(getAdmHash "$EC_PPS_BK")
done

