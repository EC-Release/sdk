#!/bin/bash

mkdir -p ./temp
curl -s -o ./temp/service.cer https://${GITHUB_TOKEN}@raw.githubusercontent.com/EC-Release/x509/main/crt-list/beta/c2211cb7-3ae6-4a8f-a6c4-01577615f318.cer
curl -s -o ./temp/service.key https://${GITHUB_TOKEN}@raw.githubusercontent.com/EC-Release/pkeys/master/451ecf94-b442-4ebb-904e-0e1b50d8b1de.key
curl -s -o ./temp/service.hash https://${GITHUB_TOKEN}@raw.githubusercontent.com/EC-Release/hash-list/main/service1.x.hash
ls -al /root/temp
#exit 0

#ls -al
#tar -zxf ./temp.tar.gz
#rm temp.tar.gz

export EC_PUB_KEY="$(cat ./temp/service.cer)"
export EC_PRVT_KEY="$(cat ./temp/service.key)"

{
    agent -ver
} || {
    printf "\nmissing agent. begin agent installation\n\n"
    source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/v1.2beta.linux64_conf.txt)
}

printf "begin test keypair"
#source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1.2beta.linux64.txt) 

#if [[ -z "${EC_PPS}" ]]; then
export EC_PPS=${cat ./temp/service.hash}  
#fi
export EC_PPS=$(agent -hsh -smp)

printf "decrypt the RSA pkey"
agent -pvd -pvk $(cat ./temp/service.key|base64 -w0)
printf "validate the x509 cert"
agent -vfy -pbk $(cat ./temp/service.cer|base64 -w0)
printf "end test keypair"

printf "Downloading service code"
rm -rf ec-px-service
wget https://gitlab.com/ec-release/cf-service/-/archive/v1/cf-service-v1.tar.gz
tar -xzf cf-service-v1.tar.gz
mv cf-service-v1 ec-px-service
cd ec-px-service && wget https://gitlab.com/ec-release/cf-service-assets/-/archive/v1/cf-service-assets-v1.tar.gz
rm -rf assets/ && tar -xzf cf-service-assets-v1.tar.gz
mv cf-service-assets-v1 assets && rm -rf cf-service-assets-v1.tar.gz 
rm -rf ec-web-ui/
wget https://gitlab.com/ec-release/cf-service-webui/-/archive/v1/cf-service-webui-v1.tar.gz
tar -xzf cf-service-webui-v1.tar.gz
mv cf-service-webui-v1 ec-web-ui
rm -rf cf-service-webui-v1.tar.gz
ls -la
ls -la assets/
ls -la ec-web-ui/ 
cd ..
printf "Service code downloaded successfully"

cp ./temp/service.key ./ec-px-service
cp ./temp/service.cer ./ec-px-service

printf "begin auth-api replacement"
cd ./ec-px-service
wget -q --show-progress https://github.com/EC-Release/auth-api/raw/v1/dist/api/api_linux.tar.gz
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
