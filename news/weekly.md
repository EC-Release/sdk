### EC Team Update (2021.10.26)
#### Customer Engagement:
**Aviation DMRO stage env**:
1. EC server agents showing 'glist not found' error
2. Identified 2 server agents in unsed state and not restarted after cert migration and causing the empty glist error
3. Restarted the unused EC server agents and all EC connections started functioning normal

### EC Team Update (2021.10.25)
#### Customer Engagement:
**Upgrade Wabtec non-prod env**:
1. Genpact QA EC connection - fixed and confirmed by customers
2. Upgraded SMTP connection to prod - confirmed by customers
3. Genpact EC connection - WIP (Pending with customers to update the scripts)

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
