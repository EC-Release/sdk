#!/bin/bash

while [[ $(type -t getURLHostnameAndPortAndScheme) != function ]]
do
  source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/libs/common.sh)
  sleep 1
done

[[ -f "./~api" ]] && rm ./~api
[[ -f "./~sdr" ]] && rm ./~sdr

export \
EC_AGT_MODE="x:gateway" \
EC_AGT_GRP="svc-group"

mkdir -p ~/.ec/scripts
#wget -q --show-progress -O ~/.ec/scripts/executor.sh https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/api/scripts/executor.sh
wget -q -O ~/.ec/scripts/cli.sh https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdr/scripts/cli.sh &> /dev/null
wget -q -O ~/.ec/scripts/proc.sh https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdr/scripts/proc.sh &> /dev/null
wget -q -O ~/.ec/scripts/exec.sh https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdr/scripts/exec.sh &> /dev/null
#chmod +x ~/.ec/scripts/executor.sh ~/.ec/scripts/exec.sh ~/.ec/scripts/cli.sh
chmod +x ~/.ec/scripts/exec.sh ~/.ec/scripts/cli.sh ~/.ec/scripts/proc.sh

if [[ "$EC_TLS" != "true" ]]; then
  export EC_TLS=false
fi

case $EC_API_APP_NAME in
  ops)
    # legacy
    printf "\n launching webportal 1.x\n"
    source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdr/portal1.x/portal.sh) &> /dev/null
    ;;
  "dcsc" | "dc")
    # legacy
    printf "\n launching DC Service Cloud Portal 1.x\n"
    source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdr/dcsc1.x/portal.sh) &> /dev/null
    ;;
  *)
    export EC_API_APP_NAME="ec"    
    
    if [[ ! -z "$ZONE" ]]; then
      
      echo "        |_ boostrapping svc.."
      source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdr/svc/svc1.1.sh)
      exit 1
    fi
    
    if [[ ! -z "$SAC_TYPE" ]]; then

      
      if [[ -f ".hash" ]]; then
        export EC_CSC=$(cat ".hash")
      fi

      export \
      EC_SEED_HOST="$SAC_URL" \
      EC_SEED_NODE="$EC_NOD" \
      EC_PPS="$EC_CSC" \
      EC_API_DEV_ID="$EC_CID" \
      EC_API_OA2=$(getURLHostnameAndPortAndScheme "$SAC_URL_MST")

      echo "   |_ boostrapping sac slave.."
      source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdr/sac/sac.sh)
      exit 1
    fi
    
    source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdr/ng-webui/ng.sh)
    ;;
esac

