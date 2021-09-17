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

#hasEnvVar is to verify of the env var $1 exists in the app name $1
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
     cat ~allInsts > ~tmp
  else 
    printf "getting appointed cf instances..\n"
    cat $PRIORITY_FILE > ~tmp
  fi
  cat ~tmp
}

function getEnvs(){
    {
      rm values.txt
      echo "removed existing values.txt. continue updating ${ZONE}"
    } || {
      echo "no values.txt found. continue updating ${ZONE}"
    }
    
    printf "\n\n***** begin of cf env vars for %s\n\n" "${ZONE}"
    cf env ${ZONE} | tee values.txt
    printf "\n\n***** end of cf env vars for %s\n\n" "${ZONE}"
}

function setEnvs(){

    while read line; do       
       op=$(cat values.txt | grep $line | cut -d ' ' -f2)
       eval "sed -i -e 's|{{ZONE}}|$op|g' ./push/manifest.yml"
    done < field_list.txt    
    
    eval "sed -i -e 's|{{DOCKER_USERNAME}}|$DOCKER_USERNAME|g' ./push/manifest.yml"
    eval "sed -i -e 's|{{GITHUB_TOKEN}}|$GITHUB_TOKEN|g' ./push/manifest.yml"    
    
    eval "sed -i -e 's|{{MISSION}}|$MISSION|g' ./push/manifest.yml" 
}

#$1: trgtInstName
#$2: current instance index
function updateDockerCred () {
  eval $(parse_yaml docker-creds.yml)
  ref=$(expr $2 % 4)
  op=$(printf "CF_DOCKER_PASSWORD=%s cf push %s --docker-image %s --docker-username %s" "$ec_$ref_token" "$1" "$ec_$img" "$ec_$ref_username")
  eval $op > ~tmp 2>&1
  
  echo $op >> ~debugger
  #cat ~tmp >> ~debugger
  
  ref1=$(cat ~tmp | grep -e 'FAILED')
  if [[ -z $ref1 ]]; then
    printf "0"
    return
  fi
  
  printf "1"
}

