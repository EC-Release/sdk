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

# PORT indicating a custom environment
if [[ ! -z "${PORT}" ]]; then
  EC_PORT=:$PORT
fi

# refresh the hash
export EC_PPS=$(getAdmHash "$EC_PPS")

case $EC_AUTH_VALIDATE in
  oaep)
    echo "     |_ launching oaep.."
    
    if [[ ! -f "$HOME/.ec/sdc/conf/sdc-oaep.yaml" ]] && [[ ! -s "$HOME/.ec/sdc/conf/sdc-oaep.yaml" ]]; then
      wget -q -O "$HOME/.ec/sdc/conf/sdc-oaep.yaml" https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdc/conf/sdc-oaep.yaml
    fi
    
    sdc -cfg "$HOME/.ec/sdc/conf/sdc-oaep.yaml"
    ;;
  aha)
    [[ -z "$SAC_TYPE" ]] && echo "     |_ launching oidc (aha).."
    
    wget -q -O ~/.ec/sdc/conf/sdc-aha.yaml https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdc/conf/sdc-aha.yaml  
    sdc -cfg "$HOME/.ec/sdc/conf/sdc-aha.yaml" &> /dev/null
    ;;
  oidc)
    [[ -z "$SAC_TYPE" ]] && echo "     |_ launching oidc.."

    wget -q -O ~/.ec/sdc/conf/sdc-oidc.yaml https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdc/conf/sdc-oidc.yaml
    sdc -cfg "$HOME/.ec/sdc/conf/sdc-oidc.yaml" &> /dev/null
    ;;
  sso)
    [[ -z "$SAC_TYPE" ]] && echo "     |_ launching oidc (sso).."
    wget -q -O ~/.ec/sdc/conf/sdc-sso.yaml https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdc/conf/sdc-sso.yaml
    sdc -cfg "$HOME/.ec/sdc/conf/sdc-sso.yaml" &> /dev/null
    ;;
  *)
    sdc $@
    ;;
esac
#sleep 5 && tail -f $(ls -t ~/.ec/*.log | head -1)    
