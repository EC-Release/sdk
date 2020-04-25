[![Build Status](https://travis-ci.com/Enterprise-connect/build.svg?branch=v1.1beta)](https://travis-ci.com/Enterprise-connect/build)

# The EC Agent SDK
The Enterprise-Connect SDK Repo.
- [Design](https://github.com/Enterprise-connect/sdk/wiki/EC-Agent)
- [Issue trackers](https://github.com/Enterprise-connect/sdk/issues)
- [Features/Projects](https://github.com/Enterprise-connect/sdk/projects)
- [Usage](https://github.com/Enterprise-connect/sdk/wiki)
- [Load-Balancer](https://github.com/Enterprise-connect/sdk/issues/89)
- [OCI images usage](https://hub.docker.com/r/enterpriseconnect/agent)

## Dependency Matrix
Mode | Avaialble Releases | CF Service | Docker | OAuth | Watcher | Daemon
--- | --- | --- | --- | --- | --- | ---
Client | v1,v1beta | Required | Optional | UAA | Not Supported | Not Supported
Client | v1.1,v1.1beta | Required | Optional | UAA | Supported | Supported
Gateway | v1,v1beta | Required | Optional | Not Required | Not Supported | Not Supported
Gateway | v1.1,v1.1beta | Required | Optional | Not Required | Supported | Supported
Server | v1,v1beta | Required | Optional | UAA | Not Supported | Not Supported
Server | v1.1,v1.1beta | Required | Optional | UAA | supported | Supported
GW:Client | v1,v1beta | Required | Optional | Not Required | Not Supported | Not Supported
GW:Client | v1.1,v1.1beta | Required | Optional | Not Required | Supported | Supported
GW:Server | v1,v1beta | Required | Optional | Not Required | Not Supported | Not Supported
GW:Server | v1.1,v1.1beta | Required | Optional | Not Required | Supported | Supported
X:Client | v1.1,v1.1beta | Not Required | Optional | OAuth2 Mode | Supported | Supported
X:Server | v1.1,v1.1beta | Not Required | Optional | OAuth2 Mode | Supported | Supported
X:Gateway | v1.1,v1.1beta | Not Required | Optional | OAuth2 Mode | Supported | Supported
API | v1.1,v1.1beta | Not Required | Optional | OAuth2 Mode | Supported | Supported
OAuth2 | v1.1,v1.1beta | Not Required | Optional | OIDC | Supported | Supported

## Revision Matrix
Rev. | Env | Download/Release | CF Service | CF Broker | SDK/Plugins | Tools | Build | QA
--- | --- | --- | --- | --- | --- | --- | --- | ---
v1.1 | Azure/AWS/CF | [edo.0](https://github.com/Enterprise-connect/sdk/tree/v1.1.edo.0/dist/agent)<br /><sup>[Release Note](https://github.com/Enterprise-connect/sdk/releases/tag/v1.1.edo.0) </sup>| not required | not required | deferred | daemon | [Travis-CI](https://travis-ci.com/github/Enterprise-connect/build) | [Integration](https://travis-ci.com/github/Enterprise-connect/qa)
v1.1beta | Azure/AWS/CF | [fukuoka.2730](https://github.com/Enterprise-connect/sdk/tree/v1.1beta.fukuoka2730/dist/agent)<br /><sup>[Release Note](https://github.com/Enterprise-connect/sdk/releases/tag/v1.1beta.fukuako.2730) </sup>| not required | not required | deferred | daemon | [Travis-CI](https://travis-ci.com/github/Enterprise-connect/build) | [Integration](https://travis-ci.com/github/Enterprise-connect/qa)
v1 | AWS/CF/GovCloud | [hokkaido.212](https://github.com/Enterprise-connect/ec-x-sdk/tree/v1.hokkaido.212/dist)<br /><sup>[Release Note](https://github.com/Enterprise-connect/ec-x-sdk/releases/tag/v1.hokkaido.212)</sup> | kyushu.145 [project access](https://github.build.ge.com/Enterprise-Connect/ec-service/tree/v1.kyushu.145) | okinawa.8 [[project access]](https://github.build.ge.com/Enterprise-Connect/ec-predix-service-broker/tree/v1.okinawa.8) | [v1.hokkaido.212](https://github.com/Enterprise-connect/ec-x-sdk/tree/v1.hokkaido.212/plugins) | [Cloud Foundry Only](https://i.ci.build.ge.com/rtc5ryln/ci/job/Enterprise-Connect/job/EC%20Phase%20II%20Automation/) | [Gitlab-CI](https://gitlab.com/digital-fo/connectivity/enterprise-connect/platform-agnostic/agent/pipelines) | [Integration](http://localhost:8080/job/EC/job/QA/)
v1beta | AWS/CF | [fukuoka.1724](https://github.com/Enterprise-connect/ec-x-sdk/tree/v1beta.fukuoka.1724/dist)<br /><sup>[Release Note](https://github.com/Enterprise-connect/ec-x-sdk/releases/tag/v1beta.fukuoka.1724)</sup> | sendai.1079 [[project access]](https://github.build.ge.com/Enterprise-Connect/ec-service/tree/v1beta.sendai.1079) | okayama.49 [[project access]](https://github.build.ge.com/Enterprise-Connect/ec-predix-service-broker/tree/v1beta.okayama.49) | [v1beta.fukuoka.1724](https://github.com/Enterprise-connect/ec-x-sdk/tree/v1beta.fukuoka.1724/plugins) | xcalrii@[v2beta.detroit.80](http://xcalr.apps.ge.com/v2beta/swagger-ui.html) | [Gitlab-CI](https://gitlab.com/digital-fo/connectivity/enterprise-connect/platform-agnostic/agent/pipelines) | [Integration](http://localhost:8080/job/EC/job/QA/)

## x509 Certificates, RSA keypair, licensing, security
Please contact ec-research@ge.com for detais.

## Validation
```
## Verify the checksum
### Linux
```bash
$ sha256 ./path/to/file/ecagent_linux_sys
b3bf9cd9686e
$ awk 's=index($0,"b3bf9cd9686e") { print "line=" NR, "start position=" s}' checksum.txt
line=2 start position=1
```
### Mac OS
```
$ shasum -a 256 ./path/to/file/ecagent_linux_sys
b3bf9cd9686e
$ awk 's=index($0,"b3bf9cd9686e") { print "line=" NR, "start position=" s}' checksum.txt
line=2 start position=1
```
### Windows
```bash
c: \> CertUtil -hashfile C:\path\to\file\ecagent_windows.exe sha256
b3bf9cd9686e (find the checksum in the checksum.txt)
```

## Release History
Please verify the [Release History](https://github.com/Enterprise-connect/sdk/releases) for previous releases.
