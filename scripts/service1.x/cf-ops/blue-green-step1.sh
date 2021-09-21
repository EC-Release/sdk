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

function pushService () {
    cat ./push/manifest.yml        
    cd ./push
    cf push --no-start > ~tmp 2>&1
    cat ~tmp
    cd -
}

#$1 cf app name
function instQualifiedForStep1 () {  
  
  url=$(findCurrentRouting $1)
  if [[ -z $url ]]; then
    printf "%s instance %s does not have a routing.\n" "$__ERR" "$1"
    return
  fi

  zon=$(echo $url | cut -d'.' -f 1)
  uid=$(isUUID $zon)
  if [[ $uid != "0" ]]; then
    printf "%s instance url %s does not appear to be a service instance.\n" "$__ERR" "$url"
    return
  fi    

  instStep1=$(cat ~allInsts | grep -e $zon'-'$MISSION)
  if [[ ! -z "$instStep1" ]]; then
    printf "%s instance %s has had a cloned instance %s\n" "$__ERR" "$1" $zon'-'$MISSION
    return
  fi

  #condition deprecated
  #instStep2=$(hasEnvVar $1 'UPDATED: '$MISSION)
  #if [[ -z "$instStep2" ]]; then
  #  printf "%s instance %s is not updated and qualified for the step1." "$__PAS" "$1"
  #  return
  #fi
    
  printf "%s instance %s meets requirement for blue-green step 1\n" "$__PAS" "$1"
  return
}

function findInstsQualifiedForStep1 () {
    
  printf "\nget appointed instances..\n"
  getAppointedInsts | awk 'NR!=1 {print $1}' > ~insts
  cat ~insts
  
  while read -r line; do
    
    ref=$(instQualifiedForStep1 $line)
    logger 'instQualifiedForStep1' "$ref"
    if [[ $ref != *"$__PAS"* ]]; then
      continue
    fi      
      
  done < ~insts
  
  echo "finding completed."
  checkInLogger 'instQualifiedForStep1'
  return 0
}

function bgStep1ClonePush () {

  printf "\nget appointed instances..\n"
  getAppointedInsts | awk 'NR!=1 {print $1}' > ~insts
  cat ~insts
  
  wget -q --show-progress -O ./manifest.yml https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/push/manifest.yml  
  while read -r line; do
    
    ref=$(instQualifiedForStep1 $line)
    logger 'instQualifiedForStep1' "$ref"
    if [[ $ref != *"$__PAS"* ]]; then
      continue
    fi
      
    printf "continue push the cloned instance for service %s\n" "$line"
    mkdir -p push
    cp ./manifest.yml ./push/manifest.yml    
    
    ref=$(setEnvs "$line")
    logger 'setEnvs' "$ref"  
    if [[ $ref != *"$__PAS"* ]]; then
        #ref=$(printf "%s failed set up env vars for instance %s" "$__ERR" "$line")
        #logger 'bgStep1ClonePush' "$ref"
      continue
    fi
      
    debugger 'bgStep1ClonePush' "$(cat ./push/manifest.yml)"
      
    ref=$(pushService $line)
    logger 'pushService' "$ref"
    if [[ $ref != *"$__PAS"* ]]; then
      continue
    fi
      
    setStep1CompletedEnv "$line"
    ref=$(printf "%s service %s updated successful in step 1\n" "$__PAS" "$line")
    logger 'bgStep1ClonePush' "$ref"        
      
  done < ~insts
  
  echo "\n\nupdate completed.\n\n"
  checkInLogger 'instQualifiedForStep1'
  checkInLogger 'setEnvs'
  checkInLogger 'pushService'
  checkInLogger 'bgStep1ClonePush'
  return 0
}
