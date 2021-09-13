#!/bin/bash

#temp. pls remove this line in release
#sleep 10
echo "import library & tools"
:'source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/cf-ops/base.sh)
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/cf-ops/blue-green-step1.sh)

echo "checking env"
echo ${VCAP_APPLICATION}
if [[ ! -z "${VCAP_APPLICATION}" ]]; then
    wget -O run.sh https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/run_v1.sh
    chmod 755 run.sh
    ./run.sh
else

  case $OPS_NAME in
  1000)
    bgStep1ClonePush
    ;;
  1001)
    printf "\n find instances\n\n"
    
  #"1001" | "1002")
    ;;
  *)
    printf "\n no operations found\n\n"
    ;;
  esac
fi
'
