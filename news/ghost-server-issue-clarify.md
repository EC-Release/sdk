## Ghost Server Supports Issue (2021.11.1)

### Table of contents
1. [Background](#background)
2. [Inaccurate Statement](#inaccurate-statement)
3. [The Support Narative](#the-support-narative)
    1. [Announce of Cert-Renewal Process](#announce-of-cert-renewal-process)
    2. [Request Upgrade of Existing Agent](#request-upgrade-of-existing-agent)
    3. [Announce "CCL Server" Migration](#announce-ccl-server-migration)
    4. [Confirm Cert-Renewal Process](#confirm-cert-renewal-process)
    5. [Begin Cert-Renewal Process](#begin-cert-renewal-process)
    6. [Post Cert-Renewal Process](#post-cert-renewal-process)
    7. [CCL Server Migration led to the ghost-server issue](#ccl-server-migration-led-to-the-ghost-server-issue)
    8. [Document, Document, Never Stop documenting](#document-document-never-stop-documenting)
4. [Customer Q&A](#customer-qa)
    1. [what do you mean "end this migration"](#what-do-you-mean-end-this-migration)
    2. [What is in fact correct?](#what-is-in-fact-correct)
    3. [what is a ghost server? How is it relevant?](#what-is-a-ghost-server-how-is-it-relevant)
    4. [in one or two sentences what was the issue](#in-one-or-two-sentences-what-was-the-issue)
    5. [Interpretation of the Statement](#interpretation-of-the-statement)
5. [Reference](#reference)


### Background
In the effort to assist the customer's (GE Digital-Connect Ops) product troubleshooting, a confusion in between cert-renewal process[7] and [ccl server migration](#announce-ccl-server-migration) unfortunetely has arised. The customer has since reached out to get a clarity over its confusion.

EC team intends to clarify the confusion with technical insights, and at the same time, to raise the awareness of the importance of the documentation effort in troubleshooting sessions to avoid a mis-configuration in business adoption.

### Inaccurate Statement

A statement by a Ops member suggested that the cert-renewal process[7] **might have been the cause of an** issue impacting its business ops. <br><br> 
EC team considers the customer's statement understated our supports value, and underminds the support efforts we extended to the customer. The statement may also lead to internal disputes, with productivity costs to the business unit.<br><br>
We wish to clarify any concerns resulting from reading such suggestion/statement below by publishing the records, the logs, and supplemental references associated with our support efforts for future training purpose.

The message snippet 
> Not sure as I already said, we see mixed findings and for some of the EC issues, we could somehow relate to these<br><br>
These were started showing since the cert renewal on EC Services and if you ask me, again I do not see any relationship but we have started noticing it since cert renewal<br><br>
Let me know of any findings,<br><br>

The PO's reply
> The newer EC service instances continue working as expected as of today. The thought of cert-renewal issue bears no merit and is not supported by any evidences. <br><br>
If Ops does not know how to shoulder the responsibility of its very decision of migrating existing agent connectivity from vm-2-vm, we can. We are here to help out! <br><br>


### The Support Narative

#### Announce of Cert-Renewal Process
On Jul-27 in the team's release planning (2021.9), we announced the feature[9] to kickoff the annual cert-based renewal process[7]. The cert which was set to expire in Oct, is embedded in each EC service instance for the enhanced security practice.

#### Request Upgrade of Existing Agent
On Aug-12, a meeting series created in the effort to support a request initiated by customer (GE Digital-Connect Ops) to upgrade[1] existing agent/connectivity instances from v212 to v214. A entirely different goal/objective/step to the cert-based renewal process[7].

#### Announce "CCL Server" Migration
On Aug-25, messages[quote-1|quote-2] sent from the customer (DC Ops) show the decision to end this upgrade[1].<br><br>
Note that in the message[quote-1|quote-2], it clearly indicates that **there will be a server-agent instances migration action taken by the customer, this would apply to several server-agent instances labeled "CCL Server".**<br><br>
[quote-1] & [2]
> **We are in a hurry to get out of CCL servers to issue decommission request by the end of September**. Timeline is tied to Coretech's ask of 3-months to decommission old infra and stop billing our org for it. Sep 30 date ensures we don't pay for any CCL hardware in Q1 next year. We don't have the budget for it and it is not something we control.<br><br>
We also cannot exercise a major change in a quarter-end month for our customers even if we can execute the hardware and software change by mid-Sep (we are on freeze for PROD after that). Which pushes this date out to Oct and possibly beyond if we run into new roadblocks. That is why we want to get out of CCL first before accommodating any change on the platform side. This will give us the breathing space and ensure a good customer experience during the platform switch.

[quote-2] & [2]
> As we are having strict timelines to complete this activity by 18-19 September with cost implications, have decided to move only CCL Agents on to the new hardware and once done, we shall resume with the Git based documentation exercise along with other product migrations. <br><br>
Thanks for all the support,

#### Confirm Cert-Renewal Process
On Sep-9. message labeled "Confirmation of date and time for EC certificate changes." from the Ops Support agent "Sthapit, Nirat" confirmed that Ops has assumed the cert-renewal date on Sep-11, and Ops is aware of this renewal process

#### Begin Cert-Renewal Process
On Sep-11, 13, 14, 15, 17, 21, product team works tirelessly towards the completion of the cert-renewal process successfully. Documents[3] show evidences/logs of such completion was **fully tested and properly communicated**. Also during the renewal process, the product team received only one incident report[4] later identified as lack of documentation/KB, which is entirely irrelevant to the process.

#### Post Cert-Renewal Process
**Three weeks** passed since Sep-21, the renewal service-instances continue working as expected with no complaints. This also suggests the working state of "renewal service-instances".<br><br>

#### CCL Server Migration led to the ghost-server issue
On Oct-15, we started to receive reports[5] of service interruption. After a thorough investigation, we were able to identify the "ghost server deployment"[8] as its root-cause to the issue. <br><br>
The keyword here **"ghost server"**[8] which is irrelevant to **"cert-renewal process"**[7] in its usage.  Moreover, we also found the maintaining codebase practice for host scripts have been revised and modified. This serves the evidence of the agent migration activity from vm-2-vm have been conducted/conducting by the Ops agents in aligning to the said CCL CoreTech budget effort itereated by both Gowri/Kamalesh.

#### Document, Document, Never Stop documenting
Since Oct-15, the product team continues documenting incidents[6] we received/supported that were originated by Ops on Oct-19, 20, 21, 22, 25, 26.


### Customer Q&A

#### What do you mean "end this migration"
please refer to the [announce ccl server migration](#announce-ccl-server-migration) and [cl-server-migration-led-to-the-ghost-server-issue](#ccl-server-migration-led-to-the-ghost-server-issue)

#### What is in fact correct?
> saying “assumes” implies that in this context that it is not correct. What is in fact correct?
>>  ..confirmed that Ops has assumed.. Please reach out to "Sthapit, Nirat" for the detail. The message is documented.

[This is to confirm](#confirm-cert-renewal-process) that Ops is aware of the cert-renewal process[7]


#### What is a ghost server? How is it relevant?
refer to Ghost-server issue[8], and incidents documented in [4], [5].

#### In one or two sentences what was the issue
> ultimately are you simply saying that some servers were missed to have their certificates updated? If not, bottom line, in one or two sentences what was the issue.

Two issues and its goal/result are all mis-matched. Please refer to [the background](#background). Please refer to [Interpretation of the Statement]() for the issue, and the root cause of the issue.


#### More Clarification for the Statement
> I don’t believe you have clearly articulated what is meant by "If Ops does not know how to shoulder the responsibility of its very decision of migrating existing agent connectivity from vm-2-vm,"... <br><br>
The best I can tell is from what you have provided is the ops team advised the product team of certain certs that needed to be updated and that maybe it was an incomplete list.

The ghost-server issue[8] is mainly caused by an ongoing task labeled "CCL Server Migration" by the Ops resources (refer to [the question "what do you mean end this migration"](#what-do-you-mean-end-this-migration)) NOT by the cert-renewal process[7]<br><br>
The customer (Ops team) has not acquired the knowledge of the cert-renewal process[7], therefore cannot tell the difference of a x509 cert.

Furthermore, during the cert-renewal process[7], product team had ensured all active-in-use service instances were updated properly, regardless the completion of the list. See Project Cert-Renewal Notes[3].



### Reference
[1] [Project Agent Upgrade by EC](https://github.build.ge.com/digital-connect-devops/ec-ccl-214-migration) <br>
[2] Project Agent CCL server migration from vm-2-vm by Customer (Ops). refer to the email body "Fw: EC Migration - Change in direction" <br>
[3] [Project Cert-Renewal Notes](https://github.com/EC-Release/service-update/blob/service-renewal-2022/docs/project-2022-renewal.md) <br>
[4] [Customer Incident Notes](https://github.com/EC-Release/service-update/blob/service-renewal-2022/docs/customer-incidents.md) <br>
[5] [Internal Custonmer Incident Notes](https://spo-mydrive.ge.com/:o:/g/personal/212359746_ge_com/ElLLpJEbi2xLlVPDDxLUke4BhQw5Sd5XcBwlUTt4e4q1tg?e=aCsEal) <br>
[6] [Weekly Product Notes](https://github.com/EC-Release/sdk/blob/wiki/news/weekly.md) <br>
[7] Certificate Renewal Process: The EC Single-Tenant Service which currently deployed in Predix CF environment to service the Predix Subscriber with its ability to reveal 
gateway agent instances across networks. The service helps agent intances to establish EC connectivity accurately.A x509 Certificate embedded in each service instance is to maintain the integrity of its ECO security. The renewal process is for EC Team to renew the expiry of the certificates on annual-basis to ensure the working state of each service instance. <br>
[8] Ghost-server issue: The issue typically happens when users become unaware of the whereabout of a series of existing server agent instances, but choose to move forward with newer deployment of server-agent instances, that is duplicate to the existing server-agent deployment. These abandoned server-agents can shadow the list of unstable gateways that is subject to removal by a service, causing the future servers unable to establish its superconn with gateways.
[9] [AHA Feature DTEC-182](https://ge-dw.aha.io/features/DTEC-182)
