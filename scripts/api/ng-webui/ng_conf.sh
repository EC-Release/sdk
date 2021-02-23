#!/bin/bash
mkdir -p ~/.ec/api/webui-assets/ ~/.ec/api/conf
wget -q --show-progress -O ~/.ec/api/webui-assets/v1.2beta.tar.gz https://github.com/EC-Release/ng-portal/archive/v1.2beta.tar.gz
tar -xzf ~/.ec/api/webui-assets/v1.2beta.tar.gz --strip 1 -C ~/.ec/api/webui-assets
rm ~/.ec/api/webui-assets/v1.2beta.tar.gz
wget -q --show-progress -O ~/.ec/api/conf/api.yaml https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/api/conf/api.yaml
ls -al ~/.ec/api/webui-assets ~/.ec/api ~/.ec/api/conf/
