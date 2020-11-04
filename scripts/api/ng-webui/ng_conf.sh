#!/bin/bash
mkdir -p ~/.ec/api/webui-assets/ ~/.ec/api/conf
wget -q --show-progress -O ~/.ec/api/webui-assets/main.tar.gz https://github.com/EC-Release/ng-webui/archive/main.tar.gz
tar -xzf ~/.ec/api/webui-assets/main.tar.gz --strip 1 -C ~/.ec/api/webui-assets
rm ~/.ec/api/webui-assets/main.tar.gz
wget -q --show-progress -O ~/.ec/api/conf/api.yaml https://ec-release.github.io/sdk/scripts/api/conf/api.yaml
ls -al ~/.ec/api/webui-assets ~/.ec/api ~/.ec/api/conf/
