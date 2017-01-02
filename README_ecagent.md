# ec-agent-daemon
Downloads | Build Status
--- | ---
[EC SDK](https://github.com/Enterprise-connect/ec-sdk) | <a href='https://predix1.jenkins.build.ge.com/job/Enterprise-Connect/EC Server Daemon CLI'><img src='https://predix1.jenkins.build.ge.com/buildStatus/icon?job=Enterprise-Connect/EC Server Daemon CLI'></a>

 - Introducing the Enterprise-Connect Agent Daemon/CLI

## Usage
```shellscript
$ ./ecagent -h
Usage of ./bin/ecagent_darwin:
-aid string
    	Specify the agent Id assigned by the EC Service. You may find it in the Cloud Foundry VCAP_SERVICE
  -bkl string
    	Specify the ip(s) blocklist in the IPv4/IPv6 format. Concatenate ips by comma. E.g. 10.20.30.5, 2002:4559:1FE2::4559:1FE2
  -cid string
    	Specify the client Id to auto-refresh the OAuth2 token.
  -crt string
    	Specify the relative path of a digital certificate to operate the EC agent. (.pfx, .cer, .p7s, .der, .pem, .crt)
  -csc string
    	Specify the client secret to auto-refresh the OAuth2 token.
  -dur int
    	Specify the duration for the next token refresh in seconds. (default 100 years)
  -hca string
    	Specify a port# to turn on the Healthcheck API. This flag is always on when in the "gateway mode" with the provisioned local port.
  -hst string
    	Specify the EC Gateway URI. E.g. wss://<somedomain>:8989
  -inf
    	The Product Information.
  -lpt string
    	Specify the EC port# if the "client" mode is set. (default "7990")
  -mod string
    	Specify the EC Agent Mode in "client", "server", or "gateway". (default "server")
  -oa2 string
    	Specify URL of the OAuth2 provisioner. E.g. https://<somedomain>/oauth/token
  -pct string
    	Specify the relative path to a TLS cert when operate as the gateway as desired. E.g. ./path/to/cert.pem.
  -pky string
    	Specify the relative path to a TLS key when operate as the gateway as desired. E.g. ./path/to/key.pem.
  -pxy string
    	Specify a local Proxy service. E.g. http://hello.world.com:8080
  -rht string
    	Specify the Resource Host if the "server" mode is set. E.g. <someip>, <somedomain>
  -rpt string
    	Specify the Resource Port# if the "server" mode is set. E.g. 8989, 38989
  -sst string
    	Specify the EC Service URI. E.g. https://<service.of.predix.io>
  -tid string
    	Specify the Target EC Server Id if the "client" mode is set (default "191001")
  -tkn string
    	Specify the OAuth Token. The token may expire depending on your OAuth provisioner. This flag is ignored if OAuth2 Auto-Refresh were set.
  -ver
    	Show EC Agent's version.
  -wtl string
    	Specify the ip(s) whitelist in the cidr net format. Concatenate ips by comma. E.g. 89.24.9.0/24, 7.6.0.0/16 (default "0.0.0.0/0,::/0")
  -zon string
    	Specify the Zone/Service Inst. Id. required in the "gateway" mode.
``` 

##Example usage in Server mode
```shellscript
$\>./ecagent_darwin -aid 191001 -hst wss://ec-chia-app-7.run.aws-usw02-pr.ice.predix.io -rht localhost -rpt 5432 -cid <id> -csc <secret> -oa2 https://helo-a69c-4cc5-83bd-459aa307a307.predix-uaa.run.aws-usw02-pr.ice.predix.io/oauth/token -dur 30 -mod server
```
##Example usage in Client mode
```shellscript
$\>./ecagent_darwin -mod client -aid 191000 -hst wss://ec-chia-app-7.run.aws-usw02-pr.ice.predix.io -lpt 7990 -tid 191001 -oa2 https://helo-a69c-4cc5-83bd-459aa307a307.predix-uaa.run.aws-usw02-pr.ice.predix.io/oauth/token -cid <id> -csc <secret> -dur 30
```

##Example usage in Gateway mode
```shellscript
$\>./ecagent_darwin -mod gateway -lpt 8989 -zon helo-1f98-4ea8-ad48-a96d38ba2931 -sst https://helo-1f98-4ea8-ad48-a96d38ba2931.run.aws-usw02-pr.ice.predix.io
```
 
