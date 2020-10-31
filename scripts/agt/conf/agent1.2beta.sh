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

case $EC_AUTH_VALIDATE in
  oaep)
    echo "launch oauth with oaep"
    cat .ec/conf/oauth_oaep.yaml
    ;;
  oidc)
    echo "launch oauth with oidc"
    cat .ec/conf/oauth_oidc.yaml
    ;;
  *)
    ;;
esac

echo hello agent1.2beta
ls -al && ls -al ~/.ec
#agent -cfg .ec/conf/${mod}.yml
agent -ver
