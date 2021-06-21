# EC 2.x Demo

### Launch Agent
Launch agent with ```x:gateway mode```. refer to [this config file](https://github.com/EC-Release/sdk/blob/disty/scripts/agt/conf/x:gateway.yml)
```shell
docker run -it -e EC_GPT=":8080" \
-e EC_HST="igs-url" \
-e EC_SED="customer-console-url/v1.2beta/ops" \
-e EC_CID="license-id" \
-e EC_OA2="the-sdc-url/oauth/token" \
-v $(pwd):/root/.ec enterpriseconnect/agent:v1.2beta \
-cfg ./.ec/agt/conf/x:gateway.yml
```
