#!/bin/bash
mkdir -p ~/.ec/api/ng-webui/ ~/.ec/api/conf
wget -q --show-progress -O ~/.ec/api/ng-webui/ng.tar.gz https://github.com/EC-Release/ng-webui/archive/main.tar.gz
tar -xzf ~/.ec/api/ng-webui/ng.tar.gz --strip 1 -C ~/.ec/api/ng-webui
rm ~/.ec/api/ng-webui/ng.tar.gz
wget -q --show-progress -O ~/.ec/api/conf/api.yaml https://ec-release.github.io/sdk/scripts/api/conf/api.yaml
ls -al ~/.ec/api/ng-webui ~/.ec/api ~/.ec/api/conf/
