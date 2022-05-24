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

source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/libs/db.sh)
echo "     |_ generating owner's hash.."

cd ./"$STEP"

crdj=$(getCredJson "cred.json" $EC_GITHUB_TOKEN)
CA_DEV_ID=$(echo $crdj | jq -r ".${LIC_LBL}.devId")
CA_EC_PPS=$(echo $crdj | jq -r ".${LIC_LBL}.ownerHash")

getPublicCrt "$CA_DEV_ID" "$EC_GITHUB_TOKEN" > ./ca.cer
CA_CSR_ID=$(getCsrId "./ca.cer")
getPrivateKey "$CA_CSR_ID" "$EC_GITHUB_TOKEN" > ./ca.key

HASH=$(renewOwnerHash "$CA_EC_PPS" "./ca.key" "./ca.cer" "$lic_pps")

getPublicCrt "$lic_id" "$EC_GITHUB_TOKEN" > ./lic.cer
csr_id=$(getCsrId "./lic.cer")
getPrivateKey "$csr_id" "$EC_GITHUB_TOKEN" > ./lic.key

vfyOwnHshWithKeypair "$HASH" "./lic.key" "./lic.cer"

if [[ ! -z "$lic_dat" ]] && [[ "$lic_dat" != "null" ]]; then
  echo update owner hash to custom string
  HASH=$(renewOwnerHash "$CA_EC_PPS" "./ca.key" "./ca.cer" "$lic_dat")
fi

EMAIL=$(getEmail "./lic.cer")

echo '{}' | jq ". += {\"hash\":\"$HASH\"}" | jq ". += {\"email\":\"$EMAIL\"}" > ./build.json
