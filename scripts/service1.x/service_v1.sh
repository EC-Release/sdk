#!/bin/bash
#
#  Copyright (c) 2020 General Electric Company. All rights reserved.
#
#  The copyright to the computer software herein is the property of
#  General Electric Company. The software may be used and/or copied only
#  with the written permission of General Electric Company or in accordance
#  with the terms and conditions stipulated in the agreement/contract
#  under which the software has been supplied.
#
#  author: apolo.yasuda@ge.com
#

#temp. pls remove this line in release
#sleep 10
echo "import library & tools"
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/cf-ops/base.sh)
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/cf-ops/blue-green-step1.sh)
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/cf-ops/find-problem-instances.sh)

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
    printf "\nfinding problematic instances\n\n"
    getProblemInstances
  #"1001" | "1002")
    ;;
  *)
    printf "\nno operations found\n\n"
    ;;
  esac
fi
