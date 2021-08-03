## This is the User Guide for EC Adoption

### Introduction
**EC** stands for "**Enterprise-Connect**", it is a professional assembly led by a group of researchers, and engineers (ec-research@ge.com) who have common vision of the de-centralisation network, currently sponsored by General Electric. It has the following main components:
1. **EC Service**: Currently built in Cloud-Foundry, the EC Service is a Single-Tenant, Self-contained, Async-Ops microservice. EC service is endorsed by the GE security team and is available as a GA release. The service breaks down into the following functions:
    * Usage reporting
    * System performance/health check
    * Account managing
    * Security validation
    * Two-way digital certs
    * Management UI

2. **EC Agent**: To make EC conformed to the design pattern of the TURN protocol (Traversal Using Relays around NAT, RFC5766) for the sake of its extendibility, sustainability, and compatibility of mass-computing (Cloud Computing), it is essentially equipped with three explicit functional modes- **Client**, **Server**, and **Gateway**, of each may operate independently without one another.

    When in the "**Client**" mode, the agent provisions a resource access and is subsumed by host applications whereas the "**Server**" which has sole access to a target resource, is tasked to transmitting the data flow between the resource and a Gateway.

    The "**Gateway**" mode handles security handshakes, IP filtering, and seeks for the permission from a EC service instance by passing on the Client/Server credentials to authorising requests. Upon authenticated, the Gateway will then perform two-way binding (Client/Server), induce a session, and then signify requesters for the readiness.

![image](https://user-images.githubusercontent.com/20440873/127664178-865d9b20-6086-4f40-a436-67813cf2e312.png)


### How to deploy
The deployment primarily involes 2 steps-
#### 1. Create EC-Service:
This tutorial presumed that you have installed the [Cloud Foundry CLI](https://github.com/cloudfoundry/cli), have an active account with the [platform](https://www.predix.io/), and had previously deployed a Cloud Foundry UAA instance. Here are the step-through commands:
```
~/.$ cf cs enterprise-connect Beta <service_name> -c \
'{"trustedIssuerIds":["https://<predix-uaa-instance-uri>/oauth/token"]}'
```
```
~/.$ cf bs cs <gateway_mode_agent_application> <service_name>
```
```
~/.$ cf env <gateway_mode_agent_application>
...
{
    "credentials": {
     "ec-info": {
      "ids": [
       "iSDjhs",
       "HzhGUD"
      ],
      "trustedIssuerIds": [
       "https://67c431e9-29e8-49e5-95b2-105660686261.predix-uaa.run.aws-usw02-pr.ice.predix.io/oauth/token"
      ],
      "admin-token": "YWRtaW46OUVEMTkxdEBJMTMxOTY3YjgtOWQ4My00ZmRhLWFkNjAtNDU0ZDNjNjFiMWY1"
     },
     "service-uri": "https://131967b8-9d83-4fda-ad60-454d3c61b1f5.run.aws-usw02-pr.ice.predix.io",
     "usage-doc": "https://github.com/Enterprise-connect/sdk/wiki",
     "zone": {
      "http-header-name": "Predix-Zone-Id",
      "http-header-value": "131967b8-9d83-4fda-ad60-454d3c61b1f5",
      "oauth-scope": "enterprise-connect.zones.131967b8-9d83-4fda-ad60-454d3c61b1f5.user"
     }
    },
    "label": "enterprise-connect",
    "name": "chia-ec-43",
    "plan": "Beta",
    "provider": null,
    "syslog_drain_url": null,
    "tags": [],
    "volume_mounts": []
   }
}
...
```

**Add the above oauth-scope to your client/user in the UAA Authority**
[Click here to add the EC scope to UAA](https://docs.cloudfoundry.org/uaa/uaa-user-management.html)

Once the EC-Service is created, we can start with the deployment of the EC-Agent.

#### 2. Deploy Agent SDK:
**Agent Usage** (Flags that can be used to configure EC-Agents):
```
$ ./agent_darwin_sys_213 -h
loading application parameters..
Usage of ./agent_darwin_sys_213:
  -aid string
    	Specify the agent Id assigned by the EC Service. You may find it in the Cloud Foundry VCAP_SERVICE
  -api
    	Operate agent in HTTP mode.
  -apt string
    	Specify the EC http endpoint port# if the agent when -api is set. (default "17990")
  -bkl string
    	Specify the ip(s) blocklist in the IPv4/IPv6 format. Concatenate ips by comma. E.g. 10.20.30.5, 2002:4559:1FE2::4559:1FE2
  -cer
    	Show EC Agent Cert.
  -cfg string
    	Specify the config file to launch the agent.
  -cid string
    	Specify the client Id to auto-refresh the OAuth2 token.
  -cps int
    	Specify the Websocket compression-ratio for agent's inter-communication purpose. E.g. [0-9]. "0" is no compression whereas "9" is the best. "-1" indicates system default. "-2" is HuffmanOnly. See RFC 1951 for more detail.
  -crt string
    	Specify the relative path of a digital certificate to operate the EC agent. (.pfx, .cer, .p7s, .der, .pem, .crt)
  -csc string
    	Specify the client secret to auto-refresh the OAuth2 token.
  -dat string
    	Specify the string to be encrypted.
  -dbg
    	Turn on debug mode. This will introduce more error information. E.g. connection error.
  -dec
    	Decrypt the string for validation. can combine with the flags (-dec -pth <dir-pvtkey> -psp <passphrase> -dat <encypted-data>) for one-step decryption.
  -dur int
    	Specify the duration for the next token refresh in seconds. (default 100 years)
  -enc
    	Encrypt the string for validation.
  -fdw string
    	Specify a file to download from the client agent.
  -fup string
    	Specify a file to upload to the server agent.
  -gen
    	Generate a certificate request for the usage validation purpose.
  -gpt string
    	Specify the gateway port# in fuse-mode. (gw:server|gw:client) (default "8990")
  -grp string
    	GroupID needed for Agent Client/Server.
  -gsg
    	Generate the signature based on the given private key string(-pks), passphrase (-psp), and message (-dat) to be signed.
  -hca string
    	Specify a port# to turn on the Healthcheck API. This flag is always on when in the "gateway mode" with the provisioned local port. Upon provisioned, the api is available at <agent_uri>/health.
  -hst string
    	Specify the EC Gateway URI. E.g. wss://<somedomain>:8989
  -inf
    	The Product Information.
  -lpt string
    	Specify the default EC port#. (default "7990")
  -mod string
    	Specify the EC Agent Mode in "client", "server", or "gateway". (default "agent")
  -oa2 string
    	Specify URL of the OAuth2 provisioner. E.g. https://<somedomain>/oauth/token
  -osg string
    	Signature string in base64 encoded format.
  -pbk string
    	Base64 encoded certificate string.
  -pct string
    	Specify the relative path to a TLS cert when operate as the gateway as desired. E.g. ./path/to/cert.pem.
  -pks string
    	Specify the private key in base64 encoded format to decrypt the token from the agent. E.g. -pkg LS0tLS1CRUdJTiBSU0EgU..
  -pky string
    	Specify the relative path to a TLS key when operate as the gateway as desired. E.g. ./path/to/key.pem.
  -plg
    	Enable EC plugin list. This requires the plugins.yml file presented in the agent path.
  -psp string
    	Specify the passphrase of the private key, combined with the flags (-dec -pth <dir-pvtkey> -psp <passphrase> -dat <encypted-data>) for one-step decryption.
  -pth string
    	Specify the directory to the certificate/key.
  -pxy string
    	Specify a local Proxy service. E.g. http://hello.world.com:8080
  -rht string
    	Specify the Resource Host if the "server" mode is set. E.g. <someip>, <somedomain>. value will be discard when TLS is specified.
  -rnw
    	Renew a previous-issued x509 certificate.
  -rpt string
    	Specify the Resource Port# if the "server" mode is set. E.g. 8989, 38989 (default "0")
  -sgn
    	Start a CA Cert-Signing process.
  -shc
    	Health API requires basic authentication for Health APIs.
  -smp
    	Simplifying the output for integration purpose.
  -sst string
    	Specify the EC Service URI. E.g. https://<service.of.predix.io>
  -tid string
    	Specify the Target EC Server Id if the "client" mode is set
  -tkn string
    	Specify the OAuth Token. The token may expire depending on your OAuth provisioner. This flag is ignored if OAuth2 Auto-Refresh were set.
  -tsd
    	Check the timestamp of the EC token (-dat) 
  -tse
    	Create a EC-compatible Token, with publickey (-pbk) and an optional 32-digits uuid (-dat). 
  -ver
    	Show EC Agent's version.
  -vfy
    	Verify the legitimacy of a digital certificate.
  -vln
    	Enable support for EC VLAN Network.
  -vsg
    	Verify the signature based on the given public key string (-pbk), passphrase, original message (-osg), and the signature (-dat), all are base64 encoded.
  -wtl string
    	Specify the ip(s) whitelist in the cidr net format. Concatenate ips by comma. E.g. 89.24.9.0/24, 7.6.0.0/16 (default "0.0.0.0/0,::/0")
  -zon string
    	Specify the Zone/Service Inst. Id. required in the "gateway" mode.
```
**Example usage in Server mode**:
```
$\>./ecagent_darwin -aid 191001 -hst wss://ec-chia-app-7.run.aws-usw02-pr.ice.predix.io \
-rht localhost -rpt 5432 -cid <id> -csc <secret> -oa2 \
https://helo-a69c-4cc5-83bd-459aa307a307.predix-uaa.run.aws-usw02-pr.ice.predix.io/oauth/token \
-dur 300 -mod server
```
**Example usage in Client mode**:
```
$\>./ecagent_darwin -mod client -aid 191000 -hst wss://ec-chia-app-7.run.aws-usw02-pr.ice.predix.io \
-lpt 7990 -tid 191001 \
-oa2 https://helo-a69c-4cc5-83bd-459aa307a307.predix-uaa.run.aws-usw02-pr.ice.predix.io/oauth/token \
-cid <id> -csc <secret> -dur 300
```
**Example usage in Gateway mode**:
```
$\>./ecagent_darwin -mod gateway -gpt 8989 -zon helo-1f98-4ea8-ad48-a96d38ba2931 \
-sst https://helo-1f98-4ea8-ad48-a96d38ba2931.run.aws-usw02-pr.ice.predix.io \
-tkn <base64(admin:<secret><your-zone-id>)>
```

##### Validation
```
## Verify the checksum
### Linux
```bash
$ sha256 ./path/to/file/ecagent_linux_sys
b3bf9cd9686e
$ awk 's=index($0,"b3bf9cd9686e") { print "line=" NR, "start position=" s}' checksum.txt
line=2 start position=1
```
##### Mac OS
```
$ shasum -a 256 ./path/to/file/ecagent_linux_sys
b3bf9cd9686e
$ awk 's=index($0,"b3bf9cd9686e") { print "line=" NR, "start position=" s}' checksum.txt
line=2 start position=1
```
##### Windows
```bash
c: \> CertUtil -hashfile C:\path\to\file\ecagent_windows.exe sha256
b3bf9cd9686e (find the checksum in the checksum.txt)
```


### How to Create Connection

### How to perform the basic troubleshooting for my connection
Please visit our [Issues-tracker](https://github.com/EC-Release/sdk/issues) for various commonly encountered issues and their resolution.

### References
1. https://github.com/EC-Release/sdk/wiki
2. https://github.com/EC-Release/sdk/wiki/EC-Service
3. https://github.com/EC-Release/sdk/wiki/EC-Agent
4. https://github.com/EC-Release/sdk/wiki/EC-Agent-Usage
5. https://github.com/EC-Release/sdk/wiki/Create-EC-Service
6. https://github.com/EC-Release/sdk/issues
7. https://github.com/Enterprise-connect/sdk
8. https://github.com/cloudfoundry/cli
9. https://www.predix.io/
10. https://docs.cloudfoundry.org/uaa/uaa-user-management.html
11. https://www.ge.com/digital/documentation/predix-services/INGZiMmIzMjctOWU1YS00NGVlLThjNzgtYmRjNmMxMjA4Njcw.html
