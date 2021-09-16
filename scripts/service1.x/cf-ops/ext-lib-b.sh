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

# find and output the original app belong to the given app $1
# $1: <app name>
function findInstOfOrigin () {

  # if have some doubts
  printf "$1 (unknown instance)\n" >> ~unknownProcStep2Insts.txt
  
  # output the origin inst
  printf "$theOrigInst"
}

# update the give app name $1 to the new URL $2
# $1: <app name>
# $2: <new URL route>
function updateInstURL () {

}
