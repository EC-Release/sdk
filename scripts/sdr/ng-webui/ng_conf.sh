#!/bin/bash

mkdir -p ~/.ec/sdr/webui-assets/ ~/.ec/sdr/conf

#if [[ -z "$ZONE" ]] && [[ -z "$SAC_TYPE" ]]; then

echo "    |_ downloading seeder assets .."
if [[ -z "$EC_DEV" ]]; then
  mkdir -p ~/.ec/api/webui-assets/ ~/.ec/api/conf
  wget -q -O ~/.ec/api/webui-assets/v1.2beta.tar.gz https://github.com/EC-Release/ng-portal/archive/v1.2beta.tar.gz &> /dev/null
  tar -xzf ~/.ec/api/webui-assets/v1.2beta.tar.gz --strip 1 -C ~/.ec/api/webui-assets
  rm ~/.ec/api/webui-assets/v1.2beta.tar.gz
else
  wget -q -O ~/.ec/sdr/webui-assets/1.2-b.tar.gz https://github.com/EC-Release/ng-portal/archive/1.2-b.tar.gz &> /dev/null
  tar -xzf ~/.ec/sdr/webui-assets/1.2-b.tar.gz --strip 1 -C ~/.ec/sdr/webui-assets
  rm ~/.ec/sdr/webui-assets/1.2-b.tar.gz
fi

if [[ ! -f ~/.ec/sdr/conf/sdr.yaml ]] && [[ ! -s ~/.ec/sdr/conf/sdr.yaml ]]; then
  echo "     |_ adding seeder config .."
  wget -q -O ~/.ec/sdr/conf/sdr.yaml https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/sdr/conf/sdr.yaml &> /dev/null
fi
