# Agent DB Usage

## made for experts with agent CLI

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

# step 6 get data
agent -ivk -url https://<agent api instance>/v1.2beta/<api app nanme>/<db key> \
-cid <dev/cert id> -tkn <the bearer token from step 3>

```

### Admin Hash
You may be prompted to type your passphrase associated with your certificate in stdin. To avoid the passphrase prompt in an environment one like CI, you may generate the admin hash following the command below-

```bash
agent -hsh -pbk <your signed certificate in base64> -pvk <private key pair matches the certificate> <-smp>
```

Once the admin hash generated, you may follow the command below to generate a usable hash to avoid the stdin prompt

```bash
EC_PPS=<admin hash generated from the above> agent -hsh <-smp>
```

The admin hash expires in 90 days, as apposed to the regular hash in 20 mins.

### For Docker Users
Please follow [the database instruction here](https://github.com/EC-Release/oci/tree/v1.2beta_api_oci_spec#agent-api-db-usage-for-docker-users)
