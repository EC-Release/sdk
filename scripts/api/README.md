### API DB Usage
```bash
# step 1 generate the hash
docker run -it enterpriseconnect/agent:v1.2beta -hsh

# step 2 post the data
docker run -e EC_PPS=<the hash> \
-it enterpriseconnect/api:v1.2beta \
-oa2 https://ec-oauth-oaep.herokuapp.com/oauth/token \
-cid <cert-id> \
-dat '{"hello":"world"}' \
-url https://ec-ng-webui.herokuapp.com/v1.2beta/ec/api/<key>

# get the data
curl -H 'Authorization:Bearer <token output from the step 2>' \
-X GET https://ec-ng-webui.herokuapp.com/v1.2beta/ec/api/<key post from step 2>
```
