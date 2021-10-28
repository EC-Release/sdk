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

#### Deploy SDC

##### Deploy SDC in EKS

**Notes**: Following steps involve usage of helm and kubectl. So please make sure to install them. Also should be able to connect to the EKS environment (using gossamer3 or etc)

- Create the DNS request with pretty name you want against the ELB deployed infront of EKS

- Create application with helm
  
  ```
  helm create sdc-app
  ```
  
- Add oauth dependencies to charts.yaml

  ```
  dependencies:
  - name: oauth
    version: 0.1.6
    repository: "https://raw.githubusercontent.com/EC-Release/helmcharts/disty/oauth/0.1.6"
  ```
  
  Please find the latest oauth helm packages [here](https://github.com/EC-Release/helmcharts/tree/disty/oauth)
  
- No additional components required. So delete all components in templates folder.

- Update the dependencies

  ```
  helm dependency update sdc-app
  ```
  
- Update values.yaml as referenced [here](https://github.com/EC-Release/helmcharts/blob/v1/k8s/oauth/values.yaml) and update following sections - 
  - `global.oauthConfig`
  - `withIngress`/`withExtIngress`

- Verify the componenets

  ```
  helm template sdc-app sdc-app -f sdc-app/values.yaml
  ```
  
- Install SDC app in EKS

  ```
  helm install sdc-app sdc-app -f sdc-app/values.yaml
  ```

##### Deploy SDC in CF

- Push the application to the CF

  ```
  cf push sdc-app --docker-image enterpriseconnect/api:v1.2beta --no-start
  ```

- Set the [environment variables](https://github.com/EC-Release/helmcharts/blob/d1cccc17cdc60e6182ae212c0cfa17e233e4d154/k8s/oauth/values.yaml#L101) to the application by `cf set-env` command

- Restage the app


#### Add license to SDC

- Select the SDC component to add license

Note: Following activity can be performed only by licensed user and have access to SDC  

- Go to the SDC swagger page like [ec-oauth-sso](https://ec-oauth-sso.run.aws-usw02-dev.ice.predix.io/v1.2beta/assets/swagger-ui/) and authenticate with license id and refreshed hash

- Use "POST /{rev}/licenses" API to add new license to SDC

<img width="1059" alt="Add-license-to-sdc" src="https://user-images.githubusercontent.com/38732583/137737629-e7b17128-1810-41d2-b4af-7ee4196f11b9.png">

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

- Start the application in cf or deploy application in EKS with [helmcharts](https://github.com/EC-Release/helmcharts/tree/disty/webportal)

    ```
    cf start <application-name>
    ```

#### Get the refreshed token

- Go to the swagger page of deployed app 

- Use admin hash generated while creating the license Or generated from [Owner hash generation](https://github.com/ramaraosrikakulapu/sdk/blob/disty/scripts/oauth/EC2.0_Developer_Onboarding_Guide.md#owner-hash-generation)

<img width="1056" alt="gen-refresh-hash" src="https://user-images.githubusercontent.com/38732583/137744568-f45dbdba-230d-4256-b709-ecba1c1b66e2.png">

