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

  ref=$(findUUID "$1")
  cat $__CACHED_ALL_ROUTES | grep -e "$ref" | awk 'length($2)==36 {print $4}'
  
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

function adhocMemScaling () {
  cf a > ~tmp
  cat ~tmp | grep -e '-2022' | grep -e 'started' | awk '$4=="1G" {print $1}' > ~adhoc
  while read -r line; do
    
cf scale $line -m 128M <<MSG
yes
MSG
    
  done < ~adhoc
  
}
