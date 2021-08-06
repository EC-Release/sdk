#!/bin/bash

ls -al
tar -zxf ./temp.tar.gz
rm temp.tar.gz

export EC_PUB_KEY="$(cat ./temp/service.cer)"
export EC_PRVT_KEY="$(cat ./temp/service.key)"

printf "begin test keypair"
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/v1.2beta.linux64.txt) 

if [[ -z "${EC_PPS}" ]]; then
  export EC_PPS=${EC_PRVT_ADM}  
fi
export EC_PPS=$(agent -hsh -smp)

printf "decrypt the RSA pkey"
#agent -pvd -pvk $(cat ./temp/service.key|base64 -w0)
agent -pvd -pvk ./temp/service.key
printf "validate the x509 cert"
agent -vfy -pbk ./temp/service.cer
printf "end test keypair"

printf "Downloading service code"
git clone https://gitlab.com/ec-release/cf-service.git ec-px-service
cd ec-px-service && git clone https://gitlab.com/ec-release/cf-service-assets.git assets
git clone https://gitlab.com/ec-release/cf-service-webui.git ec-web-ui && cd ..
rm -Rf ./ec-px-service/.git; rm ./ec-px-service/.gitmodules; rm -Rf ./ec-px-service/assets/.git; rm -Rf ./ec-px-service/ec-web-ui/.git 
printf "Service code downloaded successfully"

cp ./temp/service.key ./ec-px-service
cp ./temp/service.cer ./ec-px-service

printf "begin auth-api replacement"
cd ./ec-px-service
wget -q --show-progress https://github.com/EC-Release/auth-api/raw/v1beta/dist/api/api_linux.tar.gz
tar -xzf api_linux.tar.gz
chmod +x api_linux
printf "end auth-api replacement"

npm install
ls -la $(pwd)
eval "sed -i -e 's#{HOST}#${APP}-${ENV}.${HOST}#g' ./assets/swagger.json"
eval "sed -i -e 's#{BASE}#${EC_REV}#g' ./assets/swagger.json"
eval "sed -i -e 's#{ENV}#${ENV}#g' ./assets/swagger.json"
eval "sed -i -e 's#{APP_PATH}#/${REV}/index#g' ./assets/index.html"
node ./app.js
