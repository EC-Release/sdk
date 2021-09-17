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

function login(){
    #echo  cf login -a ${CF_API} -u ${CF_USR} -p ${CF_PWD} -o ${ORG} -s ${SPACE}
    cf login -a ${CF_API} -u ${CF_USR} -p ${CF_PWD} -o ${ORG} -s ${SPACE}
}

#getAllInsts return appointed instances for the workflow
function getAppointedInsts () {
  if [[ $PRIORITY_FILE == "0" ]]; then
    printf "get all cf instances..\n"
    cf a | grep -e 'started' -e 'stopped' | awk '{print $1}' > ~tmp
  else 
    printf "get appointed cf instances..\n"
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
