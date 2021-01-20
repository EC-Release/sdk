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

{
    agent -ver
} || {
    printf "\nmissing agent. begin agent installation\n\n"
    source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/v1.2beta.linux64_conf.txt)
}

# PORT indicating a custom environment
if [[ ! -z "${PORT}" ]]; then
  EC_PORT=:$PORT
fi

cd ~/.ec/oauth/

# refresh the hash
if [[ -z "${EC_PPS}" ]]; then
  export EC_PPS=$CA_PPRS    
fi
export EC_PPS=$(agent -hsh -smp)

case $EC_AUTH_VALIDATE in
  oaep)
    echo "launch oauth with oaep"
    agent -cfg ./conf/oauth_oaep.yaml &
    ;;
  aha)
    echo "launch oauth with aha"
    agent -cfg ./conf/oauth_aha.yaml &
    ;;
  oidc)
    echo "launch oauth with oidc"
    agent -cfg ./conf/oauth_oidc.yaml &
    ;;
  sso)
    echo "launch oauth with ge-sso"
    agent -cfg ./conf/oauth_sso.yaml &
    ;;
  *)
    agent $@
    ;;
esac
sleep 5 && tail -f $(ls -t ~/.ec/*.log | head -1)    
