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
#  autor: puja.sharma@ge.com

# find and output the original app belong to the given app $1
# $1: <app name>
function findInstOfOrigin () {

  #theOrigInst=$(echo $1 | awk -F'-2022' '{print $1}')
  theOrigInst=$(cat $__CACHED_ALL_ROUTES | grep -e "$1" | awk '{print $4}')

  #cf app $theOrigInst > ~tmp 2>&1
  #getApp=$(cat ~tmp | grep -e 'FAILED')

  if [[ ! -z $theOrigInst ]]; then
    #printf "%s app name %s is identified" "$__PAS" "$theOrigInst"
    printf "%s" "$theOrigInst"
    return
  fi
  
  #getEnv=$(cf e $theOrigInst | grep -e 'UPDATED: '$MISSION)
  : 'instStep1=$(hasEnvVar "$theOrigInst" 'UPDATED: '$MISSION)
  #echo $instStep1
  if [[ $instStep1 == "0" ]]; then
    printf "$theOrigInst"
    return
  fi'

  
  # if have some doubts
  #printf "$1 (unknown instance)\n" >> ~unknownProcStep2Insts
}

# unmap the url route $2 from the app name $1
# $1: <app name>
# $2: <URL route>
function unmapInstURL () {
  hostname=$(echo $2 | cut -d'.' -f 1)
  cf unmap-route $1 $CF_DOMAIN --hostname $hostname  
}

# mapping the url route $2 to the app name $1
# $1: <app name>
# $2: <URL route>
function mapInstURL () {
  hostname=$(echo $2 | cut -d'.' -f 1)
  cf map-route $1 $CF_DOMAIN --hostname $hostname
}

# update the url routing from the give app name $1 to the new app name $2
# $1: <original app name>
# $2: <new app name>
function updateInstURL () {

  theRouting=$(findCurrentRouting $1)
  if [[ -z $theRouting ]]; then
    printf "empty routing."
    return
  fi
  
  ref=$(unmapInstURL $1 $theRouting | grep -e 'FAILED')
  if [[ ! -z $ref ]]; then
    printf "error in unmapping."
    return
  fi
  
  ref1=$(mapInstURL $2 $theRouting | grep -e 'FAILED')
  if [[ ! -z $ref1 ]]; then
    printf "error in re-mapping."
    return
  fi

  printf "0"
}
