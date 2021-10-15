## EC 2.0 Developer Onboarding Guide

### Licence
Every EC developer should have license to access the resources

#### Create new license

- Go to [certifactory](https://github.com/EC-Release/certifactory) repo and go to 'Actions'

- Select 'License Request (Beta)' workflow. Fill the details in the form and run the workflow

Note: Passphrase is secured and can't be recovered. So please save the passphrase in a secure location. 

<img width="1178" alt="create-license-request" src="https://user-images.githubusercontent.com/38732583/137537515-33f26b63-e7e9-4704-90b0-84a6f6371451.png">


- Workflow will create the PR as result to create the license and reviewers will approve the PR based on details to generate the license

- Email will be generated with the license details upon approval

#### Owner hash generation

- Go to [certifactory](https://github.com/EC-Release/certifactory) repo and go to 'Actions'

- Select 'Hash Generator (Beta)' workflow. Fill the form with license id and passphrase

<img width="1152" alt="hash-generator" src="https://user-images.githubusercontent.com/38732583/137540272-db3918e3-829b-4ce9-8393-aa2ebe8c876f.png">


- Email will be generated with generated owner hash and valid for 90 days

#### Add license to SDC

- Select the SDC component to add license

Note: Following activity can be performed only by licensed user and have access to SDC  

- Go to the SDC swagger page like [ec-oauth-sso](https://ec-oauth-sso.run.aws-usw02-dev.ice.predix.io/v1.2beta/assets/swagger-ui/) and authenticate with license id and refreshed hash

(add-license-to-sdc.png)

- Use "POST /{rev}/licenses" API to add new license to SDC

#### Deploy seeder application

Below steps will help to deploy seeder application in a CF environment

- Login into the CF environment and run the below commands - 

    ```
    cf push <application-name> --docker-image enterpriseconnect/api:v1.2beta --no-start
    
    cf set-env <application-name> AGENT_REV_TEMP_UNSET 1.2-b.0.reiwa
    
    cf set-env <application-name> CA_PPRS <owner-hash>
    
    cf set-env <application-name> EC_AGT_GRP test
    
    cf set-env <application-name> EC_AGT_MODE x:gateway
    
    cf set-env <application-name> EC_API_APP_NAME ec
    
    cf set-env <application-name> EC_API_DEV_ID <license-id>
    
    cf set-env <application-name> EC_API_OA2 https://<sdc-application-uri>/oauth/token
    
    cf set-env <application-name> EC_PORT 8080
    
    cf set-env <application-name> EC_SEED_HOST https://<seeder-application-uri>/v1.2beta/ec
    
    cf set-env <application-name> EC_SEED_NODE https://ng-portal-7.run.aws-usw02-dev.ice.predix.io/v1.2beta/ec
    ```

- Use any application in cluster for `EC_SEED_NODE` property

- Start the application

    ```
    cf start <application-name>
    ```

#### Get the refreshed token

- Go to the swagger page of deployed app 
