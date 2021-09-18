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
    {
      cf push
    }
    cd -
}

function findInstsQualifiedForStep1 () {
    
  printf "\nget instances without step1 suffix..\n"
  getAppointedInsts | awk 'NR!=1 && $1 !~ /-'$MISSION'/ {print $1}' > ~insts
  
  printf "\nloop into instances without step1 suffix..\n"
  while read -r line; do
    
    url=$(findCurrentRouting $line)
    if [[ -z $url ]]; then
      printf "instance %s does not have a routing. continue identify next instance\n" "$line" | tee -a ~failedFindInstsQualifiedForStep1
      continue
    fi
    
    zon=$(echo $url | cut -d'.' -f 1)
    uid=$(isUUID $zon)
    if [[ $uid != "0" ]]; then
      printf "\ninstance url %s does not appear to be a service instance. continue identify next instance\n" "$url" | tee -a ~failedFindInstsQualifiedForStep1
      continue
    fi    
    
    instStep1=$(cat ~allInsts | grep -e $line'-'$MISSION)
    if [[ ! -z "$instStep1" ]]; then
      printf "\ninstance %s has had a cloned instance. continue identify next instance\n" "$line" | tee -a ~failedFindInstsQualifiedForStep1
      continue
    fi
    
    instStep2=$(hasEnvVar $line 'UPDATED: '$MISSION)
       
    if [[ -z "$instStep2" ]]; then
      printf "\ninstance %s has not been updated. added to the list" "$line"
      printf "$line\n" >> ~findInstsQualifiedForStep1
    fi
    
  done < ~insts
  
  {
    rm ~insts
  }
  
}

function bgStep1ClonePush () {

  wget -q --show-progress -O ./manifest.yml https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/push/manifest.yml
  printf "\nget appointed instances..\n"
  getAppointedInsts | awk 'NR!=1 {print $1}' > ~insts
  cat ~insts

  #if [[ "$PRIORITY_FILE" != "0" ]]; then
  #  cat $PRIORITY_FILE > ./service_list.txt
  #else 
  #  cf a | grep -E 'started|stopped' | awk '$1 == /-2022/ {print $1}' > ./service_list.txt
  #fi

  #findInstsQualifiedForStep1
    
  while read -r line; do
    
      : 'qualifiedInst=$(cat ~findInstsQualifiedForStep1.txt | grep -e $line)
      if [[ -z "$qualifiedInst"]]; then
        printf "\ninstance %s is not qualified for blue-green step 1. continue to next instance\n" "$line"
        continue
      fi'
      
      ZONE=${line%-$MISSION}
    
      echo "Updating $ZONE.."      
      
      ref=$(hasEnvVar "$ZONE" 'UPDATED: '$MISSION)    
      if [[ $ref == "0" ]]; then
        printf "instance %s had been completed step1. continue to next instance\n" "$ZONE"
        continue
      fi
      
      mkdir -p push
      cp ./manifest.yml ./push/manifest.yml
      
      #cat ./push/manifest.yml
      {
        setEnvs      
        echo "Manifest file updated"    
      } || {
        echo "failed update the manifest file. proceed to next instance"
        echo "${ZONE}" >> ~failedBgStep1ClonePush
        continue
      }
      
      {
        pushService | tee -a ~output
        if grep -q FAILED output.txt; then
          echo "Service update unsuccessful. proceed to next instance"
          echo "${ZONE}" >> ~failedBgStep1ClonePush
        else
          setStep1CompletedEnv ${ZONE}
          #cf set-env ${ZONE} UPDATED '2022'
          echo "service ${ZONE} updated successful" >> ~bgStep1ClonePush
          
        fi        
      } || {
        echo "service update unsuccessful. proceed to next instance"
        echo "${ZONE}" >> ~failedBgStep1ClonePush
      }
      
  done < ~insts
    
  echo "update completed."    

}
