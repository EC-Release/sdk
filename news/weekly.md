### EC Team Update (2021.11.08)
#### Customer Engagement:
Wabtec - Genpact Production outage

- Genpact customer reached EC team to investiage the `TNS listener` issue for connecting to wabtec database
- Identified there was an outage in the weekend for database and changes were not made to the EC server scripts, which are running in wabtec env
- Requested wabtec team to update the EC server and restart and connections are back to normal

DPOD - DTE Maximo Integration - Phase 2 - Stage env instability

- Agents were down again and notified by DTE team. Upon investigation, monitoring scripts were not enabled and requested again.


### EC Team Update (2021.11.05)
#### Customer Engagement:
DPOD - DTE Maximo Integration - Phase 2 - Stage env instability

- Upon the investigation identified, EC agents were stopped running in new VM machines and requested operations team to enable the monitoring scripts on agents.

### EC Team Update (2021.11.04)
#### Customer Engagement:
DPOD - DTE Maximo Integration - Phase 2

- UAT testing is in progress by DTE and going fine
- Initial discussion on production EC env setup
- Should send the details to network team to update the firewall rules

### EC Team Update (2021.11.03)
#### Retro on empty glist issue

Here is the idea sharing notes - 

- In general, After getting the bearer token and public certs, EC server will make call POST /api/gateways and get gateway list (glist) from the service. EC Service will send all registered gateways as response.
- But recent issue, EC servers are getting the empty glist, instead of real gateway list (though gateways are up and running)
- This is because of ghost EC Server agents, which were not restarted after cert migration.
- Since ghost EC servers are not restarted, they are still running with old certs and throwing the 'Invalid cert issuer' error and then suspecting these ghost EC servers are updating the glist to empty.
- Expected functionality - It will delete only gateway url from glist, which mentioned in server script. But have to recreate the scenario.
- However, as discussed, EC servers must be maintained well. Customers/ops must be aware of where and what server agents are running. That will help to avoid making unnecessary API calls to EC Service.
- As an enhancement, agent can have flexibility to report to EC Service with details like agent id, grouop or location. So that we can stop the unused agents and controlled remotely.

### EC Team Update (2021.10.29)
#### Customer Engagement:
- Perceptive SAP ERP's - Deploy EC client in EKS with custom agent version

#### EC 2.x
1. [DTEC-180](https://ge-dw.aha.io/features/DTEC-180) Containerize the ML-Portal as a single app with ML-API Endpoint being embedded in UI to make it more user-friendly, so that the users can use a single endpoint to access the api-endpoint as well as the UI. Consolidate ML-App (including frontend & backend) into a single image & containerize into a single container. (Puja)


### EC Team Update (2021.10.28)
#### Customer Engagement:
- Aviation AOA non prod EC Server. Fixed the network route to the service instance.
- 'no glist found' error for power ec connections
- KT Session and demo on EKS topology and SDC deployment

#### EC 2.x
1. [DTEC-180](https://ge-dw.aha.io/features/DTEC-180) Containerize the ML-Portal as a single app with ML-API Endpoint being embedded in UI to make it more user-friendly, so that the users can use a single endpoint to access the api-endpoint as well as the UI. Consolidate ML-App (including frontend & backend) into a single image & containerize into a single container. (Puja)


### EC Team Update (2021.10.27)
#### Sprint Demo
##### EC 2.x CAAS Demo.
- Begin with the feature details, 
- LEAN value stream, 
- config/settings, 
- then jump in to the end-to-end demo with SSH connectivity.
- Made the video available in Teams recording.

#### Service Update
- Team exercise for creating the automation script to mitigate the memory usage.
- Analysis a possible business impact.
- Team concluded to deploy the script ASAP to avoid any memory spike charges from @Predix. [See log](https://github.com/EC-Release/service-update/runs/4024281070?check_suite_focus=true)
- Team decided to de-prioritise the collaboration as the broker remains unchanged.
- Team will work on the broker improvement to mitigate any service subscription going forward.

#### EC Service Tile
There appears to be some broken linkage to EC subscription @Predix.io, but the concern has been clarified by Mary @Digital

#### EC 2.x
1. [DTEC-180](https://ge-dw.aha.io/features/DTEC-180) Containerize the ML-Portal as a single app with ML-API Endpoint being embedded in UI to make it more user-friendly, so that the users can use a single endpoint to access the api-endpoint as well as the UI. Consolidate ML-App (including frontend & backend) into a single image & containerize into a single container. (Puja)


### EC Team Update (2021.10.26)
#### Customer Engagement:
**Aviation DMRO stage env**:
1. EC server agents showing 'glist not found' error
2. Identified 2 server agents in unsed state and not restarted after cert migration and causing the empty glist error
3. Restarted the unused EC server agents and all EC connections started functioning normal

#### EC 2.x
1. [DTEC-180](https://ge-dw.aha.io/features/DTEC-180) Containerize the ML-Portal as a single app with ML-API Endpoint being embedded in UI to make it more user-friendly, so that the users can use a single endpoint to access the api-endpoint as well as the UI. Consolidate ML-App (including frontend & backend) into a single image & containerize into a single container. (Puja)

### EC Team Update (2021.10.25)
#### Customer Engagement:
**Upgrade Wabtec non-prod env**:
1. Genpact QA EC connection - fixed and confirmed by customers
2. Upgraded SMTP connection to prod - confirmed by customers
3. Genpact EC connection - WIP (Pending with customers to update the scripts)

#### EC 2.x
1. [DTEC-180](https://ge-dw.aha.io/features/DTEC-180) Containerize the ML-Portal as a single app with ML-API Endpoint being embedded in UI to make it more user-friendly, so that the users can use a single endpoint to access the api-endpoint as well as the UI. Consolidate ML-App (including frontend & backend) into a single image & containerize into a single container. (Puja)


### EC Team Update (2021.10.22)
#### Customer Engagement:
**Upgrade Wabtec npn-prod env**:
1. EC Server agent throwing 'glist not found' error
2. Identified the root cause and found 2 server agents are running, which causes the glist error and the issue is fixed.
3. Working on other issue for fixing the connectivity at gateway to create session object for EC connection

**Service instances memory optimization**:
1. Working on fix to reduce the consumed memory by EC service instances in US West CF environment.

#### EC 2.x
1. [DTEC-179](https://ge-dw.aha.io/features/DTEC-179) Integrate ML API Endpoint with UI, so that the user can upload EC Service Logs from UI. (Puja)
2. [DTEC-180](https://ge-dw.aha.io/features/DTEC-180) Containerize the ML-Portal as a single app with ML-API Endpoint being embedded in UI to make it more user-friendly, so that the users can use a single endpoint to access the api-endpoint as well as the UI. (Puja)


### EC Team Update (2021.10.21)
#### Ops Supports:
**Perceptive Prod EC Issue** 
1. Intermittant connection failure when connecting to onprem API 'emsappo-prd.cloud.ge.com' from EKS TC
2. Upon debug, identified API is resolvable from EKS. So advised to test connectivity with no EC

#### Customer Engagement:
**Upgrade Wabtec SMTP to prod env**:
1. today's call did not go as planned as the attendee gave no show.
2. Updated EC client with new configuration under production subscription
3. Shared the EC server script with customer to update and relaunch

#### EC 2.x
1. [DTEC-186](https://ge-dw.aha.io/features/DTEC-186) Continue SDC Training series on daily basis. Document/KT the usage of SDC/Unified WebApp APIs by the demo of ML Portal & EC Portal integrations. (Team)
2. [DTEC-179](https://ge-dw.aha.io/features/DTEC-179) Integrate ML API Endpoint with UI, so that the user can upload EC Service Logs from UI. (Puja)
3. [DTEC-180](https://ge-dw.aha.io/features/DTEC-180) Containerize the ML-Portal as a single app with ML-API Endpoint being embedded in UI to make it more user-friendly, so that the users can use a single endpoint to access the api-endpoint as well as the UI. (Puja)

### EC Team Update (2021.10.20)
#### Ops Supports:
1. Ops continues struggling in several service updated, regardless the [preliminary progress on the documentation](https://github.build.ge.com/digital-connect-devops/ec-ccl-214-migration) we have supported, there is no documentation effort done. The project labeled **Perceptive Prod EC Issue** is another example in repeating the effort over [the similar issue](https://spo-mydrive.ge.com/:o:/g/personal/212359746_ge_com/ElLLpJEbi2xLlVPDDxLUke4BhQw5Sd5XcBwlUTt4e4q1tg?e=WydGBg)
2. The support priority resulting in the product team had to cancel the SDC occurence series and push back key deliverables.

#### EC 2.x
1. [DTEC-179](https://ge-dw.aha.io/features/DTEC-179) Integrate ML API Endpoint with UI, so that the user can upload EC Service Logs from UI. (Puja)
2. [DTEC-180](https://ge-dw.aha.io/features/DTEC-180) Containerize the ML-Portal as a single app with ML-API Endpoint being embedded in UI to make it more user-friendly, so that the users can use a single endpoint to access the api-endpoint as well as the UI. (Puja)


### EC Team Update (2021.10.19)

#### Customer Engagement:
    
1. Aviation OperationAdvisor support. (Ram)
2. DPOD. (Ram)
3. Ops call to troubleshoot an existing connectivity at Service/Server/Gateway configuration. (Ram)
4. Wabtec Genpact Production issue (Ram)

#### Service Migration:
1.  [DTEC-184](https://ge-dw.aha.io/features/DTEC-184) continue assisting Ops team in the effort to migrate all agent revision from v212/v213 to v214. (Team)

#### EC 2.x
1. SDC
   1. endpoint exposure, documenting in swagger-ui. (ay)
   2. continue SDC Training series on daily basis. (Team)
   3. Document the adoption progress and share feedback from the group to the group. (Team)
   4. Work with developers to PRs the document/Wiki for the SDC usage/high-level concept. (Team)
   5. Document MoM for each KT session. (Team)
   6. [DTEC-186](https://ge-dw.aha.io/features/DTEC-186) Continue SDC Training series on daily basis. Document/KT the usage of SDC/Unified WebApp APIs by the demo of ML Portal & EC Portal integrations. (Team)
2. [DTEC-179](https://ge-dw.aha.io/features/DTEC-179) Integrate ML API Endpoint with UI, so that the user can upload EC Service Logs from UI. (Puja)
3. [DTEC-180](https://ge-dw.aha.io/features/DTEC-180) Containerize the ML-Portal as a single app with ML-API Endpoint being embedded in UI to make it more user-friendly, so that the users can use a single endpoint to access the api-endpoint as well as the UI. (Puja)
4. [DTEC-175](https://ge-dw.aha.io/features/DTEC-175) Continue on developing the e2e connectivity demo. (ay/Ram)
5. [DTEC-178](https://ge-dw.aha.io/features/DTEC-178) Document user guide for SDC/EC 2.x adoption. PRs in progress. (Team)

### SDC KT (2021.10.19)
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

### SDC KT (2021.10.18)
Following are the topics covered -
- Introduction to SDC, architecture and high level overview
- SDC features - multiple tenancy capabilities
- SDC integration with GE federated service
- SDC custom scopes and mapping to default OIDC scopes
- Deployment topology in EKS
