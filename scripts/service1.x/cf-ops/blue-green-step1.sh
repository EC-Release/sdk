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
    #cat ./push/manifest.yml        
    cd ./push
    cf push --no-start > ~tmp 2>&1
    #cat ~tmp
    ref=$(cat ~tmp | grep -e 'FAILED')    
    if [[ -z "$ref" ]]; then
      printf "0"
      return
    fi
    
    cd -  &> /dev/null
    printf "1"
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

  instStep1=$(cat $__CACHED_ALL_INSTS | grep -e $zon'-'$MISSION)
  if [[ ! -z "$instStep1" ]]; then
    printf "%s instance %s has had a cloned instance %s\n" "$__ERR" "$1" $zon'-'$MISSION
    return
  fi
  
  ref=$(verifyEnvs "$1")
  #echo '$verifyEnvs: '$ref
  #logger 'verifyEnvs' "$ref"
  #checkInLogger 'verifyEnvs'
  if [[ $ref != *"$__PAS"* ]]; then
      printf "%s instance %s failed verify env variables" "$__ERR" "$1"
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
    
    appName=$(findInstOfOrigin "$line")
    if [[ -z "$appName" ]]; then
      ref=$(printf "%s findInstOfOrigin could not identify associated instance with the name (%s)\n" "$__ERR" "$line")
      logger 'findInstOfOrigin' "$ref"
      continue
    fi
    
    ref=$(instQualifiedForStep1 $appName)
    if [[ $ref != *"$__PAS"* ]]; then
      logger 'instQualifiedForStep1' "$ref"
      continue
    fi

    ref=$(printf "%s findInstsQualifiedForStep1 successfully verified instance (%s)\n" "$__PAS" "$line")
    logger 'findInstsQualifiedForStep1' "$ref"
  done < ~insts
  
  checkInLogger 'findInstOfOrigin'
  checkInLogger 'instQualifiedForStep1'
  return
}

function bgStep1ClonePush () {

  printf "\nget appointed instances..\n"
  getAppointedInsts | awk 'NR!=1 {print $1}' > ~insts
  cat ~insts  
  
  while read -r line; do
    
    appName=$(findInstOfOrigin "$line")
    if [[ -z "$appName" ]]; then
      printf "%s findInstOfOrigin could not identify associated instance with the name (%s)\n" "$__ERR" "$line"
      continue
    fi
    
    ref=$(instQualifiedForStep1 "$appName")
    if [[ "$ref" != *"$__PAS"* ]]; then
      logger 'instQualifiedForStep1' "$ref"
      continue
    fi
      
    printf "continue push the cloned instance for instance %s\n" "$line"
    
    ref=$(setEnvs "$appName")
    if [[ "$ref" != *"$__PAS"* ]]; then
      logger 'setEnvs' "$ref"  
      continue
    fi
     
    #re-visit 
    #debugger 'bgStep1ClonePush' "$(cat ./push/manifest.yml)"
      
    ref=$(pushService "$appName")
    #echo '$ref: "'$ref'"'
    if [[ "$ref" != "0" ]]; then
      ref1=$(printf "%s pushService for instance %s unsuccessful\n" "$__ERR" "$appName")
      logger 'pushService' "$ref1"
      continue
    fi
      
    setStep1CompletedEnv "$appName"
    ref=$(printf "%s instance %s updated successful in step 1\n" "$__PAS" "$line")
    logger 'bgStep1ClonePush' "$ref"
      
  done < ~insts
  
  #echo "\n\nupdate completed.\n\n"
  checkInLogger 'instQualifiedForStep1'
  checkInLogger 'setEnvs'
  checkInLogger 'pushService'
  #checkInLogger 'bgStep1ClonePush'
  return 0
}
