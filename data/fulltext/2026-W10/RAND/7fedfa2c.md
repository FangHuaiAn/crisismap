# The Defense Contract Management Agency's Resource Workload Model Ecosystem: A Basis for Enhanced Warfighter Support

**來源：** RAND
**日期：** 2026-03-05
**URL：** https://www.rand.org/pubs/research_reports/RRA3524-1.html

---

SUSAN M. GATES, TOM WINGFIELD, HEIDI PETERS,  
BRANDON CROSBY, BARBARA BICKSLER, KARISHMA R. MEHTA, 
JACK LASHENDOCK, ELLIOTT BRENNAN
The Defense Contract 
Management Agency’s 
Resource Workload 
Model Ecosystem
A Basis for Enhanced Warfighter Support
Research Report

For more information on this publication, visit www.rand.org/t/RRA3524-1.
About RAND
RAND is a research organization that develops solutions to public policy challenges to help make 
communities throughout the world safer and more secure, healthier and more prosperous. RAND 
is nonprofit, nonpartisan, and committed to the public interest. To learn more about RAND, visit 
www.rand.org.
Research Integrity
Our mission to help improve policy and decisionmaking through research and analysis is enabled through 
our core values of quality and objectivity and our unwavering commitment to the highest level of integrity 
and ethical behavior. To help ensure our research and analysis are rigorous, objective, and nonpartisan, 
we subject our research publications to a robust and exacting quality-assurance process; avoid both 
the appearance and reality of financial and other conflicts of interest through staff training, project 
screening, and a policy of mandatory disclosure; and pursue transparency in our research engagements 
through our commitment to the open publication of our research findings and recommendations, 
disclosure of the source of funding of published research, and policies to ensure intellectual independence. 
For more information, visit www.rand.org/about/research-integrity.
RAND’s publications do not necessarily reflect the opinions of its research clients and sponsors.
Published by the RAND Corporation, Santa Monica, Calif.
© 2026 RAND Corporation
 is a registered trademark.
Library of Congress Cataloging-in-Publication Data is available for this publication.
ISBN: 978-1-9774-1585-1
Limited Print and Electronic Distribution Rights
This publication and trademark(s) contained herein are protected by law. This representation of RAND 
intellectual property is provided for noncommercial use only. Unauthorized posting of this publication 
online is prohibited; linking directly to its webpage on rand.org is encouraged. Permission is required 
from RAND to reproduce, or reuse in another form, any of its research products for commercial purposes. 
For information on reprint and reuse permissions, visit www.rand.org/about/publishing/permissions.
RR-A3524-1

iii
About This Report
In July 2024, the Defense Contract Management Agency (DCMA) asked RAND to conduct 
an independent, comprehensive assessment of its manpower requirements for core functions 
and of the process by which requirement estimates are generated. This report summarizes 
our findings and recommendations based on an in-depth review of DCMA’s Fiscal Year 2023 
Integrated Resource Workload Model version 2.0. The Integrated Resource Workload Model 
version 3.0 was under development at the time our study began and was not released until 
June 2025, after our data gathering was complete. In this report, we assess the model and 
provide suggestions for improving the modeling effort by encompassing more of DCMA’s 
activities, refining and standardizing estimates for some tasks, and formalizing the mod-
eling infrastructure within DCMA to drive greater consistency and improve transparency. 
Improvements to the resource workload modeling ecosystem could support more–data-
driven decisionmaking within DCMA and the acquisition community. 
The research reported here was completed in November 2025 and underwent security 
review with the sponsor and the Defense Office of Prepublication and Security Review before 
public release.
RAND National Security Research Division 
This research was sponsored by DCMA and conducted within the Personnel, Readiness, and 
Health Program of the RAND National Security Research Division (NSRD), which operates 
the National Defense Research Institute (NDRI), a federally funded research and develop-
ment center sponsored by the Office of the Secretary of War, the Joint Staff, the Unified 
Combatant Commands, the Navy, the Marine Corps, the defense agencies, and the defense 
intelligence enterprise. 
For more information on the RAND Personnel, Readiness, and Health Program, see 
www.rand.org/nsrd/prh or contact the director (contact information is provided on the 
webpage).
Acknowledgments
This study benefited from the direct, personal involvement of DCMA leadership, starting 
with former DCMA Director Lieutenant General Gregory Masiello, Deputy Director (now 
Acting Director) Sonya Ebright, Financial and Business Operations Executive Director and 
Comptroller (now Acting Deputy Director) Cherry Wilcoxon, and Technical Director Juanita 
Christensen. We thank them for their leadership and personal involvement in setting the 
organizational tone for cooperation and transparency. We thank the numerous individuals

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
iv
across DCMA—especially our primary points of contact within the DCMA Financial and 
Business Operations Directorate (first, Chris Borek and Colonel Johnathan Artis and, later, 
Nick Kling)—who provided continuing guidance and support for this effort. We wish to 
acknowledge the work of Kevin Smith, who, more than any other individual, is responsible 
for the creation of DCMA’s Integrated Resource Workload Model and whose work has been 
continued by his colleagues since his retirement. 
We are especially grateful to the many subject-matter experts across DCMA’s contract 
management offices, headquarters-level mission centers, and regional commands who 
answered our questions, hosted on-site visits, and shared their insights. Some, such as Scott 
Gunter and Christine Graven, we can acknowledge by name, as they played a continuing role 
in connecting us with valuable sources of information. Other participants spoke on a non-
attribution basis; although we cannot acknowledge them by name, we deeply appreciate their 
candor, engagement, and deep expertise. 
At RAND, we thank Molly Mcintosh and Daniel Ginsberg, the director and associate 
director, respectively, of NDRI’s Personnel, Readiness, and Health Program, for their leader-
ship. We received helpful feedback and reviews from Al Robbert, Bradley Knopp, William 
Shelton, and Daniel Ginsberg during the project. Lawrese Brown provided helpful research 
support while this project was underway. Kim Schwartz assisted throughout, and RAND’s 
production team helped with editing and preparing the report for publication.

v
Summary
The Defense Contract Management Agency (DCMA) is the U.S. Department of War’s 
(DOW’s) lead organization for contract oversight, administration, and support, from pre-
award through closeout.1 In its contract management mission, DCMA plays three mutu-
ally reinforcing roles. First, the agency supports DOW warfighter lethality and readiness by 
enabling the timely delivery of supplies that span the full spectrum of military capabilities. 
Second, DCMA provides financial oversight for contract execution and delivery, ensuring 
effective stewardship and efficient use of taxpayer dollars. Third, DCMA is uniquely posi-
tioned to provide insight into the operation of the defense industrial base for national deci-
sionmakers, providing perspectives “from balance sheet to factory floor.”2
In fulfillment of these roles, DCMA has been modeling its manpower and workload with 
growing sophistication over the past ten years. This effort is providing increasingly more 
accurate and more actionable information to support budget requests, manpower allocations, 
and workload acceptance and assignment decisions. DCMA asked us to validate the accuracy 
and usefulness of the DCMA headquarters Integrated Workload Resource Model (IRWM), 
including its supporting function-specific Resource Workload Models (RWMs). In conduct-
ing this validation effort, our research and analysis focused on two key questions: 
•  Is DCMA accepting the highest-priority mission work, given current funding and staff-
ing levels?
•  Is DCMA doing work efficiently and to the appropriate standard of performance? 
We approached these questions from a tactical and a strategic perspective. The tactical 
analysis examined the inputs, assumptions, and outputs of the IRWM ecosystem, including 
its RWM components. The strategic analysis examined the IRWM in its operating context to 
assess its accuracy, relevance, and practical utility. To support these analyses, we reviewed 
DCMA artifacts and publicly available information and conducted semistructured inter-
views with more than 225 DCMA subject-matter experts to learn about the IRWM ecosys-
tem, including its structure, operations, and functions in real-world tasks. 
We found that the IRWM is grounded in best practices for manpower analysis. At the 
same time, stakeholders pointed to procedural shortfalls in how the model is developed, 
improved, and used and mentioned that model estimates diverge from reality on the ground. 
Our findings also indicated that the model ecosystem supports DCMA decisionmaking and 
operational improvement and that DCMA iteratively improves RWMs and the IRWM over 
1	 The Department of War is designated the Department of Defense under Public Law 81-216, National 
Security Act Amendments of 1949.
2	 DCMA, INSIGHT, 2025a, p. 2.

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
vi
time to address shortfalls. Considering these findings from our assessment, we arrived at 
three principal conclusions.
The IRWM and its component RWMs have short-term and longer-term benefits. 
The IRWM generates a solid point-in-time estimate of the number of DCMA personnel 
required to support a given contract management workload for the enterprise as a whole 
and for key workforce segments. The estimates are useful for planning and organizational 
decisionmaking. 
But the benefits of the IRWM go well beyond its ability to generate an estimate of work-
force requirements at any point in time based on existing internal and external factors. The 
modeling effort surfaces insights and prompts conversations, choices, and decisions that 
drive changes to workload distribution, DCMA policy and standard operating procedures, 
and organizational structures that have the potential to enhance efficiency and process 
improvement. Insights derived from the modeling effort can influence external factors, such 
as memorandums of agreement with customers. Another value of the IRWM is that it pro-
vides a road map to help DCMA understand the implications of changes to key factors for 
its workforce needs—changes to budget and authorized personnel levels, statute and regula-
tions, DOW policy and missions, and customer demands. 
Although it is continuously working to improve its modeling effort, DCMA lacks a 
clear structure for prioritizing model improvement efforts. The model does not aim to 
achieve universal predictive accuracy with its estimates, but there may be circumstances 
in which enhanced accuracy is desired. Improvements to model accuracy require addi-
tional personnel and budget beyond what is allocated to maintain the status quo. Existing 
staffing levels dedicated to this effort in DCMA headquarters are insufficient to maintain 
routine model validation and maintenance while incorporating adjustments to keep pace 
with significant changes in DCMA’s external and internal operating conditions. Formal 
documentation and standard operating procedures are not as robust as would be useful to 
those using the model. In the face of heightened demands and constrained staffing, it is 
important to have a rigorous framework for prioritizing and sequencing the work that can 
be accomplished based on a deliberate cost-benefit analysis. A repeatable, institutionalized 
process will ensure that model maintenance and improvement efforts continue at the speed 
and quality required for DCMA operations.
Finally, enhanced communication could improve transparency, trust, and accuracy. 
Internal and external communication about the model effort, its assumptions, and the ana-
lytical capabilities it facilitates have not been prioritized in the face of resource constraints. 
The lack of effective communication, particularly between the DCMA headquarters model-
ing team and functional model experts in the field, has created some degree of confusion and 
compromised trust. Moreover, existing feedback mechanisms are largely reliant on personal 
relationships and are insufficient to ensure collaboration among stakeholders throughout the 
IRWM ecosystem. Finally, better communication about model inputs and how they are used 
could help standardize the use of systems of record at the field level, improving accuracy.

Summary
vii
We recommend that DCMA take the following steps:
•  Formally document the processes used to develop the structure and function of the 
existing IRWM and component RWMs. This effort will bring further discipline and 
rigor to the modeling process, permit more-precise evaluation of model capabilities, and 
focus improvements where needed. 
•  Develop standard operating procedures for future model assessment and develop-
ment. These operating procedures should cover the entire IRWM and all the functional 
models on which it depends for inputs and validation. DCMA should develop, as part of 
this effort, an explicit plan to assess the efficiency and effectiveness of its data-capture 
systems, from automatic data-feeds to human-entered data, with an eye toward ensur-
ing completeness and timeliness while reducing the time and complexity of data entry.
•  Develop an actionable framework to prioritize and sequence model refinements and 
upgrades. A deliberate cost-benefit analysis should be done comprehensively once and 
repeated at relevant intervals. 
•  Improve internal communication about the IRWM ecosystem. Improved communi-
cation about the objectives and limitations of the IRWM and user-friendly resources 
will enhance the effectiveness of model use.
•  Actively leverage DCMA modeling efforts to support agency decisionmaking. We 
recommend that DCMA capitalize on the investment it has made in the IRWM by lever-
aging it more widely to support decisionmaking.
What does this analysis mean for DCMA? The IRWM is fit for its current purpose: pro-
viding an accurate-enough estimate of total aggregate work hours to inform agency-wide 
staffing and budget allocations. The recommendations presented here are aimed at improv-
ing model functionality, accuracy, and timeliness that, in turn, will allow DCMA to expand 
its return on investment by making use of the model for a wider variety of purposes. No 
model provides a perfect representation of what is being modeled. However, continued use 
and improvement of the model within a rigorous framework will clarify areas of alignment 
and divergence across field locations and functional activities. Attending to areas of diver-
gence will allow the model to offer a more accurate picture of day-to-day activities across the 
agency. The continuous development and documentation processes we propose will enable 
more–data-driven decisionmaking within DCMA, improve collaboration between head-
quarters and field elements, and help focus resources devoted to enhancements to the IRWM 
ecosystem where they can be the most beneficial.

ix
Contents
About This Report.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . iii
Summary.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . v
Figures and Table.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . xi
CHAPTER 1
Introduction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1
Background on the DCMA.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 2
Motivation for This Research. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 5
Research Methods. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 7
Organization of This Report. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 8
CHAPTER 2
Workload Modeling at DCMA.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 9
Characteristics of Workload Modeling.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 9
Is DCMA Accepting the Highest-Priority Mission Work? .. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 11
Is DCMA Doing Work Efficiently and to the Appropriate Standard of Performance?. . . . . . . 13
CHAPTER 3
Looking Under the Hood of the Integrated Resource Workload Model.. . . . . . . . . . . . . . . . . . . . . . . 15
Governance.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 15
Components.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 16
Structure of the Resource Workload Models. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 17
Generation of Total Estimated Workload in the RWMs. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 18
Generation of Total Estimated Manpower Requirements.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 22
DCMA Review and Validation of RWMs. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 23
CHAPTER 4
Enterprise-Level Observations of the Integrated Resource Workload Model. . . . . . . . . . . . . . . . . 25
The IRWM Is Grounded in Best Practices for Manpower Analysis. . . . . . . . . . . . . . . . . . . . . . . . . . . . . 25
Field-Level Stakeholders Have an Incomplete Understanding of Model Development, 
Improvement, and Use.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 28
Stakeholder Views on Why Model Estimates Diverge from Reality on the Ground. . . . . . . . . . 29
Model Ecosystem Supports DCMA Decisionmaking and Operational Improvement.. . . . . . . 31
DCMA Iteratively Improves RWMs and the IRWM over Time to Address Shortfalls.. . . . . . . 32
CHAPTER 5
Conclusions and Recommendations. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 33
Conclusions .. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 33
Recommendations.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 37
What This Means for DCMA. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 40

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
x
APPENDIXES
A. How Does DCMA Arrive at Its Required Manning?. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 41
B. In What Sequence and Priority Should DCMA Functions and Activities Be  
Modeled? . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 43
C. Modeling Can Help DCMA Determine the Optimal Balance of Mission and 
Reimbursable Work.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 47
D. How Can Contract Management Workload Be Quantified?.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 53
E. How Are Special Programs Modeled?. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 55
F. Methodological Approach. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 57
Abbreviations .. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 63
Bibliography . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 65

xi
Figures and Table
Figures
	
1.1.	
Continental U.S.-Based DCMA Administrative Alignment, Prior to  
October 5, 2025.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 4
	
1.2.	
Typical DCMA Contract Management Office Structure. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 5
	
1.3.	
DCMA Operational Command Structure, as of October 5, 2025. . . . . . . . . . . . . . . . . . . . . 6
	
2.1.	
DCMA IRWM Ecosystem.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 10
	
3.1.	
DCMA Resource Workload Models, as of FY 2023.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 17
	
5.1.	
DCMA IRWM: Dynamic Modeling Ecosystem.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 34
	
C.1.	
DCMA Workforce, FY 2008 to FY 2024. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 49
	
C.2.	
Reimbursable Positions as a Percentage of Total . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 50
Table
	
F.1.	
Contract Management Office Site Visits.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 61

1
CHAPTER 1
Introduction 
The core mission of the Defense Contract Management Agency (DCMA) is to provide over-
sight, administration, and support for the defense contracts that deliver the supplies and ser-
vices that are critical to U.S. Department of War (DOW) warfighting capabilities and busi-
ness operations.1 To accomplish this function, DCMA carries out three mutually supporting 
roles. First, the agency supports DOW warfighter lethality and readiness by enabling the 
timely delivery of supplies that span the full spectrum of military capabilities. For fiscal year 
(FY) 2024, DCMA supervised the manufacture and delivery of nearly 400 aircraft, approxi-
mately 6,100 combat vehicles, and close to 339,100 missiles and rockets—in addition to more 
than 300 million items shipped.2 
Second, DCMA provides financial oversight for contract execution and delivery, ensur-
ing effective stewardship and efficient use of taxpayer dollars. For FY 2024, the total value of 
DCMA-overseen items delivered was reportedly $81.4 billion; moreover, in FY 2024, DCMA 
reported savings, recovery, or cost-avoidance of approximately $9.3 billion against an annual 
budget of approximately $1.6 billion through such activities as litigation, cost and pricing 
actions, and cost rate settlements,3 representing a nearly six-to-one return on investment.4 
Personnel compensation for DCMA’s workforce represents nearly 84 percent of the agency’s 
noncyber budget request to Congress for FY 2026.5 
Third, DCMA is uniquely positioned to provide insight into the operations and health of 
the defense industrial base for national decisionmakers, with the broad spectrum of contracts 
it manages providing perspectives “from balance sheet to factory floor.”6 As of March 26, 
2025, DCMA reported nearly 10,000 civilian employees—of whom about 1,400 were support-
ing reimbursable workload—and slightly more than 500 military personnel located at nearly 
1	 The Department of War is designated the Department of Defense under Public Law 81-216, National 
Security Act Amendments of 1949.
2	 DCMA, INSIGHT, 2025a, pp. 5–6. 
3	 DCMA, 2025a, p. 12.
4	 DCMA, 2025a, p. 6; see also DCMA, Fiscal Year 2026 Budget Estimates: Defense Contract Management 
Agency, June 2025b, p. 2. 
5	 DCMA, 2025b, p. 2. 
6	 DCMA, 2025a, p. 2.

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
2
900 DCMA locations and serving approximately 17,750 contractor locations worldwide.7 
Also as of March 26, 2025, DCMA personnel were managing approximately 300,000 active 
contracts with a total contract value of approximately $5.9 trillion and processing $1 billion 
in contractor payments on an average business day.8 Approximately 85 percent of personnel 
are part of DOW’s acquisition workforce and occupy billets coded as such.9
Background on the DCMA
Mission and Functions
DCMA is one of the nonmilitary service agencies and field activities that provide central-
ized support functions to the entirety of DOW. In 2000, DCMA was chartered as a separate 
three-star U.S. Department of Defense (DoD) agency by DoD Directive 5105.64.10 DCMA 
incorporated the functions of its predecessor organization, the Defense Contract Manage-
ment Command, which had been created as a Defense Logistics Agency (DLA) subcommand 
in 1990 to centralize and consolidate certain contract management functions that had been 
performed by the military services up until that point.11 Although contract administration 
is the agency’s core mission, its responsibilities span the entire defense acquisition life cycle 
and include such activities as validation of cost accounting standards compliance for DOW 
contractors, commercial item determinations, quality assurance, equipment delivery, and 
sustainment support.12 DCMA supports the armed services; other defense agencies, such as 
DLA and the Missile Defense Agency; and certain nondefense agencies, such as the National 
Aeronautics and Space Administration (NASA). 
Beyond carrying out its assigned functions,13 DCMA’s other agency missions have evolved 
significantly in recent years. In May 2019, then–Under Secretary of Defense for Acquisition 
and Sustainment Ellen Lord authorized the expansion of DCMA’s mission areas, including 
7	 DCMA, 2025a, p. 4. The distinction between direct and reimbursable workload is discussed in more 
detail in Chapter 2 and Appendix C.
8	 DCMA, 2025a, p. 4.
9	 Susan M. Gates, Elizabeth A. Roth, and Jonas Kempf, Department of Defense Acquisition Workforce 
Analyses: Update Through Fiscal Year 2021, RAND Corporation, RR-A758-2, 2022; DCMA Unit Manning 
Report, provided to the authors by DCMA, August 5, 2024. 
10	 DoD Directive 5105.64, Defense Contract Management Agency (DCMA), U.S. Department of Defense, 
January 10, 2013, change 1, March 2, 2023. 
11	 Janet A. McDonnell, “A History of Defense Contract Administration,” Defense Contract Management 
Agency, March 5, 2020. 
12	 DCMA, “About DCMA,” webpage, undated. 
13	 As mandated by the Federal Acquisition Regulation (FAR), the Defense Federal Acquisition Regulation 
Supplement (DFARS), and other applicable DOW and DCMA policies and regulations.

Introduction
3
new authorities to carry out certain activities.14 This mission expansion permitted DCMA 
to provide contract administration services, on a reimbursable basis, to non-DOW agen-
cies (such as NASA) and other DOW functions, such as the foreign military sales program 
administered by the Defense Security Cooperation Agency. In some instances, this mission 
expansion resulted in the creation of new DCMA units, such as the Defense Industrial Base 
Cybersecurity Assessment Center. 
DCMA’s mission set continues to evolve and expand. For example, in July 2025, Secretary 
of War Pete Hegseth transferred responsibility to DCMA for the Blue List of DOW-approved 
commercial unmanned aircraft systems, as well as related components and software, that 
have been certified as lacking Chinese-manufactured elements.15 
Organization of Agency
Since its inception, DCMA has evolved to accomplish this continuously changing mission 
set. DCMA is headquartered in Fort Lee, Virginia, and is organized hierarchically around 
external mission work and internal support work. In March 2023, DCMA announced Vision 
2026—a plan to realign its workforce skills with customers’ specialized needs by evolving the 
agency’s organizational structure over three years. The plan aimed to address three issues: 
the “growing disconnect from the warfighters [DCMA] serves,” the increasingly special-
ized work of contract administration, and the budget constraints that have been imposed 
across DOW. The plan involved a reconfiguration of the offices through consolidation and 
realigned reporting structures, simplifying the major U.S. commands for DCMA down to 
two commands.16 The plan also established the DCMA Space Enterprise, which consolidates 
the agency’s work related to the U.S. Space Force and other federal agencies with contracts 
related to the space domain. 
During our assessment, the organizational structure of DCMA within the continental 
United States (omitting headquarters-level organizations) was as depicted in Figure 1.1. Each 
of the three regional commands was composed of numerous subordinate contract manage-
ment offices (CMOs), grouped by region or by purpose (e.g., DCMA Northeast and DCMA 
Space Enterprise). Contracts with large defense contractors are often managed by DCMA 
colocated in the contractors’ facilities; others are centrally managed by DCMA CMOs, which 
can deploy personnel to contractor locations as needed.
14	 Under Secretary of Defense for Acquisition and Sustainment, “Defense Contract Management Agency 
Mission Changes,” memorandum, U.S. Department of Defense, May 20, 2019.
15	 Pete Hegseth, “Unleashing U.S. Military Drone Dominance,” memorandum, U.S. Department of 
Defense, July 10, 2025; see also Carley Welch, “Pentagon Shifts Control of Blue UAS List to DCMA in Effort 
to Scale Secure Drone Fleet,” Breaking Defense, July 11, 2025. 
16	 Patrick Tremblay, “Vision 2026, ‘Structure by Choice,’” Defense Contract Management Agency, Octo-
ber 13, 2023.

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
4
Each CMO follows a similar mandatory organizational structure, with a Quality Assur-
ance Group, an Engineering/Manufacturing Group, and a Contracts Group (see Figure 1.2). 
Within each group, the structure may vary to account for local workload differences. 
During our study, DCMA was in the final stages of a large-scale reorganization that took 
effect on October 5, 2025. This realignment replaced the organizational structure depicted in 
Figure 1.1. To support traditional headquarters functions and geographically organized field 
activities, DCMA stood up two major U.S. continental commands: (1) Systems Command 
and (2) Geographic & Systems Support Command, with 11 and nine subordinate field activ-
ities, respectively. In addition, and not depicted here, DCMA created three headquarters-
based operational centers with mission-focused roles, such as learning, analytics and integra-
tion, and business. An overview of the new operational command structure is depicted in 
Figure 1.3.
DCMA field activities, which are focused on a particular function or type of system (such 
as Vertical Lift or Fixed Wing), are managed by the new Systems Command. Other functions 
and systems support are organized geographically under the Geographic & Systems Sup-
FIGURE 1.1
Continental U.S.-Based DCMA Administrative Alignment, Prior to October 5, 
2025
• DCMA Northeast 
• DCMA Mid-Atlantic
• DCMA Southeast
• DCMA Radar and Sensors
• DCMA Springfield
• DCMA Aircraft Propulsion Operations
• DCMA Naval Special Emphasis Operations
DCMA Eastern Regional Command HQ: 
Boston, Massachusetts
• DCMA South
• DCMA Land Systems
• DCMA Ohio River Valley
• DCMA Great Lakes
• DCMA Great Plains
• DCMA Vertical Lift
• DCMA Fixed Wing
DCMA Central Regional Command HQ: 
Chicago, Illinois
• DCMA Southern California
• DCMA Mountain Pacific
• DCMA Space Enterprise
• DCMA Missiles
• DCMA Palmdale
• DCMA NASA Product Operations
DCMA Western Regional Command HQ: 
Carson, California
• AIMO Eglin
• AIMO Greenville
• AIMO San Antonio
• AIMO North Texas
• AIMO Oklahoma City
• AIMO St. Augustine
DCMA Aircraft Integrated Maintenance 
Operations HQ: St. Augustine, Florida 
SOURCE: Features information provided by DCMA.
NOTE: AIMO = Aircraft Integrated Maintenance Operations; HQ = headquarters.

Introduction
5
port Command. For example, under the reorganization, the Fixed Wing CMO falls under 
DCMA Systems Command instead of Central Regional Command. This functional struc-
ture is intended to enhance automation, information-sharing, and oversight for major pro-
grams and their supply chains. Although the reporting structures change, the internal orga-
nizational structure of most CMOs will likely remain largely unchanged under the broader 
realignment of DCMA operations, at least in the short term.17
Motivation for This Research
Making attempts to ensure efficient and effective centralization and professionalization of its 
personnel has been a consistent theme in DCMA’s history. Over time, DCMA’s civilian work-
force (and DOW’s civilian workforce more generally) has expanded and contracted, with its 
workforce shrinking during periods when the priority was the perceived savings from uni-
formly cutting the civilian workforce across DOW and expanding when the effects of these 
contractions were perceived as reducing the timeliness, quality, and quantity of materiel pro-
vided to the warfighter and reducing savings and cost avoidance by an agency that generates 
many times its annual budget in such savings.18 
In 2014, DCMA launched a resource workload modeling effort with the potential to pro-
vide better data to inform these trade-offs. The modeling effort has grown and evolved since 
17	 Tonya Johnson, “DCMA Stands Up New CMOs,” Defense Contract Management Agency, July 3, 2025.
18	 Gates, Roth, and Kempf, 2022; Susan M. Gates, Shining a Spotlight on the Defense Acquisition Workforce—
Again, RAND Corporation, OP-266-OSD, 2009. 
FIGURE 1.2
Typical DCMA Contract Management Office Structure
SOURCE: Features information provided by DCMA.
Quality Assurance Group
Commander/Director
Engineering/Manufacturing 
Group
Contracts Group
Mandatory structure
Quality Assurance 
Team
Engineering
Team
Manufacturing
Team
Contracts
Team
Flexible—based 
on workload

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
6
then, helping DCMA size and shape its workforce to maximize its efficiency and effective-
ness. DCMA developed, as part of this work, detailed manpower models that depict most—
but not all—of the personnel requirements associated with DCMA activities. 
DOW directed DCMA to commission an independent, comprehensive assessment of 
the process by which estimates of manpower requirements for core functions are generated. 
DCMA contracted with RAND to provide that assessment, along with options for further 
improving the model. To complete the assessment, we evaluated the FY 2023 update (referred 
to as version 2.0) of DCMA’s Integrated Resource Workload Model (IRWM), its subcompo-
nent models, and the ecosystem in which the IRWM operates. The IRWM develops estimates 
of the annual DCMA workload and the number of full-time equivalent (FTE) personnel nec-
essary to carry out that workload. The first version of the IRWM was developed in FY 2022; 
the IRWM has had two subsequent updates in FY 2023 and FY 2024. IRWM version 3.0 was 
under development at the time our project began and was not released until June 2025, near 
FIGURE 1.3
DCMA Operational Command Structure, as of October 5, 2025
• DCMA Geographic and Systems Support Command
• DCMA Systems Command
• DCMA Cost and Pricing Command (six offices)
• DCMA International Command (three offices)
• DCMA Special Programs Command (four offices)
DCMA Operational Commands (effective October 2025)
• DCMA Northeast
• DCMA Mid-Atlantic
• DCMA Southeast
• DCMA South
• DCMA Ohio River Valley
• DCMA Great Lakes
• DCMA Southern California
• DCMA Mountain Pacific
DCMA Geographic and Systems 
Support Command
• DCMA Space Enterprise
• DCMA Radars and Sensors
• DCMA Missiles
• DCMA Land Systems
• DCMA Vertical Lift
• DCMA Fixed Wing
• DCMA Conventional Munitions
• DCMA Aircraft Propulsion Operations
• DCMA NASA Product Operations
• DCMA Naval Special Emphasis Operations
• DCMA Aircraft Integrated Maintenance 
Operations
DCMA Systems Command
SOURCE: Features information provided by DCMA.

Introduction
7
the completion of our work. The development of this integrated model followed the develop-
ment of the subcomponent workload models, some of which were created as early as 2019. 
Research Methods
Our research focused on the IRWM’s ability to shed light on two key questions of interest to 
DCMA and DOW leaders: 
•  Is DCMA accepting the highest-priority mission work, given current funding and staff-
ing levels?
•  Is DCMA doing work efficiently and to the appropriate standard of performance?
As we began our research, it became clear that there would be two dimensions to our 
analysis: one tactical and the other strategic. The tactical analysis examined the structure and 
function of the IRWM ecosystem and its Resource Workload Model (RWM) components. 
The strategic analysis examined the IRWM in its operating context to assess its accuracy, 
relevance, and practical utility. This broader analysis involved not only the other models 
at work in DCMA but also a review of how they functioned together to support real-world 
DCMA activities. Additional details of the tactical and strategic validation methodology are 
provided in Appendix F. 
We reviewed version 2.0 of the IRWM and component RWMs that used modeling param-
eters and data inputs to project DCMA’s workload for FY 2023. In some cases, these projec-
tions were derived using historical inputs—i.e., data from FY 2022. Our review focused on 
determining the model’s effectiveness at that point in time and examining options for poten-
tial improvement. This work included a review of both qualitative and quantitative materials, 
including DCMA-internal artifacts (such as Authoritative Process List library, Unit Manning 
Documents, and Work Breakdown Structure) and publicly available information. 
To support both the tactical and strategic analysis, we conducted semistructured inter-
views with DCMA subject-matter experts (SMEs) using protocols informed by the artifact 
review. The discussions were meant to elicit detailed insights into the construction and func-
tion of the IRWM ecosystem, how the IRWM operates in practice, its alignment with mission 
objectives, alignment between modeled tasks and performed tasks, validity of model assump-
tions, quality of data inputs, and the model’s usefulness for decisionmaking and for staffing, 
planning, and oversight. 
To inform the tactical validation effort, we interviewed SMEs responsible for developing 
each model component. We conducted 15 virtual interviews and one in-person interview 
involving approximately 75 DCMA personnel in total. For the strategic validation, we con-
ducted interviews with supervisory staff across a representative mix of CMOs, consisting of 
four geographic offices, four Product Line units, and one Special Programs location. We also 
interviewed supervisory staff from DCMA International. We conducted 34 in-person inter-
views and 11 virtual interviews with DCMA personnel. Each interview averaged approxi-

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
8
mately five participants, amounting to roughly 154 total personnel across the strategic vali-
dation. Together, these discussions explored how the RWMs align with real-world tasks and 
organizational structures. Data from these interviews were analyzed thematically, which is 
discussed in more detail in Appendix F. 
Limitations and Caveats
The IRWM ecosystem is dynamic and subject to ongoing improvement. At the time our 
assessment began in July 2024, DCMA was using IRWM version 2.0 while finalizing and val-
idating IRWM version 3.0. Because the updated version of the IRWM was not released for use 
until June 2025, our validation effort focused on version 2.0; therefore, some of our findings 
may no longer apply, and some of our recommendations may have already been implemented. 
Our analysis of Unit Manning Report (UMR) data is based on a September 2024 UMR. 
For purposes of historical comparison, we also obtained and analyzed the September 2015 
UMR. Both were provided to us by DCMA. We began outreach for our data collection inter-
views in October 2024, and the bulk of interviews took place between November 2024 and 
July 2025. Most interviewees had a long tenure with DCMA and, in some cases, with the 
organizational unit they represented. Several interviewees were filling multiple roles simul-
taneously and participated in more than one interview or conversation.
Because DCMA was implementing structural changes to its organization during our study 
period, the organizational structure as reflected in IRWM version 2.0 (or reflected in the Sep-
tember 2024 UMR), which was the focus of our review, was not fully aligned with the orga-
nizational structure in place at the time of our interviews. For example, many small CMOs 
in existence in FY 2023 had been combined under a revised command reporting structure by 
the time of our interviews. 
Organization of This Report
This report contains four substantive chapters, as follows: 
•  In Chapter 2, we describe the IRWM ecosystem and explain how it promotes efforts to 
ensure that DCMA is accepting the highest-priority mission work and that it is accom-
plishing that work efficiently and to the appropriate standard of performance. 
•  In Chapter 3, we provide the results of the tactical validation of the functions and output 
of the IRWM. 
•  In Chapter 4, we take a broader view of the combined validation efforts and provide 
enterprise-level observations. 
•  In Chapter 5, we present conclusions and recommendations based on our research. 
The report contains six appendixes. The first five, Appendix A through Appendix E, 
address focused questions about the DCMA operations that relate to or can be informed by 
IRWM functionality. Appendix F contains additional detail on the methods used in this study.

9
CHAPTER 2
Workload Modeling at DCMA
Workforce analysis allows organizations to compare workforce demand with workforce 
supply and assess whether they have the right number of people.1 Workload modeling tech-
niques help organizations estimate their manpower requirements or demand.2 Around 2014, 
DCMA embarked on a journey to develop a formal RWM infrastructure that could inform 
resource allocation, planning, process improvement, and other strategic organizational deci-
sions, including those that could advance efficiency and effectiveness in the short and longer 
term. This infrastructure is known as the IRWM, and its estimates of manpower require-
ments are based on assumptions and available data. Like any workload model, the IRWM 
generates an estimate of how many people DCMA needs to achieve its mission. 
Characteristics of Workload Modeling
DCMA documentation about the development of the IRWM ecosystem emphasizes that the 
IRWM provides foundational, relatively objective data in support of organizational planning 
and decisionmaking and is not intended to be used to generate a “final answer” for appro-
priate DCMA manning levels. Because the operating context is constantly changing, the 
number of required workers is not fixed or static. At any point in time, this number depends 
on the work DCMA is asked to do and how it does that work. 
When embarking on a resource workload modeling effort, an organization’s starting point 
is the status quo. The organization knows what work it is doing, how it is doing that work, and 
how many people it employs to accomplish that workload. For a large organization execut-
ing similar functions in a variety of contexts (such as DCMA), resource workload modeling 
drives consistency by insisting on common definitions of tasks, task times, and standards of 
performance, as well as authoritative sources of data about task frequency and performance. 
1	 Shanthi Nataraj, Christopher Guo, Philip Hall-Partyka, Susan M. Gates, and Douglas Yeung, Options for 
Department of Defense Total Workforce Supply and Demand Analysis: Potential Approaches and Available 
Data Sources, RAND Corporation, RR-543-OSD, 2014. 
2	 Albert A. Robbert, Avery Calkins, and Louis T. Mariano, Modeling for Manpower and Personnel Policy 
Analysis: Applications in RAND Research, RAND Corporation, TL-A3401-1, 2024.

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
10
The standard approach used to develop workload models involves documenting core mis-
sions, enumerating enduring functions or processes used to produce mission-related outputs, 
decomposing them into specified and implied tasks, gathering data on the number of times 
the task is performed and the time it takes to perform each task, using task and task time 
information to calculate overall workload, and calculating the FTE staffing required to meet 
this workload.3 Such modeling efforts focus on output-oriented tasks but include an allow-
ance for tasks not linked directly to customer deliverables, such as supervisory and overhead. 
Organizations may seek to model overhead activities—such as human resources, information 
technology, and financial management functions—in addition to activities associated with 
core missions.4 Decisions to model overhead activities are informed by cost-benefit trade-offs. 
As illustrated in Figure 2.1, the IRWM ecosystem translates information about DCMA’s 
workload into an estimate of the required workforce based on the current process of con-
ducting work. However, the IRWM does not exist in a vacuum. It is embedded in a dynamic 
3	 Robbert, Calkins, and Mariano, 2024, Ch. 11; Air Force Manual 38-102, Manpower and Organization 
Standard Work Processes and Procedures, Department of the Air Force, updated July 5, 2024.
4	 David Schulker, Nelson Lim, and Albert A. Robbert, Determining Staffing Needs for Administrative, Pro-
fessional, and Technical Workers in the U.S. Secret Service: Methods and Lessons Learned, Homeland Secu-
rity Operational Analysis Center operated by the RAND Corporation, RR-3206-DHS, 2020. The U.S. Secret 
Service was using a standard ratio of one administrative, professional, and technical worker per 2.5 law 
enforcement employees. 
FIGURE 2.1
DCMA IRWM Ecosystem
IRWM 
ecosystem
External factors
Internal factors
Workload
Standards
Required workforce

Workload Modeling at DCMA
11
modeling ecosystem. Factors internal and external to DCMA influence both workload and 
how the work is performed. Those internal and external factors change over time, partly 
because of exogenous events but also in response to insights generated through the model-
ing process itself. The process of modeling workload and how it is performed (i.e., standards) 
generates insights that inform process improvement and other changes to the organization. 
In this chapter, we describe DCMA’s IRWM ecosystem; the factors that influence it; and how, 
in theory, the RWM ecosystem can help DCMA and DOW leadership address the core ques-
tions articulated in Chapter 1: 
•  Is DCMA accepting the highest-priority mission work? 
•  Is DCMA doing work efficiently and to the appropriate standard of performance?
Is DCMA Accepting the Highest-Priority Mission Work? 
Numerous factors influence the work the agency does, including legislative, regulatory, and 
policy drivers; resources; and other factors internal to DCMA.
Legislative, Regulatory and Policy Drivers
Most simply, DCMA performs contract management and oversight activities spanning the 
acquisition life cycle for DOW and for other federal agencies, foreign governments, and inter-
national organizations. DCMA’s mission is derived, in part, from Title 10 and Title 41 of 
the U.S. Code, as implemented by such regulations as Section 42.302(a) of the FAR and Sec-
tion 242.302(a) of the DFARS. Together with DOW issuances, such as DoD Directive 5105.64, 
these policies and regulations outline the work that DCMA must do and the work it is allowed 
to do. For example, DFARS 242.202(a) specifies functions or activities for which contract 
administration must be retained by DOW buying organizations (e.g., those DOW entities 
looking to obtain goods or services through a contract instrument) and cannot be transferred 
to DCMA. Examples include university-based research and development, communications 
services, and airlift and sealift services. 
These regulations and directives establish the scope of practice for DCMA. They also out-
line where buying organizations have some flexibility to manage contracts on their own or 
in collaboration with DCMA based on the features and characteristics of the contract. More 
broadly, DOW buying commands may engage DCMA to provide contract administration 
and related support. However, certain activities must be performed by DCMA on behalf of 
the entirety of the department, such as evaluating whether contractors’ cost accounting sys-
tems are compliant with Part 30 of the FAR or whether contractors’ cybersecurity risk mitiga-
tion mechanisms are compliant with applicable DFARS clauses.5
5	 DFARS, Part 252, Solicitation Provisions and Contract Clauses; Section 252.204-7012, Safeguarding 
Covered Defense Information and Cyber Incident Reporting; Ron Ross and Victoria Pillitteri, Protecting

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
12
DCMA is expected to prioritize workload associated with high-value and high-risk con-
tracts over low-value and low-risk contracts and to prioritize work that involves specialized 
contract oversight expertise. 
Resources
DCMA is funded through a mix of direct congressional appropriations that fund core mis-
sion workload and reimbursable funds that support noncore workload for DOW customers 
and work for other U.S. federal organizations, such as NASA, the Department of Homeland 
Security, and the Department of State, as well as foreign governments and organizations. 
DCMA’s combined noncyber and cyber operations and maintenance budgets for FY 2024 
totaled $1.59 billion; the combined budget request for FY 2026 was $1.48 billion.6 Personnel 
costs account for about 85 percent of DCMA’s budget, so workforce size is a helpful indicator 
of resource availability. Since 2008, DCMA’s military workforce has been between 440 and 
640 positions, with no clear trend. In contrast, DCMA’s civilian workforce grew from about 
9,500 in 2008 to more than 12,000 in 2015 amid a DOW-wide effort to grow and enhance 
the quality of its acquisition workforce (of which 85 percent of DCMA’s workforce is a part). 
Since 2015, the civilian workforce has steadily declined to 10,168 in FY 2024. At the same 
time, reimbursable workload has accounted for a growing share of DCMA’s funding (see 
Appendix C). In FY 2008, the share of civilian workforce supported by reimbursable funding 
sources stood at just under 9 percent. In FY 2024, reimbursable funding sources supported 
over 14 percent of civilian positions, with the possibility of further increases to 17 percent by 
FY 2026. 
Factors Internal to DCMA
As a combat support agency, DCMA’s work responds to the needs of other organizations. 
DCMA relies on its employees to manage and prioritize work requests.7 DCMA policies, 
procedures, and manuals establish guardrails for those decisions and dispute resolution pro-
cedures when DCMA and customers disagree. The workload acceptance process for mis-
sion work is outlined in DCMA Manual 4502-02.8 It requires DCMA employees to consider 
five criteria when reviewing a work request. The process is designed to ensure that DCMA 
Controlled Unclassified Information in Nonfederal Systems and Organizations, National Institute of Stan-
dards and Technology, Special Publication 800-171r3, May 2024; DFARS, Part 252, Solicitation Provisions 
and Contract Clauses; Section 252.204-7020, NIST SP 800-171 DoD Assessment Requirements.
6	 DCMA, 2025b; DCMA, Fiscal Year 2026 Budget Estimates: Defense Contract Management Agency Cyber, 
June 2025c. 
7	 DCMA, “DCMA Tailorable Contract Administration Services (CAS),” briefing slides, February 14, 
2023a. 
8	 DCMA Manual 4502-02, Workload Acceptance, Defense Contract Management Agency, September 15, 
2021; DCMA, “DCMA Workload Acceptance (WA) Overview,” briefing slides, February 14, 2023b.

Workload Modeling at DCMA
13
is accepting work it is authorized to perform and that it is effectively prioritizing workload 
within available resources. Four of the five workload acceptance criteria are grounded in 
regulation and policy. The fifth, whether the work meets high-value and high-risk thresholds 
or characteristics, is detailed in several manuals, instructions, and job aids. 
Work acceptance for reimbursable work is governed by DCMA Manual 4301-12.9 DCMA 
can only accept reimbursable work that falls under an approved support agreement or other 
form of documentation (e.g., for Foreign Military Sales programs, Building Partner Capacity 
programs, and Direct Commercial Sales programs). The manual outlines general expecta-
tions for budgeting, manpower estimation, and time-recording for reimbursable work. These 
expectations require DCMA to estimate the number of hours required to perform the task 
and record time spent on reimbursable work in the Defense Agencies Initiative system.
Is DCMA Doing Work Efficiently and to the Appropriate 
Standard of Performance?
Performance expectations for DCMA are rooted in the FAR and DFARS, which articulate 
detailed oversight provisions for government contracts. Although some (but by no means 
all) of the regulatory provisions are grounded in statute—and the FAR is actively under revi-
sion to streamline and simplify its requirements,10 in part by eliminating non–statutorily 
based rules—they effectively define the responsibilities and actions to be taken by contract 
administration authorities, including DCMA. DCMA instructions, manuals, and job aids 
are issued to provide guidance to employees about the performance expectations for specific 
functions conducted by DCMA. 
As described in DCMA Manual 4501-01, instructions outline high-level responsibilities 
related to key processes, whereas manuals provide more detail, including step-by-step instruc-
tions. To support further standardization and alignment across the organization, DCMA 
also publishes guidebooks, business rules and practices, and job aids on specific topics as 
needed. These publications provide standard operating procedures that help employees inter-
pret statutory and regulatory responsibilities for the full range of DCMA functions. They are 
updated regularly to reflect the changing statutory and regulatory landscape.11 In addition to 
9	 DCMA Manual 4301-12, Reimbursable Programs, Defense Contract Management Agency, April 8, 2024.
10	 General Services Administration, “Policy & Guidance,” webpage, Acquisition.gov, undated. 
11	 Executive Order 14275 mandates an extensive review of the FAR and the DFARS to eliminate provi-
sions that are not strictly required by law in order to promote mission efficiency and value to stakeholders. 
Experts have argued that another key component to improving defense acquisition is adjusting the incen-
tives for the defense acquisition workforce to encourage and support more risk-taking. See Ronald J. Fox, 
Defense Acquisition Reform, 1960–2009: An Elusive Goal, U.S. Army Center of Military History, 2011; Ryan 
Evans, “An Early, Easy, and Essential Win for Trump on Defense Acquisitions Is Within Reach,” War on 
the Rocks, January 27, 2025; and Thomas C. Bruneau, “It’s All About Incentives—Lessons for DoD Acquisi-
tions,” Defense Acquisition Magazine, May–June 2025.

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
14
supporting compliance with statutory and regulatory requirements, DCMA’s standard oper-
ating procedures can help DCMA employees navigate situations in which customer requests 
might exceed the typical standard of performance.12 
In an organization that executes a similar workload in a variety of locations (such as 
DCMA), information about workload and the time it takes to execute it can be used both 
strategically and tactically.13 Data showing that different teams take different amounts of 
time to complete similar tasks can prompt information-sharing about best practices, includ-
ing updates to business rules and job aids. Historical information on the amount of time it 
takes, on average, for teams to complete tasks can be used in conjunction with projections 
of future workload for staff planning purposes, budget allocation, and Future Year Defense 
Plan forecasts. Then, data on actual workload and its deviation from projections can be used 
for workload balancing decisions in real time. In the longer term, the data can feed into orga-
nizational restructuring decisions and can allow an organization to identify impacts (e.g., 
trade-offs in terms of cost and benefits) from changes to ecosystem inputs, such as policy, 
tools, and training. 
12	 A 2011 report from the U.S. Government Accountability Office found that DCMA’s efforts in the first 
decade of the millennium to prioritize responsiveness to the buying organizations within DOW that are 
DCMA’s “customers” through extensive decentralization and customer-focused metrics led to inefficien-
cies. The report noted that, during that time, DCMA’s internal policies, procedures, and process manu-
als became less prescriptive, allowing for more customer-focused tailoring at the CMO level. See John P. 
Hutton, Defense Contract Management Agency: Amid Ongoing Efforts to Rebuild Capacity, Several Factors 
Present Challenges in Meeting Its Missions, U.S. Government Accountability Office, GAO-12-83, November 
2011. 
13	 See Dan L. Ward, Rob Tripp, and Bill Maki, Positioned: Strategic Workforce Planning That Gets the Right 
Person in the Right Job, American Management Association, 2013.

15
CHAPTER 3
Looking Under the Hood of the Integrated 
Resource Workload Model
As mentioned in Chapter 1, we used two axes of validation—tactical and strategic—to review 
the effectiveness of the version 2.0 instantiation of the IRWM ecosystem. The tactical axis 
involved a close analysis of the inputs, assumptions, and outputs of the model, checking for 
internal consistency and evaluating whether the IRWM and its component models produced 
facially valid results. It also involved investigating how the IRWM and its RWM components 
were developed. With this validation process, we considered and assessed such factors as
•  whether and how tasks are associated with assigned missions and objective workload 
drivers
•  whether and how task time estimates are developed and validated
•  whether and how manpower availability factor calculations were determined
•  the identification of workload that is and is not modeled by the RWMs, as feasible. 
The strategic validation focused on three core concerns: (1) aspects of the workload that 
are and are not represented in the model; (2) how supervisory personnel perceive the valid-
ity of the model’s inputs, processes, and outputs; and (3) the extent to which model results 
are used and how they could be applied to support management and decisionmaking. In the 
strategic validation, we mapped the IRWM ecosystem, analyzing the incorporated functional 
RWMs that depict frontline work and that, to a certain degree, supported and informed the 
development of the integrated model.
We report the results of these assessments in two parts. This chapter documents what we 
learned about the models in the IRWM ecosystem and their functionality, primarily through 
the tactical validation lens. In the next chapter, we discuss broader observations gleaned from 
the combined results of the tactical and strategic validation efforts. 
Governance
The IRWM is intended to inform manpower decisionmaking and related resourcing deci-
sions for DCMA. During the period covered by our review, the IRWM was overseen by the

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
16
Executive Director of the DCMA headquarters–level Technical Directorate.1 The Executive 
Director, Financial and Business Operations/Comptroller, had ownership of the RWM pro-
gram, with SMEs at varying agency levels assigned responsibility for model development, 
creation of taxonomies defining associated tasks and task times, engagement with SMEs 
to generate task time estimates, and compilation of individual models for inclusion in the 
IRWM. For example, Headquarters-level staff had responsibility for developing the enter-
prise CMO-level models depicted in Figure 3.1, whereas center-level and Cost and Pricing 
Command–level staff had responsibility for developing models depicting each component of 
the Cost and Pricing Command’s activities. 
Components
The IRWM ecosystem is composed of two main parts: the Integrated Model (IM) and the 
RWMs. The IM is an interactive Microsoft PowerBI dashboard that compiles the RWMs, 
additional datasets that depict certain categories of work not included in the RWMs (referred 
to as unmodeled work for the purposes of the IRWM), and other information. The IM dash-
board provides an overview of the workload and associated manpower resourcing for mod-
eled and unmodeled DCMA mission functions and allows DCMA to compare mission 
function FTE estimates (as generated through the RWMs and other mechanisms) with data 
derived from DCMA’s use of the Fourth Estate Manpower Tracking System (FMTS).2
FMTS data can be used to determine the number of DCMA-authorized and on-board 
FTEs and allows the IM to be used to identify any deltas between the FMTS-generated FTE 
authorization and the number of FTEs predicted by the RWM models (or related datasets 
estimating FTEs for certain categories of unmodeled activities) as needed to carry out DCMA 
mission functions. DCMA defines an FTE as the number of straight-line hours worked (not 
including overtime or holiday hours worked but including annual leave and other categories 
of leave for the purposes of defining FTE employment) divided by the number of compen-
sable hours in a given fiscal year.3 
Because the IM includes position-based and function-based FTE numbers, the model 
allows users to isolate and compare manning levels for DCMA CMOs and other locations 
by mission function (e.g., comparing between DCMA East and DCMA West the number of 
affiliated FTEs on-board and derived from the RWM model to carry out quality assurance 
tasks within a CMO).
1	 DCMA Manual 4301-10, Resource Workload Model (RWM) Integrated Model, draft, Defense Contract 
Management Agency, undated, Not available to the general public.
2	 DCMA Manual 4301-09, Manpower and Mission Analysis, Defense Contract Management Agency, 
July 15, 2019.
3	 DCMA Manual 4301-02, Volume 2, Budget Formulation and Execution: Budget Execution, Defense Con-
tract Management Agency, April 8, 2024.

Looking Under the Hood of the Integrated Resource Workload Model
17
FIGURE 3.1
DCMA Resource Workload Models, as of FY 2023
• Contracting
• Engineering
• Earned Value Management
• Industrial Specialist
• Program Integration
• Support Program Integration
• Quality Assurance
• Software
Enterprise CMO level
IRWM 
ecosystem
NOTE: RWMs depicted reflect components and functions in operation prior to DCMA’s October 2025 
reorganization.
Structure of the Resource Workload Models
The RWMs included in version 2.0 of the IRWM that we reviewed are shown in Figure 3.1. 
Each RWM is generally aligned with the internal DCMA processes that are carried out in 
support of contract administration (e.g., contracting, quality assurance) at CMOs or carried 
• Contract Lifecycle Management Center
• Small Business Center
• Defense Industrial Base Cybersecurity
Analysis Center
• Logistics Center
DCMA mission centers
• Property
• Pricing
• Divisional Administrative Contracting
Officer (DACO)
• Corporate Administrative Contracting
Officer (CACO)
Special Programs—Local
• Contracting
• Engineering
• Earned Value Management
• Industrial Specialist
• Program Integration
• Support Program Integration
• Quality Assurance
• Software
Special Programs—Technical
• Division A—Pricing
• Division B—Tools and Analysis Group
• Division C—Commercial Items Group
• Division E—Earned Value Management
Systems Group
• Division H—CACO/DACO Division
• Division I—Specialty Pricing Group
Cost and Pricing Regional Command

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
18
out by other DCMA mission functions (e.g., the Contract Lifecycle Management Center or 
Cost and Pricing Command). 
Version 2.0 of the RWMs included the following broad categories of models that are asso-
ciated with different types of workload, all of which estimate total workload in terms of task 
hours: 
•  Functional models at the enterprise CMO level depict mission functions associated with 
the operation of contract administration activities at CMOs across DCMA, with each 
model developed separately by a SME (generally a different SME for each functional 
model, although the closely aligned Program Integration and Support Program Integra-
tion RWMs were developed by the same SME) and reflective of comparable but unique 
modeling parameters and assumptions. 
•  Parallel RWM models—referred to as Special Programs—are maintained in support 
of DCMA’s contract administration work for classified and restricted programs (see 
Appendix E for an expanded discussion of the Special Programs models). Compared 
with the RWMs for the equivalent functions at the enterprise CMO level, these models 
are derived from separate sources of data, modeling parameters, and assumptions. 
•  Functional models for DCMA mission centers are reflective of all work taking place 
within a single mission center. Each mission center model is developed separately by 
a different SME and is likewise reflective of unique modeling parameters and assump-
tions.
•  The Cost and Pricing Command model is composed of six submodels, each reflective of a 
category of mission functions executed by the command (e.g., cost and pricing analysis 
on behalf of DOW). Although each submodel is developed separately by a different SME 
(or group of SMEs), a supervisory SME is responsible for compiling the six submodels 
into a single model depicting all Cost and Pricing Command activities. Each submodel 
uses common modeling parameters and assumptions to facilitate this roll-up of mod-
eled organizational activities.
Generation of Total Estimated Workload in the RWMs
RWMs of all categories estimate total workload in terms of task hours derived from the 
number and length of completed tasks that comprise the work of an enterprise CMO func-
tion, mission center, or command. In other words, the RWM calculates the following: 
(Task Count) × (Task Time Duration) = Task Hours.4
4	 DCMA Manual 4301-10, undated.

Looking Under the Hood of the Integrated Resource Workload Model
19
RWM task counts are composed of two elements: identified tasks, which are derived in 
part from the respective function, mission center, or command’s work breakdown struc-
ture (WBS), and the frequency with which tasks are performed.5 The WBS is a taxonomy of 
DCMA’s mission essential tasks. Tasks reflected in the WBS have been disaggregated until 
associated work can be clearly defined (e.g., “commercial item financing” is a discrete task 
within the general category of “payment support” under the Contracting RWM) to the level 
at which associated task time measures or estimates can be derived. WBS task components 
are also directly linked to (1) DCMA policies documenting the regulatory or policy driver 
associated with each task component and (2) the agency’s Authoritative Process List, which 
maps and documents the processes that DCMA executes in carrying out its mission.6 Where 
possible, each task in the WBS is linked to an agency source of record for associated data (e.g., 
the Product Data Reporting and Evaluation Program [PDREP], which tracks such activities 
as corrective action requests and surveillance planning7) that can be used to derive a mea-
sure or estimate of the associated frequency of tasks: the total number of times the task was 
executed over a period (generally 12 months for the purposes of the models). 
Within each RWM, task time durations are linked to each task depicted in the WBS. An 
estimated duration for a task is assigned by the respective SME for the associated RWM after 
it has been reconciled across the enterprise and depicts a should-take, or the amount of time 
it should take to complete one instance of the task as defined.8 RWM SMEs interpret how 
to define should-take in several ways, as discussed later in this chapter. In some instances, 
should-takes include a complexity weight to account for differences in executing the same 
task based on such factors as the dollar value of the associated contract (e.g., to account for 
quality assurance tasks associated with a high dollar value contract taking longer than the 
same tasks associated with a lower dollar value contract).
Together, the task count and task time duration yield the total task hours associated with 
the execution of particular tasks and task components depicted in the WBS (e.g., the total 
amount of time associated with the execution of all “commercial item financing” tasks as a 
subset of “payment support” tasks, as well as the total amount of time associated with the exe-
cution of all payment support tasks within the Contracting RWM). This calculation allows 
for the estimation of the total FTE workload associated with a particular function, mission 
center, or command (e.g., the total amount of time associated with all activities depicted in 
the Contracting RWM for the entirety of DCMA).
One key difference in the generation of estimated workload in the RWMs is the treatment 
of workload in the Special Programs models. Because the depicted workload is associated 
5	 DCMA Manual 4301-10, undated.
6	 DCMA Manual 4301-10, undated.
7	 Phil Wedgie, “PDREP Innovates Agency Business,” Defense Contract Management Agency, Decem-
ber 21, 2022. 
8	 DCMA Manual 4301-10, undated.

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
20
with classified or sensitive programs, which do not use the same unclassified agency sources 
of record as the other models in the IRWM ecosystem, the Special Programs models derive 
depicted task counts and associated task time durations from several data sources, such as 
key contractual requirements—or specifications that a contractor must successfully address 
in order to carry out the terms of the contract—and the risk levels associated with contracts 
administered by the Special Programs.9 The Special Programs models are discussed further 
in Appendix E.
Treatment of Supervisory and Unmodeled Workload
The IRWM also includes other workload data intended to estimate and account for man-
power requirements associated with certain components of the agency’s workload that are 
not modeled in the RWMs, such as administrative functions, supervisory work, and some 
types of reimbursable work DCMA performs for other entities (as referenced in Chapter 1).10 
These workload data are not as granular as the data represented in the RWMs and generally 
are tied to authorized personnel levels for certain functions, such as the reimbursable work 
performed for NASA, role-modeled and union staff positions, NASA Product operations, the 
work of the DCMA Navy Special Emphasis Operations Contract Management Office, and 
AIMO.11 Data intended to represent the workload associated with supervisory functions are 
estimated with a ratio of one supervisor to every ten nonsupervisory personnel, as derived 
from FMTS and the Defense Civilian Personnel Data System.12
This methodology is used because the associated tasks are not or cannot be included in 
the WBS. In some instances, DCMA chose not to include certain categories of work in the 
WBS (for example, NASA reimbursable work), in part to understand the variances in agency 
workload associated with certain categories of similar work, such as unaggregated reimburs-
able and nonreimbursable quality assurance work. In other instances, the lack of an agency 
source of record for associated task count data (for example, supervisory work that, while 
critical to DCMA operations, is not easily reduced to discrete tasks) would likely not offer an 
adequate cost-benefit ratio for including this category of work in the WBS.
9	 DCMA Manual 4301-10, undated.
10	 When other categories of reimbursable work are accepted, associated work is accounted for in the rel-
evant functional model for the location where the workload is performed.
11	 DCMA, “Resource Workload Model Integrated Model Version 2 (IMv2) Training,” briefing slides, 
March 1, 2024a, Not available to the general public.
12	 DCMA, 2024a.

Looking Under the Hood of the Integrated Resource Workload Model
21
Treatment of Overhead and Manpower Availability Factors in the 
RWM
When calculating the number of FTEs required to carry out DCMA’s mission functions, the 
RWMs employs various standard manpower availability factors that compute the amount of 
productive time an individual has to complete their assigned tasks within the depicted period 
(again, generally a single fiscal year).13 The specific available hours yielded through the use 
of these factors may vary slightly from year to year as DCMA adjusts and refines its assump-
tions and as the number of compensable hours changes from year to year because of calendar 
variances. The following discussion reflects assumptions used for the manpower availability 
factors incorporated in the IRWM projection of anticipated workload for FY 2023.
Manpower availability factors for DCMA employees in the continental United States 
reflect two baseline elements. The first is the annual available work hours for an FTE 
employee. Using a standard Office of Management and Budget (OMB) number of compen-
sable hours for FY 2023, DCMA established its annual available hours for an FTE as 2,088 
hours.14 Second, a standard DOW productive man year for an FTE is estimated. Using an 
OMB approximation of the number of annual leave, sick leave, administrative leave, training, 
and other nonproductive hours an individual might use in a fiscal year (312 hours), DCMA 
estimated the baseline annual productive time in FY 2023 for an FTE as 1,776 hours.15 In gen-
erating the second baseline calculation, DCMA obtained an agency productive man year by 
subtracting time associated with annual training requirements. This calculation yields 1,740 
hours of availability per FTE individual. No consideration of indirect overhead is included in 
this figure, which is applied to all DCMA employees. 
From that baseline computation of annual productive hours, DCMA employs two main 
availability factors to account for differences between various categories and locations of 
work. First, DCMA generates a baseline availability factor for FTEs attached to certain func-
tional mission models.16 This approach subtracts 40 hours, the amount of time associated 
with achieving the continuous learning points needed each year by these categories of work-
ers, yielding 1,700 hours of availability per individual. Again, no consideration of indirect 
overhead is included in this figure.
13	 DCMA, “Manpower Availability Factor Computation,” briefing slides, October 30, 2024b, Not available 
to the general public.
14	 Standard factor defined by OMB in conjunction with annual President’s Budget Request preparation. See 
OMB Circular No. A-11, Preparation, Submission, and Execution of the Budget, August 2022, Section 85, 
p. 3. 
15	 OMB Circular No. A-76, Performance of Commercial Activities, Office of Management and Budget, 
May 29, 2003, p. C-8. 
16	 This factor includes enabling components (region staff for East, West, Central, International, Special 
Programs, and AIMO), mission centers, Cost and Pricing Regional Command, certain Special Programs 
local models (Government Property, Pricing, DACO/CACO), and certain enterprise CMO models (Pro-
gram Integration/Support Program Integration).

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
22
Second, DCMA uses an estimated nonavailability factor, typically 15 percent, to account 
for various categories of unmeasurable work within its enterprise CMO models17 and cer-
tain Special Programs models18 (mission manpower availability factor). This factor represents 
work that cannot be tracked using a formal system of records or other objective mechanisms. 
Indirect mission overhead work may include (but is not limited to) such tasks as mentoring 
other DCMA employees, attending all-hands meetings, or certain other categories of train-
ing (such as providing or receiving on-the-job training) and results in approximately 255 
hours of unmeasurable work per FTE. Subtracting work hours associated with unmeasurable 
work from the default calculation of productive hours yields a manpower availability factor 
of 1,445 hours per FTE reflected in these models.
DCMA also generates a separate international manpower availability factor for DCMA 
employees located outside the continental United States that relies on different estimations of 
available work hours, including differing types of leave, training requirements, and frequent 
turnover associated with individuals rotating in and out of the country. From the base mis-
sion manpower availability factor (again, 1,445), DCMA subtracts additional leave and train-
ing time. For example, holiday leave for a DCMA employee stationed in Germany would also 
include observance of German-specific national holidays that differ from U.S. holidays, as 
foreign suppliers do not conduct business during these times. Additionally, overseas DCMA 
employees must complete training to account for international duty station–unique consid-
erations, such as personal and facility security. Overseas DCMA employees rotating in and 
out of the country also generate significant amounts of nonavailability because of the time 
associated with such tasks as making permanent change of station moves or securing perma-
nent local housing. For international DCMA employees, the agency estimates an availability 
factor of 1,240 hours per year. 
Another time factor (generally, 10 percent) is added to the Enterprise CMO models to 
account for inefficiencies associated with the performance of certain tasks by DCMA person-
nel working at locations outside the continental United States when compared with the execu-
tion of the same task by DCMA personnel working within the continental United States. This 
addition is intended to account for such factors as foreign language materials and currency. 
Generation of Total Estimated Manpower Requirements
Using standard manpower modeling methods, the IM takes the output of the total estimated 
workload equation associated with each RWM and divides that output by the appropriate 
17	 Including the Enterprise CMO models depicted in Table 3.1.
18	 Including certain Special Programs local and technical models, as depicted in Table 3.1.

Looking Under the Hood of the Integrated Resource Workload Model
23
manpower availability factor to generate an estimate of the required number of FTEs needed 
to carry out the estimated total workload.19 
DCMA Review and Validation of RWMs
The IRWM is intended to be refreshed and validated through an annual update cycle. Indi-
vidual RWMs refresh at different rates depending on the underlying data sources; the IRWM 
as a whole is modified and validated on an annual basis.20 DCMA’s Financial and Business 
Operations has overall ownership of this process. During the IRWM review and validation, 
model SMEs adjust model parameters and generate new estimates of the number of FTEs 
required to carry out DCMA’s mission functions for the coming fiscal year.
Once the RWMs are updated and complete, the validation process begins. The RWMs 
go through multiple levels of review, including review by respective operational units, cross-
operational units, and DCMA headquarters. An additional validation step is used for the 
Enterprise CMO models to give CMOs an opportunity to respond to the predicted man-
ning levels for a location and associated functional responsibilities and, as necessary, request 
modifications. As noted earlier in this chapter, the IM allows users to isolate and compare 
function-specific manning levels for a CMO. This allows for the identification of location-
specific manning levels and comparison of the number of authorized and on-board person-
nel by function with the number of personnel estimated to be necessary to carry out that 
function by the RWMs. CMO-level senior leaders have an opportunity to identify and pro-
pose additional personnel or fewer personnel where there is disagreement with model param-
eters or for a CMO-unique task that is not represented in the model. Each CMO must also 
generate a confidence estimate to indicate the degree to which the (1) model design, (2) model 
input data sources, and (3) model results are accurate and complete. 
Special Programs, the individual centers, and Cost and Pricing Command models do not 
undergo a similar external validation because of the internal development and adjustment 
of each respective model; these models are reviewed by the operational unit prior to further 
review and validation by cross-operational units and DCMA headquarters.
19	 Robbert, Calkins, and Mariano, 2024; Appendix D elaborates on the complexity of DCMA’s workload 
and ways of characterizing it.
20	 For example, the Cost and Pricing Regional Command model, the center models, and the Special Pro-
grams models all refresh semiannually. Enterprise CMO models, on the other hand, refresh monthly.

25
CHAPTER 4
Enterprise-Level Observations of the 
Integrated Resource Workload Model
In terms of both the tactical and strategic validation analyses—which included artifact review, 
interviews, and site visits—we confirmed that the modeling effort is rigorous and robust. Our 
validation surfaced both benefits and challenges stemming from DCMA’s workload models. 
The models we reviewed (which were part of IRWM version 2.0) are underpinned by reli-
able data inputs and undergo internal and external validation processes. DCMA iteratively 
improves the models in the IRWM ecosystem over time to respond to shifts in the orga-
nization. Respondents reported improvements in standardization, transparency, and the 
perceived fairness of resource allocation, along with expanded uses for strategic planning 
and workload management. At the same time, they identified significant concerns with data 
integrity, task representation, and limitations in the reliability, integration, and usability of 
agency platforms for workload tracking and model integration. 
The IRWM Is Grounded in Best Practices for Manpower 
Analysis
Modeling efforts, by definition, attempt to simplify the complexity of day-to-day reality to 
extract usable information from extensive data. The IRWM is a comprehensive and serious 
modeling effort that is generally conducted according to core principles aligned with the best 
practices for manpower analysis described in Chapter 2.
The functional RWMs are the centerpiece of the IRWM. The RWMs focus on DCMA’s 
core operational, output-oriented functions. They formally model workload for those func-
tions using valid methods. Specifically, tasks are derived from authoritative sources (e.g., 
FAR, DFARS, and DCMA directives, instructions, and manuals); task frequencies are drawn, 
whenever possible, from DCMA systems of record (e.g., PDREP and Mechanization of Con-
tract Administration Services); and task time estimates are developed by functional RWM 
SMEs, which are continually refined based on input and data from those performing the 
functions at the operational level. The models differ in both the number of tasks included in 
the WBS for each function and the level of detail in the steps used to complete those tasks. 
This variation stems partly from model maturity and partly from the function’s complexity.

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
26
More-complex functions may require more task differentiation to apply standard task time 
estimates across the organization. 
Functional models are applied in a consistent manner using the same task frequency 
sources and task times across the organization. The sole exception to this policy is for Spe-
cial Programs, which operate separate RWMs for similar functions because of the classi-
fied nature of the underlying data. The IRWM aggregates the information generated by the 
RWMs and applies adjustments to account for workload that is not formally modeled through 
RWMs. Those adjustments take the form of such factors as (1) supervisory ratios, which are 
applied as a percentage of the RWM modeled workload to account for direct administrative 
and supervisory oversight, and (2) simple additions (additives) that account for the manpower 
currently devoted to activity other than direct administration and supervisory oversight that 
is not covered by the RWMs. The former adjustments are akin to the way in which govern-
ment contractors apply indirect cost percentages to direct labor charges. The latter adjust-
ments cover activities that are not included in RWMs because the work is done for a reim-
bursable customer, the work could likely be but has not yet been formally modeled, or the 
work would be difficult to model efficiently. 
Over the period covered by our review, we found that DCMA has made reasonable choices 
in deciding which agency functions to model and which functions could be reflected using 
more high-level estimates. DCMA is in the process of expanding its modeling program, and 
several categories of workload have been modeled in subsequent versions (e.g., version 3.0 and 
later) of the IRWM; others may be added in the future. In evaluating and prioritizing whether 
to add a particular function or workload to the IRWM, DCMA may wish to consider the 
cost-benefit ratio of doing so. A potential starting point for such a cost-benefit analysis could 
involve considering whether (1) tasks can be derived from authoritative sources and (2) the 
agency systems of records from which task counts could be derived are in place. 
As discussed in the previous chapter, adding more-authoritative task time estimates for 
certain categories of work may allow DCMA to more reliably estimate and track manpower 
needs associated with the agency’s workload. For example, certain categories of work—such 
as the reimbursable work DCMA performs for other U.S. government entities—may be ben-
eficial to model and include in the IRWM. Other categories of work, such as administrative, 
support, supervisory, service member, and noncore functions, for which an agency source of 
record for associated task count data may not exist and identification of discrete tasks may be 
complex, may be less beneficial to model and include in the IRWM. 
Our tactical validation found that, in most instances, the IRWM component models use 
•  quality data derived from consistently available, authoritative agency systems of record
•  a formal, validated WBS that portrays most major DCMA mission functions

Enterprise-Level Observations of the Integrated Resource Workload Model
27
•  consistent, broadly applicable equations for deriving total estimated workload, annual 
manpower availability, and total estimated manpower requirements that are in line with 
equations employed for workload measurement by other U.S. executive branch agencies.1
We assess that these three factors indicate a high reliability of the data and modeling 
assumptions driving the IRWM ecosystem; high reliability is defined as the degree to which 
authoritative agency systems of record are used to generate task counts and the degree to 
which the models generally reflect operational reality in quantifying DCMA’s total estimated 
workload and manpower requirements.2 Where exceptions existed, they related to either 
(1) unmodeled activities or (2) activities associated with Special Programs operations, which 
had unique challenges associated with generating data from which to derive tasks and task 
counts because of the classified nature of the depicted work and a corresponding lack of 
unclassified agency systems of record to document these data.
However, our tactical validation found significant variances in how SMEs responsible for 
RWM development estimated time associated with depicted tasks. Governance documents 
that we reviewed indicated that model SMEs had been allowed to individually determine 
methodologies for generating task time estimates. In some instances, task times were deter-
mined by consultation with frontline supervisors who had knowledge of and experience with 
the average amount of time it should take to complete a particular task, with task time esti-
mates derived from broadly authoritative but potentially subjective individual experience. 
In other instances, models attempted to statistically analyze and derive median should-take 
times from actual task times reflected in agency systems of record. 
Some task times were assumed to be associated with the completion of the depicted task 
by a journeyman-level employee, with no allowance or adjustment for differing levels of expe-
rience in completing the same task. Some models attempted to include complexity factors to 
account for variances in the execution of the same task caused by such factors as contract 
size or dollar value. Although these estimates were intended to be reflective and inclusive of 
the differences in should-take task times executed by different functions, we assess that the 
varying processes used to generate the task time estimates incorporated into the version 2.0 
instantiation of the IRWM resulted in a low to medium reliability3 of the task time estimates 
forming the foundation of the total estimated manpower requirement for DCMA and con-
tributed to the procedural shortfalls identified by stakeholders. 
1	 Robbert, Calkins, and Mariano, 2024. 
2	 As derived, in part, from a workforce requirements model maturity framework, included as an attach-
ment to Department of Homeland Security, “Workforce Requirements Model Verification, Validation, and 
Accreditation,” memorandum, October 1, 2021.
3	 We define low to medium as the degree to which the estimated task time durations are representative, 
unbiased, complete, and relevant. These metrics are derived, in part, from a workforce requirements model 
maturity framework, included as an attachment to Department of Homeland Security, 2021.

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
28
Field-Level Stakeholders Have an Incomplete Understanding 
of Model Development, Improvement, and Use
Information we gathered from interviews with field-level personnel suggests that they have 
an incomplete understanding of the IRWM and its use. The IRWM was developed primarily 
as a tool to inform DCMA headquarters decisionmakers with timely information. It is vali-
dated and updated through a process that is led by modeling and functional SMEs at head-
quarters and the command level but relies on input from DCMA personnel in CMOs and 
field offices. During and after the validation process, CMO and field office personnel have 
access to the model output and may derive value from it. However, staff across the numerous 
CMOs we visited pointed to a lack of formal documentation about the model, its evolution, 
underlying business rules, and updates, referring to the documentation as “vague,” “lacking,” 
and “nonexistent.” This widely held view was particularly strong when it came to the IRWM, 
which many CMO-level representatives viewed as something of a “black box.” 
Relatedly DCMA personnel outside the headquarters IRWM modeling team were not well 
informed about the capabilities and intended use of the model. Field office staff had a limited 
understanding about how the model outputs were being used at higher levels of the organiza-
tion. In interviews, field office staff described limited visibility into how functional data are 
aggregated into the enterprise-wide estimates and how leadership applied results in resource 
decisions. Field personnel expressed a desire for more-consistent communication about the 
models’ intent, scope, and practical role in decisionmaking. Respondents emphasized that 
even brief, standardized explanations of version changes and uses of outputs could help 
reduce speculation, build trust, and support more-accurate and more-constructive engage-
ment during the validation process.
DCMA transitioned the modeling effort into the PowerBI platform in FY 2023, an inno-
vation that allowed broad access to the model by users across the organization. Many inter-
viewees reported that they were taking advantage of the model and using it within their 
organization to inform process improvement. Although the model was never intended to 
provide team-level counts and self-reported task times for end user analysis, many inter-
viewees reported that they were eager to access the model data down to the team level so they 
could compare task times and workload across teams. 
Many staff at the CMOs and field offices pointed to the model validation process as the 
step at which they had the most in-depth interaction with the model. DCMA model stake-
holders were asked to provide data, feedback, and input via functional teams at the regional 
command level. Many field-level staff reported that they were eager to do so to better under-
stand the IRWM and its component modeling assumptions, with an eye toward providing 
better inputs and perhaps lending their expertise to the model’s improvement. 
Finally, interviewees pointed to concerns about a lack of consistent feedback mechanisms 
within the model validation process. Some reported providing model improvement sugges-
tions and requests for additives to the functional SMEs during the validation process but 
received no information about why their requests were accepted or denied. Several noted that

Enterprise-Level Observations of the Integrated Resource Workload Model
29
these submissions often required extensive supporting data and justifications, adding to the 
frustration at the absence of feedback. In some cases, when feedback was provided, it arrived 
late in the cycle and had limited value for planning or future submissions. Interviewees 
emphasized that their confidence in the models depended less on whether adjudications were 
favorable and more on whether the process was transparent, consistent, and applied fairly 
across commands. In contrast, other interviewees reported clear communication, follow-up, 
and engagement with the functional SMEs for their command. 
Stakeholder Views on Why Model Estimates Diverge from 
Reality on the Ground
In this section, we report the views of stakeholders we interviewed, most of them in CMOs, 
about the difference between model estimates and ground truth for their organization. In 
reporting these views, we emphasize that even the most rigorously constructed model cannot 
capture the scope and complexity of real-world operations, particularly those as dynamic, 
diverse, and complex as those of DCMA. The IRWM was not designed with an eye toward 
managing day-to-day operations but rather was designed to form accurate-enough aggre-
gate estimates that would permit sound planning and decisionmaking for the whole agency. 
Addressing these issues in pursuit of greater fidelity would require additional resources and 
potentially add complexity to the modeling effort.
Interviewees pointed to four key sources as drivers of these discrepancies:
•  treatment of unmodeled workload
•  model input data that do not accurately capture workload
•  shortfalls in the WBSs
•  use of historical data to make predictive estimates for anticipated workload. 
According to interviewees, a major source of discrepancies between IRWM outputs and 
ground truth stemmed from the way the IRWM handles unmodeled workload. These are, 
strictly speaking, not challenges in modeling but choices DCMA has made about what to 
prioritize within the modeling effort, as well as assumptions underlying the way modeled 
estimates are adjusted to account for this workload. Interviewees pointed to the application 
of standard supervisory ratios, noting that these assumptions did not reflect the realities of 
team structures. For example, staff highlighted that team leads and GS-12 personnel fre-
quently carry substantial supervisory or quasi-supervisory responsibilities that are not rec-
ognized in the current ratios, leading to workload misrepresentation. Several respondents 
argued that standard assumptions also undervalue military contributions in some contexts; 
in many cases, military personnel contribute at or near a full FTE, but the IRWM convention 
is to represent military personnel at 0.5 FTE each.

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
30
In terms of unmodeled functions, mission support was frequently cited by stakeholders as 
an area that could and should be modeled. Respondents noted that mission support person-
nel often manage large and dispersed workloads, such as supporting hundreds of staff across 
multiple states. These responsibilities are not currently captured. Stakeholders said that a 
more accurate picture of mission support activities would inform a more equitable allocation 
of mission support resources.4
Interviewees frequently commented that the IRWM was only as accurate as the data 
submitted to it. They pointed to the potential inconsistency of human-entered data across 
hundreds of work locations, which likely reflects some degree of variance caused by such 
factors as subjectivity in interpreting how a particular task might be categorized in agency 
systems of record. Interviewees also expressed concern about systems of record that provided 
the appearance of rigorous inputs but were often so cumbersome and time-consuming that 
they disincentivized full and accurate logging of tasks. Numerous interviewees suggested 
that more user-friendly input mechanisms would provide more consistently reliable data and 
would take a smaller percentage of working hours away from operational tasks. 
Interviewees also attributed discrepancies between modeled and actual workload to limi-
tations of task complexity factors used in the RWMs, which feed into IRWM outputs. For 
example, quality assurance personnel noted that performing surveillance on an aircraft 
program is far more complex and time-intensive than on simple hardware, yet the model 
applies the same task time to both. Similarly, engineering staff emphasized that geographi-
cally dispersed contracts can require substantially more time to manage than colocated work, 
but this difference is not reflected in current estimates. RWMs do apply complexity factors 
and adjustments for contract requirements or work type. A core principle of the modeling 
effort is that any such adjustments to task times for a particular task are applied enterprise-
wide. Therefore, it is to be expected that some field staff at some CMOs might perceive the 
complexity factors included in the RWM to be insufficient and the source of discrepancies 
between their actual average task times and modeled task times.
CMOs have an opportunity to surface such examples during the model validation pro-
cess. If task times vary by some observable characteristic of the work that can be consistently 
measured, a revision to the task breakdown structure can be considered to allow for differen-
tiation in the task times. An alternative is for the CMO to receive an additive above the model 
estimate to account for the differences. Generally, the use of average task times should gener-
ate accurate enterprise-wide estimates of manpower requirements despite variation in accu-
racy across CMOs or field offices. DCMA leaders can use workload balancing at the com-
mand and enterprise levels to address gaps between staffing and workload at the CMO level. 
A final point commonly made across the CMOs was that even reasonably accurate histori-
cal workload data may not be useful for predictive analysis—or for projecting future work-
load. The modeling effort attempts to account for this limitation in a variety of ways, includ-
ing through the opportunity to request additives. We observed a major difference between 
4	 Operational centers have since been established by DCMA to help address this concern.

Enterprise-Level Observations of the Integrated Resource Workload Model
31
resident CMOs, which often have substantial workloads related to major defense acquisition 
programs, and geographic CMOs, which tend to focus on smaller contractors and subcon-
tractors. Resident CMOs described program-driven workload as cyclical and highly sensitive 
to milestones, contract modifications, and engineering changes. As programs mature, task 
demand can surge or decline rapidly, requiring leadership to project future workload using 
the horse blanket technique (an approach to planning the defense acquisition life cycle) to 
map expected changes across portfolios. Geographic CMOs, on the other hand, emphasized 
that although their aggregate workload is more stable, it is spread across many small suppli-
ers and involves a higher proportion of fragmented or administrative tasks that are not well 
captured in the models. DCMA personnel explained that the accelerating pace of change, 
both in contract requirements and the urgency of external threats faced by the United States, 
increased the need for a system that can provide a stronger foundation for planning and 
operations in a dynamic environment.
Model Ecosystem Supports DCMA Decisionmaking and 
Operational Improvement
The IRWM and the processes underpinning it support DCMA decisionmaking and pro-
cess improvement at different levels of the organization. These process improvements, in 
turn, feed into revisions to process manuals and into workload acceptance negotiations with 
customers. When it comes to resource allocation, the IRWM generates an estimate of the 
number of people DCMA will need in the coming year to accomplish the expected workload. 
The IRWM also provides estimates by command, center, CMO, and function. These more 
granular estimates are used to inform hiring plans and workload balancing.
The IRWM supports annual reallocation decisions to place staff where the workload 
requires and provides context for broader decisions about restructuring the organization 
in response to longer-term trends and acceptance of reimbursable workload. An observa-
tion made by many interviewees is that resource allocation is relatively easy within, but not 
between, organizational units. Within a CMO, budgeted resources can be shifted between 
functions (for example, employing more contracting officers and fewer quality assurance spe-
cialists), but it is much more difficult to shift resources between CMOs. Given this constraint, 
DCMA managers at the command level strive to redirect workload to where the resources 
are available to accomplish the work. Several interviewees noted that recent organizational 
changes to consolidate CMOs and to align CMOs with similar workload under the same 
command will facilitate such workload balancing and help the organization better anticipate 
its capacity to accept reimbursable workload and to allocate that workload effectively.
The IRWM is grounded in standard task definitions and task time estimates that are 
based on data about how long tasks across the enterprise, on average, take to accomplish. 
Managers have access to their actual task times for tasks and can use IRWM data to bench-
mark the performance of their organization. Several interviewees mentioned that, before a

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
32
particular function was modeled, different CMOs had different ideas about how a certain 
task should be done. The modeling effort has made visible the extent of variation, prompting 
conversations about the reasons for such variation. The result has led to revisions to process 
manuals and job aids to more accurately reflect actual practice and more clearly document 
expectations. For example, at one site, the IRWM highlighted significant differences in how 
contract surveillance planning was sequenced across offices. This prompted revisions to local 
work instructions and accompanying flowcharts so that the documented steps aligned with 
the practices actually used by contract managers. Similarly, other CMOs reported updating 
job aids to clarify expectations for pre-award survey documentation, ensuring greater con-
sistency in execution. Several interviewees who were functional managers at the CMO level 
also stated that the data helped them to identify team members in need of coaching and level-
setting on performance expectations. 
DCMA Iteratively Improves RWMs and the IRWM over Time to 
Address Shortfalls
DCMA has been gradually building and iteratively improving the IRWM by modeling more 
functions through the creation of new RWMs, refining existing RWMs, including more 
workload in the RWMs, modifying assumptions used in the IRWM, and improving access 
to the model results. Interviewees across functions and across organizational levels reported 
that the IRWM has improved substantially with each version. And although many interview-
ees characterized workload-tracking data systems (such as PDREP) as being excessively time 
consuming, others at the CMO level emphasized that the creation of these data systems and 
the development of related functional models has been a “game changer.” 
When deciding what to prioritize with limited resources, the headquarters-based IRWM 
team considered lessons learned through the model review and validation process along with 
the operational needs of leaders at the headquarters, command, and field levels. The RWMs 
are developed and improved by a team of hands-on experts with deep functional expertise 
who engage with their functional counterparts at the field level. The IRWM has benefited 
from this robust ecosystem, both in terms of the quality and timeliness of the data it supplies 
and in terms of the modeling expertise developed over the past decade. Now in its third com-
plete version, the integrated model has improved substantially since its initial deployment, 
with refinements in data sources, algorithms, and output formats.
Initial estimates for agency-wide task times have prompted evidence-based discussions 
that have led to refined estimates and to greater differentiation across geographic areas and 
contract type. These discussions continue across the full range of integrated model function-
ality, with an eye toward providing the most timely and most accurate data, as well as the 
most logical algorithms for the integrated model. The small number of model development 
personnel at headquarters, however, and the lack of processes to identify and share best prac-
tices limit the speed and quality of model refinements.

33
CHAPTER 5
Conclusions and Recommendations
DCMA requested that we base our research and analysis on IRWM version 2.0, which was 
released on October 1, 2022, and used to estimate manpower requirements for FY 2023. The 
conclusions and recommendations described in this chapter are based on that review. IRWM 
version 3.0 was under development at the time our study began and was released in June 2025, 
near the completion of our assessment. Because DCMA has been working continuously to 
address workload modeling challenges and upgrade its capabilities, some of the conclusions 
and recommendations described in this chapter will have been fully or partially addressed 
prior to the release of this report. 
In providing these recommendations, we recognize that the IRWM is not the only 
source of workload and staffing information available to DCMA leadership. DOW’s Office 
of the Chief Digital and Artificial Intelligence Officer is assembling numerous dashboards 
of near-real-time business data to support DCMA leadership decisionmaking. Although 
these dashboards will eventually include the full breadth of DCMA strategic information, 
the IRWM will remain the principal source of DCMA manpower analysis for the foresee-
able future.
Conclusions 
The IRWM and RWMs Have Short-Term and Longer-Term Benefits
The IRWM generates a point-in-time estimate of the number of DCMA personnel required 
to support a given contract management workload for the entire enterprise.1 It also generates 
cross-functional estimates for organizational units within DCMA and cross-organizational 
estimates for functions. The estimate is useful for planning purposes within DCMA and can 
support organizational decisionmaking. It is based on inputs and assumptions about how 
much work will come to DCMA and how many people it should take the organization to 
accomplish that work. Those inputs and assumptions are affected by such external factors 
as budget and authorized manning levels, statute and regulation, DOW policy and missions, 
and customer demands and by such internal factors as DCMA policy and standard operat-
1	 See Appendix A for more discussion on that point-in-time estimate.

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
34
ing procedures, DCMA organizational structure, and resource allocation decisions. These 
internal and external factors, combined with the IRWM itself, define the IRWM ecosystem. 
The benefits of the IRWM go well beyond its ability to generate an estimate of work-
force requirements at any point in time based on existing internal and external factors. The 
IRWM interacts with the broader ecosystem of which it is a part, as reflected in Figure 5.1. 
The modeling effort surfaces insights and prompts conversations, choices, and decisions that 
drive changes to workload distribution, DCMA policy, standard operating procedures, and 
organizational structures, with the potential to enhance efficiency and process improvement. 
In some cases, insights derived from the modeling effort influence external factors, such as 
memorandums of agreement with customers. 
Of course, the external and internal factors also change because of forces outside DCMA’s 
control. Another value of the IRWM is that it provides a road map to help DCMA understand 
the implications of changes to key factors for its workforce needs. The model can provide 
DCMA with information about how changes to its budget and authorized manning levels 
could affect the amount of work it can accept. It can provide an estimate of how changes to 
statute and regulation (i.e., the current revision of the FAR and DFARS, which could change 
or eliminate many of the regulations under which DCMA carries out its mission) could affect 
the required workforce. It can help the organization understand the manpower implications 
of changes to DOW policy and missions (e.g., a requirement to be on a war footing by a cer-
FIGURE 5.1
DCMA IRWM: Dynamic Modeling Ecosystem
IRWM 
ecosystem
External factors
Internal factors
Workload
Standards
Required workforce

Conclusions and Recommendations
35
tain date) and changes in customer demands, especially in large and complex programs with 
a significant international component. 
DCMA can use the IRWM and its supporting modeling ecosystem in support of scenario 
planning related to actual or potential changes to external and internal factors. Scenarios 
could be defined around changes to mission, statue or regulation, or resources. Scenarios 
could involve front-end changes, such as the following: 
•  What budget and staffing would be required to resource the current contract manage-
ment workload to fully execute at current should-take levels with no additional accep-
tance of risk by field personnel? 
•  What would be the effect of a defense-wide budget cut of X percent? 
•  What budget would be required to accelerate DCMA operations to be on a war footing 
by date Y?
The model can also be used to develop forecasts and scenarios to help DCMA consider 
how it might respond to changes in resourcing. For example, a scenario could include decreas-
ing the workload to match existing personnel numbers and task should-takes; increasing 
the workload to accelerate the delivery of certain warfighter capabilities more quickly than 
anticipated; or, perhaps, determining the budget and staffing required for DCMA to handle 
a larger share (or all) of defense contracting. With a reliable model, each of these scenarios 
could produce a reliable budget and staffing number to accommodate changes deliberately.
Another advantage of the model is the ability to account for changes caused by revised 
statutes or regulations. Because the modeling ecosystem maps tasks to specific statutes or 
regulatory provisions, modeling teams can clearly see where changes to authorities may have 
implications for tasks and/or task times and adjust accordingly. This road map not only per-
mits DCMA to more quickly update its models but also helps the organization identify where 
standard operating procedures need to be updated. In this way, the modeling ecosystem could 
allow the workflow to adjust with greater speed and efficiency across the entire organization 
in response to regulatory change. The probable major revision of the DFARS expected in the 
next fiscal year could place strain on an organization without a model, or with a model that 
does not link tasks directly to authorities.
Finally, from the bottom-up perspective, a sound model ecosystem would allow front-
line managers and other supervisors to evaluate their sections’ work performance against 
agency standards. This would generate a goal for improving task performance in required 
areas or the basis for an adjustment to the model(s) to account for special circumstances at 
the work site. 
In all cases, an accurate-enough, timely-enough, and trusted-enough model can provide 
an objective basis for budget and staffing discussions outside the agency. Given the high oper-
ational tempo for the agency and given that this operational tempo is expected to increase, 
such evidence-based discussion would, in most cases, reveal the degree to which DCMA 
requires additional resources.

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
36
DCMA Lacks a Clear Structure for Prioritizing Model Improvement 
Efforts
As described in Chapter 4, stakeholders pointed to shortfalls in the IRWM in terms of how 
well it reflects ground truth. Although the model does not aim to achieve universal predic-
tive accuracy with its estimates, there may be circumstances in which enhanced accuracy is 
desired. Each of the real or perceived shortfalls in the IRWM would require additional per-
sonnel and budget to correct and improve. Current staffing levels dedicated to this effort in 
DCMA headquarters, including gapped billets, are insufficient to keep pace with the evolv-
ing speed and complexity of operations, and staff are challenged to maintain and operate 
the model at current refresh rates and levels of complexity. During our interviews, we also 
heard that some model SMEs had deprioritized developing formal documentation or stan-
dard operating procedures because of the relatively small number of staff responsible for 
model development—a potential concern with respect to knowledge transfer and continuity 
of model operations, as DCMA staffing levels may be subject to future adjustment.
Enhanced Communication Could Improve Transparency and Trust
Not all issues we identified were the result of shortfalls in technology, staffing, or exper-
tise. Several issues were primarily the result of poor communication between the headquar-
ters modeling team and the functional model experts in the field. Initial deployment of the 
IRWM was hindered by a lack of explanation to stakeholders regarding the intended purpose 
of the model. Over time, this confusion compromised trust. 
A related issue is that feedback mechanisms between the field and the modeling teams 
are insufficient to ensure iterative, collaborative feedback and maintenance. Although many 
interviewees were highly complimentary about their interactions with the model SMEs, 
others were less so, and some said that the quality of communication was highly dependent 
on the person in charge of a particular model. 
The data entry mechanisms initially chosen by headquarters modelers led to additional 
friction, and the lack of a regular, authoritative feedback mechanism slowed its resolution. 
Automated feeds reduced back-end challenges for the modeling team, but the systems of 
record for human-entered data, especially PDREP, were viewed as comprehensive and uni-
form from the headquarters perspective but were so user-unfriendly from the field’s perspec-
tive that the time it would take to enter a task into PDREP was weighed against the value of 
doing the task at all. Additional improvements to PDREP and other systems of record have 
reduced and may continue to reduce this strain and lead to more consistent and more timely 
data entry. The broad stakeholder consensus was that the absence of collaborative, iterative 
feedback and maintenance processes slowed model development and restricted its accuracy.

Conclusions and Recommendations
37
Recommendations
Considering these conclusions, we offer three principal recommendations to DCMA and sev-
eral supporting recommendations that would improve the development and use of the IRWM.
Principal Recommendations
Formally document the processes used to develop the structure and function of the exist-
ing IRWM and component RWMs. Formal documentation—including finalizing coordi-
nation for the draft DCMA manual for operating the IRWM that we reviewed—will bring 
further discipline and rigor to the modeling process, permit more precise evaluation of model 
capabilities, and focus improvements where needed. We believe this work is foundational to 
successfully implementing our other recommendations.
Develop standard operating procedures for future model assessment and development. 
These operating procedures should cover the entire IRWM and all functional models on 
which it depends for inputs and validation. DCMA should provide more guidance to model 
SMEs for developing consistent, rigorous, and easily replicable task time estimates with doc-
umented analytical methods employed to generate these estimates in order to ensure that 
the manpower requirement generated by the IRWM more accurately estimates future work-
force needs. Additionally, the standard operating procedures should lay out timelines for 
regular reviews, processes to be followed in routinely soliciting and responding to feedback, 
and realistic timelines to ensure that these assessments and reviews are done as frequently 
as practicable. A sufficiently integrated model ecosystem could support better, more timely 
data-driven decisionmaking and support helpful standardization across the enterprise.
DCMA should develop, as part of this effort, an explicit plan to assess the efficiency and 
effectiveness of its data-capture systems, from automatic data-feeds to human-entered data, 
with an eye toward ensuring completeness and timeliness while reducing the time and com-
plexity of data entry. We believe that this step will ensure a more robust flow of timely and 
accurate data throughout DCMA’s modeling ecosystem.
Building on this effort, DCMA needs to establish a greater degree of transparency around 
the development and selection of business rules for the IRWM. Numerous experts in the field 
said that, without a clear understanding of what the actual business rules were or how they 
operated, they were at a loss to understand how the IRWM generated the outputs it did, based 
on the inputs supplied. It is important to note that this transparency is intended to produce 
the best possible set of business rules and not remove headquarters’ right as the final arbiter 
among the improved solutions.
We believe it is essential that a new, standardized validation process include an explicit 
feedback mechanism to CMOs. Almost without exception, we learned from discussions at 
all field offices that feedback on data submission, business rule design, and output charac-
terization was suboptimal, running the gamut from uneven to nonexistent. This is partially 
explained by the very limited bandwidth of the small number of modeling experts at head-
quarters and perhaps by a lack of interest in any criticism from the field, constructive or oth-

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
38
erwise. A standardized validation process, operated on a more-than-annual battle rhythm, 
would permit that constructive conversation to occur. 
Develop an actionable framework to prioritize and sequence model refinements and 
upgrades. This effort may include representing current work more accurately (i.e., by adjust-
ing task times or task frequency estimates) or applying the model to new areas (i.e., mission 
support operations, reimbursable work, or the work of nonsupervisory military personnel 
assigned). 
Staffing limitations serve to increase the value of having a rigorous framework for priori-
tizing and sequencing the work. A deliberate cost-benefit analysis should be done compre-
hensively once and repeated at relevant intervals to answer the following questions: 
•  Which tasks need to be modeled? 
•  Of these tasks, what is the urgency and importance of each category (which would deter-
mine which tasks to prioritize)? 
•  To what level of detail should each function be modeled? Within this question, which 
tasks should be further broken down into subcomponents, and which should be aggre-
gated into larger ones? 
•  Which task times should be refined? 
•  What is the best mechanism for soliciting feedback from the DCMA employees whose 
work is represented in the RWMs, and how often should this be done? 
•  Finally, how can automatic data feeds be improved and human-entered data systems be 
made both more user-friendly and more time-efficient?
Answering these questions in the most comprehensive fashion might require a dedicated 
pause in model development, during which all relevant stakeholders and all necessary experts 
could confer and establish these priorities, sequences, and standards for agency leadership to 
approve. Tasking the current number of headquarters experts to do so as a collateral duty is 
unlikely to yield a useful result in a reasonable length of time. More-detailed suggestions are 
provided in Appendix B.
Supporting Recommendations
Improve internal communication about the IRWM ecosystem. Hand in hand with sub-
stantive improvements to the IRWM and supporting functional models, improved commu-
nication between headquarters and the field will reduce confusion, relieve strained trust, 
and energize future collaboration among DCMA professionals to produce the most effective 
models possible. Toward this end, we recommend that DCMA do the following:
•  Clearly and authoritatively state the objectives and limitations of the IRWM. This will 
help calibrate expectations, will provide an opportunity for functional model experts to 
provide helpful input on fundamental model assumptions, and could provide insights 
that might have eluded the small number of model experts at headquarters. We believe

Conclusions and Recommendations
39
that being meaningfully consulted will generate a level of buy-in among the experts in 
the field who will be indispensable to the headquarters model’s eventual success.
•  Produce user-friendly resources to enable DCMA personnel to understand the models 
better, provide more accurate and more timely data, and apply the models to improve 
the operation of their offices. 
Actively leverage DCMA modeling efforts to support agency decisionmaking. An 
accurate, accessible, and up-to-date IRWM can support external and internal DCMA activi-
ties. We recommend that DCMA capitalize on the investment it has made in the IRWM by 
leveraging it more widely to support decisionmaking. For example, the IRWM outputs could 
be used in the following ways:
•  Support customer interactions, whether mission or reimbursable, first by scoping the 
expected level of effort as a point of departure for discussions and then by allowing the 
cost of various numbers of personnel, levels of surveillance, and frequencies of reporting 
to inform both parties of the costs of all relevant options and ensuring clarity of expec-
tations on both sides.
•  Determine the optimal mix of funded and reimbursable work to be accepted. Under 
current DCMA policy, this is largely a bottom-up process, in which intermediate- or 
headquarters-level leadership become involved only by exception. By incorporating the 
IRWM into a more centralized decisionmaking process, DCMA leadership could bal-
ance the optimal level of high-risk and high-importance work with the need to maintain 
a cadre of defense contract management professionals over the course of their careers 
and to continuously maintain this balance with timely decisionmaking throughout the 
year.
•  In conversations with DLA and the service contracting offices, support data-driven dis-
cussions about which organization is best positioned to carry out which categories of 
work. Making the costs of these obligations transparent before agreements are reached 
would lead to more rational decisionmaking and a more efficient distribution of the 
defense contracting workload.
•  Support policy- and strategy-level discussions with the DOW Comptroller, Office of the 
Under Secretary of War for Acquisition and Sustainment, the services, and Congress on 
the costs of various levels of DCMA defense contract management capacity. Scenarios 
for budget increases or decreases, adjustments to authorized and filled staffing levels, 
the expectation of contract management by the number of contracts, the value of con-
tracts, and the complexity of contracts could be represented by the IRWM. Rather than 
producing a single number or forecasting a single outcome, the IRWM could provide 
a variety of options from which decisionmakers could choose. Similarly, multiple fact-
based scenarios would allow DCMA decisionmakers to anticipate and better navigate 
challenging circumstances as they arise.

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
40
What This Means for DCMA
The IRWM is fit for its current purpose: providing an accurate-enough estimate of total 
aggregate work hours to inform agency-wide staffing and budget allocations.
When DCMA’s model-building effort began organically a little over ten years ago, it pri-
oritized the build-out of model features over formal documentation—a sensible starting posi-
tion. However, retroactive documentation of model components, assumptions, and function-
ality will enhance confidence in and understanding of the model and lay the groundwork for 
additional improvements. Continued efforts to clarify what the model will and will not be 
used for should reduce confusion and increase trust across the agency, providing field-level 
employees with the context needed to provide accurate inputs to the model.
Formal model documentation can be supplemented with documentation about the mod-
el’s ongoing development process. This iterative process relies on data from the field and 
collaboration with DCMA’s functional modeling experts at the headquarters, command, 
and field levels. The process must be assessed on a regular and recurring basis against 
explicit benchmarks on such dimensions as rigor and validity. This process should result 
in a steady battle rhythm of collaboration between headquarters and subordinate elements, 
which will, in turn, lead to more-timely and more-accurate inputs and more-accurate and 
more-useful outputs.
No model is a perfect representation of what is being modeled. However, continued use 
and improvement of the model within a rigorous framework will clarify areas of alignment 
and divergence across field locations and functional activities. Areas of alignment, generating 
more-uniform agency-wide standards for performing similar tasks, will provide a valuable 
benchmark for frontline supervisors across the agency. Areas of divergence will highlight the 
need for additions to the model and algorithm refinement that will more closely represent 
the way real-world activities are undertaken. Continuously revisiting areas of alignment and 
refining of areas of divergence will allow the model to asymptotically approach a true pic-
ture of day-to-day activities across the agency. When the model’s accuracy reaches the point 
at which only small improvements can be gained, model building will transition to model 
maintenance. Against this increasingly coherent backdrop of agency activity, smaller, more 
localized anomalies can be identified and resolved by human managerial practices.
The continuous documentation and development processes we propose will enable more–
data-driven decisionmaking within DCMA, improve collaboration between headquarters 
and field elements, and help focus resources devoted to enhancements to the IRWM ecosys-
tem where they can be the most beneficial.

41
APPENDIX A
How Does DCMA Arrive at Its Required 
Manning?
The DCMA IRWM can provide a solid estimate of DCMA’s required workforce at a particu-
lar point in time, conditional on the internal and external factors in place and the assump-
tions underpinning the model at that time. The model’s assumptions are reasonable and 
aligned with best practices for manpower modeling—one of which is to regularly validate 
and improve the model itself. 
IRWM version 2.0 generated an estimated required DCMA workforce for FY 2024 of 
approximately 12,795.1 Of these positions, 9,686 (approximately 76 percent of the total) were 
modeled in IRWM version 2.0 through the functional RWMs based on tasks as cataloged in 
the WBS and on data supplied through authoritative sources (PDREP, Mechanization of Con-
tract Administration Services Mechanization of Contract Administration Services, Procure-
ment Integrated Enterprise Environment, Defense Agencies Initiative, and FMTS). Another 
117 of the positions associated with workload performed for NASA were accounted for within 
the functional RWMs and associated with tasks in the WBS but not modeled based on data 
supplied through authoritative sources, bringing the total functional positions accounted for 
by the model to 9,803. The remaining 2,992 positions (approximately 23 percent of the total) 
were represented by an as-is/should-take equivalency, accounting for areas not yet modeled 
or, because of their supervisory or general administrative nature, not scheduled to be mod-
eled. These positions include headquarters staff and enabling components (1,244 positions, 
9.7 percent), operational region staffs (410 positions, 3.2 percent), and CMO-level command 
and functional staffs (1,338 positions, 10.4 percent). 
To provide a benchmark for comparing DCMA’s overhead rate with the industry stan-
dard, we analyzed data from the U.S. Bureau of Labor Statistics. The bureau’s classification 
for the industry that most closely matches DCMA is Management, Scientific, and Techni-
cal Consulting Services. An analysis of the May 2023 Occupational Employment and Wage 
Statistics data shows that approximately 40 percent of employees who work in this sector 
1	 Specific position counts for FY 2024 were provided by DCMA via email dated September 8, 2025. These 
numbers were cross-validated for consistency with data from UMR reports and IRWM information made 
available to us over the course of the study.

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
42
perform overhead or administrative activities.2 With DCMA’s overhead percentage falling 
somewhere in the range of 9.7 percent to 23.2 percent, DCMA’s percentage is well below the 
relevant industry standard. 
2	 U.S. Bureau of Labor Statistics, “Occupational Employment and Wage Statistics (OEWS) Tables, web-
page, updated July 23, 2025. We used the Department of Labor’s definition to categorize administrative 
and overhead activities. See U.S. Department of Labor, “Fact Sheet #17C: Exemption for Administrative 
Employees Under the Fair Labor Standards Act (FLSA),” webpage, updated August 2024.

43
APPENDIX B
In What Sequence and Priority Should 
DCMA Functions and Activities Be Modeled? 
IRWM version 2.0 aggregates estimates of position requirements generated by functional 
RWMs, with estimates of position requirements derived from the application of supervisory 
ratios to the RWM estimates, data on how many people were assigned to perform a particular 
task in the prior fiscal year, or negotiated memorandums of understanding for reimbursable 
work. Although these estimates are all considered part of the IRWM, the estimates gener-
ated by the functional RWMs have a higher level of validity because of the rigorous struc-
ture of the process used to generate and update the estimates. We consider these activities to 
be formally modeled. Over time, DCMA has created new RWMs covering additional func-
tions, thus expanding the portion of position requirements that are generated through formal 
modeling. As described in Appendix A, about 76 percent of the position requirements for 
FY 2024 generated by IRWM 2.0 were formally modeled. Internal and external stakeholders 
have called for new models covering additional functions. 
DCMA’s IRWM models most of the functional work done at the CMO level and some 
work conducted within functionally oriented centers at the headquarters level, such as cost 
and pricing. This modeling includes positions filled by technical specialists, such as engi-
neers, quality assurance specialists, software specialists, and industrial specialists; business 
and financial specialists, such as administrative contracting officers, cost and price analysts, 
property management specialists, and program integrators and analysts; and program and 
operations specialists, such as program support specialists, small business professionals, 
packaging specialists, and transportation specialists. 
Additional work, such as mission support activities, nonsupervisory work done primar-
ily by military personnel, and reimbursable work, could be modeled through the RWM pro-
cess already in use by DCMA. General and administrative functions at the enterprise level, 
such as legal, human resources, leadership, and administrative, along with indirect overhead 
activities (those that cannot be easily tied to a single function, such as a command or CMO 
headquarters), have not been modeled, in keeping with the common practice of regarding 
those activities as being so attenuated from concrete mission outcomes as to not be worth 
the time and expense of capturing them.1 Direct overhead (supervisory positions that can be 
1	 Air Force Manual 38-102, 2024.

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
44
tied to a single function) is accounted for through a 10 percent overhead ratio applied to the 
estimate of the number of modeled positions for the function. Unmodeled positions include 
functional supervisors above the level of GS-12, general administrative support personnel, 
legal counsel, procurement analysts, military personnel assigned to DCMA, and personnel 
engaged in reimbursable work.
The potential benefits of modeling currently unmodeled positions are (1) visibility into 
what work is being performed and why and (2) visibility into how the work is being per-
formed. The former can help senior leaders prioritize unmodeled activities, especially if work 
cannot be tied to a mission document or other authoritative source. The latter can help func-
tional leaders in that the newly modeled function can improve efficiency through standard-
ization or the adoption of best practices. The value of these benefits is likely to be larger for 
activities that involve a larger number of people, more highly compensated people, and activi-
ties that are performed across multiple locations. 
These benefits come at a cost. A modeling team at DCMA headquarters is funded to 
develop new functional models and maintain existing ones. Model development, improve-
ment, and validation also require substantial input from functional experts at the command 
and CMO levels and from DCMA leadership across the enterprise. 
We recommend that the as-yet-unmodeled work be addressed in the following sequence 
or priority: 
1.	
all remaining mission work with a direct nexus to operational deliverables and out-
comes (all personnel, both military and civilian, not in supervisory positions or pro-
viding general administrative support or engaged in reimbursable work), with priori-
tization by mission size and scope
2.	
all personnel engaged in reimbursable work, to the extent that such work is not 
already depicted in the models and can be associated with agency systems of record 
in order to generate the data necessary for estimating the associated workload. This 
will complete the modeling effort of all nonsupervisory and non-administrative 
DCMA personnel.
DCMA leadership can consider the following options for expanding the scope of the mod-
eling effort based on resource availability:
3.	
Following the status quo with no additional investment in workload modeling per-
sonnel, the timeline for improving existing models can be extended to reduce the 
modeling workload to the size of the modeling staff. New modeling efforts would 
come at the expense of reduced maintenance and improvement of existing work-
load models.
4.	
Maintain current personnel authorizations, but fill currently vacant billets, to sup-
port continued maintenance and improvement of existing models while new models 
are developed.

In What Sequence and Priority Should DCMA Functions and Activities Be Modeled?
45
5.	
Increase the number of IRWM modelers in order to model all work that could be 
modeled in the next two to three years.
At this time, and given resource constraints, we would not recommend DCMA invest in 
modeling purely supervisory or administrative work that is not connected to immediate mis-
sion deliverables.

47
APPENDIX C
Modeling Can Help DCMA Determine 
the Optimal Balance of Mission and 
Reimbursable Work
DCMA provides contract administration services, on a reimbursable basis, to non-DOW 
agencies (such as NASA) and to other DOW agencies and programs, such as the Foreign Mili-
tary Sales program administered by the Defense Security Cooperation Agency. Although mis-
sion work, supported by operations and maintenance funding, is the priority, reimbursable 
work enhances DCMA’s ability to maintain its career workforce during periods of reduced 
mission funding, preserving the capacity to accept increased mission workload in the future.
DCMA has a workload acceptance process with concrete guidelines that inform decisions 
about how to prioritize mission and reimbursable work using available resources.
The mission workload acceptance process outlined in DCMA Manual 4502-02 requires 
DCMA managers to consider five criteria when reviewing a work request. The process is 
designed to ensure that DCMA is accepting work it is authorized to perform and that it is 
effectively prioritizing workload using available resources.1 The review process typically 
starts at the CMO level and considers whether 
1.	
the request came from a mission customer2 
2.	
DCMA is the Contract Administration Office Authority or Cognizant Federal 
Agency Official for the contract3 
3.	
the contract should have been retained by the buying organization based on statutory 
or regulatory exclusions, in accordance with DFARS 242.202(a)(i)(ii)4 
1	 DCMA Manual 4502-02, 2021; DCMA, 2023b. 
2	 DFARS, Part 202, Definition of Words and Terms; Section 202.101, Definitions.
3	 FAR, Part 42, Contract Administration and Audit Services; Section 202(a), Assignment of Contract 
Administration; DFARS, Part 242, Contract Administration; Section 242.202, Assignment of Contract 
Administration.
4	 DFARS, Part 242, Section 242.202(a)(i)(ii).

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
48
4.	
the contract is for functions that DCMA is authorized to perform5 
5.	
the request meets high-value or high-risk thresholds or characteristics. 
Whereas the specifics of the first four workload acceptance criteria are grounded in regu-
lation and policy, the high-value and high-risk thresholds are detailed across several manu-
als, instructions, and job aids. If the initial (CMO-level) review determines all criteria are 
met, the work is accepted. Further review takes place at the command level and, if needed, 
at the headquarters level. Rejections at the CMO and region levels are subject to review at a 
higher level. Only the DCMA director has the authority to issue waivers allowing acceptance 
of nonmission work or to decline mission work because of resource constraints.
The high-value and high-risk criteria appear to be the most fungible of the five. The 
FY 2026 DCMA budget, describing workload declines through FY 2026, articulates plans to 
change key workload acceptance criteria for Product Acceptance, Cost and Pricing, Contract 
Administration, and Acquisition Insight to align with the smaller workforce, with much of 
the work redirected to the buying command or program office.6 For example, to support 
reductions in its product acceptance workload, DCMA plans to limit workload acceptance 
of requests for variance and nonconforming material workload ACAT I programs that are 
60 percent or less complete.7
Reimbursable workload acceptance within DCMA is governed by DCMA Manual 4301-12.8 
DCMA can accept only reimbursable work that falls under an approved support agreement 
or other form of documentation (e.g., for Foreign Military Sales programs, Building Part-
ner Capacity programs, or Direct Commercial Sales programs). The manual outlines gen-
eral expectations for budgeting, manpower estimation, and time-recording for reimbursable 
work. These expectations require DCMA to estimate the number of hours required to per-
form each task and record time spent on reimbursable work in the Defense Agencies Initia-
tive system.
The percentage of total DCMA positions funded through reimbursable work has gradu-
ally increased, as funding for reimbursable work has grown while funding levels for mission 
work have declined. Historically, personnel costs account for about 85 percent of DCMA’s 
budget. Therefore, workforce size is the single best index of the organization’s resource avail-
ability. DCMA’s military workforce has remained relatively stable over time, with 436 to 640 
billets since 2008. DCMA’s overall workforce declined from about 20,000 in the early 1990s 
to about 10,000 in 2008 (Figure C.1). Between 2008 and 2015, DCMA’s civilian workforce 
grew to just over 12,700 as part of a DOW-wide effort to strengthen the quality of its acquisi-
5	 FAR, Part 42, Contract Administration and Audit Services; Section 302(a, b), Contract Administration 
Functions; DFARS, Part 242, Contract Administration; Section 242.302(a, b), Contract Administration 
Functions.
6	 DCMA, 2025b.
7	 DCMA, 2025b, p. 11.
8	 DCMA Manual 4301-12, 2024.

Modeling Can Help DCMA Determine the Optimal Balance of Mission and Reimbursable Work
49
tion workforce (of which 85 percent of DCMA’s workforce is a part). Part of that growth was 
funded by the Defense Acquisition Workforce Development Account, which funded career 
development programs for DOW civilian acquisition workers through a separate budget line 
item. Since 2015, the workforce size has steadily declined, reaching a level of just under 10,697 
in FY 2024. 
This decline masks an even larger decline in the number of civilian FTEs dedicated to 
mission work. The share of FTEs supported by reimbursable funding sources stood at 8.2 per-
cent in 2008 (see Figure C.2). By 2024, reimbursable funding sources supported 14 percent 
of DCMA’s FTEs. DCMA’s FY 2026 combined Cyber and Non-Cyber Operations and Man-
agement budget request projects declines in civilian end strength from 10,461 in FY 2024 to 
8,940 in FY 2026, with the reimbursable civilian workforce holding steady at just under 1,500 
and with reimbursable funds accounting for more than 17 percent of civilian FTEs budgeted 
for FY 2026, which is double the 2008 level.9
9	 DCMA, 2025b; DCMA, Fiscal Year 2017 President’s Budget: Defense Contract Management Agency 
(DCMA), February 2016. 
FIGURE C.1
DCMA Workforce, FY 2008 to FY 2024
NOTE: DAWDA = Defense Acquisition Workforce Development Account.
0
2,000
4,000
6,000
8,000
10,000
12,000
14,000
2008
2012
2016
2020
2024
Number of people 
End of fiscal year
Direct civilians
DAWDA civilians
Reimbursable civilians
Military

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
50
Reimbursable work is qualitatively similar to mission work and aligned with task break-
down structures in functional models. When reimbursable work is accepted, it is accounted 
for in the relevant functional model for the location where the workload is performed. When 
not formally modeled by drawing on systems of record inputs, reimbursable work is incorpo-
rated as an additive. When aggregating the functional models into the IRWM, supervisory 
factors are applied to capture the direct overhead associated with the workload. Reimburs-
able workload does not affect the model’s estimates for indirect or general and administra-
tive overhead. If reimbursable work continues to grow as a percentage of DCMA work, this 
approach may need to be revisited.
DCMA has options to improve the IRWM to better support decisionmaking about the 
optimal mix of mission and reimbursable workload and in advocating for the best funding 
mechanism for the agency overall. Specifically, DCMA can
• continue estimating workload and direct overhead charges as it has done up to this
point, or it can model the proposed reimbursable work and direct overhead for a more
precise estimate before entering into memorandums of understanding negotiations
with a potential reimbursable workload customer
• continue to exclude a pro rata share of indirect overhead charges from reimbursable
workload estimates, or, in light of reimbursable work becoming a larger and larger
FIGURE C.2
Reimbursable Positions as a Percentage of Total 
0%
2%
4%
6%
8%
10%
12%
14%
16%
2008
2009
2010
2011
2012
2013
2014
2015
2016
2017
2018
2019
2020
2021
2022
2023
2024
End of fiscal year

Modeling Can Help DCMA Determine the Optimal Balance of Mission and Reimbursable Work
51
part of DCMA’s total workload, include indirect overhead in its reimbursable work-
load estimates
•  continue to accept workload in its bottom-up model, excluding work at the command 
or headquarters level only by exception, or it can adopt a top-down approach to better 
prioritize high-value and high-risk workload over time and across geographical and 
functional areas 
•  continue its ad hoc approach to accepting indeterminate ratios of mission workload 
and reimbursable workload, or it can adopt a more intentional process of optimiz-
ing workforce retention and professional development in light of varying budget and 
staffing levels
•  enter into discussions with the Office of the Under Secretary of War Comptroller, the 
Office of the Under Secretary of War for Acquisition and Sustainment, and other senior 
decisionmakers and policy offices to help proactively shape the optimal quantity and 
type of work assigned to its workforce and the mechanism for budgeting (i.e., budget 
authorization plus reimbursable, pure budget authorization, or working capital fund). 
The IRWM and its supporting ecosystem in its current state or in an enhanced form can 
provide objective input for evidence-based decisionmaking and will provide a firm founda-
tion for agency advocacy in future budget and staffing discussions.

53
APPENDIX D
How Can Contract Management Workload 
Be Quantified?
Quantifying DCMA’s contract management workload presents a particularly complex ana-
lytical challenge. In some instances, attempts to quantify DCMA’s workload have relied on 
such metrics as the total number and dollar value of contract actions processed, the number 
of items delivered to its DOW customers, the number of contractors managed, the ratio of 
liquidated to unliquidated obligations, and other similar measurements. However, reliance 
on such relatively simple metrics—absent further analysis—may not provide an authoritative 
accounting of DCMA’s contract management workload.
For example, one contract action could be associated with the initiation of a new multibil-
lion dollar contract to acquire a weapon system, designated as a Major Defense Acquisition 
Program, with a large multinational corporation acting as the prime contractor. Another 
contract action could be associated with initiating a new multimillion dollar contract to 
acquire systems engineering and technical support services from a U.S.-based small busi-
ness. The former contract would likely be significantly more complex than the latter, and 
tasks associated with executing this new contract would likely take significantly more time 
to complete. As discussed in greater detail in Chapter 4, surveillance for an aircraft program 
involves greater complexity and effort than monitoring basic hardware. Likewise, contracts 
spread across multiple locations can demand much more management time than those con-
ducted at a single site. 
Our interviewees raised these observations as potential reasons why model estimates 
sometimes deviated from on-the-ground realties in terms of actual staffing needs—a critique 
that follows directly from a core principle of manpower modeling that establishes enterprise-
wide task definitions and task times in order to generate consistent, comparable data. CMOs 
have an opportunity to surface such examples during the model validation process. If task 
times vary by some observable characteristic of the work that can be consistently measured, 
a revision to the task breakdown structure can be considered to allow for differentiation in 
the task times. For example, the Quality Assurance WBS for “Corrective Actions” divides 
subtasks for Level I/Level II Corrective Actions into “Response Required–Minor,” “Response 
Required–Major,” and “Response Required–Critical,” establishing separate should-take 
times for each type of response by degree of severity. Another alternative is for the CMO to 
receive an additive above the model estimate to account for the differences.

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
54
Some models included in the RWM also incorporate a complexity weight in should-take 
task times to account for differences in the amount of time taken to complete one instance of 
a task. For example, the Contracting RWM included task complexity metrics that considered 
such factors as contract value, the number of contract line items, and the number of account-
ing classification reference numbers included in a contract. However, this practice was not 
universal; if more fidelity in terms of measuring total DCMA workload is desired, similar 
complexity weights could be established and applied DCMA-wide. 
Complexity weights and the use of more detailed task breakdowns in the WBSs illustrate 
why contract numbers and value cannot fully capture the magnitude of DCMA’s workload.

55
APPENDIX E
How Are Special Programs Modeled?
Special Programs Command provides contract administration services for acquisition pro-
grams with enhanced security protocols. Special Programs positions are modeled through 
two sets of RWMs: 
•  Technical (Engineering, Industrial Specialist, Earned Value, Program Integration, Sup-
port Program Integration, Quality Assurance, and Software)
•  Local (Property, Pricing, and DACO/CACO). 
Although the work performed in Special Programs Command is similar to the work 
performed in other CMOs, it cannot be tracked through the standard unclassified agency 
sources of record used in other parts of DCMA to track technical functions. Because of 
this limitation, Special Program’s Technical Models deviate from the parallel functional 
models used outside Special Programs (see Figure 3.1 for a full listing of the Special Pro-
grams Technical Models, which include Quality Assurance and Earned Value Manage-
ment). Notably, they do not use a WBS and do not have tasks or task times; instead, they 
use a modeling approach with a 1 to n list methodology and S-curve staffing level percent-
ages. The S-curve methodology uses a low bound of 0, 5.1, and 8.1; high bound of 5, 8, and 
10; and staffing level of 40 percent, 60 percent, and 80 percent to optimize resource alloca-
tion in a constrained resource environment. These models rely on a stand-alone Workload 
Allocation Management Tool that collects and reports workload data by CMO, function, 
risk-rating, and other factors. 
Special Programs Local Models are derived from the Enterprise CMO Contracting model 
but with a modified WBS to account for different process requirements. These Local Models 
rely on either Special Programs–specific systems of records or manual data collection, 
depending on the specific function.
The Special Programs modeling team reported that the two models should generate simi-
lar results. However, similarities and differences have never been validated, since the Special 
Programs workload is completely segmented. Organizations (CMOs) use either one set of 
models or another. That approach is changing in FY 2026, with Special Programs Command 
assuming responsibility for contract administration of all DOW drones and unmanned

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
56
systems—both mainstream and special programs.1 For the first time, mainstream and special 
program workload will be conducted within the same CMO. This offers DCMA an oppor-
tunity to validate those assumptions about the alignment between the two sets of models 
and address differences. Allowing CMOs to do both special programs and mainstream work 
could improve efficiency by standardizing performance expectations for the Special Pro-
grams workload, aligning such work with mainstream workload performance expectations, 
and enabling DCMA to balance workload between Special Programs and standard contracts.
1	 Sarah Gauvin, “Special Programs Change of Command Extends Legacy of Leadership, Dedication,” 
Defense Contract Management Agency, July 22, 2025.

57
APPENDIX F
Methodological Approach
As discussed in Chapter 1, we conducted two types of validation: (1) a tactical analysis that 
examined both the IRWM ecosystem and its RWM components and (2) a strategic analysis 
that examined the IRWM in its operating context to assess its accuracy, relevance, and prac-
tical utility. In this appendix, we discuss the methodological approaches underlying these 
assessments. We also discuss the UMR data used in our work. 
Tactical Validation Methods
The tactical validation approach looked at the IRWM ecosystem and its development, imple-
mentation, and validation. In this work, we sought to identify and understand how tasks—as 
depicted in the WBS and reflected in the IRWM component models—were associated with 
assigned missions and objective workload drivers. We (1) examined how task time estimates 
were developed and validated and (2) assessed the manpower availability factor calculations 
used to generate FTE requirements. We used leading practices for workforce modeling (see 
the introduction to Chapter 2 for a survey of these practices) to guide and frame our exami-
nation of how the models were developed, implemented, and validated. 
Our validation began with examining artifacts—including the models, depicted model 
data, briefings, recordings of training presentations, governance policy, spreadsheets, and 
other materials—developed by DCMA while producing and validating the components of the 
IRWM. These artifacts were either directly provided to us by our DCMA sponsor or located 
in a Common Access Card–protected SharePoint repository maintained by the Resource and 
Workload Modeling Team, part of DCMA’s Financial and Business Operations Executive 
Directorate. We reviewed these materials with the intent to ground our tactical validation by 
first documenting and understanding the analytical choices made in the process of establish-
ing the IRWM ecosystem. With this review, we sought to understand such topics as 
•  data input reliability, or the degree to which the data ingested into the IRWM ecosystem 
are of sufficiently high quality, derived from agency systems of record, and reviewed 
through internal and external validation mechanisms1
1	 The full list of DCMA authoritative manpower sources, provided by DCMA in an email to the authors 
dated September 8, 2025, is as follows: Mechanization of Contract Administration Services (MOCAS),

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
58
•  accuracy of model relationships, or the degree to which workload, workload drivers, and 
outputs have been sufficiently and correctly modeled, including the development of 
process maps and taxonomies of core functions
•  scalability, or the degree to which all organizational levels and personnel are depicted 
in the IRWM ecosystem, with the individual models able to be accurately aggregated to 
generate total estimated manpower requirements.2
In total, we reviewed approximately 210 artifacts related to the development, use, and vali-
dation of the model, as well as training material connected to the models. No one artifact—
with the partial exception of a DCMA Manual establishing policy and governance for the 
IRWM, which appeared to still be undergoing coordination at the time of our review—offered 
a comprehensive, authoritative summary of the intended inputs, operation, and validation of 
the IRWM ecosystem.3 Although these artifacts as a whole provided useful background, we 
found that they were oriented to users with a deep understanding of agency operations and 
the specific modeled functions. They were relatively light on context-setting and description 
of how the model pieces fit together or were being used to inform decisionmaking. 
To obtain the necessary context, we interviewed the DCMA SMEs responsible for devel-
oping and validating the components of the IRWM ecosystem. We developed a semistruc-
tured interview protocol to guide our conversations with SMEs responsible for developing 
the Enterprise CMO–level models, Special Programs models, center models, and Cost and 
Pricing Command’s model. In total, we conducted 15 virtual interviews and one in-person 
interview with model SMEs.4 Each interview averaged five DCMA SMEs who were involved 
in the development of the respective models, amounting to approximately 75 DCMA person-
nel interviewed in total.
Shared Data Warehouse (SDW), Procurement Integrated Enterprise Environment (PIEE), Audit Tracking 
and Action Tool (AT-AT), Contract Closeout (CCO), Duty Free Entry (DFE), Award Management Team 
(AMT), Modifications and Delivery Orders (MDO), Contract Administration Services Directory (CASD), 
Contract Deficiency Reports (CDR), Electronic Data Access (EDA), Item Unique Identifier Registry (IUID), 
Product Data Reporting and Evaluation Program (PDREP), Contract Business Analysis Repository (CBAR), 
Commercial Item Determination (CID) Database, Delivery Schedule Manager (DSM), Government Fur-
nished Property (GFP), Joint Appointment Module (JAM) & Surveillance and Performance Monitoring 
(SPM), Wide Area Workflow (WAWF), Contract Administration Management System (CAMS), Contract 
Audit Follow-Up (CAFU), Integrated Workload Management System (IWMS), Fourth Estate Manpower 
Tracking System (FMTS), Defense Agencies Initiative, Technical Value-Added Database (TVAD), and 
Online Aerospace Supplier Information System (OASIS). 
2	 As derived, in part, from a workforce requirements model maturity framework, included as an attach-
ment to Department of Homeland Security, 2021.
3	 DCMA Manual 4301-10, undated.
4	 Given the complexities of the Cost and Pricing Command’s unique divisional models, we conducted 
multiple interviews with SMEs responsible for developing each divisional model.

Methodological Approach
59
Strategic Validation Methods
We undertook a strategic validation designed to understand how stakeholders across DCMA 
view and use the IRWM model and its estimates as a complement to the tactical validation 
of the model itself. Specifically, we sought their feedback on the extent to which the model 
captures the work being done by the organization and the manpower resources required to do 
the work. We used a qualitative research design that relied on semistructured interviews with 
supervisory personnel from selected CMOs. In total, we conducted 34 in-person interviews 
and 11 virtual interviews with DCMA personnel. Each interview averaged approximately 
five participants, amounting to roughly 150 total personnel across the strategic validation. 
The interviews aimed to elicit insights into how the IRWM operates in practice, its alignment 
with mission objectives, and its usefulness for decisionmaking. Data from these interviews 
were analyzed thematically.
What Was Asked
In our interviews, we examined the extent to which the IRWM reflects the actual scope of 
work performed, aligns with organizational missions, and supports decisionmaking in its 
current configuration. Participants described their responsibilities, the relationship of their 
functions to DCMA’s core missions, and how those functions have evolved since the model’s 
introduction in 2023 in response to shifting priorities, organizational changes, and emerging 
operational demands.
A central focus was task representation. Participants considered whether the model 
includes all activities they perform and, for each activity, whether there is a clear authoritative 
source that justifies its inclusion. This line of inquiry was intended to determine whether each 
modeled task has a documented basis that explains its necessity and relevance, as opposed 
to being an undocumented or discretionary activity. Discussions also examined whether any 
modeled tasks are no longer performed or lie outside the unit’s responsibility.
We further explored the perceived validity of model data and outputs in the interviews. 
Respondents assessed whether estimates for task frequency, duration, and manpower require-
ments aligned with operational experience, whether the sequencing of modeled work steps 
matched actual processes, and how closely the model’s metrics corresponded with internal 
time-tracking or reporting systems. We asked whether respondents had received such mate-
rials as standard operating procedures, guidelines, or standards that explain the model’s 
structure and intended use. We also asked whether respondents found these materials useful 
for interpreting and applying the model.
The interviews also addressed the perceived practical utility of the model. Participants 
described whether and how the model has been applied in decisionmaking, the benefits 
and challenges experienced in operational contexts, and their experiences with the valida-
tion process.

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
60
Site Selection
We designed the site selection process to produce a representative and analytically robust 
sample of CMOs for interviews. The intent was to capture variation in mission scope, con-
tract profile, and organizational structure to best understand how workforce modeling trans-
lates into operational execution across DCMA.
We considered multiple operational, contractual, and structural characteristics in our 
selection criteria. These characteristics included the size and complexity of managed con-
tracts, contract types (e.g., fixed-price, cost-plus, or hybrid instruments), the number of 
authorized billets, organizational alignment as either Geographic or Product Line, customer 
type, and geographic location. We used UMR data to calculate the mean and standard devia-
tion of personnel counts across CMOs. Offices within one standard deviation of the mean 
were considered broadly representative in size.
Organizational classification followed DCMA’s Geographic and Product Line categories. 
Contract activity data were obtained from SAM.gov for FY 2023, filtered to isolate contract 
actions executed by DCMA CMOs. Because DCMA had recently realigned its organizational 
structure, we mapped contract data to the current framework using DCMA General Orders 
and associated organizational realignment records. This ensured a consistent basis for com-
paring contract activity across CMOs.
With the aligned dataset, CMOs were ranked by the total obligated dollar value of con-
tracts in FY 2023 to identify those with the highest levels of mission activity. From this 
ranked set, we selected eight CMOs, four Geographic offices, four Product Line offices, one 
office from DCMA Special Programs, and DCMA International. Priority was given to offices 
with substantial contract volume and those identified as strategically significant in internal 
DCMA documentation. 
Logistical efficiency also shaped final selections. We sought to minimize travel time and 
cost by assigning researchers already located near candidate CMOs, prioritizing locations 
where multiple offices could be visited on a single trip. When multiple CMOs met the same 
selection criteria, we used practical considerations, such as scheduling constraints, to deter-
mine the final set. The final set of CMOs selected for site visits and interviews is listed in 
Table F.1. 
Unit Manning Report Data
For this study, we received and reviewed DCMA’s UMR as of August 2024. We also obtained 
and reviewed the UMR for the end of FY 2015 to examine whether there had been any notable 
shifts in the workforce structure over the past decade. 
Billet information can be broken down across several dimensions at multiple levels 
using the UMR, which provides an account of all authorized billets across the agency. 
Approaching the organization from this billet-level view provides a “bottom-up” perspec-
tive on DCMA that complements the hierarchical view of the agency’s organizational chart

Methodological Approach
61
and provides a more granular understanding of the workforce. We used this information 
to select sites for in-depth interviews and to cross-validate other information provided to 
us directly by DCMA.
In total, the 2024 UMR identifies 14,255 positions at DCMA. According to data provided 
in the DCMA Overview Brief (published in July 2024), there are 10,720 employees within 
DCMA, including civilians, active-duty military, and reservists. This indicates that there are 
approximately 3,500 vacancies across the established manpower structure within the agency.
The UMR illustrates the organization of the DCMA workforce in two primary ways. The 
first is through a compartmentalized departmental view of the agency, which locates a spe-
cific billet within the four-tier set of subdivided compartments. The second is through a 
characterization of individual billets based on their unique identifiers, including the grade, 
supervisory level, military or civilian status, and other features of the position.
In terms of the departmental view, the UMR indicates four levels of compartmentaliza-
tion, and all billets across DCMA are specified to at least two levels within the agency’s orga-
nizational structure. At each level, the UMR provides a code for the organizational unit, 
which increases in specificity depending on how many levels down within the compartmen-
talized scheme the billet is located. The highest-level compartment is Command (e.g., P1), the 
second level is CMO or Directorate (e.g., P1-A), the third level is Group, Center, or Division 
(e.g., P1-AA), and the fourth level is the billet’s Department (e.g., P1-AAA). Some billets are 
only specified to the second or third level, so their names and organizational codes for the 
subordinate third and/or fourth levels are the same as that highest level of specificity.
Command, the largest organizational unit, breaks out into nine subdivisions: four geo-
graphic subdivisions (Eastern Regional, Central Regional, Western Regional, and Interna-
TABLE F.1
Contract Management Office Site Visits
Name
Location
Total Obligation 
Authority in FY 2023
Number of Personnel
DCMA Northeast
Hanscom Air Force Base, 
Massachusetts
$14.0 million
590
DCMA Southern California Los Angeles, California
$16.1 million
493
DCMA Palmdale
Palmdale, California
$99.3 million
151
DCMA Mountain Pacific
Denver, Colorado
$76.1 million
530
DCMA Space Enterprise
Littleton, Colorado
$17.2 million
241
DCMA Ohio River Valley
Wright-Patterson Air Force 
Base, Ohio
$9.8 million
325
DCMA Southeast
Orlando, Florida
$99.7 million
460
DCMA Special Programs
N/A
N/A
N/A
NOTE: Amounts for total obligation authority and number of personnel are approximate. We are unable to report the location, 
obligation authority, and personnel counts for Special Programs.

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
62
tional), four functional or programmatic subdivisions (Cost and Pricing, Information Tech-
nology, AIMO, and Special Programs), and one for the Headquarters Command of DCMA. 
In mapping this organizational structure for an assessment of the future manpower structure 
for DCMA, one point of uncertainty we encountered is whether the geographic organiza-
tional subdivision will continue to be used, since DCMA has indicated that the agency is 
moving away from organizing by region and emphasizing organizing by functions. 
Below the command level, 131 distinct CMOs and Directorates make up the second level 
of DCMA compartmentalization. The relationship between the Commands and the CMOs 
and Directorates is difficult to characterize in a standardized way. For certain organizational 
units, it is hierarchical or geographical, and the CMOs and Directorates are direct subordi-
nate units specified within the Command structure (e.g., AIMO Greenville). In other cases, 
CMOs and Directorates are present within all Commands (e.g., Contracts Group and Quality 
Assurance Group) except the Headquarters Command, and these seem to represent a stan-
dardized set of functional units by which the DCMA workforce is organized. 
This second level of the organizational scheme provided by the UMR appears to be a 
useful lens for mapping DCMA’s structure, since the CMOs and Directorates directly link to 
the Command structure while indicating a distinct and unique organizational unit without 
becoming too complicated. Going further down, there are 435 Groups, Centers, and Divi-
sions at the third level and 1,288 Departments at the fourth level.
We also analyzed the UMR to understand the DCMA workforce structure and to assess 
whether there had been any change over time by analyzing characteristics of individual bil-
lets. We examined several features of the individual billets, including the skill code, acquisi-
tion functional area, service status (civilian or military), geographic description, and supervi-
sor level. We observed remarkable stability in the workforce between 2015 and 2024 in terms 
of key characteristics.

63
Abbreviations 
AIMO
Aircraft Integrated Maintenance Operations
CACO
Corporate Administrative Contracting Officer
CMO
contract management office
DACO
Divisional Administrative Contracting Officer
DCMA
Defense Contract Management Agency
DFARS
Defense Federal Acquisition Regulation Supplement
DLA
Defense Logistics Agency
DoD
U.S. Department of Defense
DOW
U.S. Department of War
FAR
Federal Acquisition Regulation
FMTS
Fourth Estate Manpower Tracking System
FTE
full-time equivalent
FY
fiscal year
IM
Integrated Model 
IRWM
Integrated Resource Workload Model
NASA
National Aeronautics and Space Administration
OMB
Office of Management and Budget
PDREP
Product Data Reporting and Evaluation Program
RWM
Resource Workload Model
SME
subject-matter expert
UMR
Unit Manning Report
WBS
work breakdown structure

65
Bibliography 
Air Force Manual 38-102, Manpower and Organization Standard Work Processes and 
Procedures, Department of the Air Force, updated July 5, 2024.
Bruneau, Thomas C., “It’s All About Incentives—Lessons for DoD Acquisitions,” Defense 
Acquisition Magazine, May–June 2025. 
Chindea, Irina A., Susan M. Gates, Katherine C. Hastings, Jennifer Lamping Lewis, Emmi 
Yonekura, Samantha Cherney, Christine DeMartini, Molly Dunigan, Jonah Kushner, and 
Barbara Bicksler, Creating Readiness Metrics for the Army Civilian Workforce: A Way Ahead for 
Integrating Readiness into Civilian Workforce Planning, RAND Corporation, RR-A2225-1, 2023. 
As of July 25, 2025:  
https://www.rand.org/pubs/research_reports/RRA2225-1.html
Code of Federal Regulations, Title 2, Federal Financial Assistance; Subtitle A, Office of 
Management and Budget Guidance for Federal Financial Assistance; Chapter II, Office of 
Management and Budget Guidance; Part 200, Uniform Administrative Requirements, Cost 
Principles, and Audit Requirements for Federal Awards; Subpart E, Cost Principles.
DCMA—See Defense Contract Management Agency.
Defense Acquisition University, “General and Administrative (G&A) Costs,” webpage, undated. 
As of September 8, 2025:  
https://www.dau.edu/acquipedia-article/general-and-administrative-ga-costs
Defense Contract Management Agency, “About DCMA,” webpage, undated. As of September 21, 
2025:  
https://www.dcma.mil/About-Us/ 
Defense Contract Management Agency, Fiscal Year 2017 President’s Budget: Defense Contract 
Management Agency (DCMA), February 2016. As of September 22, 2025:  
https://comptroller.defense.gov/Portals/45/Documents/defbudget/FY2017/budget_justification/
pdfs/01_Operation_and_Maintenance/O_M_VOL_1_PART_1/DCMA_OP-5.pdf
Defense Contract Management Agency, “DCMA Tailorable Contract Administration Services 
(CAS),” briefing slides, February 14, 2023a. As of August 29, 2025:  
https://www.dau.edu/sites/default/files/Migrate/EventAttachments/850/ 
Tailorable%20CAS%202.14.23.pdf
Defense Contract Management Agency, “DCMA Workload Acceptance (WA) Overview,” 
briefing slides, February 14, 2023b. As of August 25, 2025:  
https://www.dau.edu/sites/default/files/Migrate/EventAttachments/850/ 
DCMA_WORKLOAD_ACCEPTANCE_OVERVIEW_ao_14February2023.pdf
Defense Contract Management Agency, “Resource Workload Model Integrated Model Version 2 
(IMv2) Training,” briefing slides, March 1, 2024a, Not available to the general public.
Defense Contract Management Agency, “Manpower Availability Factor Computation,” briefing 
slides, October 30, 2024b, Not available to the general public.
Defense Contract Management Agency, INSIGHT, 2025a. 
Defense Contract Management Agency, Fiscal Year 2026 Budget Estimates: Defense Contract 
Management Agency, June 2025b. As of September 21, 2025:  
https://comptroller.defense.gov/Portals/45/Documents/defbudget/FY2026/budget_justification/
pdfs/01_Operation_and_Maintenance/O_M_VOL_1_PART_1/DCMA_OP-5.pdf

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
66
Defense Contract Management Agency, Fiscal Year 2026 Budget Estimates: Defense Contract 
Management Agency Cyber, June 2025c. As of September 9, 2025:  
https://comptroller.defense.gov/Portals/45/Documents/defbudget/FY2026/budget_justification/
pdfs/01_Operation_and_Maintenance/O_M_VOL_1_PART_1/DCMA_Cyber_OP-5.pdf
Defense Contract Management Agency, “Historical Perspective: DCMA Scope of Work and 
Resources (FY24),” briefing slide, August 20, 2025d, Not available to the general public. 
Defense Contract Management Agency Manual 2501-11, International Requests for Contract 
Administration Services, Defense Contract Management Agency, June 26, 2025. 
Defense Contract Management Agency Manual 4301-02, Volume 2, Budget Formulation and 
Execution: Budget Execution, Defense Contract Management Agency, April 8, 2024. 
Defense Contract Management Agency Manual 4301-09, Manpower and Mission Analysis, 
Defense Contract Management Agency, July 15, 2019. 
Defense Contract Management Agency Manual 4301-10, Resource Workload Model (RWM) 
Integrated Model, draft, Defense Contract Management Agency, undated, Not available to the 
general public.
Defense Contract Management Agency Manual 4301-12, Reimbursable Programs, Defense 
Contract Management Agency, April 8, 2024. 
Defense Contract Management Agency Manual 4501-01, Agency Issuance Program, Defense 
Contract Management Agency, March 18, 2024. 
Defense Contract Management Agency Manual 4502-02, Workload Acceptance, Defense 
Contract Management Agency, September 15, 2021. 
Defense Federal Acquisition Regulation Supplement, Part 202, Definitions of Words and Terms; 
Section 202.101, Definitions.
Defense Federal Acquisition Regulation Supplement, Part 242, Contract Administration; 
Section 242.202, Assignment of Contract Administration.
Defense Federal Acquisition Regulation Supplement, Part 242, Contract Administration; 
Section 242.302, Contract Administration Functions.
Defense Federal Acquisition Regulation Supplement, Part 252, Solicitation Provisions and 
Contract Clauses; Section 252.204-7012, Safeguarding Covered Defense Information and Cyber 
Incident Reporting. 
Defense Federal Acquisition Regulation Supplement, Part 252, Solicitation Provisions and 
Contract Clauses; Section 252.204-7020, NIST SP 800-171 DoD Assessment Requirements.
Department of Defense Directive 5105.64, Defense Contract Management Agency (DCMA), U.S. 
Department of Defense, January 10, 2013, change 1, March 2, 2023. 
Department of Homeland Security, “Workforce Requirements Model Verification, Validation, 
and Accreditation,” memorandum, October 1, 2021.
DFARS—See Defense Federal Acquisition Regulation Supplement.
DiNapoli, Timothy J., Contractor Business Systems: DOD Needs Better Information to Monitor 
and Assess Review Process, U.S. Government Accountability Office, GOA-19-212, February 2019. 
DoD—See Department of Defense.
Evans, Ryan, “An Early, Easy, and Essential Win for Trump on Defense Acquisitions Is Within 
Reach,” War on the Rocks, January 27, 2025.

Bibliography
67
Executive Order 14275, “Restoring Common Sense to Federal Procurement,” Executive Office of 
the President, April 15, 2025. 
FAR—See Federal Acquisition Regulation.
Federal Acquisition Regulation, Part 42, Contract Administration and Audit Services; Section 
202, Assignment of Contract Administration.
Federal Acquisition Regulation, Part 42, Contract Administration and Audit Services; Section 
302, Contract Administration Functions. 
Fox, J. Ronald, Defense Acquisition Reform, 1960–2009: An Elusive Goal, U.S. Army Center of 
Military History, 2011. 
Gates, Susan M., Shining a Spotlight on the Defense Acquisition Workforce—Again, RAND 
Corporation, OP-266-OSD, 2009. As of September 21, 2025:  
http://www.rand.org/pubs/occasional_papers/OP266.html
Gates, Susan M., Elizabeth A. Roth, and Jonas Kempf, Department of Defense Acquisition 
Workforce Analyses: Update Through Fiscal Year 2021, RAND Corporation, RR-A758-2, 2022. 
As of September 10, 2025:  
https://www.rand.org/pubs/research_reports/RRA758-2.html
Gauvin, Sarah, “Special Programs Change of Command Extends Legacy of Leadership, 
Dedication,” Defense Contract Management Agency, July 22, 2025. 
General Services Administration, “Policy & Guidance,” webpage, Acquisition.gov, undated. As 
of September 21, 2025:  
https://www.acquisition.gov/far-overhaul/policy-and-guidance 
Grant Thornton and Professional Services Council, 2017 Government Contractor Survey, Spring 
2018.
Hegseth, Pete, “Unleashing U.S. Military Drone Dominance,” memorandum, U.S. Department 
of Defense, July 10, 2025.
Hutton, John P., Defense Contract Management Agency: Amid Ongoing Efforts to Rebuild 
Capacity, Several Factors Present Challenges in Meeting Its Missions, U.S. Government 
Accountability Office, GAO-12-83, November 2011. 
Johnson, Tonya, “DCMA Stands Up New CMOs,” Defense Contract Management Agency, 
July 3, 2025. 
McDonnell, Janet A., “A History of Defense Contract Administration,” Defense Contract 
Management Agency, March 5, 2020. 
Nataraj, Shanthi, Christopher Guo, Philip Hall-Partyka, Susan M. Gates, and Douglas Yeung, 
Options for Department of Defense Total Workforce Supply and Demand Analysis: Potential 
Approaches and Available Data Sources, RAND Corporation, RR-543-OSD, 2014. As of June 26, 
2025:  
https://www.rand.org/pubs/research_reports/RR543.html
Neenan, Alexandra G., Department of Defense Contract Pricing, Congressional Research 
Service, R47879, December 19, 2023. 
OMB Circular No. A-11, Preparation, Submission, and Execution of the Budget, Office of 
Management and Budget, August 2022. As of September 22, 2025:  
https://web.archive.org/web/20221205061634/https://www.whitehouse.gov/wp-content/
uploads/2018/06/a11.pdf

The Defense Contract Management Agency’s Resource Workload Model Ecosystem
68
OMB Circular No. A-76, Performance of Commercial Activities, Office of Management and 
Budget, May 29, 2003. As of September 21, 2025:  
https://bidenwhitehouse.archives.gov/wp-content/uploads/legacy_drupal_files/omb/circulars/
A76/a76_incl_tech_correction.pdf 
Rawls, Darius D., Arthur L. Stone, and Justin B. Woods, Systemic Delay in Defense Contracting: 
A Case Study of the Defense Contract Management Agency’s Contract Closeout Backlog from 
FY2015 to FY2020, thesis, Naval Postgraduate School, December 2023. 
Robbert, Albert A., Avery Calkins, and Louis T. Mariano, Modeling for Manpower and Personnel 
Policy Analysis: Applications in RAND Research, RAND Corporation, TL-A3401-1, 2024. As of 
June 27, 2025:  
https://www.rand.org/pubs/tools/TLA3401-1.html
Robbert, Albert A., and Hilary Reininger, Determining Staffing Needs for Administrative, 
Professional, and Technical Workers in the U.S. Secret Service: A User Guide for Workforce 
Staffing Models, Homeland Security Operational Analysis Center operated by the RAND 
Corporation, TL-353-DHS, 2020. As of July 7, 2025:  
https://www.rand.org/pubs/tools/TL353.html
Ross, Ron, and Victoria Pillitteri, Protecting Controlled Unclassified Information in Nonfederal 
Systems and Organizations, National Institute of Standards and Technology, Special Publication 
800-171r3, May 2024. 
Schulker, David, Nelson Lim, and Albert A. Robbert, Determining Staffing Needs for 
Administrative, Professional, and Technical Workers in the U.S. Secret Service: Methods and 
Lessons Learned, Homeland Security Operational Analysis Center operated by the RAND 
Corporation, RR-3206-DHS, 2020. As of July 7, 2025:  
https://www.rand.org/pubs/research_reports/RR3206.html
Sehgal, Mona, Contract Financing: Factors That Influence the Use of Financing Methods and 
DOD’s Progress on Proposed Actions, U.S. Government Accountability Office, GAO-24-106850, 
May 2024. 
Tremblay, Patrick, “Vision 2026, ‘Structure by Choice,’” Defense Contract Management Agency, 
October 13, 2023. 
Under Secretary of Defense for Acquisition and Sustainment, “Defense Contract Management 
Agency Mission Changes,” memorandum, U.S. Department of Defense, May 20, 2019.
U.S. Bureau of Labor Statistics, “Occupational Employment and Wage Statistics (OEWS) 
Tables,” webpage, updated July 23, 2025. As of October 24, 2025:  
https://www.bls.gov/oes/tables.htm
U.S. Department of Labor, “Fact Sheet #17C: Exemption for Administrative Employees Under 
the Fair Labor Standards Act (FLSA),” webpage, updated August 2024. As of October 24, 2025:  
https://www.dol.gov/agencies/whd/fact-sheets/17c-overtime-administrative
Ward, Dan L., Rob Tripp, and Bill Maki, Positioned: Strategic Workforce Planning That Gets the 
Right Person in the Right Job, American Management Association, 2013.
Wedgie, Phil, “PDREP Innovates Agency Business,” Defense Contract Management Agency, 
December 21, 2022. 
Welch, Carley, “Pentagon Shifts Control of Blue UAS List to DCMA in Effort to Scale Secure 
Drone Fleet,” Breaking Defense, July 11, 2025. 
Woods, William T., Defense Contracts: Improved Information Sharing Could Help DOD 
Determine Whether Items Are Commercial and Reasonably Priced, U.S. Government 
Accountability Office, GAO-18-530, July 2018.

$24.00
RR-A3524-1
9
7 8 1 9 7 7 4 1 5 8 5 1
ISBN-13 978-1-9774-1585-1
ISBN-10 1-9774-1585-7
52400
T
he core mission of the Defense Contract Management 
Agency (DCMA) is to provide oversight, administration, and 
support for the defense contracts that deliver the supplies 
and services that are critical to U.S. Department of War 
(DOW) warfighting capabilities and business operations. 
In 2014, DCMA launched a resource workload modeling effort with the 
potential to provide better data to help size and shape its workforce to 
maximize its efficiency and effectiveness.
The authors of this report evaluate DCMA’s Integrated Resource 
Workload Model (IRWM), its Resource Workload Model (RWM) 
components, and the ecosystem in which the IRWM operates. They 
focus on the IRWM’s ability to shed light on two key questions of interest 
to DCMA and DOW leaders: (1) whether DCMA is accepting the highest-
priority mission work, given current funding and staffing levels, and (2) 
whether DCMA is doing work efficiently and to the appropriate standard 
of performance.
www.rand.org
NATIONAL DEFENSE RESEARCH INSTITUTE