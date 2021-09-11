## Service 1.x

### How to run

Requirements -
1. Cloud foundry credentials
2. Cloud foundry Service zone id
3. docker.io credential

Command to run -
```shell
#renewed script. Adding docker credential may remediate the pull-limit but
# shall not completely lift the limit due to the docker account type.
docker run -e CF_USR=<cf-system-username> \
-e CF_PWD=<cf-system-pwd> \
-e ORG=<cf-service-org> \
-e SPACE=<cf-service-space> \
-e CF_API=<cf-api> \
-e DOCKER_USERNAME=<docker username> \
-e CF_DOCKER_PASSWORD=<docker password> \
-e GITHUB_TOKEN=<github token to access cred repos> \
-e IMAGE_TAG=<oci image tag used for the instance> \
-e ZONE=<existing service zone-id> -it enterpriseconnect/service:v1

#deprecated
docker run -e CF_USR=<cf-system-username> \
-e CF_PWD=<cf-system-pwd> \
-e ORG=<cf-service-org> \
-e SPACE=<cf-service-space> \
-e CF_API=<cf-api> \
-e EC_PRVT_ADM=<admin-hash> \
-e ZONE=<existing service zone-id> -it enterpriseconnect/service:v1beta
```
