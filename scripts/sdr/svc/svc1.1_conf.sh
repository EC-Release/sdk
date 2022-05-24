#!/bin/bash

mkdir -p ~/.ec/svc/conf



if [[ ! -z "$EC_DEV" ]]; then

  wget -q -O ~/.ec/svc/conf/svc.yaml https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdr/conf/svc-dev.yaml &> /dev/null

  
else

  wget -q -O ~/.ec/svc/conf/svc.yaml https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdr/conf/svc.yaml &> /dev/null

fi
