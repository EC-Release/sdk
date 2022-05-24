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

echo LIC_LBL: "$LIC_LBL"

getPublicCrt "$lic_id" "$EC_GITHUB_TOKEN" > ./tmp.cer

getLicDetail "./tmp.cer" | jq '.'
