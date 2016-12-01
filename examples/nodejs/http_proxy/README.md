#EC HTTP Proxy Example

##Usage
```
git clone <ec_sdk_repo>
cd ./examples/nodejs/http_proxy
cf push

//for client
node ./client-cf
```

##Configuration
* Ensure the gateway has been deployed prior to the usage.
* log in your CF environment.
* push the server example.
* run the client example.
* replace your cf login -a <api_endpoint> to http://localhost:7990 --skip-ssl-validation
* You're now reaching-in from public to Predix select environment! 
