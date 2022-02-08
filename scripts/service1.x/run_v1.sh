#!/bin/bash
#
#  Copyright (c) 2020 General Electric Company. All rights reserved.
#
#  The copyright to the computer software herein is the property of
#  General Electric Company. The software may be used and/or copied only
#  with the written permission of General Electric Company or in accordance
#  with the terms and conditions stipulated in the agreement/contract
#  under which the software has been supplied.
#

: '# legacy env vars from CF1

ADMIN_PWD
ADMIN_TKN
ADMIN_USR
BASE

EC_PRVT_PWD <service 2.x pphrase>
EC_SETTINGS <group detail, account, etc.>
ENV
GITHUB_TOKEN
PLAN_ID
PLAN_NAME
UPDATED
ZONE

# *S*AC
ZAC_CLIENT_ID <DevID>
ZAC_CLIENT_SECRET <Hash>
ZAC_SERVICE_ID <EC-1.x>
ZAC_UAA <SDC URL>
ZAC_URL <SAC URL>

# deprecated
CF_API
CF_LOGIN
CF_PWD
CF_USR
NR_KEY
NUREGO_API_KEY
NUREGO_ENDPOINT
NUREGO_FEATURE_ID
NUREGO_TKN_INS
NUREGO_TKN_PWD
NUREGO_TKN_URL
NUREGO_TKN_USR
NUREGO_USAGE_FEATURE_ID'


mkdir -p ./temp
curl -s -o ./temp/service2.x.cer https://${GITHUB_TOKEN}@raw.githubusercontent.com/EC-Release/x509/main/crt-list/beta/c2211cb7-3ae6-4a8f-a6c4-01577615f318.cer
curl -s -o ./temp/service2.x.key https://${GITHUB_TOKEN}@raw.githubusercontent.com/EC-Release/pkeys/master/451ecf94-b442-4ebb-904e-0e1b50d8b1de.key
curl -s -o ./temp/service.cer https://${GITHUB_TOKEN}@raw.githubusercontent.com/EC-Release/service-update/main/service.cer
curl -s -o ./temp/service.key https://${GITHUB_TOKEN}@raw.githubusercontent.com/EC-Release/service-update/main/service.key
curl -s -o ./temp/service.hash https://${GITHUB_TOKEN}@raw.githubusercontent.com/EC-Release/service-update/main/service1.x.hash
ls -al /root/temp
#exit 0

#ls -al
#tar -zxf ./temp.tar.gz
#rm temp.tar.gz

# jira integration

export EC_PUB_KEY="$(cat ./temp/service.cer)"
export EC_PRVT_KEY="$(cat ./temp/service.key)"

{
    agent -ver
} || {
    printf "\n\nmissing agent. begin agent installation\n"
    source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/v1.2beta.linux64_conf.txt)
}

printf "\n\nbegin test keypair\n"
#source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1.2beta.linux64.txt) 

#if [[ -z "${EC_PPS}" ]]; then
export EC_PPS=$(cat ./temp/service.hash)
#fi
export EC_PPS=$(agent -hsh -smp)

printf "\n\ndecrypt the RSA pkey\n"
agent -pvd -pvk ./temp/service2.x.key
printf "\n\nvalidate the x509 cert\n"
#agent -vfy -pbk $(cat ./temp/service.cer|base64 -w0)
agent -vfy -pbk ./temp/service2.x.cer
printf "\n\nend test keypair\n"

printf "\n\nDownloading service code\n"
#rm -rf ec-px-service
mkdir -p ec-px-service ec-px-service/assets ec-px-service/ec-web-ui
wget https://gitlab.com/ec-release/cf-service/-/archive/v1/cf-service-v1.tar.gz
tar -xzf cf-service-v1.tar.gz --strip 1 -C ec-px-service
cd ec-px-service

wget https://gitlab.com/ec-release/cf-service-assets/-/archive/v1/cf-service-assets-v1.tar.gz
tar -xzf cf-service-assets-v1.tar.gz --strip 1 -C assets
wget https://gitlab.com/ec-release/cf-service-webui/-/archive/v1/cf-service-webui-v1.tar.gz
tar -xzf cf-service-webui-v1.tar.gz --strip 1 -C ec-web-ui

printf "\n\nservice code downloaded successfully\n"

cp ./../temp/service.key ./
cp ./../temp/service.cer ./

:'deprecated
printf "\n\nbegin auth-api replacement\n"
#cd ./ec-px-service
wget -q --show-progress https://github.com/EC-Release/auth-api/raw/v1/dist/api/api_linux.tar.gz
tar -xzf api_linux.tar.gz
chmod +x api_linux
printf "\n\nend auth-api replacement\n"'

#rm ./cf-service-webui-v1.tar.gz ./cf-service-assets-v1.tar.gz ./../cf-service-v1.tar.gz ./api_linux.tar.gz
rm ./cf-service-webui-v1.tar.gz ./cf-service-assets-v1.tar.gz ./../cf-service-v1.tar.gz

npm install
#ls -la $(pwd)
tree ./
eval "sed -i -e 's#{HOST}#${APP}-${ENV}.${HOST}#g' ./assets/swagger.json"
eval "sed -i -e 's#{BASE}#${EC_REV}#g' ./assets/swagger.json"
eval "sed -i -e 's#{ENV}#${ENV}#g' ./assets/swagger.json"
eval "sed -i -e 's#{APP_PATH}#/${REV}/index#g' ./assets/index.html"

touch -a ~/.env
npm install dotenv

node ./app.js


