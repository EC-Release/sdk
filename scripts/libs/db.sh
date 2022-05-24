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

while [[ $(type -t getURLHostnameAndPortAndScheme) != function ]]
do
  source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/cipher/crypto.sh)
  sleep 1
done

echo "    |_ importing db libraries & tools.."

# $1: seeder host URL. $2: datapoint "name" or "key"
function getDBUrl () {
  url=$(getURLHostnameAndPortAndScheme "$1")
  printf '%s/1.2-b/ec/api/%s' "$url" "$2"
}

# $1: seeder host URL. $2: datapoint "name". $3: bearer token. $4: json data
function insertData () {
  url=$(getDBUrl "$1" "$2")
  agt -ivk -tkn "$3" -url "$url" -dat "$4" -mtd "POST" -smp
}

# $1: seeder host URL. $2: datapoint "key". $3: bearer token. $4: json data
function updateData () {
  url=$(getDBUrl "$1" "$2")
  agt -ivk -tkn "$3" -url "$url" -dat "$4" -mtd "PUT" -smp 
}

# $1: seeder host URL. $2: datapoint "key". $3: bearer token.
function getData () { 
  url=$(getDBUrl "$1" "$2") 
 
  agt -ivk -tkn "$3" -url "$url" -mtd "GET" -smp
}

# $1: seeder host URL. $2: datapoint "key". $3: bearer token.
function delData () {
  url=$(getDBUrl "$1" "$2")
  echo url: $url
  agt -ivk -tkn "$3" -url "$url" -mtd "DELETE" -smp
}
