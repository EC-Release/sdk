# ec-server-daemon
Downloads | Build Status
--- | ---
[EC SDK](https://github.com/Enterprise-connect/ec-sdk) | <a href='https://predix1.jenkins.build.ge.com/job/Enterprise-Connect/EC Server Daemon CLI'><img src='https://predix1.jenkins.build.ge.com/buildStatus/icon?job=Enterprise-Connect/EC Server Daemon CLI'></a>

 - Enterprise-Connect Client Daemon/CLI

$ ./ecclient -h
Usage of ./ecclient:
  -file string
     EC Client settings.json file path. (default "./settings.json")
  -ver
     Show EC Client version.
  -mem int
     Specify listening port# for the health check request.
  -cid string
     Specify client id for auto-refresh the OAuth2 token.
  -csc string
     Specify client secret for auto-refresh the OAuth2 token.
  -tkn string
     Specify refresh-token for the OAuth2 provider.
