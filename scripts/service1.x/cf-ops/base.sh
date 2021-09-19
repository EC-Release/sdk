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

set -e
__ERR="EC_ERR"
__PAS="EC_PAS"
__UKN="EC_UKN"
__DBG="EC_DBG"
__DBG_TMP="~debugger"
__DBG_FLE="debug.log"

#hasEnvVar is to verify of the env var $2 exists in the app name $1
# $1: <app-name>
# $2: Env Key keyword
function hasEnvVar () {
    cf e $1 > ~tmp
    ref1=$(cat ~tmp | grep -e "$2" | awk '$2!="" {print $1}')
    if [[ ! -z $ref1 ]]; then
      printf "0"
      return
    fi
    
    printf "1"
}

#getEnvVar is to get the env var $2 in the app name $1
# $1: <app-name>
# $2: Env Key keyword
#function getEnvVar () {
#  cf e $1 > ~tmp
#  ref=$(cat ~tmp | grep -e "$2" | awk '{print $2}')
#  printf "%s" "$ref"
#}

function login () {
    #echo  cf login -a ${CF_API} -u ${CF_USR} -p ${CF_PWD} -o ${ORG} -s ${SPACE}
    cf login -a ${CF_API} -u ${CF_USR} -p ${CF_PWD} -o ${ORG} -s ${SPACE}
    getAllInsts
}

#getAppointedInsts return appointed instances for the workflow
function getAllInsts () {
  #sleep 1
  printf "\ncaching all cf instances..\n"
  cf a | grep -e 'started' -e 'stopped' | awk '{print $1}' > ~allInsts
  #cat ~instsAll
}

#getAppointedInsts return appointed instances for the workflow
function getAppointedInsts () {
  if [[ $PRIORITY_FILE == "0" ]]; then
    printf "getting all cf instances..\n"
    cp ~allInsts ~tmp
  else 
    printf "getting appointed cf instances..\n"
    cp $PRIORITY_FILE ~tmp
  fi
  cat ~tmp
}

#function getEnvs () {
#    cf env $1 > ~tmp
#    cat ~tmp
#}

#$1: app name
function setEnvs(){
  cf env $1 > ~tmp 2>&1
  ref=$(cat ~tmp | grep -e 'FAILED')
  if [[ ! -z $ref ]]; then
    printf "1"
    return
  fi
  
  while read line; do
    ref1=$(cat ~tmp | grep $line | cut -d ' ' -f2)
    if [[ -z $op ]]; then
      printf "1"
      return
    fi
    
    eval "sed -i -e 's|{{$line}}|$ref1|g' ./push/manifest.yml"
  done < field_list.txt

  eval "sed -i -e 's|{{DOCKER_USERNAME}}|$DOCKER_USERNAME|g' ./push/manifest.yml"
  eval "sed -i -e 's|{{GITHUB_TOKEN}}|$GITHUB_TOKEN|g' ./push/manifest.yml"    

  eval "sed -i -e 's|{{MISSION}}|$MISSION|g' ./push/manifest.yml"
  printf "0"
}

#$1: trgtInstName
#$2: current instance index
function updateDockerCred () {
  eval $(parse_yaml docker-creds.yml)
  ref=$(expr $2 % 4)
  a=$(eval echo '$ec_'$ref'_token')
  b=$(eval echo '$ec_'$ref'_username')
  op=$(printf "CF_DOCKER_PASSWORD=%s cf push %s --docker-image %s --docker-username %s" "$a" "$1" "$ec_img" "$b")
  eval $op > ~tmp 2>&1
  
  echo $op >> ~debugger
  cat ~tmp >> ~debugger
  
  ref1=$(cat ~tmp | grep -e 'FAILED')
  if [[ -z $ref1 ]]; then
    printf "0"
    return
  fi
  
  printf "1"
}

#$1 function name
function checkInLogger () {
  [[ -e "$__DBG_TMP" ]] && cp "$__DBG_TMP" ./logs/"$__DBG_FLE"
  [[ -e "~$__ERR$1" ]] && cp ~procStep2 ./logs/insts-completed-step2.log
  [[ -e ~failedProcStep2Insts ]] && cp ~failedProcStep2Insts ./logs/insts-failed-step2.log
  [[ -e ~unknownProcStep2Insts ]] && cp ~unknownProcStep2Insts ./logs/insts-unknown-step2.log
}

#$1: function name
#$2: log output
function logger () {
  if [[ $2 == *"$__ERR"* ]]; then
    printf "%s\n" "$2" | tee -a ~$__ERR$1
    return
  fi
  
  if [[ $2 == *"$__PAS"* ]]; then
    printf "%s\n" "$2" | tee -a ~$__PAS$1
    return
  fi
  
  if [[ $2 == *"$__UKN"* ]]; then
    printf "%s\n" "$2" | tee -a ~$__UKN$1
    return
  fi
  
  if [[ $2 == *"$__DBG"* ]]; then
    printf "%s\n" "$2" | tee -a ~$__DBG
    return
  fi
}

