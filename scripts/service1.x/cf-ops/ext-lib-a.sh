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

  {
    current_routes=$(cf app $1 | grep routes | awk -F':' '{print $2}' | xargs)

    if [[ -z "$current_routes" ]]; then
      printf "\n\nno routes for the instance %s \n", "$1"
    else
      printf "\n\n current routes for %s are: %s \n", "$1" "$current_routes"
    fi

  } || {
    printf "\n\nunable to get the routes for %s \n", "$1"
  }

  # if have some doubts
#  printf "$1 (unknown instance)\n" >> ~unknownProcStep2Insts.txt
#
#  printf "$theRouting"
}

# set the env var in the app $1 as the completion of step2
# $1: <app name>
function setStep2CompletedEnv () {
  {
    cf set-env $1 'UPDATED' '2022-DONE'
    printf "\n\n marked %s as step2 completed \n", "$1"
  } || {
    printf "\n\n unable to mark %s as step2 completed \n", "$1"
  }
}
