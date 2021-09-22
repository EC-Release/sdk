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
#  author: RamaRao.Srikakulapu@ge.com
#

# find the routing based on $1
# $1: <app name>
function findCurrentRouting () {
    
    ref=$(findUUID "$1")
    cat $__CACHED_ALL_ROUTES | grep -e "$ref" | awk 'length($2)==36 {print $2"."$3}'
}

# set the env var in the app $1 as the completion of step2
# $1: <app name>
function setStep2CompletedEnv () {
  cf set-env "$1" UPDATED $MISSION'-DONE' > ~tmp 2>&1
  ref=$(cat ~tmp | grep -e 'FAILED')
  if [[ $ref != *"FAILED"* ]]; then
    printf "0"
    return
  fi
  
  printf "1"
}

# set the env var in the app $1 as the completion of step1
# $1: <app name>
function setStep1CompletedEnv () {
  cf set-env "$1" UPDATED $MISSION > ~tmp 2>&1
  ref=$(cat ~tmp | grep -e 'FAILED')
  if [[ $ref != *"FAILED"* ]]; then
    printf "0"
    return
  fi
  
  printf "1"
}

# restage the new app (ending with -2022)
# $1: <app name>
function restageTheNewApp () {
  
  cf restage "$1" > ~tmp 2>&1
  result=$(cat ~tmp)

  if [[ $result != *"FAILED"* ]]; then
    printf "0"
    return
  fi
  printf "1"
}

