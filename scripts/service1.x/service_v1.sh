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

echo "import libraries & tools.."
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/libs/common.sh)
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/cf-ops/base.sh)
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/cf-ops/ext-lib-a.sh)
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/cf-ops/ext-lib-b.sh)
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/cf-ops/blue-green-step1.sh)
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/cf-ops/blue-green-step2.sh)
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/cf-ops/find-problem-instances.sh)

wget -q --show-progress -O ./manifest.yml https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/push/manifest.yml  
curl -s -o $(pwd)/field_list.txt https://${GITHUB_TOKEN}@raw.githubusercontent.com/EC-Release/service-update/main/field_list.txt
curl -s -o $(pwd)/docker-creds.yml https://${GITHUB_TOKEN}@raw.githubusercontent.com/EC-Release/service-update/main/docker-creds.yml

echo "checking env"
echo ${VCAP_APPLICATION}
if [[ ! -z "${VCAP_APPLICATION}" ]]; then
    wget -O run.sh https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/run_v1.sh
    chmod 755 run.sh
    ./run.sh
else

  #trap 'checkInLogger "bgStep1ClonePush" "$LINENO" "$?" "$BASH_COMMAND"' EXIT ERR RETURN
    
  case $OPS_NAME in
  1000)
    login    
    printf "\nexecute blue-green step 1\n\n"    
    bgStep1ClonePush
    checkInLogger 'bgStep1ClonePush'
    #trap - EXIT ERR RETURN
    exit 0
    ;;
  1003)    
    login
    printf "\nidentify instances qualified for step1\n\n"
    # find instances that have no suffix "E.g. -2022" and are qualified for running bg step 1
    findInstsQualifiedForStep1
    checkInLogger 'findInstsQualifiedForStep1'
    exit 0
    
    ;;
  1006)
    login
    printf "\nidentify instances qualified for the step 2\n\n"
    findInstsQualifiedForStep2
    checkInLogger 'findInstsQualifiedForStep2'
    exit 0
    ;;
  1002)
    login
    
    printf "\nexecute blue-green step 2\n\n"
    procStep2
    checkInLogger 'procStep2'
    exit 0
    ;;
  1007)
    login
    
    printf "\nupdate credential for instances have completed the blue-green step 2\n\n"
    procDoneStep2
    checkInLogger 'procDoneStep2'
    exit 0
    ;;
  1004)
    printf "\nclean up and remove the original instances\n\n"
    ;;
  1005)
    printf "\nrestort instance to the original state.\n\n"
    ;;
  1008)
    login    
    printf "\nad-hoc memory scaling on 2022 insts (1G->128M)\n\n"
    adhocMemScaling
    exit 0
    ;;
  1001)
    login
    
    printf "\nfinding problematic instances\n\n"
    getProblemInstances
  #"1001" | "1002")
    checkInLogger 'getProblemInstances'
    exit 0
    ;;
  *)
    printf "\nno operations found\n\n"
    ;;
  esac
fi
