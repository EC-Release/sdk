# Enterprise Connect (EC) Developer Guide

### Contents

Table of contents to EC developer guide (self managed subscriptions) - 

- Introduction
- Components
  - EC Service
  - EC Agent
- Security
- How to subscribe to EC Service
  - Prerequisites - Subscribe to UAA
  - Create EC Service
  - Add EC Scopes to UAA (Please refer GE Digital documentation)
- Traditional EC Connection
- Connecting to multiple targets(VLAN) -
  - Linux clients
  - Windows clients
- Connecting to APIs(TLS)
- Fuse mode
- Deployment options
  - Cloud Foundry
  - EKS/AKS
  - Binary process
- Trobleshooting tips
  - Common issues
  - Health page
   

# Contents

**Enterprise Connect (EC) Developer Guide:**

# Introduction:

Enterprise Connect is a service that enables you to establish a secure and scalable connection between any cloud environment and your enterprise resources. As a service, it connects any two networks governed by different transmission protocols. Data passes through Enterprise Connect before getting routed to its destination. The EC service, which is currently built on Cloud Foundry, is a single tenant, self-contained microservice.

The service could be employed for a host of functions that include usage reporting and monitoring, system performance, security validation, managing accounts, etc.

# Components of Enterprise Connect:

Enterprise Connect service has two components, namely the EC Service and the EC Agent.

## EC Service:

Enterprise Connect (EC) is a microservice that has multiple components. It constitutes a client, a server, and a gateway. The data passes through the EC service through TCP (Transmission Control Protocol).

## EC Agent:

Both the EC client and the EC server act as agents in the Enterprise Connect (EC) service. The EC client and server, though agents, have the ability to act as a gateway also. The EC Client appears on the side of the source system (a client application) and the EC Server appears on the side of the target system (a database).

# Ensuring Security of the Enterprise Connect: (Security)

If we closely observe the Enterprise Connect service, on the one hand, we have a database (a target system) and the EC server agent running next to the target system. On the other hand, we have the EC client agent running next to the client application that could either be a web UI or SQL developer. Since the applications and agents (both client and server) are running in the same environment, there is no need for any secure connection and the TCP protocol is enough to serve the purpose.

Secure connectivity is required when communication happens between the client agent and the server agent because they run on different networks and a handshake needs to happen in a secure environment. And, midway, we even have the EC gateway running, which could either be a Predix Cloud Foundry, an AWS EKS environment, or even an Azure network. That means the client agent, the gateway, and the server agent are all running on different networks.

Here, the client communicates with the gateway, and the gateway, in turn, communicates with the server. The agents and the gateway communicate with each other through a secure channel (HTTPS). The responsibility of converting the data traffic from TCP to HTTPS and vice versa is taken care of by client and server agents.

**TLS plugin:**

You require a TLS plugin when you want to make an API call to a data source from a server agent. Normally, the TLS plugin is installed along with the server agent. The server agent, which is enabled with the TLS plugin, can communicate with the network resource by making an API call through a secure channel.

The Enterprise Connect service, as it provides secure connectivity between any two discrete networks, implements industry-standard security protocols. It makes the handshake secure through protocols such as OAuth2, IPv4/IPv6 CIDR whitelist/blocklist filtering, Cloud Foundry ZONE-Id validation, etc. The service is also equipped with the ability to issue/validate two-way TLS/SSL certificates.

Security needs to be ensured in different ways. For example, there is a need to validate whether a particular server is the right one to get the EC connection. This can be ensured through Oath2.

If you want to use a server agent, you need to provide the URL of the authentication service so that the service knows that it is likely to receive a request from an agent for authentication. And the Predix UAA supplies the Client ID and Client Secret to the EC service. Therefore, authentication happens through the Client ID and Secret.

[https://github.com/EC-Release/sdk/tree/v1/plugins/tls](https://github.com/EC-Release/sdk/tree/v1/plugins/tls)

[https://github.com/EC-Release/sdk/wiki/Security-(Agent)](https://github.com/EC-Release/sdk/wiki/Security-(Agent))

# How to subscribe to EC Service?

Enterprise Connect (EC) is a microservice offered as part of the Predix environment. To use the service, you need to subscribe to the Predix User Account and Authentication (UAA) service to become a trusted user. You can either use the UAA dashboard or the Cloud Foundry command line interface (CLI) to create and configure your service.

# Prerequisites for Subscribing to UAA:

In order to subscribe to the Enterprise Connect service, you need to meet some prerequisites. They are:

- An active account in predix.io
- Cloud Foundry CLI installed

## Create EC Service:

First, you need to create the Enterprise Connect service. Here are the steps involved in the creation of the EC service.

**Configure your proxy settings if necessary.**

If the traffic between your corporate network and the internet is monitored, access to some tools/applications may be blocked by the proxy. Therefore, you will need to configure your proxy settings to access remote resources such as Enterprise Connect. The values for your proxy settings may vary based on your location and network configuration. Therefore, you may please contact your IT administrator for the correct proxy settings.

**Create a UAA Service Instance**

You can create multiple instances of the UAA service in your space.

However, it is a best practice to delete any older and unused UAA service instances before creating a new instance.

Steps to create a new service instance:

- Sign into your Predix account at [https://www.predix.io](https://www.predix.io/)
- Navigate to Catalog \&gt; Services, then click the User Account and Authentication tile
- Click **Subscribe** on the required plan
- Complete the fields on the New Service Instance page
- Click Create Service

**Note:** To know more about the creation of a UAA service instance, please visit the below-mentioned page:

[https://www.ge.com/digital/documentation/edge-software/t\_creating\_predix\_uaa\_instance.html#task\_y1l\_vms\_2s](https://www.ge.com/digital/documentation/edge-software/t_creating_predix_uaa_instance.html#task_y1l_vms_2s)

**Binding an Application to the UAA Instance**

Applications that run in the Cloud Foundry environment gain access to bound service (a server in a client-server interface) instances through the credentials stored in VCAP\_SERVICES. Therefore, the next step involves binding your application to your UAA instance through the VCAP\_SERVICES.

In the below diagram, we have a client application running on the network, and the application wants to access a network resource that could be a database, an SFDC server, or could even be an API service provider. If we want to access the resource from the client application, we need to install some agents, like the Server Agent on the side of the network resource, so that it can access the resource over the TCP protocol. Thereafter, it will translate the traffic over TCP into HTTPS and then the data will be sent to the Client Agent via the EC gateway, from where it will be accessed by the client application.

Add EC Scopes to UAA:

Whether it is a client agent or a server agent, before using the Enterprise Connect (EC) service, it needs to get authenticated by a UAA (User Account and Authentication) service.

To get the authentication done, you must have the OAuth 2.0 service provider in place.

In the Enterprise Connect service, we use Predix UAA as an authentication service provided by the Cloud Foundry environment. The EC service is already registered with the Predix UAA service. Even if you want to use a service other than the Predix UAA, such as AWS Cognito, you need to get the EC application registered with the service provider you want to use.

When you want to start either the Client Agent or the Server Agent, validation is the first thing that happens. In the event of a validation failure, the service will quit immediately as the agents are not authorised to use the EC service.

# Traditional EC Connection:

In the traditional mode, you have three components, namely EC Client, EC Server, and EC Gateway that constitute the Enterprise Connect (EC) service. This arrangement ensures connectivity when you have multiple clients and servers and there is a need to be connected through a gateway.

# Connecting to multiple targets (VLAN)

A VLAN is a plugin that is helpful in connecting to multiple target systems.

If you want to connect to more than one target system (multiple databases), but don&#39;t want to use multiple agents, you are required to deploy a VLAN plugin. The VLAN plugin empowers the EC service to communicate with multiple target systems with the help of just a single server agent and a single client agent. The plugin could be deployed on both Linux and Windows.

**Note:** The target system may include a MySQL database, an SFDC server, an Oracle database, or even a secure API.

## Linux clients

When you deploy a VLAN plugin in a Linux environment, you must run the EC client only on a Linux machine, irrespective of where your server agent and gateway are running. The EC client is configured with VLAN and TLS.

The Linux machine should understand to which IP or port number it should connect.

Normally, when you want to make an EC connection, your client application communicates with the client agent. And the client agent, in turn, establishes a secure connection with the server agent via the gateway.

However, in VLAN mode, the client application must use the IP address of the target system instead of the IP address of the client agent machine. As you have already added the IP addresses of the target systems to the local loopback adapter, the Linux system knows with which target system it needs to establish the connection.

So, the Linux machine already has the capability of spotting where the target machine is. The request passes through the client, the EC gateway, and the server agent. And the EC server gets the information from the client application as to which IP address it wants to connect to.

## Windows clients

When you deploy the VLAN plugin along with Linux, the EC client runs on a Linux machine. In the same way, when VLAN is deployed on Windows, the EC client runs on a Windows machine. And the EC server communicates with multiple databases such as Oracle, SQL Server, MySQL, SFTP, etc.

The Linux client can communicate with the network adapter system (local loopback adapter) to add the IP addresses of the target machines through a **plugins.yml** file. However, Windows does not carry such a facility. As Windows does not allow the agent to communicate with the network adapter system, you need to create a network adapter and add the IP addresses to the adapter manually. The rest of the things happen in the same manner as they happen in the Linux system.

## Steps to run VLAN client in windows

**Run EC server**

Run the EC server agent as given below

./agent -mod server -aid agent-id -grp group-name

-cid uaa-client-id -csc uaa-client-secret -dur 3000

-oa2 https://valid-uaa-url/oauth/token

-hst wss://valid-gateway-url/agent

-sst https://valid-ec-service-url/v1beta -zon valid-zone-id

-rht localhost -rpt 5432 -rpt 3306 -rpt 1521 -dbg -vln

**Install local loopback adapters in windows**

- Right-click on the Windows start menu icon and select Device Manager.
- Click on the system name and, thereafter, click the Action menu to select &quot;Add legacy hardware.&quot;
- Click Next on the welcome screen.
- Choose &quot;Install the hardware that I manually select from a list&quot; and click on Next.
- Scroll down and select Network Adapters from the offered common hardware types and click on Next.
- Select Microsoft as the manufacturer, and then select the Microsoft KM-TEST Loopback adapter card model and click on Next.
- Click Next.
- Click on Finish.

**Add target system IP addresses to local loopback adapter**

- Go to &quot;Network Connections&quot; via the control panel.
- Open Properties for the newly created adapter by right clicking on it.
- Select &quot;Internet Protocol Version 4 (TCP/IPv4)&quot; and click on properties.
- Select &quot;Use the following IP address&quot; and enter one of the target system&#39;s IP addresses.
- Press the tab to get the &quot;Subnet mask&quot; and &quot;Default gateway&quot; filled automatically.
- Click on &quot;Advanced&quot; and add all target system IP addresses in the &quot;IP Settings/IP Addresses&quot; section.
- To have the &quot;Subnet mask&quot; filled automatically based on the IP address, press Tab.

**Run EC client in windows**

agent\_windows\_sys.exe -mod client

-aid client-agent-id -tid target-agent-id -grp group-name

-zon valid-zone-id -sst https://valid-ec-service-url/v1beta

-hst wss://valid-gateway-url/agent

-cid uaa-client-id -csc uaa-client-secreat

-oa2 https://valid-oauth2-url/oauth/token

-dur 1200 -hca 6006 -lpt 6192 -rpt 5432,3306,1521 -dbg -vln

**Test the connection**

- Use target system IP and port for testing the connection

**Note:**  Following the usage of sst flag based on agent version

| **Agent rev.** | **sst flag usage** |
| --- | --- |
| v1 | [https://valid-ec-service-url](https://valid-ec-service-url/) |
| --- | --- |
| v1beta | [https://valid-ec-service-url](https://valid-ec-service-url/) |
| v1.1 | [https://valid-ec-service-url/v1](https://valid-ec-service-url/v1) |
| v1.1beta | [https://valid-ec-service-url/v1beta](https://valid-ec-service-url/v1beta) |

# Connecting to APIs (TLS)

Content under this heading is under development.

# Fuse mode

In the traditional mode, you have three components, namely EC Client, EC Server, and EC Gateway, that constitute the Enterprise Connect (EC) service. This arrangement ensures connectivity when you have multiple clients and servers and there is a need to be connected through a gateway.

However, if you have a requirement where you need only a single EC connection, then you can combine the EC Gateway with either an EC Client or an EC Server. In that case, you need only two EC components (instead of three in the case of a traditional mode).

- Either a gateway with a server and a client (GW Server and Client)
- Or a gateway with a client and a server (GW Client and Server)

Such an arrangement is termed a &quot;Fuse Mode&quot; or &quot;direct connection.&quot;

# Deployment options

Content under this heading is under development.

## Cloud Foundry

Content under this heading is under development.

## EKS/AKS

Content under this heading is under development.

## Binary process

Content under this heading is under development.

# Common Issues &amp; Troubleshooting tips:

While using the Enterprise Connect service, you may face some problems. The following are some of the most commonly faced problems and how to troubleshoot them.

1. **The EC Gateway is Down:**

When the Enterprise Connect gateway (either Predix or AWS) is down, all the EC connections from the gateway will be lost. This may occur if the Predix gateway application is mistakenly stopped, or if the AWS gateway process is killed. When this situation occurs, the operations team has to restart the gateway manually.

1. **The EC Agent is Down:**

When the EC agent is down, the connectivity between the EC service and the agent gets snapped. The reasons behind the failure could be occasional heavy loads or processes getting killed. The operations team needs to check the connection details and identify which agent went down. And, thereafter, deploy the restage script to bring the agent up.

1. **The Client Agent Fails:**

When the Client Agent fails to start or throws an error while making a connection, the gateway remains out of service. In that case, the agent script needs to be corrected and a restage script needs to be deployed to restore the service.

1. **When the Server Agent Fails:**

When the Server Agent fails to start or throws an error while making a connection, the gateway remains out of service. In that case, the agent script needs to be corrected and a restaging script needs to be deployed to bring the service back.

1. **Unable to Make EC Connection with VLAN:**

When you are unable to make an EC connection with VLAN, you need to check the configuration.

Carry out the following checks if an EC connection is not established with VLAN:

- Check to see if the -vln flag is set in the client script.
- Check if the plugins.yml file is available next to the client agent script.
- Check the content format in the plugins.yml file.

The client application must use the target IP and port to connect (not the client host IP and lPT)

1. **The TLS Plugin Doesn&#39;t Function:**

If the TLS Plugin is not able to make a connection with TLS (Transport Layer Security), then you need to check the configuration.

Please carry out the following checks to fix the problem.

- The yml file must be placed alongside the server script.
- Check the format of the plugins.yml file

1. **The CF Service is Down:**

If the CF (Cloud Foundry) service is down, the EC service for the related subscription goes down. The failure will impact all the connections under the subscription, and the operations team has to restage the subscription application to bring the service back.

1. **The Broker App for Predix EC is Down:**

Every Predix service has a broker application, and if the broker application for the Predix EC service is down, you will not be able to create new subscriptions. If the CF (Cloud Foundry) service broker fails, you need to reach out to the Predix support team for help.

1. **The Predix Cloud Foundry is Down:**

If the Predix Cloud Foundry is down, the entire Predix platform will be out of service and, as a result, all the EC services will be adversely affected. Therefore, to resolve the network issue, you need to reach out to the Predix support team. Once the platform is back on track, all EC connections will be back to normal.

1. **Predix UAA Service is Down:**

When the Predix UAA (User Account and Authentication) service is down, it impacts all new EC connections. The UAA service may be down due to issues in the Predix environment. Subscribe to the status alerts at **status.predix.io** to receive notifications when any Predix service goes down. Since it is an automated alert, no action is needed by the admin team.

1. **The VM, Where the EC Agent is running, goes down:**

When the Virtual Machine (VM), where the EC Agent is installed goes out of service, it affects the EC connection for agents installed in that VM. Normally, the VMs in the cloud go down but come back immediately. One way to overcome this problem is to create bootstrap scripts to install EC agents and make them run.

1. **Docker Containers Go Down:**

When Docker containers go down, the EC connection where the agent is running may get interrupted. As a docker container comes back automatically on its own after it gets destroyed, no action is required on your part.

1. **Proxy Issues:**

Proxy URLs must be used only when connecting from on premise resources and should not be used while connecting from external environments such as AWS or Azure. Any misuse may result in a failure of the EC connection. If the proxy is configured correctly, you should be able to get the UAA token properly. If not, try again with another proxy URL.

1. **Network Goes Down:**

Network outages are rare. However, if it indeed occurs, all connections via that network will be disconnected. You need to reach out to the core tech team to get the problem fixed.

1. **Connection Fails Suddenly:**

Multiple reasons may cause an EC connection to fail. Carry out the following checks when there is a disruption to an EC connection.

- Check the gateway health for the EC Connection.
- Restart the gateway if the page does not load.
- If there is no super connection, start the server agent.
- If a super connection exists and the connection is not working, check the client agent status.
- If client logs show &#39;Bad handshake error&#39;, check the gateway URL and check the agent IDs and group name against the EC service API.
- If server logs show &#39;Exception occurred while reading the data ...&#39;, check the rht and rpt flags in the server script.
- If gateway/server/client logs say, &quot;Empty cert found,&quot; check with the product team to update the certs for EC service.
- Agent version must be same for gateway, server, and client

1. **Parental EC Service is Down:**

When the parental Predix EC service is down, you can&#39;t create new subscriptions. You will need to reach out to the Predix support team to get the problem fixed.

1. **Certificate Expiry:**

When a certificate for a subscription expires, all the EC connections created under that subscription will be lost. Tracking the certificate expiry and its timely renewal are required to resolve the problem.

1. **Connections More than the Specified Limit:**

The Predix gateway has a defined limit of 50 connections. Therefore, you either need to restrict the number of connections to fifty or send an alert when the upper limit is reached. There is a possibility of connection failure when the number of connections surpasses the fifty mark.

## Health page

The content under this heading is under development

GE Confidential
