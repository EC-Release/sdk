# ec-sdk-buildpack

This repo was created to support building out the official EC SDK.

### Related products

Execute the buildpack will result in the following plugins/artifacts and will be checked-in in [the SDK](https://github.build.ge.com/Enterprise-Connect/ec-sdk) -

* TLS plugin: [bin](https://github.build.ge.com/Enterprise-Connect/ec-sdk/tree/beta/plugins/tls) | [source code](https://github.build.ge.com/212359746/tls-wzlib-plugin)
* VLAN plugin: [bin](https://github.build.ge.com/Enterprise-Connect/ec-sdk/tree/beta/plugins/vln) | [source code](https://github.build.ge.com/212359746/ipmod-wzlib-plugin)
* PTC Kepware/px-eventhub: [bin](https://github.build.ge.com/Enterprise-Connect/ec-sdk/tree/beta/plugins/kepware) | [source code](https://github.build.ge.com/212359746/kepware-wzlib-plugin)
* EC Agent: [bin](https://github.build.ge.com/Enterprise-Connect/ec-sdk/tree/beta/dist) | [source code](https://github.build.ge.com/Enterprise-Connect/ec-agent)

### Build an agent with the docker image

The [agent buildpack image](dtr.predix.io/dig-digiconnect/ec-agent-builder) conviniently includes all dependencies and components to build the EC-Agent-relate products. Please refer to [these steps to build a custom agent binary](https://github.build.ge.com/Enterprise-Connect/ec-agent#build)

### Setup a CI/CD pipeline by using this buildpack

This buildpack depends on the following environment variables-

* *REPO*: Internal EC-SDK Repo URL.	
* *BRANCH*: The SDK branch.	
* *PROXY_URL*: Proxy settings.
* *GITTOKEN*: github.build.ge.com user token for the internal SDK push.	 
*	*GITPUBTKN*: github.com user token for the SDK push. This includes the homebrew ruby formula. 	
* *DTRUSR*: A dtr.predix.io cred for images push. 	
* *DTRPWD*

*OR*

### If you are granted access to the digi-digiconnect org @dtr.predix.io, you may use the Digital-Foundry Jenkins to access all builds-

```shell
#enable docker gRPC API for DIND
dockerd -H 0.0.0.0:2375 -H unix:///var/run/docker.sock

#login into the DTR repo in Predix. This enables pull the image.
docker login dtr.predix.io -u <username> -p <password>

#launch the digital-foundry jenkins instance
docker run \
--rm \
--name digital_foundry \
--network=host
-e DOCKER_HOST=<this should resolve by your vm. E.g. 10.0.2.15. 127.0.0.1 when no vm> \
-e HTTPS_PROXY=${https_proxy} \
-e NO_PROXY=${no_proxy} \
-p 8080:8080 \
-v /var/run/docker.sock:/var/run/docker.sock \
dtr.predix.io/dig-digiconnect/digital-foundry:v1beta

#To persist the builds/logs, first let's make a backup
docker exec -u jenkins digital_foundry \
bash -c 'rm -Rf /var/backups/jenkins_home; cp -R /var/jenkins_home /var/backups/'

#secondly, commit the backup
docker commit digital_foundry dtr.predix.io/dig-digiconnect/digital-foundry:v1beta

#finally, push the commit. This step is needed in order to share the latest build information amongst other builders
docker push dtr.predix.io/dig-digiconnect/digital-foundry:v1beta
```

The Digital-Foundry self-provisioning Jenkins instance adopts the concept of DIND (Docker-in -Docker) which allows the EC/TC (tc-subscription series) software bundles be built anywhere with the docker-daemon installed. Since the DIND Jenkins instance requires the docker native API access via gRPC, developers would need to enable the local dockrd with the TCP access as it's specified above. You may consider [enable the API via systemctl refers to the official docker](https://docs.docker.com/install/linux/linux-postinstall/#configuring-remote-access-with-systemd-unit-file) for further usage.

If everything worked as expected, you may now browse the Jenkins instance locally at http://localhost:8080/job/EC/job/Core/job/EC-SDK-Build-Beta/ and VIEW the build detail. FYI ***annonymous users will need the DC Admin account to execute/modify jobs***. Please contact the team for the credential.

#### What to expect in the Digital-Foundry Jenkins

The instance contains the following builds-
##### Enterprise-Connect
* [SDK](https://github.build.ge.com/Enterprise-Connect/ec-sdk)
* [Agent](https://github.build.ge.com/Enterprise-Connect/ec-agent)
* [Single-Tenance Service](https://github.build.ge.com/Enterprise-Connect/ec-service)
* [CF Broker](https://github.build.ge.com/Enterprise-Connect/ec-predix-service-broker)
* Test Automation

##### Thread-Connect
* [xcalr CA/Subscription API](https://github.build.ge.com/Thread-Connect/tc-xcaler)
* [tc-proxy nifi registry](https://github.build.ge.com/Thread-Connect/tc-proxy)
* [CF Broker](https://github.build.ge.com/Thread-Connect/tc-broker)






