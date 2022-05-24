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

case $STEP in
1000)
  source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/cipher/certifactory/hsh-gen.sh)  
  exit 0
  ;;
1001)
  source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/cipher/certifactory/lic-detail.sh)
  exit 0
  ;;
1002)
  source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/cipher/certifactory/csr-gen.sh)
  exit 0
  ;;
1003)
  source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/cipher/certifactory/lic-sign.sh)
  exit 0
  ;;
*)
  echo "no operations avaialble. ($STEP)"
  ;;
esac
