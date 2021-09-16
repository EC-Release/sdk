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

# find the routing based on $1
# $1: <app name>
function findCurrentRouting () {
  # if have some doubts
  printf "$1 (unknown instance)\n" >> ~unknownProcStep2Insts.txt  

  printf "$theRouting"
}

# set the env var in the app $1 as the completion of step2
# $1: <app name>
function setStep2CompletedEnv () {


}
