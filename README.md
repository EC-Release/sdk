# ec-sdk
The Enterprise-Connect SDK. [Visit the wiki to get familiar with EC](https://github.com/Enterprise-connect/ec-sdk/wiki). We track down every single reported issue and are passionate in solving problems. Please leave your feedbacks/concerns [here](https://github.com/Enterprise-connect/ec-sdk/issues). You're encouraged to make a pull request.

[![GitHub version](https://badge.fury.io/gh/Enterprise-connect%2Fec-sdk.svg)](https://badge.fury.io/gh/Enterprise-connect%2Fec-sdk)
[![Hex.pm](https://img.shields.io/hexpm/l/plug.svg)](https://github.com/Enterprise-connect/ec-sdk)
[![Travis branch](https://img.shields.io/travis/rust-lang/rust/master.svg)](https://travis-ci.org/)

## Download
```bash
git clone --recursive https://github.com/Enterprise-connect/ec-sdk.git
```

## Agent usage
```bash
tar -xvzf ./path/to/ec-sdk/dist/ecagent_linux_sys.tar.gz
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

## Contribution
The SDK examples were created in the open-source form with the vision of a greater private cloud and at the same time, making computer network more secure. The EC team recognises every indiviual's contribution and is actively looking for partners who share the same vision.

## Credits
- [Springboot sample app](https://github.com/Enterprise-connect/ec-springboot-II/tree/master) by [avnsri4986](https://github.com/avnsri4986)
- [Python3+ sample app/lib](https://github.com/Enterprise-connect/ec-python3) by [avnsri4986](https://github.com/avnsri4986)

## Release History
### [v1.2.90_fukuoka](https://github.com/Enterprise-connect/ec-sdk/releases) current
- Introducing the "Gateway" mode of EC Agent.
- Add the Service URL as mandatory flag for the gateway.
- Fix proxy settings. https://github.com/Enterprise-connect/ec-sdk/issues/7
- Add session information for exceptions. https://github.com/Enterprise-connect/ec-sdk/issues/9
- System stability updates. Prevent memory deadlock.
- Improve IP Filter, supporting IPv4/IPv6 in CiDR Net.
- Allow Loopback access.
- Add token validation API from the EC Service.
- Add Usage reporting. usage calculation.
- Add health port listener.
- Some bug fixes. https://github.com/Enterprise-connect/ec-sdk/issues/14
- Docs clean up.
- Super Connection Auto-Reconnect.
- Add Debug mode.
- Add feature option to generating/submitting a CSR.
 
[more](https://github.com/Enterprise-connect/ec-sdk/releases)
