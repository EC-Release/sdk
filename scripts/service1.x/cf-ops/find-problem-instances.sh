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

function hasEnvVar () {
    #hasIssue=false
    while read line; do
       # do some finding blah
       ref1=$(echo "$2" | awk -v ref="$line" '($1==ref":" && $2!="") {print}')
       #echo ref1: "${ref1}"
       if [[ -z $ref1 ]]; then
         #hasIssue=true       
         #printf "\ninstance (%s) is missing field/value: %s\n" "$1" "$line"
         printf "instance (%s) is missing field/value: %s\n" "$1" "$line" | tee problem_insts.txt     
       fi
    done < field_list.txt
    
    #f [[ "$hasIssue" = true ]]; then
    #    echo $1 >> problem_insts.txt
    #fi 
}

function getProblemInstances () {
    #cf delete ${ZONE} -f 
    #cd ./push
    #cf push
    #cd -
    login
    #echo "login successful"
    printf "\n\ncalculating the list of problematic instance..\n\n" 
    #cf a | grep -E '0/|\?/'| awk '{print $1}'| while read -r line ; do
    cf a | grep -E 'started|stopped' | awk '{print $1}'| while read -r line ; do
      printf "\nevaluating the ec service app name: %s\n" "$line"
      ev=$(cf env $line)
      hasEnvVar "$line" "$ev"
    done
    
    printf "\n\nlist the problem instances\n\n"
    cat problem_insts.txt
}
