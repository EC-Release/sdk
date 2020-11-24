# API DB Usage
```bash
# step 1 generate the hash
docker run -it enterpriseconnect/agent:v1.2beta -hsh

# step 2 post the data
docker run -e EC_PPS=<hash generated in step 1> \
-it enterpriseconnect/api:v1.2beta \
-oa2 https://ec-oauth-oaep.herokuapp.com/oauth/token \
-cid <cert-id> \
-dat '{"hello":"world"}' \
-url https://ec-ng-webui.herokuapp.com/v1.2beta/ec/api/<key>

# post the data
curl -H 'Authorization:Bearer <token output from step 2>' \
-d '{"your":"json","object":"hello"}' \
-X POST https://ec-ng-webui.herokuapp.com/v1.2beta/ec/api/<key post from step 2>

# get the data
curl -H 'Authorization:Bearer <token output from step 2>' \
-X GET https://ec-ng-webui.herokuapp.com/v1.2beta/ec/api/<key post from step 2>

# get all keys list
curl -H 'Authorization:Bearer <token output from step 2>' \
-X GET https://ec-ng-webui.herokuapp.com/v1.2beta/ec/api
```
