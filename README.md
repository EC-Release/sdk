# ec-x-sdk
The Enterprise-Connect Ultimate SDK Repo. [Visit the wiki to get familiar with EC](https://github.com/Enterprise-connect/ec-sdk/wiki). We track down every issue possible and are passionate in solving problems. Please leave your feedback/concerns [here](https://github.com/Enterprise-connect/ec-x-sdk/issues). Developers are encouraged to submit PRs.

[![GitHub version](https://badge.fury.io/gh/Enterprise-connect%2Fec-sdk.svg)](https://badge.fury.io/gh/Enterprise-connect%2Fec-sdk)
[![Hex.pm](https://img.shields.io/hexpm/l/plug.svg)](https://github.com/Enterprise-connect/ec-sdk)
[![Travis branch](https://img.shields.io/travis/rust-lang/rust/master.svg)](https://travis-ci.org/)
## Vision
At EC Agent, as developers/contributors, we believe that-
 * Computer network should always be within our reach, and operated beyond political boundries.
 * No users be asked to give away privacy in exchange for information.
 * No ones should govern people's privacy, work, or devices, other than themselves.
 * There should not exist the best practice, but rather always better practices.
## Credits
- [NodeJS postgres example](https://github.com/Enterprise-connect/cf-sample-node-app-to-on-prem-postgres) by [Philip Wofford](https://github.com/philipwofford)
- [Cloud Foundry deployment example](https://github.com/Enterprise-connect/ec-agent-cf-push-sample) by [Philip Wofford](https://github.com/philipwofford)
- [Go library example](https://github.com/Enterprise-connect/ec-vars-loading-example-go) by [Paul Stuart](https://github.com/paulstuart)
- [Springboot sample app](https://github.com/Enterprise-connect/ec-springboot-II/tree/master) by [avnsri4986](https://github.com/avnsri4986)
- [Python3+ sample app/lib](https://github.com/Enterprise-connect/ec-python3) by [avnsri4986](https://github.com/avnsri4986)
- [Microsoft .NET framework](https://github.com/Enterprise-connect/ec-dotnet-sample-I) by [Aberto Gorni](https://github.com/gorniAbertoGeDigital)
## Contribution Policy
The SDK were created in the open-source form with the vision of a greater private cloud and at the same time, making computer network more secure. This repo is built/maintained only by developers/pratners [who share the same vision](https://github.com/Enterprise-connect/ec-x-sdk/blob/v1beta/README.md#vision). Any updates without a PR review by the authors will be overridden by the X-Robot, a Digital-Founry CI Autobot.

## Usage

Please refer to [the official usage document](https://github.com/Enterprise-connect/documentation), as well as our [modes guide](./ec-modes.md), to get familiar with how a typical script is configured for all available EC agent modes.

## System Requirement
### Hardware
- 15Mb system storage memory
- 32Mb DRAM.

### Instruction/OS
- Sun/Oracle Solaris SPARC64
- ARM32/64.(Raspian, Symbian)
-  Windows 32/64
- Android.
- iOS.
- Linux 32/64.
- Mac OS X (Darwin)

### Load Balancing (Optional)
- [Cloud Foundry Diego Cell](https://docs.cloudfoundry.org/concepts/diego/diego-architecture.html)

## Build a Binary
- **[The internal instruction available here](https://github.build.ge.com/Enterprise-Connect/ec-agent)** entails the building process for the agent binary in this sdk.

## Download & Run
```bash
wget https://github.com/Enterprise-connect/ec-x-sdk/blob/v1beta.fukuoka.1665/dist/ecagent_linux_sys.tar.gz && \
tar -xvzf ecagent_linux_sys.tar.gz && \
ecagent_linux_sys -ver
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
## Homebrew installation (experiment)
- This will install the agent binary as well as setup your local Dev environment
```bash
 $ brew install ecagent
 ```

## Release History
Please verify the [Release History](https://github.com/Enterprise-connect/ec-sdk/releases) for previous releases.
