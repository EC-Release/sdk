# ec-agent-daemon
Downloads | Build Status
--- | ---
[EC SDK](https://github.com/Enterprise-connect/ec-sdk) | <a href='https://predix1.jenkins.build.ge.com/job/Enterprise-Connect/EC Server Daemon CLI'><img src='https://predix1.jenkins.build.ge.com/buildStatus/icon?job=Enterprise-Connect/EC Server Daemon CLI'></a>

 - Introducing The Enterprise-Connect Agent Daemon/CLI

## Usage
```shellscript
$ ./ecagent -h
Usage of ./ecagent:
-aid string
    	Specify the agent Id assigned by the EC Service. You may find it in the Cloud Foundry VCAP_SERVICE
  -cid string
    	Specify client Id to auto-refresh the OAuth2 token.
  -csc string
    	Specify client secret to auto-refresh theOAuth2 token.
  -dur int
    	Specify the duration for the next token refresh in seconds. (default 100 years)
  -hst string
    	Specify the EC Gateway URI. E.g. wss://<somedomain>:8989
  -lpt int
    	Specify the EC port# if the "client" mode is set. By default 7990 (default 7990)
  -mod string
    	Specify the EC Agent Mode ("client" or "server". "server" By default) (default "server")
  -oa2 string
    	Specify URL of the OAuth2 provisioner. E.g. https://<somedomain>/oauth/token
  -pxy string
    	Specify a local Proxy service. E.g. http://hello.world.com:8080
  -rht string
    	Specify the Resource Host if the "server" mode is set. E.g. <someip>, <somedomain>
  -rpt int
    	Specify the Resource Port# if the "server" mode is set. E.g. <someip>, <somedomain>
  -tid string
    	Specify the Target EC Server Id if the "client" mode is set (default "191001")
  -tkn string
    	Specify the OAuthToken. This token may expire depending on your OAuth provisioner.
  -ver
    	Show EC Server version.

``` 
 
