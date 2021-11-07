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

![EC-Usecase](https://user-images.githubusercontent.com/38732583/140664340-1792a8ab-636e-4832-99eb-9d1db31698b9.png)


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
       "iCCjhs",
       "HCCGUD"
      ],
      "trustedIssuerIds": [
       "https://688431e9-2228-49e5-95b2-1062612425ffs.predix-uaa.run.aws-usw02-pr.ice.predix.io/oauth/token"
      ],
      "admin-token": "YWRtaW46OUVEMTkxdEBY3YjgtOWQ4My00ZmRhLWFkZDNjNjFiMWY1"
     },
     "service-uri": "https://131967b8-xxxx-4fda-xxxx-454dxxxxb1f5.run.aws-usw02-pr.ice.predix.io",
     "usage-doc": "https://github.com/Enterprise-connect/sdk/wiki",
     "zone": {
      "http-header-name": "Predix-Zone-Id",
      "http-header-value": "131967b8-xxxx-4fda-xxxx-454dxxxxb1f5",
      "oauth-scope": "enterprise-connect.zones.131967b8-xxxx-4fda-xxxx-454dxxxxb1f5.user"
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

#### Traditional mode

![image](https://github.com/ramaraosrikakulapu/sdk/blob/v1/images/EC_Tradtional.png)

Gateway example

Flag | Mandatory | Description
--- | --- | ---
`mod` | Yes | Agent mode - gateway
`gpt` | Yes | Gateway port number
`zon` | Yes | EC Subscription Id
`sst` | Yes | EC Service URI
`tkn` | Yes | EC Service admin token
`hst` | Yes | Gateway URI
`dbg` | No | Debugger. Default 'false'
`wtl` | No | Whitelist IP's
`bkl` | No | Blacklist IP's

```
./agent -mod gateway -gpt {gateway-port} \
 -zon {ec-subscription-id} \
 -sst https://{service-uri} \
 -tkn {ec-admin-token} \
 -hst {gateway-uri} \
 -dbg
```

Server example

Flag | Mandatory | Description
--- | --- | ---
`mod` | Yes | Agent mode - server
`aid` | Yes | Server agent id
`grp` | Yes | Agent group which combines server and client agent id's
`zon` | Yes | EC Subscription Id
`sst` | Yes | EC Service URI
`hst` | Yes | Gateway URL - wss://{gateway-uri}/agent
`oa2` | Yes | OAuth URL for agent authentication
`cid` | Yes | OAuth client id
`csc` | Yes | OAuth client secret
`dur` | Yes | OAuth token expiry time in secs
`rht` | Yes | Remote host DNS name or IP range
`rpt` | Yes | Remore port for connectivity
`dbg` | No | Debugger. Default 'false'
`hca` | No | Agent health port number

```
./agent -mod server -aid {server-agent-id} \
-grp {agent-group} \
-cid {uaa-client-id} -csc {uaa-client-secret} -dur {oauth-token-dur} \
-oa2 https://{oauth-uri}/oauth/token \
-hst wss://{gateway-uri}/agent \
-sst https://{service-uri} \
-zon {ec-subscription-id} \
-rht {remote-host} -rpt {remote-port} -hca {agent-health-port} -dbg
```

Client example

Flag | Mandatory | Description
--- | --- | ---
`mod` | Yes | Agent mode - client
`aid` | Yes | Client agent id
`tid` | Yes | Server agent id
`grp` | Yes | Agent group which combines server and client agent id's
`hst` | Yes | Gateway URL - wss://{gateway-uri}/agent
`oa2` | Yes | OAuth URL for agent authentication
`cid` | Yes | OAuth client id
`csc` | Yes | OAuth client secret
`dur` | Yes | OAuth token expiry time in secs
`lpt` | Yes | Client agent running host port for connectivity from applications
`dbg` | No | Debugger. Default 'false'
`hca` | No | Agent health port number
`sts` | No | Status endpoint port. Only for agents later than 214
```
./agent -mod client -aid {client-agent-id} \
-tid {server-agent-id} \
-grp {agent-group} \
-cid {uaa-client-id} -csc {uaa-client-secret} -dur {oauth-token-dur} \
-oa2 https://{oauth-uri}/oauth/token \
-hst wss://{gateway-uri}/agent \
-lpt {local-port} -hca {agent-health-port} -dbg
```

#### VLAN

Virtual LAN will create a secure connection between source and multiple target systems by mirroring the target system details in source network settings. It means, one client agent can connect to multiple server agents with one EC connection. Client agent can decide to which target system it should make connection and will update network settings accordingly.

Please refer the below pages for EC connection with VLAN plugin based on EC Client agent host os - 

[linux](https://github.com/EC-Release/sdk/tree/v1/plugins/vln#vlan-plugin)

[windows](https://github.com/EC-Release/sdk/wiki/Windows-VLAN)


#### TLS


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
