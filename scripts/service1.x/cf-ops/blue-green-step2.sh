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

function findInstsQualifiedForStep2 () {
  
  printf "\nget instances with MISSION suffix..\n"
  getAppointedInsts | awk 'NR!=1 {print $1}' > ~insts
  cat ~insts
  
  printf "\nloop into instances in the appointed instance list..\n"
  while read -r line; do
    
    theInst=${line%-$MISSION}
    
    instStep1=$(cat ~allInsts | grep -e "$theInst-$MISSION")
    if [[ -z "$instStep1" ]]; then
      printf "\ninstance %s does not have a cloned instance from step1. continue identify next instance\n" "$theInst" | tee -a ~failedFindInstsQualifiedForStep2
      continue
    fi
    
    url=$(findCurrentRouting $theInst)
    if [[ -z $url ]]; then
      printf "instance %s does not have a routing. continue identify next instance\n" "$line" | tee -a ~failedFindInstsQualifiedForStep2
      continue
    fi
    
    zon=$(echo $url | cut -d'.' -f 1)
    uid=$(isUUID $zon)
    if [[ $uid != "0" ]]; then
      printf "\nthe routing url %s does not appear to be a regulated URL for the instance %s. continue identify next instance\n" "$url" "$theInst" | tee -a ~failedFindInstsQualifiedForStep2
      continue
    fi
    
    instStep2=$(hasEnvVar "$theInst-$MISSION" 'UPDATED: '$MISSION)    
    if [[ $instStep2 == "0" ]]; then
      printf "\ninstance %s is valid for step2. added to the list" "$theInst"
      printf "$theInst\n" >> ~findInstsQualifiedForStep2
    fi
    
  done < ~insts
  
  {
    rm ~insts
  }
  
}

function procStep2 () {
   while read -r line; do
     origInstName=$(findInstOfOrigin $line)
     if [[ -z "$origInstName" ]]; then
       printf "\napp %s is not qualified for the step2. continue to next instance.\n" "$line"
       continue
     fi
     
     {
       stdout=$(updateInstURL $origInstName $line)
       if [[ $stdout = *"FAILED"* ]]; then
         printf "\ninstance %s failed in URL route re-mapping. continue to next instance.\n" "$line"
         printf "$line (failed updateInstURL)\n" >> ~failedProcStep2Insts.txt
         continue
       fi
       
       stdout=$(setStep2CompletedEnv $line)
       if [[ $stdout = "1" ]]; then 
         printf "\ninstance %s failed in setting step 2 Env. continue to next instance.\n" "$line"
         printf "$line (failed setStep2CompletedEnv)\n" >> ~failedProcStep2Insts.txt
         continue       
       fi
      
       printf "\ninstance %s has completed blue-green step 2 and added to the list\n" "$line"
       printf "$line\n" >> ~procStep2.txt                
     }
   done < ~findInstsQualifiedForStep2.txt

}
