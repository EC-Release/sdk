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

### EC Team Update (2021.10.20)
#### Ops Supports:
1. Ops continues struggling in several service updated, regardless the [preliminary progress on the documentation](https://github.build.ge.com/digital-connect-devops/ec-ccl-214-migration) we have supported, there is no documentation effort done. The project labeled **Perceptive Prod EC Issue** is another example in repeating the effort over [the similar issue](https://spo-mydrive.ge.com/:o:/g/personal/212359746_ge_com/ElLLpJEbi2xLlVPDDxLUke4BhQw5Sd5XcBwlUTt4e4q1tg?e=WydGBg)
2. The support priority resulting in the product team had to cancel the SDC occurence series and push back key deliverables.

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
   6. [DTEC-179](https://ge-dw.aha.io/features/DTEC-179) Document/KT the usage of SDC/Unified WebApp APIs by the demo of ML Portal integration. (Team)
   7. [DTEC-185](https://ge-dw.aha.io/features/DTEC-185) Create Microsoft Threat-Models for security engaging purpose. (Puja)
2. [DTEC-175](https://ge-dw.aha.io/features/DTEC-175) Continue on developing the e2e connectivity demo. (ay/Ram)
3. [DTEC-178](https://ge-dw.aha.io/features/DTEC-178) Document user guide for SDC/EC 2.x adoption. PRs in progress. (Team)

### SDC KT (2021.10.18)
Following are the topics covered -
- Introduction to SDC, architecture and high level overview
- SDC features - multiple tenancy capabilities
- SDC integration with GE federated service
- SDC custom scopes and mapping to default OIDC scopes
- Deployment topology in EKS
