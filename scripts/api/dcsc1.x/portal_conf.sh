#!/bin/bash
mkdir -p ~/.ec/api/dcsc1.x/ ~/.ec/api/conf

wget -q --show-progress -O ~/.ec/api/dcsc1.x/v1beta.tar.gz https://github.com/dc-release/dc-portal/archive/refs/heads/v1beta.tar.zip

tar -xzf ~/.ec/api/dcsc1.x/v1beta.tar.gz --strip 1 -C ~/.ec/api/dcsc1.x
rm ~/.ec/api/dcsc1.x/v1beta.tar.gz
wget -q --show-progress -O ~/.ec/api/conf/api.yaml https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/api/conf/api.yaml
ls -al ~/.ec/api/dcsc1.x ~/.ec/api ~/.ec/api/conf/
