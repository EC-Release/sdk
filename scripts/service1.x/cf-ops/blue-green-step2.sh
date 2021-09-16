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
  cat ~instsAll.txt | awk '$1 !~ /-'$MISSION'/ {print $1}' > ~insts.txt
  
  while read -r line; do
    
    instStep1=$(cat ~instsAll.txt | grep -e $line'-'$MISSION)
    if [[ ! -z "$instStep1" ]]; then
      printf "%s has a cloned instance %s. resume searching\n" "$instStep1"      
      continue
    fi
    
    instStep2=$(hasEnvVar "$line" 'UPDATED: '$MISSION)
       
    if [[ -z "$instStep2" ]]; then
      printf "inst %s has not been updated. added to the list\n" "$line"
      printf "$line\n" >> ~findInstsQualifiedForStep1.txt
    fi
    
  done < ~insts.txt
  
  {
    rm ~instsAll.txt ~insts.txt
  }
  
}

function bgStep2URLReMapping(){
    
}
