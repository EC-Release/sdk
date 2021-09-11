## Service 1.x

### How to run

Requirements -
1. Cloud foundry credentials
2. Service zone id
3. Admin hash
    Generate admin hash using following command(One time process)
    ```
    ./agent_linux_sys -hsh -pvk <PRIVATE_KEY> -pbk <PUBLIC_KEY>
    ```

Command to run -
```
#renewed script. Add docker credential may remediate the pull-limit but
# may not completely lift the limit.
docker run -e CF_USR=<cf-system-username> \
-e CF_PWD=<cf-system-pwd> \
-e ORG=<cf-service-org> \
-e SPACE=<cf-service-space> \
-e CF_API=<cf-api> \
-e DOCKER_USERNAME=<docker username> \
-e DOCKER_PASSWORD=<docker password> \
-e ZONE=<existing service zone-id> -it enterpriseconnect/service:v1beta

#deprecated
docker run -e CF_USR=<cf-system-username> \
-e CF_PWD=<cf-system-pwd> \
-e ORG=<cf-service-org> \
-e SPACE=<cf-service-space> \
-e CF_API=<cf-api> \
-e EC_PRVT_ADM=<admin-hash> \
-e ZONE=<existing service zone-id> -it enterpriseconnect/service:v1beta
```
