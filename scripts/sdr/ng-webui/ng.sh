#!/bin/bash

while [[ $(type -t getAdmHash) != function ]]
do
  source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/cipher/crypto.sh)
  sleep 1
done

source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdr/ng-webui/ng_conf.sh)

if [[ ! -z "${PORT}" ]]; then
  export EC_PORT=":$PORT"
fi

snHost=$(getURLHostnameAndPortAndScheme "$EC_SEED_NODE")
shHost=$(getURLHostnameAndPortAndScheme "$EC_SEED_HOST")

export \
EC_SEED_NODE=$(printf "%s/1.2-b/%s" "$snHost" "$EC_API_APP_NAME") \
EC_PPS=$(getAdmHash "$EC_PPS")

: 'if [[ -z "${EC_DEV}" ]]; then
  export \
  EC_SEED_HOST=$(printf "%s/1.2-b/%s" "$shHost" "$EC_API_APP_NAME")
else
  export \
  EC_SEED_HOST=$(printf "%s/1.2-b/%s" "$shHost" "$EC_API_APP_NAME")
fi'

echo "      |_ launching seeder .."
sdr -cfg "$HOME/.ec/sdr/conf/sdr.yaml"
