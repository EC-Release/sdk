#!/bin/bash
mkdir -p ~/.ec/api/portal1.x/ ~/.ec/api/conf ~/.ec/tmp/portal

# temp for PR https://github.com/EC-Release/web-ui/pull/112
# wget -q --show-progress -O ~/.ec/api/portal1.x/v1.1beta.tar.gz https://github.com/Subhash-vishwakarma/web-ui/archive/v1.1beta.tar.gz
wget -q --show-progress -O ~/.ec/api/portal1.x/v1.1beta.tar.gz https://github.com/EC-Release/web-ui/archive/v1.1beta.tar.gz

wget -q --show-progress -O ~/.ec/tmp/portal/v1.2beta.tar.gz https://github.com/EC-Release/ng-portal/archive/refs/heads/v1.2beta.tar.gz


tar -xzf ~/.ec/api/portal1.x/v1.1beta.tar.gz --strip 1 -C ~/.ec/api/portal1.x

tar -xzf ~/.ec/tmp/portal/v1.2beta.tar.gz --strip 1 -C ~/.ec/tmp/portal

{
 rm -Rf ~/.ec/api/portal1.x/webui-assets/swagger-ui
}

mv ~/.ec/api/portal1.x/webui-assets ~/.ec/api/

mv ~/.ec/tmp/portal/swagger-ui ~/.ec/api/webui-assets/
#rm ~/.ec/api/portal1.x/v1.1beta.tar.gz 
rm -Rf ~/.ec/api/portal1.x ~/.ec/tmp/portal
wget -q --show-progress -O ~/.ec/api/conf/api.yaml https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/api/conf/api.yaml
tree ~/.ec/api
