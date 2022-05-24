#!/bin/bash

mkdir -p "${HOME}/.ec/sac-slav/conf"

if [[ ! -z "$EC_DEV" ]]; then

  wget -q -O "${HOME}/.ec/sac-slav/conf/sac.yaml" https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdr/conf/sac-dev.yaml &> /dev/null
  
else

  wget -q -O "${HOME}/.ec/sac-slav/conf/sac.yaml" https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdr/conf/sac.yaml &> /dev/null
fi
