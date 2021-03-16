#!/bin/bash
mkdir -p ~/.ec/api/portal1.x/ ~/.ec/api/conf
wget -q --show-progress -O ~/.ec/api/portal1.x/v1.1beta.tar.gz https://github.com/EC-Release/web-ui/archive/v1.1beta.tar.gz
tar -xzf ~/.ec/api/portal1.x/v1.1beta.tar.gz --strip 1 -C ~/.ec/api/portal1.x
rm ~/.ec/api/portal1.x/v1.1beta.tar.gz
wget -q --show-progress -O ~/.ec/api/conf/api.yaml https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/api/conf/api.yaml
ls -al ~/.ec/api/portal1.x ~/.ec/api ~/.ec/api/conf/
