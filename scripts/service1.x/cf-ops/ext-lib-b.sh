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
  theOrigInst=${1%-"$MISSION"}

  cf app $theOrigInst > ~tmp 2>&1
  getApp=$(cat ~tmp | grep -e 'FAILED')

  if [[ ! -z $getApp ]]; then
    printf "$1 (unknown instance)\n" >> ~unknownProcStep2Insts.txt
    return
  fi

  #getEnv=$(cf e $theOrigInst | grep -e 'UPDATED: '$MISSION)
  instStep1=$(hasEnvVar "$theOrigInst" 'UPDATED: '$MISSION)
  #echo $instStep1
  if [[ $instStep1 == "1" ]]; then
    printf "$theOrigInst"
    return
  fi

  # if have some doubts
  printf "$1 (unknown instance)\n" >> ~unknownProcStep2Insts.txt
}


# unmap the url route $2 from the app name $1
# $1: <app name>
# $2: <URL route>
function unmapInstURL () {
  hostname=$(echo $2 | cut -d'.' -f 1)
  cf unmap-route $1 run.aws-usw02-pr.ice.predix.io --hostname $hostname  
}

# mapping the url route $2 to the app name $1
# $1: <app name>
# $2: <URL route>
function mapInstURL () {
  hostname=$(echo $2 | cut -d'.' -f 1)
  cf map-route $1 run.aws-usw02-pr.ice.predix.io --hostname $hostname
}

# update the url routing from the give app name $1 to the new app name $2
# $1: <original app name>
# $2: <new app name>
function updateInstURL () {
  theRouting=$(findCurrentRouting $1)
  unmapInstURL $1 $theRouting
  mapInstURL $2 $theRouting
}
