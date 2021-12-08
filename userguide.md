# Enterprise Connect (EC) User Guide

### Contents

* Introduction:
* What is Enterprise Connect?
* Why Do You Need Enterprise Connect?
* Characteristics of Enterprise Connect:
* Where Do You Find the EC Service?
* Components of Enterprise Connect (EC).
  * EC Client:
  * EC Server:
  * EC Gateway:
  * VLAN Plugin:
  * TLS Plugin:
  * Fuse Mode:
* Connectivity between Discrete Networks:
  * Through Firewall:
  * Through Enterprise Connect (EC)
* Steps Involved in Deploying the EC Service:
* How Things Flow in Enterprise Connect?
  * Connecting On-premise Data Sources to Predix/Cloud
  * Connecting Predix Data Sources to On-premise-ETL
* More about How Things Flow in Enterprise Connect
* Authentication (OAuth 2.0)
* Enterprise Connect Service Setup


### Introduction

Enterprise Connect (EC) is a micro service offered as part of the Predix environment.  It acts as a middleware to connect and transfer data between two discrete networks. Though the Enterprise Connect service is offered as part of Predix, it can connect any two independent networks. Therefore, it can even be used in a different environment such as Amazon Web Services (AWS).

### What is Enterprise Connect?

Enterprise Connect is a service that enables you to establish a secure and scalable connection between any cloud environment and your enterprise resources. As a service, it connects any two networks governed by different transmission protocols. Data passes through Enterprise Connect before getting routed to its destination.

![image](https://user-images.githubusercontent.com/38732583/145247241-d5241a61-d4bd-482f-9cfd-71aa2608d765.png)

### Why Do You Need Enterprise Connect?

Enterprises that leverage data to enhance the productivity of their assets are better equipped to become market leaders. Therefore, data from industrial devices needs to be captured for the purpose of analysis.

Internet of Things (IoT) brought about revolutionary changes in the way we, as a society, operate. There are millions of IoT-enabled devices that are installed to track and monitor a multitude of things. The devices constantly and continuously stream data, which needs to be captured, analysed, and transformed into actionable insights.

The Enterprise Connect service, which can connect any two independent networks, empowers enterprises to transfer data for the purpose of analysis.

The Predix, a Platform-as-a-Service (PaaS) offering from GE Digital, is built on an open-source cloud computing platform called Cloud Foundry. The Enterprise Connect service is offered as a microservice as part of the Predix Cloud Foundry.

### Characteristics of Enterprise Connect:

•	Enterprise Connect is a Software-as-a-Service (SaaS) platform 

•	A single instance of Enterprise Connect service can serve only one customer (single tenancy)

•	Is a system that contains many smaller software systems (self-contained microservice)

•	Has the ability to perform asynchronous operations.

### Where Do You Find the EC Service?

•	The Cloud Foundry Marketplace (CFM) offers a host of services on the Predix platform. When you log into the Predix environment and visit the Cloud Foundry marketplace, you will find several services listed out there and Enterprise Connect (EC) is one among them.

•	As of now, Enterprise Connect (EC) is being offered as a service as part of the Predix Cloud Foundry environment. However, there are future plans to make the EC run anywhere including Amazon Web Services (AWS).

•	As Enterprise Connect (EC) is offered as a service, those who want to use it must subscribe to it.

![image](https://user-images.githubusercontent.com/38732583/145245189-839a5b4d-2df3-4241-b086-3d5dc4aa42ec.png)

•	If you have a Predix account, you may visit the site www.predix.io and log into your account. In your services dashboard you will find all the services that you subscribed to.


### Components of Enterprise Connect (EC).

Enterprise Connect (EC), being a self-contained micro service, has six (6) components.

•	EC Server

•	EC Client

•	EC Gateway

•	VLAN Plugin

•	TLS Plugin

•	Fuse Mode

#### EC Client: 
The EC client, though an agent, has the ability to act as a gateway also. It appears on the side of the source system (a client application) and enables it to communicate with the server.
#### EC Server: 
The EC Server, though an agent, has also got the ability to act as a gateway. It appears on the side of the target system (a database) and communicates with the database through a driver to fulfill a request.
#### EC Gateway: 
The EC gateway acts as a middleware between the EC Client and the EC Server and routes the requests to their right destinations as there may be multiple EC Clients and Servers.
#### VLAN Plugin: 
A virtual LAN that enables you to connect to multiple target systems at a time from the client.
#### TLS Plugin: 
A TLS (Transport Layer Security) Plugin is used when you want to talk to a secure API. For example, there are some APIs that allow communication only through secure channels such as HTTPS and don’t permit the use of any unsecure channels such as Port 80 or http. In such instances, the TLS plugin comes in handy.
#### Fuse Mode: 
In the traditional mode, you have three components namely, EC Client, EC Server, and EC Gateway that constitute the Enterprise Connect (EC) service. This arrangement ensures connectivity when you have multiple clients and servers and there is a need to be connected through a gateway.
However, if you have a requirement where you need only a single EC connection, then you can combine the EC Gateway with either EC Client or EC Server. In that case, you need only two EC components (instead of three in case of a traditional mode).

•	Either a Gateway with server and a client (GW Server and Client)

•	Or a Gateway with client and a Server (GW Client and Server)

Such an arrangement is termed as a Fuse Mode or direct connection.

### Connectivity between Discrete Networks:

You can easily connect to an internal database while you are connected to the VPN on your device. However, if you try to access a database either from an AWS VPC or Azure environment, you face difficulty as there is no direct connectivity between the two discrete networks. So, what are the options available to overcome the problem?

#### Through Firewall:

One of the solutions to overcome the problem is through the creation of a firewall.

When you make an API call, it passes through your organization’s proxy, which in turn passes through the secure protocol (https).

However, if you are dealing with a database that doesn’t connect with https, then you need something on Transmission Control Protocol (TCP) level access.

You need to create a firewall between the Virtual Private Cloud (VPC) and the database, and through the firewall we can connect to the database. So, this is one of the approaches to overcome the problem of connectivity between discrete networks.


### Through Enterprise Connect (EC)
The other way to overcome the problem is through the Enterprise Connect service.
 
•	To access the Predix database, you need to deploy two agents, namely Enterprise Connect (EC) server and Enterprise Connect (EC) Client.

![image](https://user-images.githubusercontent.com/38732583/145246034-20d5b65d-758c-45af-ba5f-0662db724ebb.png)


•	You initialize the request to access data from the Virtual Private Cloud (VPC) and the request is sent to the EC Client.

•	The EC Client in turn sends the request to the EC Server and the request is routed through the EC Gateway. And, the EC Server communicates with the database to fulfil the request.

•	The EC Gateway, the heart of the Enterprise Connect service, acts as a router to route requests. It knows from where the request originated and where to send the data.

•	The connectivity between the VPC and the EC client is governed by the Transmission Control Protocol (TCP). In the same way, connectivity between the EC Server and the database is also governed by TCP.

•	However, the connectivity between the two agents, namely the EC Client and the EC Server, is governed by a secure WebSocket (https).


### Steps Involved in Deploying the EC Service:

To deploy the Enterprise Connect (EC) service, you need to follow the below steps.

![image](https://user-images.githubusercontent.com/38732583/145246099-98fe8b4b-861d-48ee-80ba-4ab016fbf3b0.png)

•	First, you need to subscribe for the Enterprise Connect (EC) service.

•	Thereafter, you need to deploy a gateway (a middleware) under the EC service.

•	The next step involves the installation of the EC server and configure it. The EC server, after coming into existence, reports to the EC gateway and a super connection will be established between the two, which facilitates accessing data from the database.

•	Next, you need to deploy the EC Client and the AWS Virtual Private Cloud (VPC) will establish a connection with it. When the EC Client sends a request to the gateway, the gateway knows to which EC server the request needs to be forwarded as there might be multiple EC clients and servers. The Gateway has the knowledge regarding all the EC Clients and servers that are part of the network and the knowledge enables it to route the requests without errors.


### How Things Flow in Enterprise Connect?

The Enterprise Connect service ensures two-way communication between the Predix Cloud and enterprise resources.

•	Connect on-premise data sources to Predix cloud

•	Connect Predix data sources to on-premise – ETL

There are two prerequisites that you need to meet before you start using the Enterprise Connect service. 

•	An active Predix cloud account

•	Installation of Cloud Foundry CLI (Command Line Interface)

![image](https://user-images.githubusercontent.com/38732583/145246295-747ae562-4193-4666-a9f5-6873368b3e8b.png)


#### Connecting On-premise Data Sources to Predix/Cloud

•	An EC Client sends a request to an EC Server and the request gets routed through the EC Gateway. The transmission happens through secure WebSocket.

•	The EC server fulfils the request by sharing the required data.


#### Connecting Predix Data Sources to On-premise-ETL

![image](https://user-images.githubusercontent.com/38732583/145246394-027947d8-3e58-45aa-a890-581b79d3bc61.png)

•	A request is sent to the Enterprise Connect (EC) client. The transmission of the request is governed by TCP (Transmission Control Protocol). 

•	The EC client relays the request to the EC Server. The request gets routed through the EC Gateway and gets transmitted through a secure WebSocket (HTTPS).

•	The server, in turn communicates with the Predix Postgres service to fulfil the request.

•	The data is extracted by an ETL (Extract, Transform and Load) tool and the users can explore the data visualizations provided by the ETL application to gain insights into the data.

Note: Postgres service allows you to store data securely and retrieve it at the request of other software applications.


### More about How Things Flow in Enterprise Connect

•	ELT tools mostly run behind a VPN. Therefore, we use the Enterprise Connect service to facilitate connectivity between the ETL tools and the Predix Cloud.

•	The components of the Enterprise Connect namely, EC Client, EC Server, and EC Gateway create a tunnel between the Cloud Foundry and the VPN Network.

•	In this particular instance, the Predix Postgres database is the target system. It could even be something else such as Amazon Web Services (AWS). In that case, you need to install the Enterprise Connect server in the AWS environment to enable it to access the corresponding database or SFDC (SalesForce Dot Com) servers.

•	And similarly, since the client runs behind the VPN, you have to install the client on that network. Since the client needs to read data from the VPN, you need to install the EC Client behind the firewall. Sometimes you may have to read data from Azure service. In that case, you have to install the EC client in the corresponding client applications.

•	Here, the ETL tools such as Informatica and Talend are client applications, but the applications can even be based on Oracle SQL, Python, or Spring Boot.

•	Ideally, if the ETL tools and the database are in the same network, they can talk to the database directly. But if they are part of two different networks, the ETL tool, which is a client application tool, has to talk to the EC client. The EC client connects to the EC server and the server, in turn, will contact the Postgress database for the fulfilment of the request.

•	Enterprise Connect (EC) service can connect any two independent networks. The connectivity can be between Cloud Foundry and on-premise, on-premise and AWS, or AWS and Azure.


### Authentication (OAuth 2.0)

Any agent, whether it is an EC Client or EC Server, before making an API call, should get validated against the User Account and Authentication (UAA). The Enterprise Connect (EC) service uses the Cloud Foundry User Account and Authentication (CF UAA) to manage the identity of the request and authorize the provision of service.

![image](https://user-images.githubusercontent.com/38732583/145246588-b7507028-df31-4460-821e-fb78f4e376cf.png)


### Enterprise Connect Service Setup

Subscribe to the Predix Cloud platform (Predix User Account and Authentication service). You can either use the UAA dashboard or the Cloud Foundry command line interface (CLI) to create and configure your service.

Next, you need to create an Enterprise Connect service instance in the Predix environment by signing into your Predix account.

To find a step-by-step procedure to create an Enterprise Connect (EC) service instance, please navigate to the below page:
https://www.ge.com/digital/documentation/edge-software/r_Enterprise_Connect_service_setup.html

