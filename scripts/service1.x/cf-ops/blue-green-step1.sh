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


function updateService(){
    #cf delete ${ZONE} -f 
    #cd ./push
    cf push
    #cd -
}

function findInstsQualifiedForStep1 () {
  insts=$(cf a | grep -E 'started|stopped')
  
  echo $insts | while -r read line; do 
    instStep1=$(echo $insts | awk -v ref=${line}-${MISSION} '($1==ref) {print $1}')
    if [[ -z $instStep1 ]]; then
      printf "$line\n" >> ~tmp.txt
    fi
    cat ~tmp.txt    
  done 
}

function bgStep1ClonePush(){
    mkdir -p push
    wget -q --show-progress -O ./manifest.yml https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/push/manifest.yml
    login
    echo "Login successful"
    
    if [[ "$PRIORITY_FILE" != "0" ]]; then
      cat $PRIORITY_FILE > ./service_list.txt
    else 
      cf a | grep -E 'started|stopped' | awk '$1 !~ /-2022/ {print $1}' > ./service_list.txt
    fi
    
    while read line; do
      ZONE=$line
      echo "Updating $ZONE.."
      
      {
        getEnvs
        echo "Fetched ENVs"      
      } || {
        echo "failed fetched envs for ${ZONE}. proceed to next instance"
        echo "${ZONE}" > ./err_ins.txt
        
        continue
      }
      
      op=$(cat values.txt | grep UPDATED | cut -d ' ' -f2)
      if [[ "$op" == *"$MISSION"* ]]; then
        echo "instance $ZONE has been marked as updated.　proceed to next instance"
        continue
      fi
      
      cp ./manifest.yml ./push/manifest.yml
      
      #cat ./push/manifest.yml
      {
        setEnvs      
        echo "Manifest file updated"    
      } || {
        echo "failed update the manifest file. proceed to next instance"
        echo "${ZONE}" > ./err_ins.txt
        continue
      }
      
      cat ./push/manifest.yml
      
      cd ./push
      {
        updateService | tee output.txt
        if grep -q FAILED output.txt; then
          echo "Service update unsuccessful. proceed to next instance"
          echo "${ZONE}" >> ./../err_ins.txt
        else
          cf set-env ${ZONE} UPDATED '2022'
          echo "Service updated successful"
        fi        
      } || {
        echo "service update unsuccessful. proceed to next instance"
      }
      cd -
    done < service_list.txt
    
    echo "update completed."    
         
    {
      echo "instance list failed during the update.."
      cat err_ins.txt      
    }
}
