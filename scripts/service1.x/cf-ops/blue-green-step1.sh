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

      uid=$(isUUID $ZONE)
      if [[ $uid != "0" ]]; then
        printf "the instance %s does not appear to be a regulated service zone id. continue identify next instance\n" "$ZONE" | tee -a ~failedBgStep1ClonePush
        continue
      fi

      echo "Updating $ZONE.."      

      
      ref=$(cat ~allInsts | grep -e "$ZONE-$MISSION")
      if [[ ! -z "$ref" ]]; then
        printf "instance %s has a cloned instance from step 1. continue identify next instance\n" "$ZONE" | tee -a ~failedBgStep1ClonePush
        continue
      fi

      ref=$(hasEnvVar "$ZONE" 'UPDATED: '$MISSION)    
      if [[ $ref == "0" ]]; then
        printf "instance %s had been completed step1. continue to next instance\n" "$ZONE" | tee -a ~failedBgStep1ClonePush
        continue
      fi

      mkdir -p push
      cp ./manifest.yml ./push/manifest.yml

      #cat ./push/manifest.yml

      ref=$(setEnvs "$ZONE")
      if [[ $ref != "0" ]]; then
        printf "failed set up env vars for instance %s" "$ZONE" | tee -a ~failedBgStep1ClonePush
        continue
      fi

      printf "manifest file updated for instance %s" "$ZONE"

      pushService > ~output
      ref=$(cat ~output | grep -e 'FAILED')
      if [[ ! -z $ref ]]; then
        printf "instance %s update unsuccessful. proceed to next instance" "$ZONE" | tee -a ~failedBgStep1ClonePush
      else
        setStep1CompletedEnv ${ZONE}
        printf "service %s updated successful" "$ZONE" | tee -a ~bgStep1ClonePush          
      fi        
      
  done < ~insts
    
  echo "update completed."    

}
