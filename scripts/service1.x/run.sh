#!/bin/bash
ls -al
tar -zxf ./temp.tar.gz
rm temp.tar.gz
cd temp

export EC_PUB_KEY="$(cat service.cer)"
export EC_PRVT_KEY="$(cat service.key)"


printf "begin test keypair"
source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1.2beta.linux64.txt) 
export EC_PPS=${EC_PRVT_ADM}
export EC_PPS=$(agent -hsh)
agent -pvd -pvk $(cat service.key|base64 -w0)
printf "end test keypair"

printf "begin auth-api replacement"
wget -q --show-progress https://github.com/EC-Release/auth-api/raw/v1beta/dist/api/api_linux.tar.gz
tar -xzf api_linux.tar.gz
chmod +x api_linux
printf "end auth-api replacement"


ls -la $(pwd)
eval "sed -i -e 's#{HOST}#${APP}-${ENV}.${HOST}#g' ./assets/swagger.json"
eval "sed -i -e 's#{BASE}#${EC_REV}#g' ./assets/swagger.json"
eval "sed -i -e 's#{ENV}#${ENV}#g' ./assets/swagger.json"
eval "sed -i -e 's#{APP_PATH}#/${REV}/index#g' ./assets/index.html"
node ./app.js
