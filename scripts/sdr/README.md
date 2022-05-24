# Agent API Usage
made for experts with agent CLI

## API Configuration
See detail in [the config file for API mode](https://github.com/EC-Release/sdk/blob/disty/scripts/api/conf/api.yaml#L1)

## DB Ops Usage
### agent binary installation
some [installation reference here](https://github.com/EC-Release/sdk/blob/disty/scripts/README.md#agent-package)

```bash
# step 1 generate hash
agent -hsh

# step 2 get bearer token
agent -gtk -oa2 https://<agent oauth2 instance>/oauth/token -cid <dev/cert id> <-smp>

# step 3 get all data key
agent -ivk -url https://<agent api instance>/v1.2beta/<api app nanme> \
-cid <dev/cert id> -tkn <the bearer token from step 2>

# step 4 post data
agent -ivk -url https://<agent api instance>/v1.2beta/<api app nanme>/<db key> \
-cid <dev/cert id> -tkn <the bearer token from step 2> \
-mtd POST
-dat '{"hello":"world"}'

# step 5 get data
agent -ivk -url https://<agent api instance>/v1.2beta/<api app nanme>/<db key> \
-cid <dev/cert id> -tkn <the bearer token from step 3>
```
## Hash Types
### Owner's Hash
Owner's hashes are designed to bypass an agent runtime security checker. An owner's hash expires in 90 days and may only be purposed for generating admin hashes.

```bash
agent -hsh -pbk <your signed certificate in base64> \
-pvk <private key pair matches the certificate> <-smp> \
<-dat: optional the secret in plaintext>
```
A cert owner may use the keypair to generate an owner's hash when a given secret ```-dat``` is present. This is particularily useful to decrypt a release binary in a ci environment.

### Admin Hash
From time to time, users may experience a passphrase prompt associated for licensing. To avoid a passphrase input prompt in an environment one like CI, user may also generate the admin hash by following the command below-

```bash
# "EC_PPS" variable is optional if bypassing the stdin prompt is not required.
EC_PPS=<owner's hash> agent -hsh <-smp>
```

The admin hash generally expires in 20 mins and is used for bypassing a passphrase prompt by the EC cryptography system.

### Passphrase Hash
Agents use Passphrase Hashes for intra-communication purposes. For security measure, the life-cycle of this type of hash is In-Process only. 


## For Docker Users
follow [the database instruction here](https://github.com/EC-Release/oci/tree/v1.2beta_api_oci_spec#agent-api-db-usage-for-docker-users)
