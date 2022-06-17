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

while [[ $(type -t getData) != function ]]
do
  source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/libs/db.sh)
  sleep 1
done

[[ -f "./~tmp" ]] && rm ./~tmp
[[ -f "./~svc" ]] && rm ./~svc

hn0=$(getURLHostname "$EC_SAC_MSTR_URL")
pn0=$(getURLPort "$EC_SAC_MSTR_URL")      

h=$(tcpHealthCheck "$hn0" "$pn0")
echo "       [-] sac master health probe via tcp. ${h}"
until [[ "$h" == "OK" ]]
do
  echo "       [-] re-try sac master health probe via tcp. ${h}"
  sleep 3
  h=$(tcpHealthCheck "$hn0" "$pn0")
done
echo "       [-] sac master health probe via tcp. ${h}"

hn1=$(getURLHostname "$EC_SAC_SLAV_URL")
pn1=$(getURLPort "$EC_SAC_SLAV_URL")      

h=$(tcpHealthCheck "$hn1" "$pn1")
echo "       [-] sac slave health probe via tcp. ${h}"
until [[ "$h" == "OK" ]]
do
  echo "       [-] re-try sac slave health probe via tcp. ${h}"
  sleep 3
  h=$(tcpHealthCheck "$hn1" "$pn1")
done
echo "       [-] sac slave health probe via tcp. ${h}"
      

echo "     |_ launching svc (${EC_SVC_ID})"

export RFD_PRT=17991

if [[ -f ".hash" ]]; then
  export EC_CSC=$(cat ".hash")
fi

echo "      |_ [1]getting svc bearer tkn"
BK=$(getSdcTkn $EC_CID $EC_CSC $EC_SAC_MSTR_URL)

echo "      |_ [2]fetching svc info"
#getData "$EC_SAC_SLAV_URL" "$EC_CID" "$BK"

ownrInf=$(getData "$EC_SAC_SLAV_URL" "$EC_CID" "$BK")

for row in $(echo "${ownrInf}" | jq -r '.SVC_LIST | keys[]'); do    
   mkdir -p "~/pvc/prod/svcs/${row}"
done

export \
RFD_URL="http://localhost:${RFD_PRT}" \
EC_SCRIPT_1=$(echo "$ownrInf" | jq -r '.SCRIPT_1') \
EC_SCRIPT_2=$(echo "$ownrInf" | jq -r '.SCRIPT_2') \
EC_SCRIPT_3=$(echo "$ownrInf" | jq -r '.SCRIPT_3')

ref=$(getURLHostnameAndPortAndScheme "$EC_SVC_URL")
op=$(echo "$ownrInf" | jq -r 'any(.SVC_LIST["'$EC_SVC_ID'"][]; . == "'$ref'")')
if [ "$op" != "true" ]; then
  echo "      |_ [!] unauthorised svc (id: ${EC_SVC_ID}; url: ${EC_SVC_URL}) deployment."  
  echo $ownrInf | jq -r '.SVC_LIST["'$EC_SVC_ID'"]'
  echo "      [*] op: ${op}"
  echo "      [*] ref: ${ref}"
  sleep 3
  exit 1
fi

echo "      |_ [3]downloading license"
#clean up svc folder
rm -Rf ./temp

GHB_TKN=$(echo "$ownrInf" | jq -r '.GHB_TKN')
mkdir -p ./temp ./service1.1 ~/svcs

#echo "svc dbg GHB_TKN: $GHB_TKN"
getSvcRSAKey "$GHB_TKN" > ./temp/service.key
getSvcX509Cer "$GHB_TKN" > ./temp/service.cer
if [[ ! -f ./temp/service.key ]] && [[ ! -s ./temp/service.key ]]; then
 #ls -al ./temp/ 
 echo "      |_  err: failed downloading svc keypair. reloading svc in 5 sec ..."
 sleep 5
 exit 1
fi

#curl -s -o ./temp/service.cer https://${GHB_TKN}@raw.githubusercontent.com/EC-Release/service-update/main/service.cer
#curl -s -o ./temp/service.key https://${GHB_TKN}@raw.githubusercontent.com/EC-Release/service-update/main/service.key


echo "      |_ [4]downloading svc api doc"
#dev only
curl -L -s -o ./service1.1.tar.gz https://github.com/ayasuda-ge/service1.x/tarball/1.1
tar -xzf service1.1.tar.gz --strip 1 -C service1.1
rm ./service1.1.tar.gz

cd ./service1.1
cp ./../temp/* ./
chmod +x auth-api

#workaround for missing cer mismatch
#cp $(pwd)/service.cer $(pwd)/service.crt

#rm ./../service1.1.tar.gz
SWG_HOST=$(getURLHostnameAndPort "$EC_SVC_URL")
eval "sed -i -e 's#{HOST}#${SWG_HOST}#g' ./assets/swagger.json"

export \
ZONE="$EC_SVC_ID" \
EC_SEED_NODE="${EC_SAC_SLAV_URL}" \
EC_SEED_HOST="${EC_SVC_URL}" \
EC_API_OA2="${EC_SAC_MSTR_URL}" \
EC_API_DEV_ID="$EC_CID" \
EC_PPS="$EC_CSC"


echo "      |_ [5]starting svc app"

source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdr/index.sh) "$@"
