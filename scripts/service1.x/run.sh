#!/bin/bash
ls -al
tar -zxf ./temp.tar.gz
rm temp.tar.gz
cd temp

#auth api read certs directly
#export EC_PUB_KEY="$(cat service.cer)"
#export EC_PRVT_KEY="$(cat service.key)"

# begin test
cat service.cer
cat service.key
echo $EC_PRVT_PWD
# end test

ls -la $(pwd)
eval "sed -i -e 's#{HOST}#${APP}-${ENV}.${HOST}#g' ./assets/swagger.json"
eval "sed -i -e 's#{BASE}#${EC_REV}#g' ./assets/swagger.json"
eval "sed -i -e 's#{ENV}#${ENV}#g' ./assets/swagger.json"
eval "sed -i -e 's#{APP_PATH}#/${REV}/index#g' ./assets/index.html"
node ./app.js
