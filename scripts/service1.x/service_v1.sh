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
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/helper.sh)
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/cf-ops/base.sh)
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/cf-ops/ext-lib-a.sh)
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/cf-ops/ext-lib-b.sh)
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/cf-ops/blue-green-step1.sh)
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/cf-ops/blue-green-step2.sh)
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/cf-ops/find-problem-instances.sh)
curl -s -o $(pwd)/field_list.txt https://${GITHUB_TOKEN}@raw.githubusercontent.com/EC-Release/service-update/main/field_list.txt

echo "checking env"
echo ${VCAP_APPLICATION}
if [[ ! -z "${VCAP_APPLICATION}" ]]; then
    wget -O run.sh https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/run_v1.sh
    chmod 755 run.sh
    ./run.sh
else

  case $OPS_NAME in
  1000)
    login
    printf "\nexecute blue-green step 1\n\n"
    bgStep1ClonePush
    mkdir -p logs
    ;;
  1003)    
    login
    printf "\nidentify instances qualified for step1\n\n"
    # find instances that have no suffix "E.g. -2022" and are qualified for running bg step 1
    findInstsQualifiedForStep1
    mkdir -p logs
    cp ~findInstsQualifiedForStep1.txt ./logs/insts-qualified-4-step1.txt
    ;;
  1006)
    login
    printf "\identify instances qualified for the step 2\n\n"
    findInstsQualifiedForStep2
    cat ~findInstsQualifiedForStep2.txt
    mkdir -p logs
    cp ~findInstsQualifiedForStep2.txt ./logs/insts-qualified-4-step2.txt
    ;;
  1002)
    login
    printf "\identify instances qualified for the step 2\n\n"
    findInstsQualifiedForStep2
    #~findInstsQualifiedForStep2.txt
    #cat ~findInstsQualifiedForStep2.txt
    
    printf "\nexecute blue-green step 2\n\n"
    procStep2
    #cat ~procStep2.txt
    mkdir -p logs
    cp ~findInstsQualifiedForStep2.txt ./logs/insts-qualified-4-step2.log
    cp ~procStep2.txt ./logs/insts-completed-step2.log
    cp ~failedProcStep2Insts.txt ./logs/insts-failed-step2.log
    cp ~unknownProcStep2Insts.txt ./logs/insts-unknown-step2.log
    ;;
  1004)
    printf "\nclean up and remove the original instances\n\n"
    ;;
  1005)
    printf "\nrestort instance to the original state.\n\n"
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
