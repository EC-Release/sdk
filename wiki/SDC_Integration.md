## SDC Integration for DC Service Cloud

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

#### SDC KT
10/18:
Following are the topics covered -

Introduction to SDC, architecture and high level overview
SDC features - multiple tenancy capabilities
SDC integration with GE federated service
SDC custom scopes and mapping to default OIDC scopes
Deployment topology in EKS