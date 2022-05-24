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
echo "     |_ signing cert req.."

cd ./$STEP
ref0=$(git rev-parse HEAD)
ref1=$(git log --format=%B -n 1 $ref0 | head -n 1)
ref2=$(printf "%s" "${ref1#*/beta-}")
export CSR_ID="${ref2%.*}"
#printf "\n\n**** CSR_ID: %s\n\n" "$CSR_ID"

cd ..
git clone https://${EC_GITHUB_TOKEN}@github.com/EC-Release/x509.git
cd x509

echo '****' CSR_ID: $CSR_ID
export REQ_EMAIL=$(getEmailByCsrDir "./csr-list/${CSR_ID}.csr")
printf "\n\n**** Req Email: %s\n\n" "$REQ_EMAIL"
echo "lic_email=$REQ_EMAIL" >> $GITHUB_ENV

# ensure to issue the enclosed license in below dir 
mkdir -p crt-list/beta
cd crt-list/beta


if [[ ! -z "${EC_PPRS}" ]]; then
  export EC_PPS=$EC_PPRS
fi

echo $EC_PVK | base64 --decode > ca.key
echo $EC_PBK | base64 --decode > ca.cer

EC_PPS=$(getAdmHash "$EC_PPS") \
agt -sgn <<MSG
ca.key
365
DEVELOPER
EC_ECO
Seat_x1
./../../csr-list/${CSR_ID}.csr
no 
ca.cer
MSG

rm ca.key ca.cer

ref7=$(ls -Art | tail -n 1)
export DEV_ID="${ref7%.*}"
echo "DEV_ID=$DEV_ID" >> $GITHUB_ENV
cp $ref7 ./../../../license.txt

tree ./../../../
cd ./../../../certifactory
