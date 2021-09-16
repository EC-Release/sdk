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

  
  cf a | grep -e 'started' -e 'stopped' | awk '{print $1}' > ~instsAll.txt
  cat ~instsAll.txt | awk '$1 ~ /-'$MISSION'/ {print $1}' > ~insts.txt
  
  while read -r line; do
    
    #instStep1=$(cat ~instsAll.txt | grep -e $line'-'$MISSION)
    #if [[ ! -z "$instStep1" ]]; then
    #  printf "%s has a cloned instance %s. resume searching\n" "$instStep1"      
    #  continue
    #fi
    
    instStep1=$(hasEnvVar "$line" 'UPDATED: '$MISSION)
       
    if [[ -z "$instStep1" ]]; then
      printf "inst %s is not ready to be migrated in step2. continue to next instance\n" "$line"
      continue    
    fi    
    
    origInstStep1=$(hasEnvVar "$line" 'UPDATED: '$MISSION)
    if [[ -z "$origInstStep1" ]]; then    
      #printf "inst %s has its origin,  was updated to be migrated in step2. added to the list\n" "$line"     
      #setStep1CompletedEnv ${line}
      printf "inst %s has its origin was updated to be migrated in step2. added to the list\n" "$line"     
    fi
    
    printf "$line\n" >> ~findInstsQualifiedForStep2.txt
    
  done < ~insts.txt
  
  {
    rm ~instsAll.txt ~insts.txt
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
