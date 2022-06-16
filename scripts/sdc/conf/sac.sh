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

if [[ -z "$EC_CID" ]]; then
  echo " ! exiting due to missing client id .."
  exit 1
fi

if [[ -f ".hash" ]]; then
  export EC_CSC=$(cat ".hash")
fi

echo "     |_ loading master envs.."
  
mkdir -p  "$HOME/.ec/sac-mstr/conf"
wget -q -O "$HOME/.ec/sac-mstr/conf/sac.yaml" https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdc/conf/sac.yaml

# legacy clean up
#[[ -d "$HOME/.ec/oauth/license" ]] && mv "$HOME/.ec/oauth/license" "$HOME/.ec/sac-mstr/"

CRT_FIL="$HOME/.ec/sac-mstr/license/${EC_CID}.cer"
if [[ ! -f "$CRT_FIL" ]] || [ ! -s "$CRT_FIL" ]; then
  ls -la "$HOME/.ec/" && ls -la "$HOME/.ec/sac-mstr" && ls -la "$HOME/.ec/sac-mstr/license"
  echo " [!] exiting due to missing license info. CRT_FIL: ${CRT_FIL}"
  exit 1
fi

PID=$(getCsrId "$CRT_FIL")
PVK_FIL="$HOME/.ec/sac-mstr/license/${PID}.key"
if [[ ! -f "$PVK_FIL" ]]; then
  echo " - exiting due to missing license key .."
  exit 1
fi    

echo "      |_ loading existing license .."


export \
EC_PUBCRT=$(cat "$CRT_FIL" | base64 -w0) \
EC_PVTKEY=$(cat "$PVK_FIL" | base64 -w0)
#echo "       |_ boostrapping sac master .."  

# PORT indicating a custom environment
if [[ ! -z "${PORT}" ]]; then
  EC_PORT=:$PORT
fi

# refresh the hash
export EC_PPS=$(getAdmHash "$EC_PPS")

while true; do
  if [[ "$EC_DBG" == "true" ]]; then
    echo "        |_ launching sac master .. [dbg]"
    dev -cfg "$HOME/.ec/sac-mstr/conf/sac.yaml"
  else
    echo "       |_ launching sac master .. "
    sac -cfg "$HOME/.ec/sac-mstr/conf/sac.yaml"
  fi
  
  export EC_PPS=$(getAdmHash "$EC_PPS_BK")
  sleep 1
done
