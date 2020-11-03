#!/bin/bash
wget -q --show-progress -O ~/.ec/api/ng-webui/ng.tar.gz https://github.com/EC-Release/ng-webui/archive/main.tar.gz
ls -al ~/.ec/api/ng-webui
tar -xzf ~/.ec/api/ng-webui/ng.tar.gz --strip 1 -C ~/.ec/api/ng-webui
ls -al ~/.ec/api/ng-webui
