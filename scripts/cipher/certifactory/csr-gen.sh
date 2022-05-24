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

source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/libs/db.sh)
echo "     |_ generating cert req.."

cd ./"$STEP"
crdj=$(getCredJson "cred.json" $EC_GITHUB_TOKEN)
CA_DEV_ID=$(echo $crdj | jq -r ".${LIC_LBL}.devId")
CA_EC_PPS=$(echo $crdj | jq -r ".${LIC_LBL}.ownerHash")

getPublicCrt "$CA_DEV_ID" "$EC_GITHUB_TOKEN" > ./ca.cer
CA_CSR_ID=$(getCsrId "./ca.cer")
getPrivateKey "$CA_CSR_ID" "$EC_GITHUB_TOKEN" > ./ca.key

lic_pps=$(cat ./build.json | jq -r '.lic_pps')
#echo lic_pps: $lic_pps
HASH=$(renewOwnerHash "$CA_EC_PPS" "./ca.key" "./ca.cer" "$lic_pps")
#echo HASH:$HASH

EC_PPS=$(getAdmHash "$HASH") agt -gen <<MSG
$(cat build.json | jq -r '.lic_common')
$(cat build.json | jq -r '.lic_country')
$(cat build.json | jq -r '.lic_state')
$(cat build.json | jq -r '.lic_city')
$(cat build.json | jq -r '.lic_zip')
$(cat build.json | jq -r '.lic_address')
$(cat build.json | jq -r '.lic_organization')
$(cat build.json | jq -r '.lic_unit')
$(cat build.json | jq -r '.lic_dns')
$(cat build.json | jq -r '.lic_email')
$(cat build.json | jq -r '.lic_cer_alg')
$(cat build.json | jq -r '.lic_key_alg')
no
MSG

#pwd && tree .

#leave it
#rm ca.key ca.cer

op=$(printf "%s" $(ls *.csr | xargs -n 1 basename))
cat build.json | jq ". += {\"EC_CSR_MSG_TITLE\":\"${op}\"}" > ~tmp && mv ~tmp build.json 

fn="${op%.*}"
cat build.json | jq ". += {\"EC_CSR_ID\":\"${fn}\"}" > ~tmp && mv ~tmp build.json 

getCsrDetail "./$op" | jq '.'

git clone "https://${EC_GITHUB_TOKEN}@github.com/EC-Release/x509.git"
cd x509
mv ./../*.csr ./csr-list/
git add .
git config user.email "EC.Bot@ge.com"
git config user.name "EC Bot"
git commit -m "csr ${fn} checked-in [skip ci]"
git push
cd -

git clone https://${EC_GITHUB_TOKEN}@github.com/EC-Release/rsa.git
cd rsa

mv ./../${fn}.key ./
git add .
git config user.email "EC.Bot@ge.com"
git config user.name "EC Bot"
git commit -m "rsa key ${fn} checked-in [skip ci]"
git push
