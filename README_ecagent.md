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
  -hst string
    	Specify the EC Gateway URI. E.g. wss://<somedomain>:8989
  -inf
    	The Product Information.
  -lpt int
    	Specify the EC port# if the "client" mode is set. (default 7990)
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
  -rpt int
    	Specify the Resource Port# if the "server" mode is set. E.g. <someip>, <somedomain>
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
    	Specify the Zone/Service Inst. Id. required for gateway.
``` 

##Example usage in Server mode
```shellscript
$\>./ecagent_darwin -aid 191001 -hst wss://example-gateway-app.run.aws-usw02-pr.ice.predix.io -oa2 https://20564631-a69c-4cc5-83bd-459aa307a307.predix-uaa.run.aws-usw02-pr.ice.predix.io/oauth/token -rht localhost -rpt 5432 -tkn ZWM1OTY4NmEtZTljOC00ZWQ2LThjZTEtZTg3YTA2MmQ5OTBl
```
##Example usage in Client mode
```shellscript
$\>./ecagent_darwin -mod client -aid 191000 -hst wss://example-gateway-app.run.aws-usw02-pr.ice.predix.io -lpt 7990 -tid 191001 -tkn ZWM1OTY4NmEtZTljOC00ZWQ2LThjZTEtZTg3YTA2MmQ5OTBl
```

##Example usage in Gateway mode
```shellscript
$\>./ecagent_darwin -mod gateway -lpt 8989 -zon ec59686a-e9c8-4ed6-8ce1-e87a062d990e -sst https://ec59686a-e9c8-4ed6-8ce1-e87a062d990e.run.aws-usw02-pr.ice.predix.io
```
 
