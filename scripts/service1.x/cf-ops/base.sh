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

set +e
__ERR="EC_ERR"
__PAS="EC_PAS"
__UKN="EC_UKN"
__DBG="EC_DBG"

__ERR_FIL_EXT="-err"
__PAS_FIL_EXT="-pas"
__UKN_FIL_EXT="-ukn"
__DBG_FIL_NAM="debug"

__LOG_FIL_EXT=".log"

__EC_TEMPLATE_INST="EC_TEMPLATE_INST"

__CACHED_TEMPLATE_ENV="~templateEnv"
__CACHED_ALL_ROUTES="~allRoutes"
__CACHED_ALL_INSTS="~allInsts"


#transform EC-specific naming
#$1 camel string
function strCamel2Dash() {
    echo $1 | awk '{gsub(/[A-Z]/, "-&");print}' | tr [:upper:] [:lower:]                                                                                                                          
}

#transform EC-specific naming
#$1 dash string
function strDash2Camel() {                                                                                                                                                                                                                                                                
    echo $1 | awk -F"-" '{for(i=1;i<=NF;i++){$i=toupper(substr($i,1,1)) substr($i,2)}} 1' OFS=""                                                                                                                                                                                          
}  

#hasEnvVar is to verify of the env var $2 exists in the app name $1
# $1: <app-name>
# $2: Env Key keyword
function hasEnvVar () {
    cf e $1 > ~tmp
    ref1=$(cat ~tmp | grep -e "$2" | awk '$2!="" {print $1}')
    if [[ ! -z $ref1 ]]; then
      printf "0"
      return
    fi
    
    printf "1"
}

#getEnvVar is to get the env var $2 in the app name $1
# $1: <app-name>
# $2: Env Key keyword
#function getEnvVar () {
#  cf e $1 > ~tmp
#  ref=$(cat ~tmp | grep -e "$2" | awk '{print $2}')
#  printf "%s" "$ref"
#}

function login () {
    #echo  cf login -a ${CF_API} -u ${CF_USR} -p ${CF_PWD} -o ${ORG} -s ${SPACE}
    cf login -a ${CF_API} -u ${CF_USR} -p ${CF_PWD} -o ${ORG} -s ${SPACE}
    getAllInsts
    getAllRoutes
    cacheTemplateEnv
}

function cacheTemplateEnv () {
  #sleep 1
  ref=$(eval '$'$__EC_TEMPLATE_INST)  
  printf "\ncaching template env vars from %s..\n" "$ref"  
  cf env $ref > $__CACHED_TEMPLATE_ENV
}

#getAppointedInsts return appointed instances for the workflow
function getAllRoutes () {
  #sleep 1
  printf "\ncaching all cf routes..\n"
  cf routes > ~allRoutes
  #cat ~instsAll
}

#getAppointedInsts return appointed instances for the workflow
function getAllInsts () {
  #sleep 1
  printf "\ncaching all cf instances..\n"
  cf a | grep -e 'started' -e 'stopped' | awk '{print $1}' > ~allInsts
  #cat ~instsAll
}

#getAppointedInsts return appointed instances for the workflow
function getAppointedInsts () {
  if [[ $PRIORITY_FILE == "0" ]]; then
    printf "getting all cf instances..\n"
    cp ~allInsts ~tmp
  else 
    printf "getting appointed cf instances..\n"
    cp $PRIORITY_FILE ~tmp
  fi
  cat ~tmp
}

#function getEnvs () {
#    cf env $1 > ~tmp
#    cat ~tmp
#}

#$1: app name
function verifyEnvs(){
  cf env $1 > ~tmp 2>&1
  ref=$(cat ~tmp | grep -e 'FAILED')
  if [[ ! -z $ref ]]; then
    printf "%s instance %s failed cf env cmd." "$__ERR" "$1"
    #debugger 'validateEnvs' "$(cat ~tmp)"
    return
  fi
  
  missingFields='=>'
  while read line; do
    
    ref=$(cat ~tmp | grep $line | awk '{print $2}')
    
    if [[ -z $ref ]]; then
      if [[ $line=="ADMIN_TKN" ]]; then
        ref=$(getRandomStr)
      else
        missingFields="${missingFields}, ${line}"
        continue
      fi
    fi
    
    eval "sed -i -e 's|{{$line}}|$ref|g' ./push/manifest.yml"
  done < field_list.txt
  
  if [[ ! -z "$missingFields" ]]; then
    printf "%s instance %s is missing env variables (%s)" "$__ERR" "$1" "$missingFields"
    return
  fi
  
  printf "%s verify instance %s env variables successful" "$__PAS" "$1"
}

#$1: app name
function setEnvs(){
  
  ref=$(verifyEnvs "$1")
  logger 'verifyEnvs' "$ref"
  checkInLogger 'verifyEnvs'
  if [[ $ref != *"$__PAS"* ]]; then
      printf "%s instance %s failed verifying env variables" "$__ERR" "$1"
      return
  fi  
 
  eval "sed -i -e 's|{{DOCKER_USERNAME}}|$DOCKER_USERNAME|g' ./push/manifest.yml"
  eval "sed -i -e 's|{{GITHUB_TOKEN}}|$GITHUB_TOKEN|g' ./push/manifest.yml"    

  eval "sed -i -e 's|{{MISSION}}|$MISSION|g' ./push/manifest.yml"
  
  
  eval "sed -i -e 's|{{ADMIN_PWD}}|$ADMIN_PWD|g' ./push/manifest.yml"
  eval "sed -i -e 's|{{ADMIN_USR}}|$ADMIN_USR|g' ./push/manifest.yml"
  
  eval "sed -i -e 's|{{CF_API}}|$CF_API|g' ./push/manifest.yml"
  eval "sed -i -e 's|{{CF_LOGIN}}|$CF_LOGIN|g' ./push/manifest.yml"
  eval "sed -i -e 's|{{CF_PWD}}|$CF_PWD|g' ./push/manifest.yml"
  eval "sed -i -e 's|{{CF_USR}}|$CF_USR|g' ./push/manifest.yml"
  eval "sed -i -e 's|{{NUREGO_TKN_INS}}|$NUREGO_TKN_INS|g' ./push/manifest.yml"
  eval "sed -i -e 's|{{NUREGO_TKN_PWD}}|$NUREGO_TKN_PWD|g' ./push/manifest.yml"
  eval "sed -i -e 's|{{NUREGO_TKN_URL}}|$NUREGO_TKN_URL|g' ./push/manifest.yml"
  eval "sed -i -e 's|{{NUREGO_TKN_USR}}|$NUREGO_TKN_USR|g' ./push/manifest.yml"
  eval "sed -i -e 's|{{NUREGO_USAGE_FEATURE_ID}}|$NUREGO_USAGE_FEATURE_ID|g' ./push/manifest.yml" 
  eval "sed -i -e 's|{{NUREGO_FEATURE_ID}}|$NUREGO_FEATURE_ID|g' ./push/manifest.yml" 
  eval "sed -i -e 's|{{NUREGO_API_KEY}}|$NUREGO_API_KEY|g' ./push/manifest.yml" 
  eval "sed -i -e 's|{{NUREGO_ENDPOINT}}|$NUREGO_ENDPOINT|g' ./push/manifest.yml" 
  eval "sed -i -e 's|{{NR_KEY}}|$NR_KEY|g' ./push/manifest.yml" 
  eval "sed -i -e 's|{{EC_PRVT_PWD}}|$EC_PRVT_PWD|g' ./push/manifest.yml"
  eval "sed -i -e 's|{{ENV}}|2022|g' ./push/manifest.yml"
  
  eval "sed -i -e 's|{{ZAC_SERVICE_ID}}|$ZAC_SERVICE_ID|g' ./push/manifest.yml"
  eval "sed -i -e 's|{{ZAC_UAA}}|$ZAC_UAA|g' ./push/manifest.yml"
  eval "sed -i -e 's|{{ZAC_URL}}|$ZAC_URL|g' ./push/manifest.yml"
  eval "sed -i -e 's|{{ZAC_CLIENT_ID}}|$ZAC_CLIENT_ID|g' ./push/manifest.yml"
  eval "sed -i -e 's|{{ZAC_CLIENT_SECRET}}|$ZAC_CLIENT_SECRET|g' ./push/manifest.yml"
    
  printf "%s instance %s updated env variables successful" "$__PAS" "$1"
}

#$1: trgtInstName
#$2: current instance index
function updateDockerCred () {
  eval $(parse_yaml docker-creds.yml)
  ref=$(expr $2 % 4)
  a=$(eval echo '$ec_'$ref'_token')
  b=$(eval echo '$ec_'$ref'_username')
  op=$(printf "CF_DOCKER_PASSWORD=%s cf push %s --docker-image %s --docker-username %s" "$a" "$1" "$ec_img" "$b")
  eval $op > ~tmp 2>&1
  
  echo $op >> ~debugger
  cat ~tmp >> ~debugger
  
  ref1=$(cat ~tmp | grep -e 'FAILED')
  if [[ -z $ref1 ]]; then
    printf "0"
    return
  fi
  
  printf "1"
}

#$1: function name
#$2: line number
#$3: return/exit code
#$4: last cmd
function checkInLogger () {
    
  #printf "\n\nthe script exited at line number %s, w/ code %s, and the command %s\n" "$2" "$3" "$4"
  printf "\ncheck-in logs for the function %s\n" "$1"

  ref=$(strCamel2Dash "$1")
  [[ -e "~$__DBG$1" ]] && cat "~$__DBG$1" >> ./logs/"$__DBG_FIL_NAM$__LOG_FIL_EXT" && rm "~$__DBG$1"
  [[ -e "~$__PAS$1" ]] && mv "~$__PAS$1" ./logs/"$ref$__PAS_FIL_EXT$__LOG_FIL_EXT"
  [[ -e "~$__ERR$1" ]] && mv "~$__ERR$1" ./logs/"$ref$__ERR_FIL_EXT$__LOG_FIL_EXT"
  [[ -e "~$__UKN$1" ]] && mv "~$__UKN$1" ./logs/"$ref$__UKN_FIL_EXT$__LOG_FIL_EXT"
  
}

#$1: function name
#$2: log output
function logger () {
  if [[ $2 == *"$__ERR"* ]]; then
    printf "[build:%s] %s\n" "$EC_BUILD" "$2" | tee -a ~$__ERR$1
    return
  fi
  
  if [[ $2 == *"$__PAS"* ]]; then
    printf "[build:%s] %s\n" "$EC_BUILD" "$2" | tee -a ~$__PAS$1
    return
  fi
  
  if [[ $2 == *"$__UKN"* ]]; then
    printf "[build:%s] %s\n" "$EC_BUILD" "$2" | tee -a ~$__UKN$1
    return
  fi
  
  if [[ $2 == *"$__DBG"* ]]; then
    printf "[build:%s] %s\n" "$EC_BUILD" "$2" | tee -a ~$__DBG$1
    return
  fi
}

#$1: function name
#$2: log output
function debugger () {
  ref=$(echo $2 | awk -v dbg="${__DBG}: line:${LINENO}, ret:${?} cmd:${BASH_COMMAND}" '{ printf ("%s\n%s",dbg,$1); }')
  logger "$1" "$ref"
}

