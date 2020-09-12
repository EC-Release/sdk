# Distributing Scripts Usage
### Agent Package
```bash
#the script works only with /bin/bash
#the script file format <revision>.<os arch>.txt. E.g. v1.1beta.linux64.txt
source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1.1beta.linux64.txt)

#download the whole agent <v1> package
source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1.linux64_pkg.txt)

#download agent package via darwin
source <(curl -s https://ec-release.github.io/sdk/scripts/agt/v1.1beta.darwin.txt)

```
### Cipher Usage
to be continue

### Plugin package
following the same format from the agent package
```bash
#install tls package
source <(wget -O - https://ec-release.github.io/sdk/scripts/plg/tls/v1.linux64.txt)
#vln package
source <(wget -O - https://ec-release.github.io/sdk/scripts/plg/vln/v1.linux64.txt)
```
