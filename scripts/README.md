# Agent Distributed Scripts Usage
### Agent Package
```bash
#install agent script via wget
#the script file format <revision>.<os arch>.txt. E.g. v1.1beta.linux64.txt
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/v1beta.linux64.txt)

#install a latest agent release script via wget
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/v1.linux64.txt)

#install agent script in MacOS
bash <(curl -k https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/agt/v1.darwin.txt)

```
### Cipher Usage
to be continue

### Plugin package
following the same format from the agent package
```bash
#install tls package
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/plg/tls/v1.linux64.txt)
#vln package
source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/plg/vln/v1.linux64.txt)
```

### Test Usage
Enable a internal performance test with the flag ```-test``` the script will running stress-test against both ```/health``` and ```/status``` http endpoints and submit a set of test data. Refer to [this working PR](https://github.com/EC-Release/sdk/pull/162#issuecomment-848739958)

```bash
# docker usage TBC
docker enterpriseconnect/agent -e test=true...

# binary usage TBC
```
