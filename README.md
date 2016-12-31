# ec-sdk
The Enterprise-Connect SDK. We track down every single reported issue and are passionate in solving problems. Please leave your feedbacks/concerns [here](https://github.com/Enterprise-connect/ec-sdk/issues). You're encouraged to make a pull request.

[![GitHub version](https://badge.fury.io/gh/Enterprise-connect%2Fec-sdk.svg)](https://badge.fury.io/gh/Enterprise-connect%2Fec-sdk)

##Download
```
git clone --recursive https://github.com/Enterprise-connect/ec-sdk.git
```
##Documents
[EC Original docs](README.origin.md)

[EC Connectivity feature based on TLS/SSL Cert](README.cert.md)

[EC Predix Gateway service usage docs](README.predix.service.md)

[EC Agent Usage](README_ecagent.md)

##Contribution
The SDK examples were created in the open-source form with the vision of a greater private cloud and at the same time, making computer network more secure. The EC team recognises every indiviual's contribution and is actively looking for partners who share the same vision.

##Release History
###[v1.28_fukuoka](https://github.com/Enterprise-connect/ec-sdk/releases) current
 - Introducing the "Gateway" mode of EC Agent.
 - Add the Service URL as mandatory flag for the gateway.
 - Fix proxy settings. https://github.com/Enterprise-connect/ec-sdk/issues/7
 - Add session information for exceptions. https://github.com/Enterprise-connect/ec-sdk/issues/9
 - System stability updates. Prevent memory deadlock.
 - Improve IP Filter, supporting IPv4/IPv6 in CiDR Net.
 - Allow Loopback access.
 - Add token validation API from the EC Service.
 
###[more](https://github.com/Enterprise-connect/ec-sdk/releases)
