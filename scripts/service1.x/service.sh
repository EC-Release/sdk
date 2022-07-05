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


[[ -f "./~tmp" ]] && rm ./~tmp
[[ -f "./~svc" ]] && rm ./~svc

#clean up svc folder
rm -Rf ./temp

#GHB_TKN=$(echo "$ownrInf" | jq -r '.GHB_TKN')
mkdir -p ./temp ./service1.1 ~/svcs

echo " [o] downloading svc api doc"

#dev only
curl -L -s -o ./service1.1.tar.gz https://github.com/ayasuda-ge/service1.x/tarball/1.1
tar -xzf service1.1.tar.gz --strip 1 -C service1.1
rm ./service1.1.tar.gz


#WORKDIR = /root
cd ./service1.1
#WORKDIR = /root/service1.1
#keypair DIR = /root/svcs-keypair
cp ./../svcs-keypair/* ./
chmod +x auth-api

#SWG_HOST=$(getURLHostnameAndPort "$EC_SVC_URL")
SWG_HOST=$(printf '%s/v1/index/' "$EC_SVC_URL")
eval "sed -i -e 's#{HOST}#${SWG_HOST}#g' ./assets/swagger.json"

export \
ZONE="$EC_SVC_ID" \
EC_SEED_NODE="${EC_SAC_SLAV_URL}" \
EC_SEED_HOST="${EC_SVC_URL}" \
EC_API_OA2="${EC_SAC_MSTR_URL}" \
EC_API_DEV_ID="$EC_CID"


echo " [o] starting svc app"

node ./app.js
