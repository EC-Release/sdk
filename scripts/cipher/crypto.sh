#!/bin/bash
#
#  Copyright (c) 2019 General Electric Company. All rights reserved.
#
#  The copyright to the computer software herein is the property of
#  General Electric Company. The software may be used and/or copied only
#  with the written permission of General Electric Company or in accordance
#  with the terms and conditions stipulated in the agreement/contract
#  under which the software has been supplied.
#
#  author: apolo.yasuda@ge.com
#

while [[ $(type -t getURLHostnameAndPort) != function ]]
do
  source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/libs/common.sh)
  sleep 1
done

echo "   |_ importing crypto libraries & tools.."

# $1: owner hash $2: req json dir
function genCSR () {
EC_PPS=$(getAdmHash $1)

agt -gen <<MSG
$(cat "$2" | jq -r ".lic_common")
$(cat "$2" | jq -r ".lic_country")
$(cat "$2" | jq -r ".lic_state")
$(cat "$2" | jq -r ".lic_city")
$(cat "$2" | jq -r ".lic_zip")
$(cat "$2" | jq -r ".lic_address")
$(cat "$2" | jq -r ".lic_organization")
$(cat "$2" | jq -r ".lic_unit")
$(cat "$2" | jq -r ".lic_dns")
$(cat "$2" | jq -r ".lic_email")
$(cat "$2" | jq -r ".lic_cer_alg")
$(cat "$2" | jq -r ".lic_key_alg")
no
MSG

#printf "%s" $(ls *.csr | xargs -n 1 basename)
}

# $1 owner hash
function getRefHash () {
 EC_PPS=$(getAdmHash "$1")
 
 getAdmHash "$EC_PPS"
}

# $1: owner hash
function getAdmHash () {
 EC_PPS="$1" agt -hsh -smp
}

# $1: owner hash. $2: pkey dir. $3: cert dir. $4: passphrase to be encrypted.
function renewOwnerHash () {
 EC_PPS=$(getAdmHash "$1")
 if [[ -z "$4" ]]; then
   EC_PPS="$EC_PPS" agt -hsh -pvk "$2" -pbk "$3" -smp
 else
   EC_PPS="$EC_PPS" agt -hsh -pvk "$2" -pbk "$3" -dat "$4" -smp
 fi
}

# $1: CSR file dir
function getCsrDetail () {
  agt -vfy -csr "$1" -smp
}


# $1: license dir
function getLicDetail () {
  agt -vfy -pbk "$1" -smp
}

# $1: Csr dir
function getCsrDetail () {
  agt -vfy -csr "$1" -smp
}


# $1: log host $2 sdc tkn $3: log filename
function loggerUp () {
  ref=$(getURLHostnameAndPort "$1")
  ref2=$(getURLScheme "$ref")
  ref3="ws"
  if [ "$ref2" == "https" ]; then ref3="wss"; fi
  ref4=$(printf '%s://%s/1.2-b/ec/log' "$ref3" "$ref")
  echo connecting log "$ref4"
  agt -log -url "$ref4" -tkn "$2" > "$3" &
}

# $1: license dir
function getCsrId () {
  CSR_ID=$(getLicDetail "$1" | jq -r '.exts.csrId')
  if [[ -z "$CSR_ID" ]]; then
   echo invalid ca cert format
   exit 1
  fi
  
  echo "$CSR_ID"
}

# $1: license dir
function getEmail () {
  Email=$(getLicDetail "$1" | jq -r '.emailAddress')
  if [[ -z "$Email" ]]; then
   echo invalid email format
   exit 1
  fi
  
  echo "$Email"
}


# $1: CSR dir
function getEmailByCsrDir () {
  Email=$(getCsrDetail "$1" | jq -r '.emailAddress')
  if [[ -z "$Email" ]]; then
   echo invalid email format
   exit 1
  fi
  
  echo "$Email"
}

# $1: devId. $2: owner hash. $3: sdc host URL
function getSdcTkn () {
 ref=$(getAdmHash "$2") 
 url=$(getURLHostnameAndPortAndScheme "$3")/oauth/token
 EC_PPS="$ref" agt -gtk -oa2 "$url" -cid "$1" -smp
}

# $1: cid. $2: csc. $3: jwt host URL
function getJwtTkn () {
 #ref=$(printf '%s:%s' "$1" "$2")
 curl -Ss -o - -X POST "$3" -u "$1:$2" -d 'grant_type=client_credentials' | jq -r '.access_token'
}

# $1: seeder host URL. $2: script key. $3: bearer token
function getGhbTkn () {
 agt -ivk -tkn "$3" -url "$1/1.2-b/ec/proc/$2" -dat "{}" -mtd "POST" -smp | jq -r ".info.GHB_TKN"
}

# $1: owner hash. $2: pkey dir. $3: cert dir
function vfyOwnHshWithKeypair () {

 adm_hsh=$(getAdmHash "$1")
 ref=$(EC_PPS="$adm_hsh" timeout 2 agt -hsh -pvk "$2" -pbk "$3" -smp)
 if [[ $ref == *"Specify the passphrass"* ]]; then
   echo invalid hash and/or keypair
   exit 1
 fi
 
 echo the hash works with the input keypair
}

# $1: db file name. $2: github token
function setDb () {

  printf "\n\n**** sharing existing db (%s).\n" "$1"
  REF="https://${2}@raw.githubusercontent.com/EC-Release/data-storage/main/${1}"
  if curl --output /dev/null --silent --head --fail "$REF"; then
    curl -Ss -o ./.ec/.db "$REF"
  fi
  
}

# $1 credential file name. $2: github token
function getCredJson () {
  REF="https://${2}@raw.githubusercontent.com/EC-Release/data-storage/main/${1}"
  if curl --output /dev/null --silent --head --fail "$REF"; then
    curl -Ss "$REF"
  else
    exit -1
  fi
}

# $1 csrId. $2: github token
function getPrivateKey () {
  REF="https://${2}@raw.githubusercontent.com/EC-Release/rsa/main/${1}.key"
  if curl --output /dev/null --silent --head --fail "$REF"; then
    curl -Ss -o - "$REF"
  else
    exit -1
  fi
}

# $1: devid. $2: owner hash. $3: github token
function vfyOwnerHash () {
  getPublicCrt "$1" "$3" > .cer  
  csrId=$(getCsrId .cer)
  getPrivateKey "$csrId" "$3" > .key
  testOwnHshWithKeypair "$2" .key .cer
}

# $1: devid $2: github token
function getPublicCrt () {
  REF="https://${2}@raw.githubusercontent.com/EC-Release/x509/main/crt-list/${1}.cer"
  if curl --output /dev/null --silent --head --fail "$REF"; then
    curl -Ss -o - "$REF"
  else
    exit -1
  fi
}

# $1: github token
function getSvcRSAKey () {
  #https://${GHB_TKN}@raw.githubusercontent.com/EC-Release/service-update/main/service.cer
  REF="https://${1}@raw.githubusercontent.com/EC-Release/service-update/main/service.key"
  if curl --output /dev/null --silent --head --fail "$REF"; then
    curl -Ss -o - "$REF"
  else
    exit -1
  fi
}

# $1: github token
function getSvcX509Cer () {
  #https://${GHB_TKN}@raw.githubusercontent.com/EC-Release/service-update/main/service.cer
  REF="https://${1}@raw.githubusercontent.com/EC-Release/service-update/main/service.cer"
  if curl --output /dev/null --silent --head --fail "$REF"; then
    curl -Ss -o - "$REF"
  else
    exit -1
  fi
}
