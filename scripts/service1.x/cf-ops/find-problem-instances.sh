#!/bin/bash

function getProblemInstances(){
    #cf delete ${ZONE} -f 
    #cd ./push
    #cf push
    #cd -
    login
    echo "Login successful"
    
    cf a | grep -E '0/|\?/'| awk '{print $1}'| while read -r line ; do
      printf "\n$line\n"
    done
}
