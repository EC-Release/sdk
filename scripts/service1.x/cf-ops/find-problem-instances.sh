#!/bin/bash

function hasEnvVar () {
    hasIssue = false
    while read line; do
       # do some finding blah
       if 
         hasIssue = true
         printf "\n instance (%s) has missing field: %s\n" "$1" "$line"
       fi
    done < field_list.txt
    
    if [[ -eq "$hasIssue" true ]]; then
        echo $1 >> problemInsts.txt
    fi 
}

function getProblemInstances () {
    #cf delete ${ZONE} -f 
    #cd ./push
    #cf push
    #cd -
    login
    echo "Login successful"
    printf "\ngetting the list..\n\n" 
    cf a | grep -E '0/|\?/'| awk '{print $1}'| while read -r line ; do
      printf "\nevaluating the app name: %s" "$line"
      ev=$(cf env $line)
      hasEnvVar "$line" "$ev"
    done
    
    echo "list the problem instances"
    cat problem_insts.txt
}
