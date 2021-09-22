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

#$1: instance app name
function instQualified4Step2 () {
  origInstName=$(findInstOfOrigin $1)
    
  if [[ -z "$origInstName" ]]; then
    printf "%s app %s does not have URL routing\n" "$__ERR" "$1"
    return   
  fi
  
  ref=$(findUUID "$origInstName")
  if [[ -z "$ref" ]]; then
    printf "%s instance %s does not appear to be a service instance\n" "$__ERR" "$origInstName"
    return
  fi
  
  ref1=$(cat ~allInsts | grep -e "$ref-$MISSION")
  if [[ -z "$ref1" ]]; then
    printf "%s instance %s does not have a cloned instance from step1\n" "$__ERR" "$origInstName"
    return
  fi

  ref2=$(hasEnvVar "$ref-$MISSION" 'UPDATED: '$MISSION'-DONE')    
  if [[ $ref2 != "0" ]]; then
    printf "%s cloned instance %s does not have env var set in step 2\n" "$__PAS" "$ref-$MISSION"
  fi
}

function findInstsQualifiedForStep2 () {
  
  printf "\nget appointed instances..\n"
  getAppointedInsts | awk 'NR!=1 {print $1}' > ~insts
  cat ~insts
  
  printf "\nloop into instances in the appointed instance list..\n"
  while read -r line; do
    
    ref=$(instQualified4Step2 $line)
    if [[ $ref != *"$__PAS"* ]]; then
      logger 'instQualified4Step2' "$ref"    
      continue
    fi
    
    ref1=$(printf "%s instance %s passed the verification for step 2\n" "$__PAS" "$line")
    logger 'findInstsQualifiedForStep2' "$ref1"
    
  done < ~insts
  
  echo "finding completed."
  checkInLogger 'instQualified4Step2'
  return 0
  
}

#1: origInstName
#2: trgtInstName
#3: current instance index
function procDone () {

    : 'ref=$(restageTheNewApp "$2")
    if [[ $ref != "0" ]]; then
      printf "instance %s failed in restageTheNewApp.\n" "$1" | tee ~failedProcStep2Insts
      continue    
    fi'
    
    ref=$(updateDockerCred "$2" "$3")
    if [[ "$ref" != "0" ]]; then
      printf "%s instance %s failed in updateDockerCred with the output %s.\n" "$__ERR" "$1" "$ref"
      return    
    fi    

    printf "%s instance %s has completed blue-green step 2 and added to the list\n" "$__PAS" "$1"
}

function procStep2 () {

  printf "\nget appointed instances..\n"
  getAppointedInsts | awk 'NR!=1 {print $1}' > ~insts
  cat ~insts
  
  printf "\nloop into instances in the appointed instance list..\n"
  
  count=-1
  while read -r line; do
    (( count++ ))
        
    ref=$(instQualified4Step2 $line)
    if [[ $ref != *"$__PAS"* ]]; then
      logger 'instQualified4Step2' "$ref"
      continue
    fi
    
    url=$(findCurrentRouting "$line")
    if [[ -z "$url" ]]; then
      ref=$(printf "%s instance %s does not have a routing.\n" "$__ERR" "$line")
      logger 'procStep2' "$ref"
      continune
    fi

    zon=$(echo $url | cut -d'.' -f 1)
    uid=$(isUUID $zon)
    if [[ $uid != "0" ]]; then
      ref=$(printf "%s instance url %s does not appear to be a service instance.\n" "$__ERR" "$url")
      logger 'procStep2' "$ref"      
      continue
    fi
  
    trgtInstName=${zon%-$MISSION}-$MISSION
    origInstName=$(findInstOfOrigin $line)
    if [[ -z "$origInstName" ]]; then
      ref=$(printf "%s app %s does not have a URL routing which contains MISSION \n" "$__ERR" "$line")
      logger 'procStep2' "$ref"
      continue
    fi
    
    ref1=$(updateInstURL $origInstName $trgtInstName)
    if [[ "$ref1" != "0" ]]; then
      ref2=$(printf "%s instance %s failed in updateInstURL\n" "$__ERR" "$origInstName")
      logger 'procStep2' "$ref2"
      continue
    fi

    ref3=$(setStep2CompletedEnv $trgtInstName)
    if [[ "$ref3" != "0" ]]; then 
      ref4=$(printf "%s instance %s failed in setStep2CompletedEnv\n" "$__ERR" "$origInstName")
      logger 'procStep2' "$ref4"
      continue       
    fi
      
    ref5=$(procDone "$origInstName" "$trgtInstName" "$count")
    if [[ "$ref5" != *"$__PAS"* ]]; then
      logger 'procDone' "$ref5"    
      continue
    fi
    
    ref6=$(printf "%s instance %s has completed blue-green step 2 and added to the list\n" "$__PAS" "$origInstName")
    logger 'procStep2' "$ref6"
    
    #temp
    #return
  done < ~insts
  
  printf "\n\nstep2 update completed.\n\n"
  
  #checkInLogger 'procStep2'
  #checkInLogger 'procDone'
  checkInLogger 'instQualified4Step2'
  #checkInLogger 'findInstOfOrigin'
  return 0
}

function procDoneStep2 () {

  printf "\nget appointed instances..\n"
  getAppointedInsts | awk 'NR!=1 {print $1}' > ~insts
  cat ~insts
  
  printf "\nloop into instances in the appointed instance list..\n"
  
  count=-1
  while read -r line; do
    (( count++ ))
    
    url=$(findCurrentRouting "$line")
    if [[ -z "$url" ]]; then
      ref=$(printf "%s instance %s does not have a routing.\n" "$__ERR" "$line")
      logger 'procDoneStep2' "$ref"
      continue
    fi
    
    zon=$(echo $url | cut -d'.' -f 1)
    uid=$(isUUID $zon)
    if [[ $uid != "0" ]]; then
      ref=$(printf "%s instance url %s does not appear to be a service instance.\n" "$__ERR" "$url")
      logger 'procDoneStep2' "$ref"      
      continue
    fi
  
    trgtInstName=${zon%-$MISSION}-$MISSION
    origInstName=$(findInstOfOrigin $line)
    if [[ -z "$origInstName" ]]; then
      ref=$(printf "%s app %s does not have URL routing which contains MISSION\n" "$__ERR" "$line")
      logger 'procDoneStep2' "$ref"
      continue
    fi
      
    ref5=$(procDone "$origInstName" "$trgtInstName" "$count")
    if [[ "$ref5" != *"$__PAS"* ]]; then
      logger 'procDone' "$ref5"    
      continue
    fi
    
    ref6=$(printf "%s instance %s updated successfully\n" "$__PAS" "$origInstName")
    logger 'procDoneStep2' "$ref6"
    
    #temp
    #return
  done < ~insts
  
  printf "\n\nstep2 update completed.\n\n"
  
  #checkInLogger 'procStep2'
  checkInLogger 'procDone'
  #checkInLogger 'procDoneStep2'
  #checkInLogger 'findInstOfOrigin'
  return 0
}
