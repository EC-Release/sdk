[![Build Status](https://travis-ci.com/EC-Release/build.svg?branch=v1.1)](https://travis-ci.com/EC-Release/build)

# The Agent SDK
The Enterprise-Connect SDK Repo.
- [Design](https://github.com/EC-Release/sdk/wiki/EC-Agent)
- [Issue trackers](https://github.com/EC-Release/sdk/issues)
- [Features/Projects](https://github.com/EC-Release/sdk/projects)
- [Usage](https://github.com/EC-Release/sdk/wiki)
- [Load-Balancer](https://github.com/EC-Release/sdk/issues/89)
- [OCI images usage](https://hub.docker.com/r/enterpriseconnect/agent)

## Dependency Matrix
Mode | Avaialble Releases | CF Service | Docker | OAuth | Watcher | Daemon
--- | --- | --- | --- | --- | --- | ---
Client | v1, v1beta | Required | Optional | UAA | Not Supported | Not Supported
Gateway | v1, v1beta | Required | Optional | Not Required | Not Supported | Not Supported
Server | v1, v1beta | Required | Optional | UAA | Not Supported | Not Supported
GW:Client | v1, v1beta | Required | Optional | Not Required | Not Supported | Not Supported
GW:Client | v1.1beta, v1.2beta | Not Required | Optional | Not Required | Supported | Supported
GW:Server | v1,v1beta | Required | Optional | Not Required | Not Supported | Not Supported
GW:Server | v1.1beta, v1.2beta | Not Required | Optional | Not Required | Supported | Supported
X:Client | v1.1beta, v1.2beta | Not Required | Optional | Service 2.x Mode | Supported | Supported
X:Server | v1.1beta, v1.2beta | Not Required | Optional | Service 2.x Mode | Supported | Supported
X:Gateway | v1.1beta, v1.2beta | Not Required | Optional | Service 2.x Mode | Supported | Supported
API | v1.1beta, v1.2beta | Not Required | Optional | Service 2.x Mode | Supported | Supported
Service 2.x | v1.1,v1.1beta | Not Required | Optional | OIDC | Supported | Supported

## Revision Matrix
Rev. | Download/Release | CF Instance | CF Service | CF Broker | SDK/Plugins | Tools | Build | QA
--- | --- | --- | --- | --- | --- | --- | --- | ---
v1.1beta | [fukuoka.2737](https://github.com/EC-Release/sdk/tree/v1.1beta.fukuoka.2737/dist/agent)<br /><sup>[Release Note](https://github.com/EC-Release/sdk/releases/tag/v1.1beta.fukuako.2737) </sup> | deferred | Optional | Optional | deferred | daemon | [Travis-CI](https://travis-ci.com/github/EC-Release/build) | [Integration](https://travis-ci.com/github/EC-Release/qa)
v1.2beta | [reiwa.0](https://github.com/EC-Release/sdk/tree/v1.2beta.reiwa.0/dist/agent)<br /><sup>[Release Note](https://github.com/EC-Release/sdk/releases/tag/v1.2beta.reiwa.0) </sup> | deferred | Optional | Optional | deferred | daemon | [Travis-CI](https://travis-ci.com/github/EC-Release/build) | [Integration](https://travis-ci.com/github/EC-Release/qa)
v1 | [hokkaido.212](https://github.com/EC-Release/sdk/tree/v1.hokkaido.212/dist)<br /><sup>[Release Note](https://github.com/EC-Release/sdk/releases/tag/v1.hokkaido.212)</sup> | Predix CF1, GovCloud, Frankfurt | kyushu.145 [project access](https://github.build.ge.com/EC-Release/ec-service/tree/v1.kyushu.145) | okinawa.8 [[project access]](https://github.build.ge.com/EC-Release/ec-predix-service-broker/tree/v1.okinawa.8) | [v1.hokkaido.212](https://github.com/EC-Release/sdk/tree/v1.hokkaido.212/plugins) | [Cloud Foundry Only](https://i.ci.build.ge.com/rtc5ryln/ci/job/EC-Release/job/EC%20Phase%20II%20Automation/) | [Gitlab-CI](https://gitlab.com/digital-fo/connectivity/EC-Release/platform-agnostic/agent/pipelines) | [Integration](http://localhost:8080/job/EC/job/QA/)
v1beta | [fukuoka.1725](https://github.com/EC-Release/sdk/tree/v1beta.fukuoka.1725/dist)<br /><sup>[Release Note](https://github.com/EC-Release/sdk/releases/tag/v1beta.fukuoka.1724)</sup> | Predix CF3 | sendai.1079 [[project access]](https://github.build.ge.com/EC-Release/ec-service/tree/v1beta.sendai.1079) | okayama.49 [[project access]](https://github.build.ge.com/EC-Release/ec-predix-service-broker/tree/v1beta.okayama.49) | [v1beta.fukuoka.1725](https://github.com/EC-Release/sdk/tree/v1beta.fukuoka.1725/plugins) | xcalrii@[v2beta.detroit.80](http://xcalr.apps.ge.com/v2beta/swagger-ui.html) | [Gitlab-CI](https://gitlab.com/digital-fo/connectivity/EC-Release/platform-agnostic/agent/pipelines) | [Integration](http://localhost:8080/job/EC/job/QA/)

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
Please verify the [Release History](https://github.com/EC-Release/sdk/releases) for previous releases.

## Be Social with the team
* [Slack Usergroup Channel](https://enterprisecon-j2w6229.slack.com)
* [Weekly Google Meeting](https://meet.google.com/xum-iykj-agp)

## Disclaimer
<sup>Predix, Cloud Foundry, and all subsidiary software products are the DT/RT copyrights all rights reserved by **GE Digital LLC**. EC Cloud Foundry Service (including the CF Broker) are the products owned by **GE Corp**, currently maintained by Enterprise-Connect R&D Team. Components that DO NOT associate with Predix, Cloud Foundry, are all under the **MIT license**, and actively developed and being authored by the **Enterprise Connect R&D team**. The team (Enterprise Connect R&D Team) is sponsored by **GE Corp**. Enterprise Connect R&D Team CA is the highest Certificate Authority of its security ECO system, under its own terms.</sup>
