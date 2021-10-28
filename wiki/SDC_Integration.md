## SDC Integration for DC Service Cloud

### On Oct-25 '21
**Meeting Subject**: KT Series - SDC Hands-on II
**Attendees**: Ram, Puja, Shubham, Nirat, Temina, Srinivas, Mike, Ripu, Mahesh, Deepak, Marion
1. Recap from the Hands-on I
2. Explain the steps to validate a product subscription and break down to the following-
    3. Register Local Scopes.
    4. Create Scope Indexes.
    5. Validate SDC Bearer Token
    6. Validate User Detail.
    7. Validate Transaction Detail
3. Introduce the transactional digital currency exchange with its usage in SDC, and the data expected in the SDC API.


### On Oct-21 '21
**Meeting Subject**: KT Series - SDC Hands-on I
**Attendees**: Prasad, Puja, Deepak, Mahesh, Virgillio, Shubham, Firdous, Nirat, Ajay, Ram, Apolo, Srinivas
1. Explain the License Acquirement, Seeder Framework, with typescript code snippet (SDC Flow), and the flow to validate Subscription.
2. Explain the Steps to get licensed.
    1. How to get licensed
    2. Submit Beta License Request.
    3. Attend minimum three SDC Training sessions.
    4. Score 80/100 in the Knowledge Test.
    5. Owner of a Seeder instance. 
    6. Owner of a SDC instance.
3. walk-thru a typescript code-snippet.




### On Oct-19 '21
**Meeting Subject**: KT Series - SDC Integration with DC Service Cloud 

**Attendees**: Srinivas, Deepak, Shubham, Shruti, Mahesh, Srujana, Firdous, Ripu, Chia, Ram, Puja
1. Provided high-level architecture overview of APIs and their usage for SDC as well as embedded db
2. Provided all the details about Universal WebApp APIs by showing sample requests & responses:
    1. Showed how we can use “Dataset” APIs to perform Create/Read/Update/Delete operations on a dataset in embedded db in a flexible & secured manner.
    2. Showed how we can use “System” APIs to get the list of seeders in the cluster.
    3. Showed how we can use “Cryptography” APIs to get ‘refreshed-hash’ from Owner’s hash.  
3. Explained about Owner’s hash & Refreshed-hash and why we use them.
4. Provided high-level overview of LIBRA and why we are using it for SDC.
5. Provided high-level overview of Blockchain Clusters and why we maintain two separate Clusters - one for SDC and the other for data-storage.
6. Provided details about SDC APIs:
    1. Explained “Scope” APIs and how they can be used to perform CRUD operations to define internal scopes.
    2. Explained “OIDC Scope APIs” and how they can be used to handle OIDC integrations.
    3. Explained how “System” APIs can be used to restart SDC instances and get seeder information.
    4. Explained how “User” APIs can be used to manage User information.
    5. Explained how “Licensing” works through “Tenancy” APIs and how we use x509 for encryption & security.
    6. Explained how “Transaction” APIs can be used to create & manage new subscriptions.
7. Explained how Transaction-flow works and how Subscriptions are translated into digital-transactions.

### On Oct-18 '21
**Meeting Subject**: KT Series - SDC Integration with DC Service Cloud 

**Attendees**: Mahesh, Firdous, Srujana, Deepak, Prasad, Shubham, Chia, Puja and Ram

Topics covered in KT session - 
- Introduction to SDC, architecture and high level overview
- SDC features - multiple tenancy capabilities
- SDC integration with GE federated service
- SDC custom scopes and mapping to default OIDC scopes
- Deployment topology in EKS


### On Oct-15 '21

#### **Meeting Subject**: KT Series - SDC Integration with DC Service Cloud 
#### **Audience**: developers, stakeholders, anybody who wants to understand more about SDC.

As part of this KT series, we are providing the following information that is crucial for integration with SDC:
1. Link to the [SDC onboarding Guide](https://github.com/ramaraosrikakulapu/sdk/blob/disty/scripts/oauth/EC2.0_Developer_Onboarding_Guide.md).
2. Links to the SDC Swagger APIs that are available to be consumed for SDC integration. The swagger documentation provides all the details as to how these APIs can be utilized on need basis.
    1. [Universal WebApp APIs](https://dc-portal-1x.run.aws-usw02-dev.ice.predix.io/v1.2beta/assets/swagger-ui/) - These APIs are organized into 3 sections and can be used to perform the following functions:
        1. **Dataset**: designed to allow users to perform CRUD operations on the Dataset.
        2. **System**: designed to allow users to restart SDC instance, etc.
        3. **Cryptography**: designed to allow users to get the ‘refreshed hash’, etc.


    2. [SDC APIs](https://dc-oauth-sso.run.aws-usw02-dev.ice.predix.io/v1.2beta/assets/swagger-ui/#/) - These APIs are organized into 6 sections and can be used to perform the following functions:
        1. **Scope**: designed to allow users to create/read/update/delete Scopes from SDC.
        2. **OIDC-Scope Index**: designed to allow users to create/read/update/delete OIDC-Scope-index from SDC.
        3. **System**: designed to allow users to restart SDC instance, etc.
        4. **User**: designed to get the current user, update the current user, get list of OIDC users, tag the owner’s license with an OIDC user.
        5. **Transaction**: these APIs are designed to create & manage new subscriptions as digital-currency transactions.
        6. **Tenancy**: these APIs are designed to manage the tenancy/licenses and validate/introspect tokens.


3. In addition to this, we will show a working demo of ML-Portal that is validating the token through SDC APIs.
4. We will also show a working demo of EC-Portal that is already integrated with SDC.

#### Here is the agenda for each day:

1. Monday - Basic intro of SDC
2. Tuesday - Intermediate session
3. Wednesday - Advanced topics
4. Thursday - demo

We are looking forward to work with our sister teams and share our knowledge on how to implement SDC so that we all can comply with the SDC guidelines to build a secure & stable system.


