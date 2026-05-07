# Decisive Economic Advantage: Modeling the Transition from Temporary First-Mover Leads to Economic Dominance in Artificial General Intelligence

**來源：** RAND
**日期：** 2026-02-23
**URL：** https://www.rand.org/pubs/research_reports/RRA4444-1.html

---

TOBIAS SYTSMA
Decisive Economic 
Advantage
Modeling the Transition from Temporary First-Mover 
Leads to Economic Dominance in Artificial General 
Inetlligence
Research Report

For more information on this publication, visit www.rand.org/t/RRA4444-1.
About RAND
RAND is a research organization that develops solutions to public policy challenges to help make communities throughout the world 
safer and more secure, healthier and more prosperous. RAND is nonprofit, nonpartisan, and committed to the public interest. To learn 
more about RAND, visit www.rand.org.
Research Integrity
Our mission to help improve policy and decisionmaking through research and analysis is enabled through our core values of quality 
and objectivity and our unwavering commitment to the highest level of integrity and ethical behavior. To help ensure our research 
and analysis are rigorous, objective, and nonpartisan, we subject our research publications to a robust and exacting quality-assurance 
process; avoid both the appearance and reality of financial and other conflicts of interest through staff training, project screening, 
and a policy of mandatory disclosure; and pursue transparency in our research engagements through our commitment to the open 
publication of our research findings and recommendations, disclosure of the source of funding of published research, and policies to 
ensure intellectual independence. For more information, visit www.rand.org/about/research-integrity.
RAND’s publications do not necessarily reflect the opinions of its research clients and sponsors.
Published by the RAND Corporation, Santa Monica, Calif.
© 2026 RAND Corporation
 is a registered trademark.
Limited Print and Electronic Distribution Rights
This publication and trademark(s) contained herein are protected by law. This representation of RAND intellectual property is 
provided for noncommercial use only. Unauthorized posting of this publication online is prohibited; linking directly to its webpage 
on rand.org is encouraged. Permission is required from RAND to reproduce, or reuse in another form, any of its research products for 
commercial purposes. For information on reprint and reuse permissions, visit www.rand.org/about/publishing/permissions.
RR-A4444-1

iii 
About This Report 
This report introduces the concept of decisive economic advantage (DEA) as a framework for 
understanding when early leads in artificial general intelligence (AGI) become a lasting, self-
reinforcing dominance rather than a temporary head start. A DEA emerges when AI capabilities, real-
world deployment, and reinvestment create feedback loops that widen the gap between leaders and 
followers over time. Once these dynamics take hold, falling behind becomes essentially permanent and 
rivals can no longer catch up through policy changes or market competition alone.  
We build a model comparing competing blocs across three dimensions: how advanced their AI 
technology is, how extensively they have deployed it, and how much hardware and capital they have 
accumulated. The model identifies conditions under which competitors converge toward balance 
versus those in which gaps grow irreversibly. Our analysis reveals multiple pathways to a DEA. In 
some scenarios, leading-edge AI directly accelerates further AI progress. In others, widespread 
deployment generates returns that fund additional investment, compounding early advantages. We 
conducted simulations to explore how these dynamics play out under a range of assumptions, because 
many key factors remain deeply uncertain. The findings carry implications for economic security and 
geopolitical competition.  
Center for the Geopolitics of Artificial General Intelligence 
RAND Global and Emerging Risks is a division of RAND that delivers rigorous and objective 
public policy research on the most consequential challenges to civilization and global security. This 
work was undertaken by the division’s Center for the Geopolitics of Artificial General Intelligence 
(AGI), which is committed to helping decisionmakers understand, anticipate, and prepare to navigate 
the national security and geopolitical implications of AGI. For more information, 
visit www.rand.org/global-and-emerging-risks/centers/geopolitics-of-agi.  
Funding 
This research was independently initiated and conducted within the Center for the Geopolitics of 
Artificial General Intelligence using income from operations and gifts from RAND supporters, 
including philanthropic gifts made or recommended by DALHAP Investments Ltd., Ergo Impact, 
Founders Pledge, Charlottes och Fredriks Stiftelse, Good Ventures, Longview, and Coefficient 
Giving. RAND donors and grantors have no influence over research findings or recommendations.

iv 
Acknowledgments 
I would like to thank Vegard Nyaard and Anton Korinek for their thoughtful reviews, as well as 
Joel Predd and Patricia Paskov for comments on an earlier draft of this report.

v 
Summary 
Issue 
When do early leads in artificial general intelligence (AGI) capabilities translate into durable 
economic dominance rather than temporary gains? This question is central to strategic geopolitical 
concerns about AGI.  
One perspective, grounded in the economics of technological change, is to treat AGI as 
transformative but ultimately diffusive. In this view, rivals can invest, imitate, and reallocate resources, 
so early advantages tend to erode over time. The main uncertainty is the speed of diffusion, not 
whether convergence occurs in the long run. A competing view is that AGI may differ from past 
general-purpose technologies in ways that would allow a leader to permanently entrench its position, 
and an early advantage could translate into an enduring constraint on a rival’s ability to compete.  
Despite the stakes, these debates often rely on competing intuitions without a shared framework 
for distinguishing temporary first-mover gains from structurally self-reinforcing advantages. This gap 
matters because strategic choices, such as research and development investment, supply chain policy, 
diffusion controls, and international coordination, might implicitly assume different answers to the 
question. Misdiagnosis of the underlying regime risks either overreacting to transient leads or 
underestimating conditions under which early advantages become durable. 
This report provides a framework for analyzing when economic feedback converts temporary 
technological leads into durable constraints on a rival’s ability to compete, with implications for 
strategic economic and geopolitical priorities. This report is intended for researchers and analysts 
concerned with the strategic dynamics of AGI development, including those working on artificial 
intelligence (AI) competition, economic security, and long-run technological advantage.  
Approach 
This report develops a dynamic economic model that captures the forces governing AGI 
competition between two competing economies. The model tracks the evolution of several 
interconnected gap variables between a leader and a follower: the technology quality gap; the 
deployment intensity gap; the hardware capacity gap; and, in some instances, an additional capital gap. 
These channels generate feedback dynamics in which superior technology facilitates broader 
deployment, deployment generates learning-by-doing effects that enhance technological capability, 
and economic gains from successful deployment finance infrastructure expansion. We analyze 
outcomes across regimes that differ in how quickly investment scales and how strongly hardware 
limits deployment. Monte Carlo simulation across thousands of parameters spanning wide uncertainty 
ranges identifies robust patterns under deep parameter uncertainty.

vi 
Key Findings 
• This report introduces the concept of decisive economic advantage (DEA). A DEA is 
defined by an economic regime in which feedback among capability, deployment, and capital 
accumulation widens competitive asymmetries over time, progressively limiting the follower’s 
ability to contest the leader’s position. This reframes strategic advantages as an emergent 
property of interacting economic systems rather than a single technological metric crossing a 
threshold. 
• Dominance emerges through multiple mechanisms, making an intelligence explosion 
sufficient but not necessary for a DEA. Although self-reinforcing AI capability gains offer 
one pathway to dominance, the model identifies distinct accumulation-driven pathways that 
operate without recursive self-improvement. Specifically, development flywheels (in which 
deployment generates learning data) and reinvestment loops (in which economic gains finance 
infrastructure moats) can drive divergence through economic feedback alone.  
• DEA is a robust structural possibility but not an inevitability. Across a simulation space 
spanning deep parameter uncertainty, the results identify two robust competitive regimes. In 
the first, natural equilibrating forces (such as technology diffusion or capital adjustment 
frictions) successfully dampen early leads, leading to convergence. In the second, feedback 
mechanisms exceed critical thresholds, causing even modest initial leads to compound into 
extreme economic dominance.  
• The leverage of strategic intervention decays as economic asymmetries widen. Acting 
while the economic gap is still small offers the follower substantially higher returns than 
attempting to stop the leader’s momentum after more-significant asymmetries have emerged. 
Furthermore, intervention effectiveness depends on the underlying mechanism driving the 
DEA. Although intelligence-explosion dynamics are generally resistant to interventions once 
established, accumulation-driven DEAs can be delayed or avoided though intervention by the 
follower. 
Implications for AGI Strategy 
• Monitor for regime transitions rather than just capability milestones. The critical strategic 
question is which feedback mechanisms are active and whether the system is shifting from 
convergence to divergence. 
• Make strategy conditional on mechanism. Frontier-driven and accumulation-driven 
pathways respond to different interventions. Policies effective against one may have limited 
leverage against the other.  
• Prioritize monitoring indicators that track feedback intensity. Key variables could include 
the rate of deployment scaling, the intensity of hardware investment, and the magnitude of 
learning-by-doing effects that translate deployment into model capabilities. 
• Design for early response under uncertainty. Given the timing findings, the window for 
action may be shorter than traditional policy cycles allow. Strategic postures should be

vii 
designed for rapid response, investing in decisionmaking infrastructure, prepositioned options, 
and analytical capabilities needed to act quickly when conditions warrant. 
Limitations 
The model uses several simplifying assumptions that bound interpretation of the results. For 
instance, the analysis assumes that AGI can perfectly substitute for human labor; does not model 
alignment failures, misuse, or loss of control; and assumes that AGI systems can be reliably deployed. 
Consequently, the findings should be interpreted as conditional on successful navigation of these 
challenges. Results characterize structural dynamics under idealized conditions rather than precise 
quantitative forecasts.

viii 
Contents 
About This Report ........................................................................................................................................................... iii 
Summary ............................................................................................................................................................................. v 
Figures and Tables ............................................................................................................................................................. x 
CHAPTER 1 ........................................................................................................................................................................................ 1 
Introduction ........................................................................................................................................................................ 1 
Research Questions and Approach ............................................................................................................................ 2 
Contributions ................................................................................................................................................................ 3 
Organization of This Report ....................................................................................................................................... 3 
CHAPTER 2 ........................................................................................................................................................................................ 5 
Model Derivation and Discussion ................................................................................................................................... 5 
Related Literature ......................................................................................................................................................... 5 
Production Technology with Perfect Substitution .................................................................................................. 6 
Dynamics of Technology and Deployment Gaps ..................................................................................................... 9 
Capital Accumulation Regimes ................................................................................................................................. 11 
Stability Analysis ........................................................................................................................................................ 13 
FMAs and DEAs ........................................................................................................................................................ 15 
CHAPTER 3 ...................................................................................................................................................................................... 18 
Parameterization and Empirical Setup ......................................................................................................................... 18 
Monte Carlo Methodology ........................................................................................................................................ 22 
CHAPTER 4 ...................................................................................................................................................................................... 24 
Discussion of Results ....................................................................................................................................................... 24 
Archetypes ................................................................................................................................................................... 24 
Overview of Simulation Outcomes ........................................................................................................................... 26 
Summary Results ........................................................................................................................................................ 28 
Analysis of DEA-100s ................................................................................................................................................ 29 
Discussion and Robustness ....................................................................................................................................... 34 
CHAPTER 5 ...................................................................................................................................................................................... 35 
Conclusion and Strategy Implications .......................................................................................................................... 35 
DEA Reframed ........................................................................................................................................................... 35 
What Drives Decisiveness? ........................................................................................................................................ 36 
Implications for AGI Strategy .................................................................................................................................. 38 
The Broader Contribution ........................................................................................................................................ 39 
APPENDIX A .................................................................................................................................................................................... 40 
Stability Conditions ......................................................................................................................................................... 40 
General Definitions and State Space ........................................................................................................................ 40 
Case 1: Fast-Capital Adjustment and Nonbinding Hardware ............................................................................. 41 
Case 2: Fast-Capital Adjustment and Binding Hardware ..................................................................................... 41

ix 
Case 3: Slow-Capital Adjustment and Nonbinding Hardware ............................................................................ 42 
Case 4: Slow-Capital Adjustment and Binding Hardware ................................................................................... 42 
APPENDIX B .................................................................................................................................................................................... 44 
Imperfect Substitution Between Human and AGI Labor .......................................................................................... 44 
Income Gap Dynamics Under Imperfect Substitution .......................................................................................... 44 
Implications for Interpretation ................................................................................................................................. 45 
APPENDIX C .................................................................................................................................................................................... 47 
Assumptions, Limitations, and Interpretation ............................................................................................................. 47 
Perfect Substitution Between Human and AI Labor ............................................................................................ 47 
Single-Good Economy with Homogeneous Technology ...................................................................................... 48 
Linear Dynamics and Constant Parameters ............................................................................................................ 48 
Exogenous Savings Rates ........................................................................................................................................... 48 
Hardware as a Unidimensional Constraint ............................................................................................................. 49 
Competitive Markets and Efficient Resource Allocation ...................................................................................... 49 
International Trade and Technology Transfer ....................................................................................................... 49 
AGI Alignment and Control ..................................................................................................................................... 50 
 
Abbreviations ................................................................................................................................................................... 51 
References ......................................................................................................................................................................... 52 
About the Author ............................................................................................................................................................ 55

x 
Figures and Tables 
Figures 
Figure 2.1. Phase Diagrams for Case 1 .......................................................................................................................... 14 
Figure 4.1. Archetypal Trajectories ............................................................................................................................... 26 
Figure 4.2. Time to DEA-100 by Driver ...................................................................................................................... 30 
Figure 4.3. Share of DEA-100s Avoided by Intervention and Trigger Point .......................................................... 34 
Tables 
Table 2.1. Four Cases ........................................................................................................................................................ 6 
Table 3.1. Parameter Ranges .......................................................................................................................................... 18 
Table 4.1. Illustrative Archetype Parameterizations and Implied Dynamics .......................................................... 25 
Table 4.2. Summary of Simulations .............................................................................................................................. 28 
Table 4.3. DEA-100s by Driver ..................................................................................................................................... 29 
Table 4.4. Strategic Intervention Archetypes .............................................................................................................. 32 
Table 4.5. Strategic Intervention Archetype Results .................................................................................................. 33

1 
Chapter 1 
Introduction 
A central question in artificial general intelligence (AGI) strategy under geopolitical competition is 
whether an early lead in advanced artificial intelligence (AI) capabilities tends to be self-limiting or 
self-reinforcing. Some accounts emphasize competitive forces, such as diffusion and imitation, that 
have historically eroded technological leads. Others argue that AGI may differ from prior general-
purpose technologies, allowing early advantages to compound rather than dissipate. The strategic 
stakes hinge on whether competitive dynamics stabilize rivalry or push it toward persistent 
dominance.  
This report introduces the concept of decisive economic advantage (DEA) to formalize this 
question. We define a DEA as a competitive regime in which the economic system’s endogenous 
feedbacks cause an initial capability or deployment lead to become self-reinforcing, generating 
widening gaps in productivity and income that progressively relax constraints for the leader and 
tighten constraints for the follower, so that (absent large exogenous shocks) the follower’s feasible 
policy responses cannot restore competitive balance on relevant strategic timescales. Critically, a DEA 
describes a structural capacity for dominance rooted in resource asymmetry, distinct from the political 
intent to exercise it.  
The DEA concept complements two perspectives in AI strategy discussions. On one hand, the 
decisive strategic advantage (DSA) framework holds that an actor could obtain “a level of 
technological and other advantages sufficient to enable it to achieve complete world domination” 
(Bostrom, 2014), typically through capability gaps that create insurmountable positions. On the other 
hand, skeptics argue that such scenarios are implausible because diffusion, imitation, capital mobility, 
and organizational limits tend to erode technological leads under conditions of continuous 
technological progress (Kokotajlo, 2019). DEA reframes this disagreement by asking when economic 
forces themselves become sources of strategic irreversibility rather than mechanisms of catch-up. A 
DEA may arise as the economic consequence of a DSA but could also emerge from more-modest 
initial conditions through feedback dynamics alone.  
Recent work suggests that economic dynamics may be central to DSAs. Davidson (2025) 
emphasizes that differential growth rates could generate de facto strategic dominance through 
economic scale alone. Kokotajlo (2019) argues that decisive advantages could emerge even under 
gradual, continuous technological progress. These arguments suggest that economic mechanisms may 
be complements to technological mechanisms in generating strategic advantage rather than brakes on 
them.

2 
Research Questions and Approach 
This report addresses three interconnected research questions. First, what are the economic 
mechanisms through which temporary first-mover advantages (FMAs) in AGI development could 
translate into persistent or growing income gaps between competing blocs? Second, under what 
parameter combinations do these mechanisms generate DEAs rather than natural convergence? 
Third, how effective are different intervention strategies at preventing or reversing the emergence of 
economic dominance once substantial asymmetries have already developed? 
To answer these questions, we developed a dynamic two-bloc economic model that captures the 
primary forces governing AGI competition.1 The model tracks the evolution of three interconnected 
gap variables between a leader and a follower: the technology quality gap (how capable each bloc’s AI 
systems are), the deployment intensity gap (how extensively AI is integrated into economic production), 
and the hardware capacity gap (the physical infrastructure available to run deployed AI systems). 
These channels generate feedback dynamics. Superior technology can facilitate broader deployment; 
deployment can generate experiential learning that enhances technological capability; economic gains 
from successful deployment can be used to finance infrastructure expansion that relaxes hardware 
constraints. The model captures how these reinforcing mechanisms can either amplify initial 
advantages into persistent dominance or be overcome by equilibrating forces and the efforts of the 
follower to restore competitive balance. 
The model assumes that sufficiently advanced AI is a perfect substitute for human labor in 
production, while allowing deployment to evolve endogenously rather than instantaneously. This 
assumption is a stylized limiting case used in several recent macroeconomic treatments of advanced AI 
and provides a benchmark for analyzing when human labor ceases to be a binding constraint on 
output.2 Appendix B derives a version of the model in which human and AGI labor are imperfect 
substitutes and shows that relaxing this assumption does not necessarily prevent a DEA. 
The model’s structure organizes analysis into four cases, defined by whether capital markets adjust 
quickly or slowly to productivity differences and whether hardware capacity constrains AI 
deployment. This two-by-two framework isolates the economic mechanisms through which 
divergence can occur. Fast-capital adjustment amplifies technology advantages through immediate 
capital deepening, while slow adjustment creates transitional windows in which the follower can 
potentially catch up. Binding hardware constraints throttle deployment but can themselves become 
moats when economic returns finance capacity expansion faster than rivals can invest.3 By analyzing 
 
1 While the model denotes the two actors as a leader and a follower bloc, the model generalizes to individual countries. 
2 This specification follows directly from one interpretation of prevailing definitions of AGI in the technical and economic 
literature. Korinek and Suh (2024) define AGI as “the ability of AI systems to perform all tasks that humans can perform,” which 
implies functional equivalence in production processes. Restrepo (2025) characterizes AGI as enabling “the economy to complete 
all relevant work using computing systems,”2 suggesting that human labor becomes economically redundant once AGI capabilities 
mature. Aghion, Jones, and Jones (2017) treat advanced AI as a perfect substitute for human researchers in innovation processes, 
while Trammell and Korinek (2023) assumes that sufficiently advanced AI can replicate any human economic contribution. 
Although this assumption represents an idealized limit case, it provides a theoretical benchmark for analyzing the economic 
implications of comprehensive human-level (or even superhuman level) artificial intelligence.  
3 A moat is a defensible barrier to competition.

3 
each combination, we identify which feedback structures are necessary and sufficient for decisive 
divergence. 
Contributions 
This report makes four primary contributions to the analysis of AGI competition and strategic 
advantage. First, the report frames and formalizes DEA as an economic dynamic under geopolitical 
competition in AGI. In this framing, DEAs arise when the feedback linking capacity, deployment, 
investment, and infrastructure shift the system from competitive convergence to self-reinforcing 
divergence.  
Second, in this report, we identify multiple pathways through which an initial FMA can become 
economically decisive. One pathway uses frontier self-reinforcement (intelligence explosion) 
mechanisms, in which superior systems accelerate further improvements at the technological frontier. 
The other is an accumulation-driven pathway in which cross-feedback among deployment experience, 
capability improvements, and investment in deployment capacity generates divergence even when 
knowledge diffuses and individual feedback channels, taken in isolation, would not imply instability. 
Distinguishing between these pathways matters because they imply different time profiles, different 
observable signatures, and different levels for intervention.  
Third, we used Monte Carlo simulation to map outcomes under deep parameter uncertainty. 
Rather than relying on contested point estimates, the analysis spans wide ranges over diffusion, 
learning, capital adjustment, and hardware constraints and reports patterns persistent across broad 
sets of assumptions. This approach makes results interpretable as regime-level regularities of the 
model rather than artifacts of a single calibration.  
Finally, we evaluate the effectiveness of intervention archetypes on both the timing of intervention 
and the underlying mechanisms generating divergence. The results imply that the intervention that 
works depends on the reason the system is diverging. Policies that can disrupt accumulation-driven 
feedbacks may have limited leverage against intelligence-explosion–like dynamics once large 
asymmetries exist, and earlier interventions tend to be substantially more effective than later efforts 
even at higher intensity.  
Organization of This Report 
The report proceeds as follows. Chapter 2 derives the formal model, establishing the mathematical 
framework and characterizing steady-state equilibria under alternative capital regimes. Chapter 3 
presents the calibration methodology and simulation design, detailing how parameters are grounded in 
empirical evidence when available and bounded by economic reasoning elsewhere. Chapter 4 analyzes 
simulation outcomes. Chapter 5 synthesizes implications for AI strategy. Appendix A provides 
complete derivations of the stability conditions. Appendix B provides a derivation of the model under 
imperfect substitution between AGI and human labor. Appendix C discusses limitations and their 
implications.

4 
Glossary of Key Terms 
Decisive economic advantage (DEA) 
A competitive economic regime in which endogenous feedback among AI capability, deployment, and capital 
accumulation cause initial advantages to become self-reinforcing, generating widening productivity and 
income gaps that progressively constrain a follower’s ability to restore competitive balance on relevant 
strategic timescales. 
 
First-mover advantage (FMA) 
An initial, time-limited lead in AI capability, deployment, or infrastructure. 
 
Deployment (AI deployment and deployment intensity) 
The extent to which AI capabilities are converted into effective productive labor across the economy, distinct 
from raw capabilities at the technological frontier. 
 
Technology quality (AI capability) 
The effectiveness of AI systems at raising productivity, abstracting from scale of use. 
 
Deployment flywheel 
A feedback loop in which greater AI deployment generates learning or data that improves AI capability, which 
in turn enables further deployment, potentially producing divergence even without frontier self-reinforcement. 
 
Hardware constraint or binding hardware 
A physical limitation (e.g., compute, data centers, energy) that caps effective AI deployment regardless of 
economic incentives or nominal deployment intentions. 
 
Capital adjustment regime (fast versus slow) 
A stylized characterization of how quickly investment responds to productivity differences, affecting the 
speed of divergence. 
 
Convergence versus divergence 
Convergence refers to dynamics in which economic gaps shrink over time because of competitive pressures; 
divergence refers to dynamics in which gaps widen because of reinforcing feedback. 
 
DEA-100 
An operational severity threshold denoting a DEA trajectory that reaches a 100-fold income gap within the 
simulation horizon; used for classification, not as a definition of a DEA itself.

5 
Chapter 2 
Model Derivation and Discussion 
In this chapter, we develop a dynamic economic model to analyze the evolution of technological 
leadership and income gaps between two economic blocs during the transition to AGI. The 
framework captures the economic forces that determine whether initial technological advantages 
persist, amplify, or dissipate over time, with particular attention to the role of AI deployment, capital 
accumulation, and hardware constraints. 
The model considers two economic blocs, indexed as 𝑖∈{𝐿, 𝐹}, representing a technological 
leader and follower, respectively. Each bloc produces a single homogeneous good using capital, human 
labor, and autonomous AGI. The model’s distinguishing feature is its treatment of AGI as a perfect 
substitute for human labor in production, reflecting the assumption that sufficiently advanced AI 
systems can perform any economically valuable task that humans can perform. 
The dynamics unfold through three interconnected channels. First, technological quality evolves 
according to innovation processes that may exhibit both autonomous progress and feedback effects 
from deployment experience. Second, AI deployment intensity responds to technological capabilities 
while potentially facing constraints from specialized hardware availability. Third, capital accumulation 
follows either fast market-driven adjustment or slower savings-driven dynamics, creating different 
amplification patterns for technology-driven advantages. These three channels interact to determine 
the evolution of income gaps over time. 
The model delivers four cases, organized two-by-two in Table 2.1, defined by whether hardware 
constraints bind and whether capital adjusts quickly. This structure does not classify outcomes as 
stable versus unstable because instability can arise in all four cases but, rather, isolates the economic 
mechanisms through which divergence occurs. The upper-left quadrant provides a benchmark case in 
which instability reflects purely upstream technology-deployment feedbacks. Moving horizontally 
introduces physical throttles that constrain deployment but may be endogenously relaxed. Moving 
vertically introduces capital frictions that dampen or delay the transition of advantage into income. 
The lower-right quadrant combines both frictions.  
Related Literature 
The model develops a two-bloc dynamic growth framework in which AGI deployment creates 
persistent competitive advantages through three interconnected mechanisms: task substitution with 
perfect labor-AGI substitutability, capacity-constrained deployment limited by rival hardware 
resources, and capital adjustment under alternative institutional regimes. The model treats FMAs as 
an initial condition and as an explicitly parameterized dynamic head start whose consequences depend 
on endogenous feedback among technology, deployment experience, infrastructure, and capital 
accumulation.

6 
Table 2.1. Four Cases 
Capital Adjustment 
Hardware: Slack 
(deployment scales freely with 
intent) 
Hardware: Binding 
(deployment is capped by 
hardware) 
Fast 
Income gaps translate quickly 
into productivity gaps 
Feedback-driven instability 
Instability driven by feedback 
between technology and 
deployment 
Throttle-based instability 
Instability reflects whether 
throttles are temporary or self-
eroding 
Slow 
Frictions delay scaling 
Frontier-dependent instability 
Instability depends on frontier 
dynamics; capital affects  
timing and magnitude 
Accumulation-driven instability 
Instability driven by gradual 
reinforcing accumulation 
NOTE: This table shows the four cases the model generates or evaluates. Hardware conditions are endogenously 
determined based on the interaction of modeled variables; capital adjustment speeds are exogenous and meant to 
capture stylized capital regimes.  
 
This framework synthesizes insights from several economic research traditions The labor-AGI 
substitution benchmark follows the task-based automation literature (Acemoglu and Restrepo, 2019; 
Autor, 2013; Korinek and Suh, 2024). Deployment dynamics draw on general-purpose technology 
diffusion (Bresnahan and Trajtenberg, 1995; Comin and Hobijn, 2010), production network 
bottlenecks (Baqaee and Farhi, 2019), capital adjustment dynamics (Hayashi, 1982; Bernanke, 
Gertler, and Gilchrist, 1999), and open-economy growth models (Barro and Sala-i-Martin, 1992).  
Relative to existing approaches, the model’s contribution is integrative. Models of international 
technology diffusion examine cross-country productivity differences without explicitly parameterizing 
FMA duration (e.g., Aghion and Howitt, 1990; Eaton and Kortum, 1996; Comin and Hobijn, 2010; 
Acemoglu, 2008). Industrial organization research analyzes firm-level FMAs but lacks the 
macroeconomic scope necessary for economy-wide impacts (e.g., Lieberman and Montgomery, 1988; 
Kerin, Varadarajan, and Peterson, 1992). Meanwhile, discussions of AGI’s potential for DSA have 
remained largely qualitative rather than empirically grounded (e.g., Bostrom 2014; Karnofsky, 2022).  
Production Technology with Perfect Substitution 
Each bloc’s aggregate output follows a Cobb-Douglas production function: 
 
𝑌!  = 𝐾!
",𝑋!𝐿#./
$%", 𝛼∈ (0,1), 
 
where 𝐾! represents reproducible capital encompassing all non–AI-specific productive assets; 𝑋! 
denotes a technology parameter capturing the overall sophistication of the bloc’s production methods;

7 
and 𝐿5! represents effective labor that combines human and AI contributions.4 The parameter 𝛼 
represents capital’s share of output.  
Perfect Substitutes 
Given the context of this research (AGI), this report assumes perfect substitutability between 
human and AI labor. While this assumption is not common in the broader economic literature, where 
technology is typically assumed to be a net complement to human labor (Acemoglu and Restrepo, 
2019; Autor, 2019), the perfect substitution assumption underpins many of the common definitions 
of AGI, including those used by major AI labs.5 Effectively, the perfect substitution assumption is 
used to model a world in which human labor is no longer a binding constraint.  
As Korinek and Suh (2024) define it, AGI represents “the ability of AI systems to perform all 
tasks that humans can perform.” Under such capabilities, AI systems become functionally equivalent 
to human workers from a production standpoint, differing only in their relative productivity levels. 
The mathematical limit implies that production decisions depend only on the relative costs rather 
than factor complementarity, which eliminates diminishing returns to AI deployment that would arise 
under imperfect substitution, similar to the dynamics in AK growth models (Romer, 1986) once 
capital scales proportionally. Although this assumption overstates current AI substitutability, it 
provides insights into limiting cases as AI capabilities equal or pass human-level performance across all 
economically valuable tasks.  
In this limit, the aggregator over human and AI labor becomes 
 
𝐿#. = 𝐻! + 𝜂𝐴! →
&!
'!
. = (1 + 𝜂𝑎!), 
 
where 𝐻! represents human labor, 𝐴! represents AI agent labor, and 𝜂> 0 captures the baseline 
productivity of AI agents relative to humans per unit of deployment. Normalizing by human labor 
creates the term 𝑎! ≡
("
'", which represents AI deployment intensity per capita.6 This linear 
aggregation embodies the assumption that AGI can seamlessly replace human workers in any 
production task, with the relative productivity parameter 𝜂 capturing any per-unit efficiency 
 
4 While the production function adopts Harrod-neutral specification, treating AGI as a composite input flowing from capital-
intensive processes (software, data centers, compute infrastructure, energy, etc.) generates dynamics that implicitly combine 
Harrod-neutral and Hicks-neutral technological change. AGI deployment simultaneously augments effective labor and 
represents capital deepening at a lower level of aggregation not explicitly modeled, capturing both channels without introducing 
time-varying factor shares. A pure Hicks-neutral specification with endogenous 𝛼 would more directly model capital 
intensification but would require tracking dynamic factor share evolution and capital allocation between AGI-producing and 
complementary capital, substantially complicating the analysis. We leave this extension for future research.  
5 While there are many definitions of AGI, one commonly referenced is that used by OpenAI’s charter: “highly autonomous 
systems that outperform humans at most economically valuable work.” 
6 Formally, the constant elasticity of substitution (CES) aggregator with shares is 𝐿# = 𝜃𝐻+ (1 −𝜃)𝜂𝐴. Normalizing human 
labor per capita to one and rescaling the productivity parameter as 𝜂←
!"#
# 𝜂 produces 𝐿# = 𝜃(1 + 𝜂𝑎). For simplicity, and 
because 𝐿# is not a primary object of the analysis, units are normalized by 𝜃 without loss of generality, renaming 𝐿# ←
$%
# .

8 
differences that might persist even with functionally equivalent capabilities.7 As a result, the system 
converges to a corner solution. 
Under perfect substitution, the marginal rate of technical substitution between human and AGI 
labor becomes constant at 𝜂, independent of current deployment levels. This implies that the decision 
to deploy AI versus human labor depends solely on relative costs, without diminishing returns from 
unbalanced factor proportions that would arise under complementarity. However, this model avoids 
literal corner solutions through the treatment of human labor as an inelastic endowment rather than 
an optimizable choice variable, a formulation that represents the eventual economic marginalization of 
human labor rather than the physical displacement from the production function. This specification, 
while a departure from models that explicitly address the factor allocation problem (Korinek and Suh, 
2024; Acemoglu and Restrepo, 2019), focuses the analysis on interbloc growth differentials, because 
the gap-based formulation described in the next subsection differences out absolute human labor 
quantities, leaving growth differences exclusively determined by gaps in technology, deployment, and 
hardware capacity, which are the specific channels through which FMAs manifest.  
Output Gaps 
Expressing output in per capita terms, 
 
𝑦! = 𝑘!
"[𝑋!(1 + 𝜂𝑎!)]$%", 
 
where 𝑘! ≡
)"
'" denotes capital intensity. Taking logarithms and defining 𝑥! ≡ln(𝑋!), 𝑧! ≡
ln(1 + 𝜂𝑎!), and 𝜅! ≡ln(𝑘!), 
 
ln(𝑦!) = 𝛼𝜅! + (1 −𝛼)(𝑥! + 𝑧!). 
 
The logarithmic formulation reveals how output depends multiplicatively on capital intensity, 
technological quality, and AI deployment intensity. The term 𝑥! captures technology quality, or the 
productivity of effective labor (AI or human) conditional on use. This reflects how effective each unit 
of effective labor is at performing economic tasks. The term 𝑧! captures deployment intensity, defined 
as the extent to which frontier AI capabilities are converted into effective labor across the economy. 
The distinction between 𝑥! and 𝑧!allows output to respond directly to technology quality while 
preserving a separate role for deployment in scaling.  
The primary purpose of this report is to focus on relative economic dominance rather than 
absolute growth paths; thus, we derive the income gap between the leader and follower as 
 
Δ𝑦≡ln(𝑦&) −ln(𝑦*) = 𝛼Δκ + (1 −α)(Δx + Δz). 
 
 
7 While technological progress in reality likely drives both general productivity (𝑥) and AI-specific per-unit capability (𝜂) 
simultaneously, we distinguish between them to isolate distinct economic mechanisms. In our context, 𝑥 represents broad 
technological sophistication that increases the output of any effective unit of labor, whether human or AI. In contrast, 𝜂 
represents the specific potency of AI agents relative to humans, determining the rate at which deployed AI infrastructures 
substitutes for human effort.

9 
This decomposition shows that income differences arise through three channels: differential capital 
intensity (Δ𝜅= 𝜅& −𝜅*), technology quality gaps (Δ𝑥= 𝑥& −𝑥*), and AI deployment differences 
(Δ𝑧= 𝑧& −𝑧*). The perfect substitution assumption means that deployment differences translate 
linearly into productivity differences, without the diminishing effects that would arise under 
complementarity.  
Dynamics of Technology and Deployment Gaps 
The evolution of technological and economic leadership depends on how quality and deployment 
gaps change over time. The dynamic system that captures innovation processes, deployment decisions, 
and hardware constraints is modeled as reduced-form parameters: 
 
Δ𝑥̇ = 𝜙+ 𝜆+Δ𝑥+ 𝛽ΔzQ 
 
 
Δ𝑧̇ = 𝜉+ 𝜌Δ𝑥+ 𝜆,Δ𝑧−𝜏(Δ𝑧−Δℎ)- 
 
 
Δℎ̇ = 𝜓+ 𝜇Δ𝑦+ 𝜆.Δℎ, 
 
where Δ𝑥≡𝑥& −𝑥* represents the technology quality gap; Δ𝑧≡𝑧& −𝑧* is the deployment 
intensity gap; and Δℎ= ℎ& −ℎ* is the hardware capacity gap. Variables on the left side are denoted 
with dots to represent the time derivative.8 The notation (𝑢)- ≡max{𝑢, 0} captures the asymmetric 
nature of hardware constraints, which enforce a penalty (𝜏) when Δ𝑧> Δℎ to capture diffusion 
bottlenecks that emerge with hardware constraints.9 Technology quality responds to effective 
deployment (Δ𝑧̅ = min(Δ𝑧, Δℎ)) rather than intended deployment, under the assumption that 
learning-by-doing (𝛽) arises from models that are actually run at scale.  
The first equation governs quality dynamics. The parameter 𝜙 represents a time-limited 
exogenous innovation-flow advantage during the initial advantage capturing temporarily superior 
capabilities or research effectiveness that are not modeled endogenously. When 𝜙> 0, the leader 
enjoys persistent advantages in pushing the technological frontier even absent any feedback effects. 
The term 𝜆+ captures the feedback loops within technology quality. If the feedback is negative, the 
natural convergence tendency of technology quality through knowledge diffusion and follower catch-
up efforts closes the gap. The convergence rate reflects the characteristics of the technological domain 
 
8 A natural extension of this model would allow follower catch-up to intensify with the size of the gap. One simple specification 
might replace the constant mean reversion with 𝜆&(𝑥) and 𝜆'(𝑧), such that 𝜆&
( (𝑥) < 0, 𝜆'
( (𝑧) < 0. In general, allowing gap-
dependent equalizing forces would shrink the region of the state space exhibiting local divergence and convert unbounded 
divergence in the linear model into convergence toward a very large, but finite, gap.  
9 The hinge term (−𝜏(Δ𝑧−Δℎ))) is a reduced-form representation of a capacity constraint rather than a symmetric 
complementarity. One way of interpreting this term is that effective deployable compute is the minimum of desired deployment 
and available hardware capacity. In gap form, this creates a regime switch, such that Δ𝑧≤Δℎ, and the constraint is slack; 
deployment follows its unconstrained dynamics. When Δ𝑧> Δℎ, deployment is pushed back toward the feasible region, where 
Δ𝑧≈Δℎ at speed 𝜏. A linear term, where Δℎ directly interacts with the deployment gap rate of change, would instead imply that 
hardware always raises deployment growth, even when hardware is not the binding margin, and could double-count hardware’s 
role relative to adoption or friction terms already captured in 𝜉, 𝜌, 𝜆'. The kink in the function encodes a physical ceiling while 
preserving tractability in the gap dynamics.

10 
and the follower’s absorptive capacity and innovation infrastructure. A more negative value of 𝜆+ 
indicates more rapid closure. For intuition, a value of 𝜆+ = −0.14 corresponds to a half-life of 
approximately five years, meaning the gap would naturally close by half over that horizon, absent other 
forces. However, as we discuss later, it is also plausible for this feedback loop to be positive, 
representing an intelligence-explosion–type scenario. In that case, a technology quality gap is self-
reinforcing because the leader is able to leverage its better technology to build continually better 
technology. The cross-effect (𝛽Δ𝑧) represents learning-by-doing, in which greater deployment 
generates data and insights that accelerate quality improvements. Whether the technology quality gap 
closes or expands depends on the values of 𝜆+ and 𝛽. Stability conditions are discussed later.  
The second equation describes deployment dynamics. The baseline deployment advantage (𝜉) 
reflects the leader’s exogenous advantage in AGI deployment, stemming time-limited from such 
factors as organizational capabilities, regulatory frameworks, or market structures. The parameter 𝜌 
captures how quality improvements enable expanded deployment by enhancing system capabilities, 
reducing operational costs, and improving the reliability metrics that drive adoption decisions. The 
deployment gap decay constant (𝜆,) governs convergence through multiple channels: market 
saturation effects as deployment approaches technological or economic limits, technology transfer 
through licensing agreements and imitation, ecosystem development that reduces deployment barriers 
for followers, and competitive responses that erode FMAs. The throttle mechanism (𝜏(Δ𝑧−Δℎ)-) 
turns on when deployment gaps exceed hardware capacity differentials, representing binding 
constraints from semiconductor availability, data center infrastructure, or energy grid limitations that 
physically constrain AI deployment regardless of economic incentives.10 
The third equation tracks hardware capacity evolution. The parameter 𝜓 captures time-limited 
exogenous advantages in hardware capabilities, supply chain control, or infrastructure development 
that create persistent capacity differentials independent of economic feedback mechanisms. The 
income feedback coefficient (𝜇) quantifies how economic advantages translate into hardware 
investment capacity, reflecting the capital-intensive nature of semiconductor fabrication, data center 
construction, and supporting infrastructure, in which superior economic performance enables 
accelerated capacity expansion.11 The hardware gap decay constant (𝜆.) determines whether capacity 
advantages exhibit persistence through learning curve effects, agglomeration economies, and ecosystem 
complementarities or erode through technology transfer, competitor investment, and supply chain 
diversification initiatives that gradually eliminate capacity bottlenecks. 
The system allows technology and hardware to interact through mediated channels. Hardware 
constraints shape realized deployment, which in turn affects technology through learning-by-doing 
effects, while technology affects hardware accumulation through income-driven investment. For 
parsimony, we set the direct terms linking ℎ to 𝑥̇ and 𝑥 to ℎ̇ to zero. These effects are conceptually 
 
10 One micro-consistent interpretation of the throttle is that actors choose a desired deployment path (𝑧) but that realized 
deployment is capacity constrained. The throttle adjusts intended deployment toward realized deployment in a reduced-form 
dynamic in which excess demand for capacity lowers the growth of the deployment gap at rate 𝜏. The throttle is only binding 
when desired scale exceeds capacity.  
11 Note that, because Δ𝑦 is a gap (in logs), 𝜇 is a per-year semielasticity and maps the income gap into the growth rate of the 
hardware-capacity gap.

11 
important but difficult to separately identify from the deployment and income–mediated pathways in 
the gap system.12  
These three equations form a coupled dynamic system in which technological progress, economic 
deployment, and physical capacity constraints interact to determine competitive outcomes. The 
feedback structure creates dynamics in which temporary advantages in one dimension can cascade into 
persistent leadership across all dimensions, or conversely, in which natural equilibrating forces prevent 
any bloc from achieving permanent dominance.  
Capital Accumulation Regimes 
The treatment of capital markets shapes how technology gaps translate into economic outcomes. 
Physical capital serves as a complementary factor that amplifies the productivity benefits of AGI 
deployment, but the speed and efficiency of capital adjustment likely vary with institutional and 
market conditions. Two stylized potential capital regimes are specified, as discussed in the following 
subsections. These regimes are intended to isolate mechanisms rather than represent literal 
descriptions of any particular country pair. 
Fast-capital Adjustment—Frictionless Scaling 
When capital markets operate efficiently with minimal frictions, capital stocks adjust rapidly to 
equate marginal products with user costs. The equilibrium condition is given by 
 
𝑅! = 𝑟! + 𝛿) =
"/"
)" , 
 
where 𝑅! denotes the cost of capital in bloc 𝑖, 𝑟! the real interest rate, and 𝛿) denotes the depreciation 
rate (assumed constant across blocs). Solving for optimal capital intensity from produces 
 
𝑘! = b
"
0"c
#
#$% 𝑋!(1 + 𝜂𝑎!). 
 
Taking logarithms, 
 
𝜅! =
$
$%" ln b
"
0"c + 𝑥! + 𝑧!. 
 
This expression clarifies what the fast-capital assumption does, and does not, impose. It assumes 
rapid adjustment of capital toward the level implied by productivity but does not require international 
capital market integration. Differences in user costs (𝑅!) can persist across blocs because of sovereign 
risk, financial friction, sanctions, or policy choices, and those differences enter as a wedge in 𝜅!. 
 
12 In a policy archetype analysis in Chapter 4, we introduce export control–type interventions as exogenous policy shocks to 
deployment and hardware dynamics rather than as permanent structural couplings.

12 
A particularly clean benchmark arises under the special case of 𝑅& = 𝑅*, which would obtain 
under highly integrated international capital markets. In that case, the capital intensity gap becomes 
simply 
 
Δ𝜅= Δ𝑥+ Δ𝑧. 
 
Substituting into the income gap equation yields 
 
Δ𝑦= Δ𝑥+ Δ𝑧 (integrated capital markets). 
 
We use this case as an analytic reference point because it makes clear that, under frictionless 
scaling, productivity advantages can be fully amplified through induced capital deepening. However, 
we do not treat cross-border-return equalization as an empirical description, especially for blocs in 
adversarial relationships. Therefore, the fast-capital regime should be interpreted as a shorthand for 
rapid scaling capacity, not as a claim that international capital markets are integrated. 
Slow Capital Accumulation—Gradual Scaling 
The slow-capital regime represents environments in which capital adjustment is limited by 
financing constraints, organizational frictions, or gradual savings and investment responses. Here, 
capital evolves according to 
 
𝑘̇ ! = 𝑠!𝑦! −(𝛿))𝑘!, 
 
where 𝑠! denotes the savings rate, and 𝛿) is the capital depreciation rate. In logarithmic terms, this 
becomes 
 
𝜅#̇ =
1"2"
3" −𝛿). 
 
Linearizing around a balanced growth path (the point at which steady-state investment flows are 
equal to depreciation), assuming blocs have the same savings rate, and examining gap dynamics, 
 
Δ𝜅̇ = 𝛿)(Δ𝑦−Δ𝜅). 
 
This generates gradual convergence dynamics where capital gaps adjust toward their long-run 
equilibrium values determined by productivity differences. 
The slow-capital regime creates important transitional dynamics. When a technology shock 
creates sudden productivity advantages, income gaps emerge immediately through the direct effect 
((1 −𝛼)(Δ𝑥+ Δ𝑧)), but the full amplification through capital deepening occurs only gradually. This 
lag creates a window in which followers might catch up technologically before the leader’s advantage 
becomes fully entrenched through complementary capital accumulation. 
These two regimes are intentionally stylized. The fast-capital case provides an upper bound on 
how quickly productivity advantages can be translated into scale through investment, while the slow-
capital case provides a lower bound in which scaling is constrained by frictions. Real-world economies

13 
will lie between these bookends and may switch regimes over time. The model is simulated under both 
stylized regimes. 
Stability Analysis 
To characterize long-run competitive outcomes, we analyze the behavior of the system after 
exogenous FMAs fade (i.e., setting 𝜙= 𝜉= 𝜓= 0). The model is piecewise because of deployment 
caps and bottlenecks, so local stability depends on the regime in which the economy operates. 
Appendix A derives the full local stability conditions across all regimes. Here, we focus on a reduced 
benchmark case that is analytically transparent and provides a reference point for identifying 
destabilizing feedback. Although all four cases are analyzed separately for clarity, the full system allows 
trajectories to move endogenously across the cases as constraints bind or relax. The case distinctions 
should therefore be interpreted as local characterizations of the dynamics rather than as mutually 
exclusive global equilibria.  
Case 1: Fast-Capital Adjustment and Nonbinding Hardware 
When hardware does not bind, and capital adjusts rapidly, effective deployment simply equals the 
deployment gap, and the bottleneck penalty is inactive. The steady state for the technology and 
deployment gaps satisfies the linear system: 
 
e𝜆+
𝛽
𝜌
𝜆,f bΔ𝑥∗
Δ𝑧∗c = 𝟎. 
 
The local stability of this reduced (Δ𝑥, Δ𝑧) subsystem requires the eigenvalues of the transition matrix 
to have negative real parts, requiring 
 
tr(𝑴) = 𝜆+ + 𝜆, < 0, det(𝑴) = 𝜆+𝜆, −𝛽𝜌> 0. 
 
The trace condition ensures that autofeedback effects are not too strong on average and that 
innovation advantages tend to dissipate rather than compound indefinitely. The determinant 
condition places a restriction on the interaction between autofeedback and cross-feedback effects. 
Strong positive feedback between quality and deployment (large 𝛽𝜌) can destabilize the system, even 
when individual autofeedback terms are negative. When either of these conditions fails to hold, the 
model creates an explosive scenario, driven either by the autofeedback intelligence-explosion–like 
dynamic or by the deployment dynamic that is itself driven by strong feedback between quality and 
deployment. As shown in Appendix A, violations of these conditions imply instability of the full 
system so long as hardware constraints are slack and capital adjusts quickly. 
Figure 2.1 displays the phase diagrams for three notional examples in Case 1. The left panel shows 
trajectories under convergence; the center shows trajectories for the case when strong feedback 
between deployment and quality creates an unstable equilibrium; and the right panel shows a situation 
in which autofeedback in technology quality creates divergence regardless of deployment scale. Note

14 
that, because this report focuses on leader-follower dynamics, we show only the upper right quadrant 
of the full phase diagram.  
Figure 2.1. Phase Diagrams for Case 1 
 
NOTE: This figure shows example transition paths for Case 1 (fast-capital and slack hardware constraints). The origin 
point reflects economic parity between the leader and follower. 
Case 2: Fast-Capital Adjustment and Binding Hardware 
When hardware constraints bind, effective deployment becomes tied to hardware capacity rather 
than desired deployment (i.e., ΔzQ = Δℎ). This breaks the closed technology-deployment subsystem 
and activates additional feedback channels through hardware accumulation and capital deepening. In 
this regime, deployment dynamics are throttled directly by hardware capacity, but technology growth 
depends on realized deployment rather than intended deployment. 
Here, binding hardware constraints tend to stabilize the system by limiting how quickly 
deployment gaps can expand. However, in Appendix A, we show that stability still depends on 
whether the three reinforcing forces are jointly controlled. First, the throttle must dominate 
deployment self-feedback (𝜏> 𝜆,). Second, the combined technology-hardware system must be 
locally dampening. Finally, the income-driven hardware accumulation must not relax the constraint 
too quickly. When these conditions fail, the system can generate deployment-driven divergence even 
though hardware initially constrains scale.  
Case 3: Slow-Capital Adjustment and Nonbinding Hardware 
When hardware is abundant, but capital adjusts slowly, the state space expands to include capital 
accumulation. However, because deployment is unconstrained, the upstream technology-deployment 
dynamics remain unchanged. Appendix A shows that capital dynamics enter as a stable downstream 
process, in which slow adjustment dampens the translation of technology and deployment gaps into 
income gaps but does not alter whether divergence occurs.

15 
As a result, instability in this regime is governed by the reduced technology-deployment 
conditions from Case 1, given by the trace and determinant conditions described earlier. Capital 
frictions primarily affect the speed and magnitude of income divergence, not its existence. This case 
captures settings in which financial or institutional frictions slow economic responses without 
fundamentally altering competitive dynamics at the technological frontier.  
Case 4: Slow-Capital Adjustment and Binding Hardware 
The most complex regime arises when hardware constraints bind, and capital adjusts slowly. In 
this case, all adjustment frictions operate at the same time. Hardware constraints break the direct 
mapping from desired deployment to realized output, while slow-capital adjustment introduces a 
stock variable that translates past income gaps into future productivity capacity. 
Stability in this regime no longer has a simple interpretation in terms of frontier technology 
convergence. Appendix A shows that local stability requires both effective throttling of deployment 
and joint stability of the technology-hardware-capital subsystem. Intuitively, stability means that 
income-driven hardware investment, effective deployment, and capital deepening remain 
proportionate to one another, so that no delayed feedback overwhelms the system’s capacity to absorb 
growth. Slow-capital adjustment is not intrinsically destabilizing, but instability arises when these 
delayed feedbacks (income ® hardware ® deployment ® technology) reinforce each other. 
Specifically, income gaps feed hardware accumulations; hardware expands effective deployment; 
deployment accelerates technology growth; and capital responds too slowly to offset the progress.  
Income Gaps Across Regimes 
The long-run income gap depends on which regime prevails. In steady state, 
 
Δ𝑦∗= j
Δ𝑥∗+ Δ𝑧∗, fast capital, no binding constraints
𝛼Δ𝜅∗+ (1 −𝛼)(Δ𝑥∗+ Δ𝑧∗), slow capital, no binding constraints13
𝛼Δ𝜅∗+ (1 −𝛼)(Δ𝑥∗+ Δℎ∗), slow capital, binding hardware constraints.
 
 
These expressions show how different frictions and constraints shape mapping from technology 
and deployment into income gaps. Stability depends on the dynamic feedback characterized in this 
section and formally derived in Appendix A.  
FMAs and DEAs 
This section analyzes the relationship between FMAs and DEA through the lens of the model’s 
mathematical structure. While the Monte Carlo simulations in Chapter 3 explore dynamics under 
 
13 Note that in steady state, Δ𝜅= 0
̇
 implies that Δ𝜅∗= Δ𝑦∗, so this expression simplifies to the same expression as the fast 
capital, no binding constrains expression. These equations are expressed separately in the main text because the interpretation 
differs, even though the algebra collapses.

16 
parameter uncertainty, the formal derivation provided in Appendix A offers a precise mechanism-
based definition of how temporary initial leads translate into permanent economic dominance. 
Here, we distinguish between FMAs and DEAs as distinct mathematical properties of the 
dynamic system. Within this framework, an FMA is modeled as a set of initial conditions and 
exogenous forcing terms (𝜙, 𝜉, 𝜓) that create a temporary asymmetry between the leader and follower. 
In contrast, a DEA corresponds with the local stability properties of the system, specifically, the 
existence of eigenvalues with positive real parts. 
The model reveals that DEAs are not just large FMAs. Instead, DEAs represent a bifurcation 
point where feedback loops within the economy exceed specific thresholds, forcing the system to 
transition from a regime of convergence (in which FMAs naturally dissipate) to a regime of divergence 
(in which FMAs are structurally amplified). We next identify two distinct feedback mechanisms 
through which this transition can occur.  
The Development Flywheel—Unconstrained Feedback 
In the regime in which hardware is abundant and capital adjusts quickly (Case 1), the evolution of 
the gap between the two blocs is governed by the reduced two-by-two system of technology quality 
and deployment intensity. The local stability of this system depends on the trace and determinant of 
its Jacobian matrix.  
As discussed earlier, instability in this regime can arise through either a trace violation, 
corresponding with self-reinforcing frontier improvement (intelligence explosion), or through a 
determinant violation, corresponding with a development flywheel. Instability, and the emergence of a 
DSA, occurs when 
 
𝛽𝜌> 𝜆+𝜆,. 
 
This inequality provides a formal definition of the development flywheel. The left-hand side captures 
the strength of the cross-feedback loops, or the rate at which deployment generates data for learning 
(𝛽) multiplied by the rate at which better technology drives further deployment (𝜌). The right-hand 
side represents the natural stabilizing forces of technology diffusion (𝜆+) and market saturation (𝜆,). 
This result demonstrates that a DEA does not require an intelligence explosion or recursive self-
improvement (𝜆+ > 0). Even if technology naturally diffuses to the follower (𝜆+ < 0), the leader can 
still generate local divergence in income gaps if the learning-deployment loop is faster than the 
diffusion-saturation loop. If this threshold is crossed, any nonzero FMA will trigger an exponential 
divergence in income. 
The Hardware-Reinvestment Moat 
A distinct pathway to dominance emerges when deployment is constrained by physical 
infrastructure (Cases 2 and 4). In this regime, the effective deployment gap is capped by the hardware 
gap (Δ𝑧= Δℎ), and the stabilizing force of the hardware throttle (𝜏) is active.

17 
However, the derivation in Appendix A shows that binding hardware constraints do not 
guarantee convergence. The stability of the system shifts to depend on the interaction between 
technology (Δ𝑥) and hardware accumulation (Δℎ). The determinant yields the condition 
 
𝛽𝜇> 𝜆+(𝜆. + 𝜇), 
 
where 𝜇 represents the sensitivity of hardware investment to income gaps. 
This inequality reveals an economic mechanism for dominance that is distinct from the pure 
flywheel in the prior case. Here, the driver of divergence is the reinvestment of economic rents. If the 
leader uses the income generated by its FMA to expand hardware capacity (𝜇) and if that capacity 
generates data for learning (𝛽), this economic feedback loop can overpower the physical decay of the 
hardware advantage.  
This result implies that hardware bottlenecks are not necessarily equalizers in the context of the 
model. While bottlenecks constrain the rate of deployment growth, they also serve as a moat. If the 
reinvestment parameter is sufficiently high, the hardware constraint effectively couples the leader’s 
economic superiority to their technological progress, creating a trap in which the follower is 
permanently constrained by their lower income level.  
The Role of Capital Frictions 
Finally, the model clarifies the role of capital accumulation in these dynamics. Comparing the 
specifications for the fast-capital cases (Cases 1 and 2) and slow-capital cases (Cases 3 and 4) 
highlights that financial frictions primarily affect the timescale of divergence rather than the structural 
outcome. In the unconstrained case (Case 3), the system is block triangular, meaning the eigenvalues 
of the technology-deployment subsystem are independent of the capital dynamics. The capital 
accumulation process adds a stable eigenvalue, corresponding with the savings and depreciation rates 
(−(𝛿)(1 −𝛼))). Any positive value of capital depreciation makes this condition less than zero. 
Additionally, this condition highlights the role of capital’s share of output, which, for this report, is 
assumed to be constant. However, if this parameter were allowed to vary, it would still maintain the 
condition that this eigenvalue was negative. 
This result implies that, while slow-capital adjustment can delay the full realization of income gaps 
(by dampening the capital response), it cannot stabilize an inherently unstable technology-deployment 
loop. If the development flywheel condition holds, the technology gap (Δ𝑥) will continue to widen, 
regardless of how slowly capital accumulates.

18 
Chapter 3 
Parameterization and Empirical Setup 
To explore the model’s implications, it is simulated under a wide range of parameters, using a 
Monte Carlo approach. Parameters are calibrated based on empirical literature, when possible. When 
no reasonable estimates exist, ranges are selected to reflect plausible bounds informed by economic 
reasoning and expert judgment. Table 3.1 summarizes the key model parameters, their interpretation, 
and the range of values considered.  
Table 3.1. Parameter Ranges 
Parameter 
Interpretation 
Model Role 
Range 
𝛼+ 
Baseline capital’s share of income Weights capital gap in income gap 
0.3 
𝜆& 
Technology autofeedback 
(diffusion) 
Governs convergence of technology gap 
−0.30 to 0.50 
𝛿, 
Capital depreciation rate 
Governs how quickly capital depreciates in 
slow-capital regime 
0.07 to 0.12 
𝜙+ 
Initial technology advantage 
Initial value of technology gap 
0.0 to 1.0 
𝜉+ 
Initial deployment advantage 
Initial value of deployment gap 
0.0 to 1.0 
𝜓+ 
Initial hardware advantage 
Initial value of hardware gap 
0.0 to 1.0 
𝜆' 
Deployment autofeedback 
Governs convergence or divergence of 
deployment gap 
−0.36 to −0.09 
𝜆- 
Hardware autofeedback 
Governs convergence or divergence of 
hardware gap 
−0.37 to −0.1 
𝜏 
Hardware bottleneck intensity 
Strength of hardware constraint on 
deployment 
0.1 to 0.9 
𝜇 
Income → hardware investment  
Feedback from income gap to hardware 
gap 
0.003 to 0.1 
𝜂 
Deployment-to-output mapping 
Marginal output gain from deployment 
1× to 16× 
𝛽 
Learning-by-doing 
Feedback from deployment to technology 
quality 
0.0 to 1.0 
𝜌 
Quality → deployment  
Feedback from technology quality to 
deployment  
0.0 to 1.0 
 
The parameter calibration strategy reflects the heterogeneous nature of the empirical evidence 
available for modeling AGI competition. Parameters can be classified into three distinct categories 
based on their empirical foundation: well-established macroeconomic parameters with extensive

19 
literature support; technology-specific parameters that can be extrapolated from historical diffusion 
patterns; and AGI-specific parameters that remain fundamentally speculative, given the 
unprecedented nature of the technology. 
Well-Established Parameters 
Several parameters in the model correspond with standard macroeconomic relationships with 
robust empirical foundations. Capital’s share of income (𝛼) has been documented showing constancy 
around 0.30 to 0.35 across developed economies over multiple decades, particularly when accounting 
for deprecation rates and housing (Rognlie, 2015). Although recent literature has identified modest 
secular variation, particularly a slight decline in labor’s share since 1980 (Karabarbounis and Neiman, 
2014), the parameter exhibits enough stability to warrant point calibration at 𝛼 = 0.3 for the baseline 
specification.14 Of course, in the model, AGI is a perfect substitute for human labor, so the effective-
labor share (1 −𝛼) is preserved even as the human component of that share declines toward zero. In 
this case, payments shift from human wages to AI-labor services. Distributional outcomes then 
depend on who owns and/or deploys AI, not on changes to 𝛼. 
Capital depreciation rates (𝛿)) correspond with standard assumptions in the growth accounting 
literature, in which annual depreciation rates of 7 to 12 percent reflect the weighted average of 
structures (2 to 4 percent) and equipment (12 to 20 percent) in the depreciation schedules used in 
national income accounting (Fraumeni, 1997). The range encompasses variation across economies 
with different capital compositions and technological vintages.15 
Technology-Specific Parameters with Some Historical Precedents 
A second category of parameters can be calibrated through extrapolation from historical 
technology diffusion patterns, although with considerably greater uncertainty, given the unique 
characteristics of AGI. The technology convergence parameter (𝜆+) draws from the literature on 
research and development (R&D) capital depreciation and knowledge spillovers. The calibration 
ranges from a lower bound of −0.30 and reflects evidence from studies of R&D capital stock 
depreciation, in which the standard assumption of 15 percent annual obsolescence (Bosworth and 
Jobome, 2003) provides the central estimate, with bounds reflecting the potential for accelerated 
convergence depending on AGI’s diffusion characteristics.  
The upper bound of 𝜆+ reflects a substantially less certain situation without historical precedent, 
but for the sake of keeping the discussion of this parameter contained, we discuss it here. Specifically, 
 
14 Specifically, Karabarbounis and Neiman (2014) found that the global corporate labor share declined by about 5 percentage 
points between 1975 and 2012, a span of roughly 35 years. However, the overall results discussed in the following sections do not 
depend heavily on values of 𝛼. For instance, assuming that 𝛼= 0.1, potentially representing “materials” as in Korinek and Suh 
(2024), changes the share of runs that end in a DEA by less than one percentage point. 
15 It is also possible that future deprecation rates could be higher than current rates, particularly if a larger share of capital 
investment is in data centers and other AI-enabling hardware that may rapidly lose value. Expanding the range of 𝛿. to [0.01, 
0.25] does not make a material change in the share of runs that result in a DEA or the composition of the runs. Mechanically, in 
the gap formulation, 𝛿, governs the speed at which the capital gap adjusts toward the income gap. Increasing 𝛿, accelerates 
convergence.

20 
we allow 𝜆+ to go up to 0.5, a value which destabilizes the system significantly. As discussed earlier, 
one of the conditions for system stability requires that 𝜆+ + 𝜆, < 0, but if values of 𝜆+ are sufficiently 
large relative to 𝜆, (which we assume is strictly negative, as discussed later), this condition can fail to 
hold. We include this large positive upper bound to capture the potential for AGI models to 
continually improve on themselves, precipitating a model quality gap that grows rather than shrinks. 
Therefore, to calibrate this upper bound, we look to the software intelligence explosion (SIE) 
literature. Specifically, we map Eth and Davidson’s (2025) estimates of a post-AI automated R&D 
software progress into an implied differential growth rate (Δ𝑥). Eth and Davidson (2025) document 
that recent AI software progress is roughly equivalent to an effective compute doubling time of about 
six months, so the corresponding log growth rate of global software progress is approximately 
 
 
56(8)
:.< ≈1.4  
 
per year. In their SIE scenarios, automating AI R&D plausibly accelerates software progress by a 
factor of 𝑚∈[3,6], which roughly corresponds to moving from a six-month to a one- or two-month 
doubling time (Eth and Davidson, 2025).  
If only the leader attains automated AI R&D systems, a simple reduced-form way to capture the 
resulting advantages is to assume (1) that only a fraction (𝑠) of software progress matters for the broad 
technology-quality state (𝑥) and (2) that only a fraction (𝜃) of the software speed-up remains a 
persistent interbloc gap after diffusion, spillovers, and imitation. Under these assumptions, the net log 
growth rate of the technology-quality gap attributable to ASARA is  
 
𝜆+ ≈𝜃𝑠(𝑚−1)1.4. 
 
For simplicity, we assume that one-half of software progress matters for the quality state (𝑠= 0.5) 
and that one-quarter of the software speed-up remains persistent (𝜃= 0.25). These assumptions are 
consistent with empirical decompositions, suggesting that algorithmic progress accounts for roughly 
40 to 60 percent of frontier AI improvements (Hernandez and Brown, 2020). Using a midpoint SIE 
of 𝑚= 4, this implies 𝜆+
max = 0.53, which we round down to 0.5. 
The deployment convergence parameter (𝜆,) leverages the technology adoption literature, 
particularly studies of general-purpose technologies with network effects and complementary 
infrastructure requirements. The empirical foundation rests on smartphone diffusion patterns, which 
exhibited a 10 to 50 percent adoption period of four years (Pew Research Center, 2024), yielding a 
baseline half-life estimate. The calibration range of −0.36 to −0.09 reflects both faster convergence 
scenarios (analogous to software-as-a-service deployment) and slower adoption patterns characteristic 
of infrastructure-intensive technologies. 
Hardware capacity convergence (𝜆.) reflects the capital-intensive nature of semiconductor 
fabrication and data center infrastructure. The calibration draws from engineering and construction 
timeline analysis, in which semiconductor fabrication deployment requires 2.5 to 6.5 years, and data 
center projects span 1.25 to 5.5 years (Shilov, 2025; Micron Technology, Inc., 2022); Dohrwardt, 
2025). The resulting parameter range of −0.37 to −0.09 captures scenarios from accelerated modular 
deployment to extended regulatory and supply chain constraints.

21 
The income-to-hardware feedback parameter (𝜇) governs how income advantages translate into 
faster-growing hardware capacity (i.e., the per-year sensitivity of Δℎ̇  to Δ𝑦). We choose 𝜇 so that, 
under our normalization, it corresponds with an incremental AI-relevant infrastructure mobilization 
spanning 0.3 and 10 percent of gross domestic product (GDP) per year, reflecting enormous 
uncertainty about AI infrastructure prioritization. The lower bound reflects current observable 
trends: Global cloud infrastructure spending of approximately $102.6 billion in the third quarter of 
2025 (approximately $410 billion annualized) represents a few tenths of a percent of global GDP of 
$100 trillion (Omdia, 2025; World Bank, 2025). The upper bound models a wartime-level 
mobilization scenario in which AI capability becomes the paramount driver of economic power and 
national security, which is comparable to total U.S. state and local government spending at 10 percent 
of GDP (Federal Reserve Bank of St. Louis, 2020). This range spans from business-as-usual 
continuation to intense geopolitical competition, with Aschenbrenner (2024) predicting AI 
investment rising toward $1 trillion annually by 2027, which, for larger economies, is on the order of a 
few percent of GDP. 
AGI-Specific Parameters: Inherent Speculation 
For parameters lacking historical precedents because of AGI’s unprecedented characteristics, we 
use a deliberately expansive range-selection strategy to systematically explore a wide range of potential 
competitive dynamics rather than attempting precise point estimates based on insufficient empirical 
foundations. This methodological choice prioritizes comprehensive scenario analysis over precision in 
domains in which expert judgment remains fundamentally limited. 
The AI productivity multiplier (𝜂) exemplifies this approach, with the 1- to 16-times range 
selected explicitly to encompass scenarios spanning from conservative parity assumptions to 
transformative productivity advantages. Rather than reflecting confidence in any particular 
productivity relationship, this range enables systematic investigation of how varying degrees of AI-
human substitutability affect competitive outcomes across the entire spectrum of technologically 
plausible scenarios. The lower bound represents the minimal case, in which AGI achieves human-
equivalent performance; the upper bound incorporates speculative advantages from continuous 
operation, perfect recall, and parallel-processing capabilities that could, theoretically, generate order-
of-magnitude productivity differentials. Specifically, the assumption that AGI is 16 times more 
productive than humans could be rationalized by noting that the average work week for a human is 40 
hours, but if an AGI can run 24 hours a day, seven days a week, the AGI will work approximately 4.2 
times the number of hours. To account for the possibility that the AGI might also be more efficient 
than a human worker, we extended the range up to 16 times to allow for the possibility that the AGI 
is not only able to work four times longer but is also up to four times more efficient than the average 
human.  
The learning-by-doing parameter (𝛽) and quality-to-deployment feedback (𝜌) are parameterized 
with 0.0 to 1.0 ranges that deliberately span from complete absence of interaction effects to dominant 
feedback mechanisms. The unit interval for these parameters acknowledges that these interaction 
effects, which could be central to AGI competition dynamics, remain entirely without empirical 
precedent. The range selection intentionally avoids imposing restrictive priors that might exclude

22 
economically significant scenarios, instead allowing the simulation framework to identify which 
feedback structures generate meaningful competitive outcomes. 
Similarly, the hardware bottleneck intensity (𝜏) uses a 0.1 to 0.9 range that systematically explores 
scenarios from minimal physical constraints to binding capacity limitations. The wide range enables 
investigation of how varying degrees of infrastructure bottlenecks affect competitive dynamics across 
fundamentally different technological architectures. 
Initial advantage parameters (𝜙, 𝜓, 𝜉) are calibrated with 0.0 to 1.0 ranges designed to explore the 
full spectrum of meaningful FMA scenarios, including extreme cases that might predetermine 
outcomes. These ranges facilitate systematic investigation of how varying initial conditions interact 
with dynamic feedback mechanisms to generate persistent or transient competitive advantages. Each 
individual parameter represents the rate at which the corresponding gap would grow per year in 
response to solely exogenous factors. That is, these are advantages arising from preexisting differences 
in research infrastructure, organizational capabilities, regulatory environments, or resource 
endowments that are not themselves explained by the model’s feedback dynamics. For example, a value 
of 𝜙= 0.5 implies that the leader’s technology quality index (𝑥) becomes approximately 65 percent 
(𝑒:.< ≈1.65) relative to the follower after one year. These initial advantage values interact with the 
exogenous advantage duration (3, 6, 12, or 24 months), representing a period during which the initial 
advantage parameters operate in their fully calibrated values. As a result, the upper end of the initial 
advantage level (1) can translate to a cumulative log gap of 2 after 24 months, or a 7-times ratio 
between the leader and follower in a that dimension.  
This expansive parameterization strategy reflects a methodological commitment to comprehensive 
scenario exploration in the face of irreducible uncertainty. Rather than imposing artificial precision 
when none exists, the wide parameter ranges enable identification of robust structural relationships 
that hold across diverse plausible futures while avoiding the analytical limitations that would result 
from premature restriction of the parameter space. 
Monte Carlo Methodology 
We used a stratified Monte Carlo approach to systematically explore the parameter space while 
ensuring computational efficiency and tracking statistical validity. First, four advantage duration 
scenarios are exogenously specified, where the leader has a 3-, 6-, 12-, or 24-month FMA. During an 
exogenously chosen window, the leader enjoys an advantage in technology, deployment, and hardware 
accumulation. The duration of this window is not endogenized and is instead treated as a scenario 
parameter that captures uncertainty about how long early leads persist before competitive forces 
dominate. The size of any given FMA is determined by the parameters of the economic model and 
their respective draws from the calibration ranges in Table 3.1. Across all advantage durations, the 
advantage fades after the advantage period has ended according to an exponential function. Then, 
4,000 simulation trajectories are generated for all combinations of fast and slow-capital adjustment 
regimes and FMA duration periods. This sampling strategy provides sufficient coverage to identify 
robust patterns while maintaining computational tractability. Parameter combinations are drawn 
using uniform random sampling within the specified ranges, with each simulation representing an 
independent draw from the joint parameter distribution. This approach assumes no prior correlation

23 
structure among parameters, allowing the full exploration of interaction effects. For each simulation, 
we document whether the system is stable (based on the trace and determinant conditions) or 
unstable.  
The stratified sampling across capital regimes ensures balanced representation of different 
institutional environments. Fast-capital adjustment scenarios capture economies with developed 
financial markets and low investment frictions, in which capital stocks rapidly equilibrate to 
productivity differences. Slow-capital adjustment scenarios represent economies with financial 
frictions, capital controls, or cautious investment behavior, in which capital accumulation lags 
productivity improvements. This dual approach enables assessment of how institutional factors 
mediate the translation of technological advantages into economic outcomes. 
The simulation tracks system dynamics at eight time points (0, 0.25, 0.5, 1, 2, 5, 10, and 20 years) 
to capture both short-run transitions and long-run outcomes. For each trajectory, gap variables 
(Δ𝑥, Δ𝑧, Δℎ, Δ𝜅), the resulting income differential (Δ𝑦) and the instantaneous values of fading 
advantage parameters are recorded. This temporal resolution enables analysis of how quickly 
advantages dissipate and whether transient benefits generate persistent economic divergence.

24 
Chapter 4 
Discussion of Results 
The simulation results illuminate how the model’s three interconnected channels of technology 
quality dynamics, deployment intensity, and hardware capacity interact to produce divergent 
competitive outcomes. This chapter discusses these simulations.  
Archetypes 
Before turning to a Monte Carlo analysis under deep parameter uncertainty, we present a small 
number of illustrative scenario calibrations corresponding to competing hypotheses about AGI 
development. These scenarios are not intended as forecasts but as mechanism-clarifying reference 
points. These scenarios are deliberately stylized and are not intended to span the full parameter space; 
rather, they serve as reference points for interpreting the Monte Carlo results that follow. 
Table 4.1 defines five illustrative archetype parameterizations, each intended to represent a 
coherent hypothesis about AGI development. Parameter values are not presented as point estimates. 
Instead, they are chosen to satisfy qualitative regime-defining restrictions: rapid decay of advantages 
under a scaling wall (negative 𝜆s with short half-lives), positive net feedback in the technology gap 
under an intelligence explosion (𝜆+ > 0 combined with reinforcing couplings), and moderate 
convergence under a stable gap (negative 𝜆 with medium half-lives, moderate couplings, and binding 
hardware).16 
To demonstrate that DEA in this model does not require recursive self-improvement or 
superhuman productivity, we constructed a development flywheel archetype that stacks all self-dynamics 
against divergence: fast technology decay, rapid diffusion of deployment and hardware advantages, and 
a moderate hardware bottleneck. Despite these constraints, sufficiently strong cross-feedback between 
deployment and learning-by-doing (β, ρ) combined with output-financed hardware investment (μ) 
can still generate divergence over a 20-year horizon. 
 
 
 
16 For each archetype calibration, we conducted a local robustness check by independently perturbing key parameters (plus or 
minus 20 percent) and resimulating the model. In all cases, the qualitative outcome class (convergence, hardware-constrained 
persistence, or explosive divergence) remained unchanged across nearly all draws (80 to 81 out of 81 successful simulations per 
archetype), with a single borderline case near the stability threshold in the intelligence-explosion scenario. This suggests that the 
illustrative paths are not knife-edge artifacts of specific point values.

25 
Table 4.1. Illustrative Archetype Parameterizations and Implied Dynamics 
Archetype 
Technology 
Gap 
Dynamics 
(𝝀𝒙) 
Deployment 
Dynamics 
(𝝀𝒛) 
Hardware 
Dynamics 
(𝝀𝒉) 
Learning- 
by- 
Doing 
(𝜷) 
Technology 
Deployment 
Feedback 
(𝝆) 
Hardware 
Bottleneck 
(𝝉) 
Output 
Reinvestment 
(𝝁) 
Output 
Mapping 
(𝜼) 
Scaling wall 
Fast decay 
(−0.25) 
Fast decay 
(−0.25) 
Fast 
decay 
(−0.25) 
Very 
weak 
(0.05) 
Weak 
(0.1) 
Extreme 
(0.8) 
Weak 
(0.01) 
Near-human 
(1×) 
Intelligence 
explosion 
Positive 
feedback 
(0.1) 
Slow decay 
(−0.1) 
Slow 
decay 
(−0.1) 
Weak 
(0.1) 
Weak 
(0.1) 
Mild 
(0.2) 
Strong 
(0.15) 
Superhuman 
(10×) 
Development 
flywheel 
Fast decay 
(−0.2) 
Fast decay 
(−0.2) 
Fast 
decay 
(−0.2) 
Very 
strong 
(0.9) 
Very strong 
(0.9) 
Moderate 
(0.5) 
Moderate-
strong 
(0.1) 
Near-human 
(1×) 
Stable gap 
Medium 
decay 
(−0.15) 
Medium 
decay 
(−0.15) 
Medium 
decay 
(−0.15) 
Weak 
(0.2) 
Moderate 
(0.4) 
 
Moderate 
(0.4) 
Moderate 
(0.05) 
Near-human 
(1×) 
NOTE: Numeric values are illustrative and chose to satisfy regime-defining inequalities rather than to serve as point estimates. 
Local perturbations around each archetype preserve qualitative outcomes (see footnote 16). Qualitative descriptors (e.g., weak, 
moderate, strong, fast or slow decay) are assigned using fixed thresholds derived from the parameter ranges used in the 
Monte Carlo analysis. For 𝜆 parameters, fast, medium, and slow correspond with implied half-lives (or doubling times when 𝜆>
0); for 𝛽, 𝜌, 𝜏, 𝜇, and 𝜂, labels correspond to bins over the simulated support. 
 
For each archetype, we characterized the resulting gaps assuming the same initial conditions and 
under the fast-capital adjustment regime. All archetypes begin with initial advantages of 𝜙= 𝜓=
𝜉= 0.5, and all have an FMA duration of six months. Figure 4.1 displays the dynamics in the relevant 
leader-follower gap variables over the 20-year horizon for each archetype. The y-axis is in log scale. In 
the early years, when the initial advantage is active, all trajectories follow the same path, which is 
expected given the explicit parameterization of the archetypes which all being with the same initial 
advantage values and duration.  
However, once the initial FMA ends and system dynamics take over, the archetypes diverge. In 
the intelligence-explosion archetype, the self-reinforcing technological improvement drives rapid 
divergence across all dimensions. In contrast, the deployment flywheel archetype achieves a 
comparable income divergence despite nonexplosive technology dynamics. The scaling wall case 
produces rapid convergence back to parity between the leader and follower. Finally, the stable gap 
archetype highlights the possibility of persistent but bounded asymmetric over a 20-year period. 
Together, these cases highlight the trajectories of competitive dynamics that arise through different 
mechanisms, which motivates the broader Monte Carlo exploration that follows.

26 
Figure 4.1. Archetypal Trajectories 
 
NOTES: This figure illustrates the five stylized archetypes generated by the model; each is defined by the parameter 
values in Table 4.1. The y-axis is in log scale. 
Overview of Simulation Outcomes 
Having illustrated the model’s core mechanisms under several scenarios, we now turn to a Monte 
Carlo exploration of outcomes across wide parameter ranges reflecting deep uncertainty about AGI 
development. 
Operational Metrics for DEAs 
We delineate DEA-driving mechanisms using the model’s local stability structure. For any 
simulation that has 𝜆+ > 0, we classify the trajectory as intelligence explosion present. In the model, 
𝜆+ > 0 implies a self-reinforcing component in frontier improvement, and holding other states fixed, a 
larger technology gap raises its own growth rate. In practice, DEAs in this subset may also reflect 
additional reinforcing channels. However, because 𝜆+ > 0 corresponds to the most salient theoretical 
distinction, we treat these DEAs as a single aggregated class and record only the presence of the 
intelligence-explosion term.  
Among DEA trajectories with 𝜆+ < 0, any divergence must be generated by cross-variable 
feedback rather than by frontier self-reinforcement. We therefore classify these DEAs by which 
reinforcing loop is responsible for local instability at the time the trajectory crosses the DEA 
threshold. There are two such cases:

27 
1. Development flywheel (slack-hardware regimes; Cases 1 and 3) 
When hardware is slack, the relevant unstable subsystem remains the (Δ𝑥, Δ𝑧) bloc (see 
Appendix A). When there is no intelligence explosion, DEAs attributed to the development 
flywheel are those for which the reduced system is unstable through a determinant violation 
(𝛽𝜌> 𝜆+𝜆,) while the trace condition is satisfied. Intuitively, deployment generates learning 
(𝛽), and learning increases deployment ability (𝜌). If this cross-feedback overwhelms the 
stabilizing terms 𝜆+ < 0 and 𝜆, < 0, a temporary lead becomes structurally amplified even 
without an intelligence explosion present.  
2. Hardware moat–reinvestment loop (binding-hardware regimes; Cases 2 and 4) 
When hardware binds, effective deployment is mediated by hardware capacity, and the 
dominant reinforcing loop is income →hardware →learning →income. In Case 2 (fast 
capital and binding hardware), the relevant instability condition can be expressed in terms of 
the (Δ𝑥, Δℎ) bloc as a cross-feedback dominance condition: 𝛽𝜇> 𝜆+(𝜆. + 𝜇). In Case 4, the 
corresponding instability is governed by the dominant eigenvalue of the (Δ𝑥, Δℎ, Δ𝜅) bloc, but 
the economic logic is the same.  
DEA-100 Threshold 
Among trajectories in a DEA regime, we further distinguish by realized severity, marking those 
reaching a 100-fold income gap by year 20. These cases, which we refer to as DEA-100, represent 
situations where divergent dynamics have produced extreme asymmetries within the simulation 
horizon. We report DEA-100 separately because a trajectory can be in a DEA regime yet diverge only 
gradually. The DEA-100 benchmark isolates cases in which decisively divergent dynamics generate 
large, salient asymmetries with a 20-year horizon. 
This threshold serves as a transparent benchmark for identifying trajectories that have entered a 
decisively divergent regime within the 20-year simulation horizon. To provide intuition, if both blocs 
begin at parity and the leader achieves a 100-fold income advantage after 20 years, the implied 
annualized growth rate differential is approximately 26 percentage points. This benchmark aligns 
with, though falls slightly below, standard definitions of explosive economic growth that typically use 
30 percent annual growth as a reference point (Davidson, 2021).17  
We emphasize that the precise numerical cutoff is not substantively important. An 80-fold or 
120-fold income gap would convey the same qualitative conclusion. Robustness checks confirm that 
the patterns reported in the next section (“Summary Results”) are not sensitive to the exact choice of 
threshold.18  
 
17 Formally, the 100-times threshold marks a regime in which the leader’s routine capital formation exceeds the follower’s 
maximum theoretical capacity. Let 𝐼-,$ = 𝜇𝑌$ denote the leader’s hardware investment. A 100-times income gap implies that 
𝐼-,$ = 100𝜇𝑌3. If the reinvestment parameter is 𝜇= 0.1 (a value consistent with high-intensity mobilization scenarios), the 
leader’s annual hardware investment effectively equals 10 × 𝑌3. This implies the follower would need to forego ten years of total 
gross GDP to match a single year’s worth of the leader’s hardware spending. 
18 For instance, using a 50-times threshold increases the DEA percentage by approximately one percentage point.

28 
Summary Results 
Table 4.2 decomposes simulation outcomes at year 20 in the three mutually exclusive bins and one 
conditional severity measure. Convergent share is the fraction of runs that are locally stable. The DSA 
share (non–DEA-100) column capture divergent trajectories but do not reach the 100-times income 
gap by year 20.19 DEA-100 share is the unconditional fraction of runs that do reach the 100-times gap 
by year 20. Finally, DEA-100 conditional share reports the probability of reaching the DEA-100 
benchmark conditional on being in a divergent regime, which isolates severity from baseline frequences 
of divergence.  
Table 4.2. Summary of Simulations 
FMA 
Duration 
(months) 
Capital 
Regime 
Convergent 
Sharea 
DEA 
Shareb 
DEA-100 
Sharec 
DEA-100 
Conditional 
Shared 
3 
Fast 
20.4 
33.8 
45.8 
57.5 
 
Slow 
23.6 
37.6 
38.8 
50.8 
6 
Fast 
20.2 
27.0 
52.8 
66.2 
 
Slow 
22.2 
33.0 
44.8 
57.6 
12 
Fast 
20.6 
22.8 
56.6 
71.3 
 
Slow 
20.0 
34.4 
45.6 
57.0 
24 
Fast 
21.6 
16.4 
62.0 
79.1 
 
Slow 
20.2 
21.4 
58.4 
72.2 
NOTE: Each row reports outcome shares at year 20 for a given FMA duration and 
capital regime.  
a The convergent share indicates local stability. 
b The non–DEA-100 share indicates divergence that does not reach 100-times by year 
20. 
c The DEA-100 share indicates a DEA reaching 100-times by year 20. 
d These values are computed conditional on being in a divergent regime.  
 
The table highlights two facets of the model and parameter sampling space. First, the convergent 
share is stable across scenarios and capital regimes, staying near 20 percent. This implies that most 
parameter draws produce divergent dynamics, but a nontrivial minority are stable even under long 
FMAs and, thus, resolve back to parity over time. Second, the duration of the FMA mainly affects 
severity, not regime incidence. As the head start period lengthens, the DEA-100 share rises and the 
conditional probability of a DEA-100 among divergent runs increases in parallel. Fast-capital 
adjustment further shifts mass toward DEA-100 outcomes, indicating that capital scaling frictions 
primarily slow the pace at which divergence becomes extreme rather than preventing it altogether.  
 
19 On average, these simulations have an income ratio of by year 20 of 1.3, indicating that the leader’s income is approximately 30 
percent larger than the followers.

29 
Analysis of DEA-100s 
Next, we turn to the primary mechanisms driving the DEA-100 outcomes. We focus on the 
DEA-100 as it is the most economic consequential set of simulations. Table 4.3 displays the drivers, 
number, and share of DEA-100s. The vast majority of DEA-100s involve an intelligence-explosion–
like dynamic, but not all. Approximately 4 percent of DEA-100 simulations arise without technology 
autofeedback (𝜆+ < 0).  
Among these non–intelligence-explosion DEA-100s, the hardware-reinvestment loop, which 
propagates income gaps into hardware, which facilitates greater deployment, and allows the 
deployment-technology feedbacks (𝛽, 𝜌) to facilitate greater income, dominate non–intelligence-
explosion cases. Just two simulations achieved a DEA-100 driven only by the development flywheel 
effect. 
This rarity of the development flywheel reflects the knife-edge nature of the required conditions in 
the sampled parameter space. When technology quality growth is not self-reinforcing (𝜆+ ≤0), the 
development flywheel requires the feedback condition (𝛽𝜌> 𝜆+𝜆,) to hold while deployment 
remains unconstrained by hardware. This combination occupies a narrow region of the parameter 
space because even modest hardware scarcity shifts the dynamics toward hardware-mediated 
amplification.20  
The rarity of pure development flywheel DEA-100s also reflects endogenous transitions. 
Trajectories that begin in the development-flywheel region typically encounter binding hardware 
constraints as deployment scales. Once this occurs, the dynamics shift away from a purely 
development-driven mechanism toward one in which income-to-hardware reinvestment becomes the 
dominant source of amplification. The simulation results suggest that development flywheel 
amplification is potentially a plausible entry point into decisive dynamics, while hardware-mediated 
reinvestment is the mechanisms that sustains them.  
Table 4.3. DEA-100s by Driver 
Driver 
Number 
Share 
Intelligence explosion present 
1,942 
0.96 
Hardware-reinvestment loop 
80 
0.04 
Deployment flywheel 
2 
<0.01 
NOTE: Counts and shares are conditional on trajectories 
classified as DEA-100. “Intelligence explosion present” is 
defined by 𝜆& > 0; the remaining DEA-100s are attributed to 
the locally dominant non-explosion instability mechanism at 
threshold crossing. 
 
 
 
 
20 Note that any case in which 𝜆& > 0 trivially satisfies the development-flywheel condition because 𝜆' < 0, 𝛽> 0, and 𝜌> 0. 
As a result, only a small sliver of the parameter space can satisfy the development flywheel condition of 𝛽𝜌> 𝜆&𝜆' when an 
intelligence-explosion is not present (𝜆& < 0) without triggering a hardware-binding regime.

30 
The different DEA-100 mechanisms also generate systematically different timing profiles (Figure 
4.2). Intelligence-explosion DEA-100s occur faster than other DEA-100s, with an average time to the 
100-times income threshold of approximately 10 years. DEA-100s driven by hardware-reinvestment 
or development-flywheel mechanisms tend to emerge later. This result highlights that the speed of 
dominance is itself informative about the underlying mechanisms. Rapid transitions to extreme 
asymmetry are indicative of strong self-reinforcing technological dynamics. From a strategic 
perspective, this distinction suggests that slower accumulation-driven DEA-100s may offer longer 
windows for intervention even if these DEA-100s ultimately prove difficult to reverse.  
Figure 4.2. Time to DEA-100 by Driver 
 
NOTE: For trajectories that reach DEA-100, the figure reports the time (years) to first cross the 100-times income-gap 
threshold, stratified by the identified mechanism class. 
Intervention Sensitivity Counterfactual 
Next, we evaluate how sensitive each DEA-100 mechanism is to potential intervention. 
Specifically, we ask whether a follower that intervenes after a substantial asymmetry has emerged, but 
before the advantage becomes fully decisive, can meaningfully delay or prevent the eventual arrival of a 
DEA-100. 
For each of the DEA-100 trajectories, we identify the moment at which the leader first crosses a 
lower threshold of a 5-times income advantage. This threshold is chosen to represent the onset of a 
clearly asymmetric economic position while still allowing scope for intervention before dominance 
becomes fully decisive. Starting from the point at which the 5-times threshold is crossed, we introduce 
interventions and simulate how the trajectory evolves over the subsequent years.21 
 
21 For each trajectory that reaches a substantial but not yet decisive asymmetry, we identify the first time at which the income gap 
exceeds the 5-times threshold. Then, we extract the fully state vector at that moment. We then treat this state as a new initial 
condition and simulate a baseline continuation in which all model parameters remain unchanged. This continuation represents

31 
We focus on two stylized intervention archetypes that map onto recognizable economic security 
and AGI strategies. In both cases, the intervention is applied once the leader first crosses the lower 
dominance threshold and is maintained for the remainder of the simulation horizon. We hold initial 
advantages (𝜙, 𝜉, 𝜓) fixed and, instead, represent policy actions that shift the autonomous dynamics 
that govern how technology deployment and hardware evolve. 
These archetypes should be interpreted as reduced-form representations of policy packages rather 
than literal one-to-one mappings. The purpose of this exercise is to compare the leverage of two 
distinct strategic approaches conditional on intervening after a substantial lead has emerged. Here, we 
looked at two archetypes: 
• Full-stack denial represents a denial strategy aimed at constraining a rival’s ability to both 
advance the frontier and scale deployment. In real-world terms, it corresponds with a package 
combining tight controls on advanced compute with complementary actions that limit how 
quickly economic gains translate into expanded hardware capacity (e.g., restrictions on supply 
chains and infrastructure scale-up). The strategic intent is to weaken the core capability and 
scale the flywheel at the same time, effectively slowing progress while also limiting the speed at 
which deployment can expand when hardware becomes binding.  
We use full-stack denial as a proxy for joint shock that reduces learning-by-doing feedback 
from deployment into technology (𝛽↓), slows autonomous technology progress (𝜆+ ↓), 
tightens hardware and deployment scaling bottlenecks through stronger throttling under 
hardware scarcity (𝜏↑), weaker reinvestment into hardware capacity (𝜇↓), and stronger decay 
or constraint in the hardware gap dynamics (𝜆. ↓). 
• Ecosystem containment represents a strategy that prioritizes containment and diffusion 
control rather that direct frontier denial. It is designed for settings in which rival blocs may not 
share the same domestic markets or training data but in which policy can still shape outcomes 
by limiting third-market adoption and weakening cross-ecosystem feedback. In real terms, 
ecosystem containment may correspond with aligned standards and certification regimes, 
procurement restrictions, trusted vendor policies, and platform access constraints that reduce 
a rival’s ability to deploy widely in allied and third-country markets. The strategic intent is to 
reduce the economic convertibility of capability gains into scale and loosen the deployment-
learning flywheel that can otherwise amplify early leads.  
We use this archetype as a proxy for joint shock that reduces the translation of capability 
improvements into deployment scale (𝜌↓), increases the rate of diffusion decay (𝜆, ↓), and 
reduces deployment-to-technology learning feedback (𝛽↓). 
Table 4.4 maps the policy archetypes into parameter changes in the model. We evaluate three 
versions of each archetype: a strong version, with larger parameter shifts; a weak version, with smaller 
shifts; and a medium version in between. The medium shifts are shown in Table 4, and the strong and 
weak versions scale these shifts by a factor of 1.5 up and 0.5 down, respectively.  
 
 
 
the counterfactual evolution of the competition absent any intervention. Comparing outcomes under this continuation allows us 
to estimate probabilities that a trajectory which reaches the 5-times threshold ultimately results in a DEA.

32 
Table 4.4. Strategic Intervention Archetypes 
Archetype 
Strategic Goal 
Parameter Changes 
Full-stack denial 
Slow frontier progress 
and constrain scaling 
𝛽× 0.8; 𝜏× 1.4; 𝜇× 0.8; 𝜆& −0.04; 𝜆- −0.02 
Ecosystem containment 
Limit diffusion or 
convertibility and weaken 
the flywheel 
𝛽× 0.9; 𝜌× 0.8; 𝜆' −0.02 
NOTE: Policy archetypes are implemented as parameter shifts applied once the leader first crosses a 5-times 
income-gap trigger and then held for the remainder of the horizon. The table shows the medium shifts; weak 
and strong versions scale these shifts by 0.5 times and 1.5 times, respectively.  
 
For each resimulated trajectory, we recorded two outcome measures. First, we determined 
whether the trajectory still achieved a DEA-100 within the 20-year horizon. Second, if a DEA-100 
still occurred, we measured the change in the time required to reach the 100-times threshold relative 
to the baseline continuation. These two measures allow us to distinguish between interventions that 
outright prevent a DEA-100, those that delay it, and those that have negligible effects once dominance 
dynamics are underway (i.e., once the 5-times threshold is crossed).  
Table 4.5 presents the results. We have grouped the deployment flywheel and hardware-
reinvestment loop trajectories together in this analysis. The results highlight that intervention 
effectiveness depends on the underlying DEA-100 mechanism. When an intelligence-explosion–like 
dynamic is present, neither intervention archetype works particularly well once the system has crossed 
the 5-times threshold. Even strong full-stack denial avoids a DEA-100 in only 12 percent of cases, and 
the ecosystem containment policy performs an order of magnitude worse. Delays are modest as well, 
on the order of one year even under strong denial, and most trajectories still reach more than 50-times 
income gaps by year 20. This pattern reflects the structure of the model because, when 𝜆+ > 0, the 
dominant source of divergence is frontier self-reinforcement. Interventions that primarily weaken 
deployment, diffusion, or hardware accumulation operate downstream of instability. As a result, 
policies slow the realization of economic dominance but do not remove the positive eigenvalue driving 
divergence.  
Later interventions are substantially more effective in nonexplosion scenarios, particularly against 
accumulation-driven dominance. When intelligence-explosion dynamics are absent, intervention 
leverage increases. Full-stack denial becomes highly effective even when applied after a 5-times income 
gap has emerged, avoiding DEA-100s in more than one-half of the cases under medium policy 
strength. Average delays increase as well, and a large share of trajectories remains under the 50-times 
level by year 20. By attacking multiple links in the reinforcement chain, the full-stack denial policy can 
move the system back into a locally stable region even after substantial divergence has occurred.  
Across both mechanism classes, ecosystem containment underperforms full-stack denial. Its 
effects are small in explosion regimes and modest in nonexplosion ones, avoiding DEA-100s in 
roughly 10 to 20 percent of nonexplosion simulations. However, the impact is nonzero, suggesting 
that containment can produce small delays and, occasionally, prevent extreme outcomes by weakening 
deployment-learning feedback and slowing diffusion.

33 
Table 4.5. Strategic Intervention Archetype Results 
Mechanism 
Group 
Archetype 
Intensity 
Avoided by  
Year 20 
(%) 
Average 
Delay 
(years) 
Final Gap 
<50× 
(%) 
Intelligence 
explosion 
present 
Full-stack denial 
Weak 
3.0 
0.4 
0.7 
 
Medium 
6.2 
0.9 
3.9 
 
Strong 
11.5 
1.3 
8.0 
Ecosystem 
containment 
Weak 
0.3 
0.0 
0.0 
Medium 
0.6 
0.0 
0.0 
 
Strong 
0.8 
0.1 
0.0 
No explosion 
Full-stack denial 
Weak 
30.1 
2.6 
21.7 
 
Medium 
67.5 
4.9 
60.2 
 
Strong 
92.8 
6.9 
85.5 
Ecosystem 
containment 
Weak 
9.6 
0.4 
0.0 
Medium 
14.5 
0.8 
1.2 
 
Strong 
19.3 
1.3 
8.4 
NOTE: Results summarize the resimulation starting at the 5-times trigger (1) whether DEA-100 is 
avoided by year 20, and (2) conditional on still reaching DEA-100, the change in time-to-100-times 
relative to baseline continuation. “Final Gap <50×” reports whether the end-of-horizon income gap 
remains below 50 times.  
 
Figure 4.3 shows the probability of avoiding a DEA-100 by year 20 as a function of when the 
intervention begins and how forceful it is, stratified by both policy archetype and underlying DEA-
100 mechanism. The figure shows how the marginal value of acting earlier instead of acting with 
stronger interventions differs across policies and archetypes.  
Under full-stack denial in nonexplosive regimes, timing sensitivity depends on intervention 
intensity. Strong denial is relatively flat over early trigger points, while medium and weak denial have a 
clearer decline as intervention is delayed. With intelligence-explosion dynamics, the curves become 
steeper, and strong full-stack denial avoids DEA-100s about 25 percent of the time if applied early, 
but this falls quickly as the trigger point rises indicating that early action matters more for intelligence-
explosion–like trajectories.

34 
Figure 4.3. Share of DEA-100s Avoided by Intervention and Trigger Point 
 
NOTE: Probability of avoiding a DEA-100 by year 20 as a function of (1) when the intervention begins (trigger point) and 
(2) intervention intensity, shown separately by policy archetype and underlying DEA-100 mechanism class.  
Discussion and Robustness 
The simulations presented in this chapter are robust to reasonable perturbations of the underlying 
parameters. Local sensitivity checks confirm that the qualitative outcome classes remain stable under 
perturbations of model inputs. The 100-fold income gap threshold used to operationalize a DEA-100 
is not load-bearing because similar patterns emerge under alternative thresholds. These findings 
suggest that the core dynamics identified are not artifacts of specific calibration choices but instead 
reflect structural features of the modeled feedback system.  
At the same time, several limitations warrant caution in interpreting these results. As discussed in 
Appendix C, the model abstracts from many real-world responses, such as institutional response, 
alliance formation, and noneconomic dimensions of strategic competition. Appendix B highlights that 
relaxing the assumption of perfect substitution between AGI and human labor does not 
fundamentally change the potential occurrence of a DEA but would likely influence the timing and 
structure of the DEA. Consequently, the simulation outputs should be read as characterizing the 
direction and strength of competitive pressures rather than as point forecasts of future income 
differences. Despite these caveats, the analysis establishes that DEA is a structurally plausible outcome 
under a wide range of assumptions about AGI development, and that it can arise through multiple 
distinct causal pathways.

35 
Chapter 5 
Conclusion and Strategy Implications 
One central point of disagreement in AGI strategy is whether economic competition tends toward 
convergence or divergence once AGI enters production. Some argue that diffusion dynamics will 
erode early leads because these dynamics have done so for most general-purpose technologies. Others 
contend that the potential self-improving nature of intelligence creates runaway advantages that 
cannot be closed. This report shows that neither intuition is entirely correct. 
DEA Reframed 
Our central conceptual contribution is the operationalizing of DEA as a structure property of 
competition, not a forecast or claim about inevitability. Understanding what a DEA is, and what it is 
not, is critical for interpreting the findings of the analysis. 
A DEA is not a claim about coercive dominance. It does not imply that a leading actor can compel 
others through force or that geopolitical outcomes are determined by economic asymmetry alone. A 
DEA is also not a claim about intelligence explosions being likely; intelligence-explosion dynamics can 
produce DEAs, but our analysis demonstrates that DEAs can also arise through slower accumulation 
channels. Finally, a DEA is not a claim that outcomes are absorbing or permanent. Regimes can shift, 
and advantages can, in principle, be contested. What the analysis shows is that the conditions for 
contestability depend on when and how actors respond.  
In the framework developed here, a DEA is a regime in which equilibrating forces are overtaken. 
In such a regime, the normal mechanisms that erode FMAs, such as technology diffusion, capital 
mobility, imitation, and catch-up investment, operate too slowly relative to the rate at which gaps are 
widening. The result is that economic asymmetries constrain future strategic action because a trailing 
actor may remain unable to close the gap regardless of subsequent effort, not because they lack 
capability in absolute terms but because the leader’s advantage continues to grow faster than the 
follower can accumulate resources. 
The relationship between DEA and DSA is worth restating. A DSA typically refers to a military 
or geopolitical position from which a leading actor or project could effectively preclude rivals from 
challenging its dominance. A DSA can produce a DEA, but a DEA does not require a DSA. Whether 
and how a DEA translates into political or military dominance is an open question that depends on 
institutions, deterrence, and strategic choice, not economic dynamics alone. The present analysis 
remains agnostic on that translation; its contribution is to characterize the economic substrate on 
which strategic dynamics would play out. In summary, DEA explains how strategic decisiveness can 
arise economically, even without extreme technological assumptions. DEA provides a tractable 
analytical object for reasoning about competitive outcomes and does so in terms of structural dynamics 
rather than threshold effects.

36 
What Drives Decisiveness? 
The model and simulations reveal that decisive outcomes arise through distinct causal pathways, 
each with different policy implications. This section abstracts from the case-by-case findings to 
identify the mechanism classes that matter the most. 
Frontier-Driven Decisiveness 
The most dramatic pathway to a DEA involves an intelligence-explosion–like dynamic, in which 
advances in AI capabilities accelerate the rate of further AI development. When frontier research is 
strongly self-reinforcing, small initial leads can compound into unbridgeable gaps within relatively 
short time horizons.  
This mechanism operates primarily through the technology gap channel. It is fast, concentrated at 
the upstream end of the economic chain, and difficult to reverse once large gaps have emerged. The 
model, and resulting simulation sample, show that, when frontier dynamics dominate, intervention 
leverage is sharply time limited. Policies that might be effective at early stages become ineffective once 
the feedback loop has engaged. The implication is that actors concerned about frontier-driven DEAs 
must focus on monitoring and early response rather than on remediation after the fact. 
Accumulation-Driven Decisiveness 
A second pathway to DEA operates through accumulation dynamics rather than frontier 
breakthroughs. Here, the mechanism is that economic output enables reinvestment in hardware, 
which allows greater deployment, which improves technology, and drives further output growth. This 
pathway does not require intelligence-explosion–like dynamics (although such dynamics can 
substantially accelerate if present) and can arise even if AI capability improvements are gradual or if 
the technology diffuses relatively freely. 
Accumulation-driven DEAs are slower to develop than frontier-driven ones but are still decisive in 
the relative sense. Once established, trailing actors face a compounding disadvantage that does not 
naturally resolve. Importantly, this pathway is much more policy sensitive. Because the feedback loop 
operates through investment and deployment rather than pure research, interventions targeting 
hardware capacity, capital formation, and deployment speed can materially affect trajectories. Export 
controls, investment restrictions, and infrastructure policy may all have traction in this regime in ways 
they do not when frontier dynamics dominate. 
The synthesis of this analysis is that most decisive outcomes in the model and simulation sample 
arise from frontier dynamics, but some decisive outcomes arise without them. This matters because 
the policy levers available differ radically between mechanisms. An approach designed for a frontier-
driven world may be entirely ineffective in an accumulation-drive scenario and vice versa. Strategic 
planners cannot assume a single model of how decisiveness arises and should prepare for multiple 
pathways.

37 
Timing Dominates Intensity 
Across the intervention analysis, one consistent finding is that when an actor intervenes may 
matter more than how aggressively they intervene. Figure 4.3 shows that, across both frontier- and 
accumulation-driven mechanisms, early intervention dominates stronger intervention later. This result 
is robust to variations in mechanism calibration, initial conditions, and policy instrument choice.  
The intuition is that, in systems with self-reinforcing feedback, the state of the system at any 
moment determines the feasible set of future states. Early in a competitive trajectory, the gap between 
leader and follower is small; feedback loopers are not yet fully engaged; and a given policy intervention 
can shift the system onto a different path. Later, once gaps have widened and feedback is operating at 
full strength, even aggressive policies may struggle to alter trajectories. 
Capital frictions and hardware constraints affect the tempo of competition but not its direction. 
Slow-capital adjustments extend the timeline over which outcomes are determined but not the 
fundamental logic. In some sense, slow-capital-accumulation regimes require more time to respond 
but also offer more time for the leader to consolidate advantages. The net effect is that the window for 
shaping outcomes is longer in calendar time but not necessarily more forgiving in strategic terms. 
This finding should be read as a warning rather than advice. We do not prescribe specific 
interventions in this report but do establish the structural fact that waiting for certainty itself is a 
strategic choice, one with a potential cost for the follower in the form of lost geopolitical and economic 
power. The option value of delaying action must be weighed against the cost of delaying action, and 
our analysis suggests that cost is convex. Actors who wait for definitive evidence that a DEA is 
forming may find that the window for effective response has already closed. 
What This Report Does Not Claim 
Clarity about the boundaries of this analysis is important to prevent misinterpretation. Several 
explicit disclaimers are warranted. 
First, this analysis is not a forecast of AGI timelines. The model takes capability trajectories as 
inputs, not outputs. It does not predict when AGI will arrive, how capable it will be, or which actors 
will develop it first. The analysis is conditional: If AGI development follows paths within the 
calibrated parameter ranges, the competitive dynamics exhibit the properties described. Readers who 
reject the premise that AGI development is imminent or plausible should treat these findings as 
scenario analysis rather than predictions. 
This is not a claim that DEAs are inevitable. The model and the simulation sample show that 
decisive outcomes are common but not universal. Across the full range of parameter uncertainty 
explored, a substantial fraction of draws result in convergent dynamics in which early leads erode. The 
analysis identifies conditions under which DEAs arise, but these conditions are not guaranteed to 
obtain. Readers should not interpret these findings as deterministic. 
This is not a welfare analysis. The report characterizes competitive dynamics but does not evaluate 
whether particular outcomes are good or bad. A world in which one actor achieves a DEA might be 
better or worse than a world of persistent competition, depending on who achieves dominance, how 
they use it, and what alternatives are foreclosed. The framework is descriptive rather than normative.

38 
This is not a prescription for any specific national policy. The intervention analysis examines how 
different policy levers affect competitive trajectories but does not recommend that any particular actor 
pursue any particular strategy. The appropriate policy response depends on an actor’s position, values, 
risk tolerance, and beliefs about other actors’ intentions, none of which is addressed here. This report 
has provided analytical inputs for strategic reasoning but does not provide strategic conclusions. 
These boundaries matter because the analysis could be misread as justifying aggressive competitive 
policies, complacency about diffusion, or fatalism about outcomes. None of these interpretations is 
warranted. The contribution is to clarify the structure of the problem, not to resolve the value 
judgments that must inform any response.  
Implications for AGI Strategy 
Rather than offering policy recommendations, this section suggests strategic lenses through which 
actors might approach AGI competition: 
• Focus on regime identification rather than point prediction. The analysis suggests that the critical 
strategic question is not “will we achieve AGI first” or “how large is our lead” but “which 
feedback regime are we in, and is it shifting?” Policymakers should develop indicators and 
monitoring systems designed to detect regime transitions rather than tracking capability 
metrics in isolation. 
• Make strategy conditional on mechanism. Because frontier-driven and accumulation-driven 
pathways to a DEA have different properties and respond to different interventions, strategic 
planning should not treat AGI competition as a single problem. Actors should develop 
distinct response playbooks for different scenarios and invest in the diagnostic capabilities 
needed to determine which playbook applies. 
• Prioritize monitoring indicators that track feedback intensity. The analysis identifies several 
variables that could serve as leading indicators of regime type: the rate of deployment scaling, 
the intensity of hardware reinvestment loops, and the magnitude of learning-by-doing effects. 
Actors concerned about competitive dynamics should develop robust measurement and 
intelligence capabilities that focus on these variables. 
• Design for early response under uncertainty. Given the timing findings, strategic postures should 
be designed for rapid response rather than deliberative optimization. This does not mean 
acting precipitously, it means investing in the decisionmaking infrastructure, prepositioned 
options, and analytical capabilities needed to act quickly when conditions warrant.  
These lenses are offered as starting points for strategic reflection, not as complete frameworks. 
The appropriate response to AGI competition depends on factors far beyond the economic dynamics 
modeled here, including alliance structures, domestic political constraints, ethical commitments, and 
beliefs about adversary intentions. What the analysis provides is a clearer picture of the economic 
substrate on which the higher-order strategic considerations must operate.

39 
The Broader Contribution 
This report makes three contributions to the literature on AGI strategy and economic growth. 
First, it connects AGI strategy debates to formal growth dynamics. Much of the existing discussion of 
AGI competition relies on informal intuitions about diffusion, catch-up, and FMAs. By embedding 
these intuitions in a growth model with explicit feedback structures, the analysis makes it possible to 
stress-test competing claims and identify conditions under which different intuitions hold.  
Second, the report operationalizes decisiveness without relying on speculative thresholds. Prior 
treatments of decisive advantage often define it in terms of specific capability levels, such as the point 
at which AI systems can take over or prevent rivals from catching up. These definitions are difficult to 
operationalize and depend on assumptions about capabilities that remain deeply uncertain. The DEA 
framework developed here defines decisiveness in terms of dynamic properties of competitive 
interaction, which can be assessed without knowledge of exactly what AGI systems will be able to do. 
This makes the concept analytically tractable. 
Third, it provides a framework for stress-testing AGI competition under deep uncertainty. By 
using Monte Carlo simulation across wide (even speculative) parameter ranges, the analysis 
characterizes not just point estimates but a full distribution of possible outcomes. This approach is 
appropriate, given the profound uncertainty about AGI development trajectories, and provides a 
template for how similar analyses might be conducted as new information becomes available.  
The debate over AGI’s strategic implications has often been framed as a contest between 
optimists, who expect diffusion, and pessimists, who expect concentration. This report suggests that 
both positions are half-right: Whether AGI produces convergence or dominance is not a matter of 
belief or temperament but a matter of economic structure. The question is empirical, contingent, and 
(to some degree) subject to choice. Understanding the structural conditions that determine which 
outcome obtains is the first step toward exercising that choice wisely.

40 
Appendix A 
Stability Conditions 
This appendix formalizes the local stability properties of the dynamic system across all four 
economic regimes discussed in the body of this report. While the main text resents the reduced 2 × 2 
stability conditions for the simplest case, the full dynamics involve switching behaviors and higher-
dimensional interactions between technology, deployment, hardware, and capital accumulation.  
As emphasized in Chapter 2, the reduced (Δ𝑥, Δ𝑧) system provides a parsimonious benchmark for 
understanding frontier dynamics when hardware constraints are slack and when capital adjusts 
rapidly. In that regime, technology and deployment for a closed upstream subsystem, and violations to 
the corresponding trace or determinant conditions, imply that the full system is unstable. However, 
when hardware constraints bind or when capital adjusts slowly, realized deployment diverges from 
notional deployment, and additional feedback channels become active. The reduced conditions, 
therefore, serve as conservative and transparent reference points. This appendix clarifies how physical 
constraints and capital dynamics mediate, delay, or amplify divergence.  
General Definitions and State Space 
We define the system in terms of the gap variables between the leader and follower. The state 
vector 𝒗 evolves according to 𝒗̇ = 𝑱𝒗, where 𝑱 is the Jacobian matrix evaluated at the steady state. The 
core dynamic equations are 
 
Δ𝑥̇ = 𝜙+ 𝜆+Δ𝑥+ 𝛽Δ𝑧 
 
 
Δ𝑧̇ = 𝜉+ 𝜌Δ𝑥+ 𝜆,Δ𝑧−𝜏(Δ𝑧−Δℎ)- 
 
 
Δℎ̇ = 𝜓+ 𝜇Δ𝑦+ 𝜆.Δℎ 
 
 
Δ𝑦= 𝛼Δ𝜅+ (1 −𝛼)(Δ𝑥+ Δ𝑧). 
 
Note that, as discussed in Chapter 2, the term −𝜏(Δ𝑧−Δℎ)- in the deployment equation 
represents a soft kink. On one side of the kink, when Δ𝑧≤Δℎ, the term is zero, and effective 
deployment is equal to desired deployment Δ𝑧. On the other, when Δ𝑧> Δℎ, effective 
deployment becomes Δ𝑧= Δℎ.

41 
Case 1: Fast-Capital Adjustment and Nonbinding Hardware 
The first case is the simplest, and the one primarily discussed in the main text. Here, financial 
markets are highly efficient and integrated and hardware capacity is abundant. In this case, the capital 
gap equilibrates instantly to Δ𝜅= Δ𝑥+ Δ𝑧. Substituting this into the income equation produces 
Δ𝑦= Δ𝑥+ Δ𝑧, as noted in the main text. The hardware equation decouples from the stability of the 
2 × 2 x-z subsystem because hardware does not constrain deployment.  
The Jacobian in this case is presented in Chapter 2, as are the stability conditions. 
Case 2: Fast-Capital Adjustment and Binding Hardware 
Here, financial markets are efficient, but hardware capacity constrains deployment. The relevant 
state vector becomes 𝑣= [Δ𝑥, Δ𝑧, Δℎ]@. In this case, the throttle term is active, and because hardware 
binds, effective deployment in the production function becomes Δℎ. As a consequence, fast-capital 
adjustment implies Δ𝜅= Δ𝑥+ Δℎ, and the income gap becomes Δ𝑦= Δ𝑥+ Δℎ. The hardware 
accumulation equation becomes Δℎ̇ = 𝜇(Δ𝑥+ Δℎ) + 𝜆.Δℎ. Additionally, because the hardware 
constraint is binding, Δ𝑥̇  depends on effective (realized) deployment rather than the desired level. 
This moves the feedback to ℎ→𝑥.  
In this case, the Jacobian becomes 
 
•
𝜆+
0
𝛽
𝜌
𝜆, −𝜏
𝜏
𝜇
0
𝜆. + 𝜇
‚. 
 
Note that in this formulation, Δ𝑧 does not feed back into Δ𝑥 or Δℎ (column 2 is zero except for 
the diagonal). We reorder the states and the matrix becomes block triangular 
 
•
𝜆, −𝜏
𝜌
𝜏
0
𝜆+
𝛽
0
𝜇
𝜆. + 𝜇
‚, 
 
with eigenvalues 𝜆, −𝜏 and those of the lower 2 × 2 bloc. In this case, stability requires the following 
three conditions: (1) the deployment throttle to dominate the deployment self-feedback is 𝜏> 𝜆,; (2) 
the x-h subsystem has a negative trace 𝜆+ + 𝜆. + 𝜇< 0; and (3) the x-h system has a positive 
determinant 𝜆+(𝜆. + 𝜇) −𝛽𝜇> 0.

42 
Case 3: Slow-Capital Adjustment and Nonbinding Hardware 
Here, hardware is abundant, but capital markets have friction. We first substitute the income gap 
equation into the capital dynamics to arrive at: Δ𝜅̇ = 𝛿)[𝛼Δ𝜅+ (1 −𝛼)(Δ𝑥+ Δ𝑧) −Δ𝜅]. The state 
space in this case is given by 𝑧= [Δ𝑥, Δ𝑧, Δ𝜅]@, and the corresponding Jacobian is 
 
ƒ
𝜆+
𝛽
0
𝜌
𝜆,
0
𝛿)(1 −𝛼)
𝛿)(1 −𝛼)
−𝛿)(1 −𝛼)
„. 
 
This matrix is block triangular, so the systems eigenvalues separate into the eigenvalues of the upper 
left 2 × 2 (the simple case discussed in Chapter 2) and the scalar value in the bottom right. Stability 
requires all real parts to be negative.  
The conditions on the upper left 2 × 2 are discussed Chapter 2, so here we focus on the bottom 
left scalar value. The conditions require that −[𝛿)(1 −𝛼)] < 0. This condition holds automatically 
for any economically meaningful parameters in which depreciation rates are strictly positive, and 
labor’s share (which is split with AI in the context of this model) is positive.  
Case 4: Slow-Capital Adjustment and Binding Hardware 
Here, hardware constrains deployment and capital adjusts slowly. The state vector is four 
dimensional, 𝑣= [Δ𝑥, Δ𝑧, Δℎ, Δ𝜅]@. The Jacobian combines elements from the prior three cases: 
 
⎣
⎢
⎢
⎡
𝜆+
0
𝛽
0
𝜌
𝜆, −𝜏
𝜏
0
𝜇(1 −𝛼)
0
𝜆. + 𝜇(1 −𝛼)
𝜇𝛼
𝛿)(1 −𝛼)
0
𝛿)(1 −𝛼)
−𝛿)(1 −𝛼)⎦
⎥
⎥
⎤
. 
 
As with Case 2, deployment is downstream of other dynamics. We again rearrange the Jacobian 
into  
 
⎣
⎢
⎢
⎡𝜆, −𝜏
𝜌
𝜏
0
0
𝜆+
𝛽
0
0
𝜇(1 −𝛼)
𝜆. + 𝜇(1 −𝛼)
𝜇𝛼
0
𝛿)(1 −𝛼)
𝛿)(1 −𝛼)
−𝛿)(1 −𝛼)⎦
⎥
⎥
⎤
. 
 
Here, the eigenvalues are given by the first entry 𝜆, −𝜏 and the eigenvalues of the lower right 3 × 3 
bloc. Case 4 is locally stable if and only if the following conditions hold: 
1. 𝜆, −𝜏< 0 
2. The 3 × 3 lower right bloc is Hurwitz stable (𝑎$ > 0, 𝑎8 > 0, 𝑎A > 0, 𝑎$𝑎8 > 𝑎A).  
We next derive these conditions. 
Define the characteristic polynomial as 𝑝(𝛾) = 𝛾A + 𝑎$𝛾8 + 𝑎8𝛾+ 𝑎A for the lower 3 × 3 bloc 
of the rearranged Jacobian:

43 
 
𝑎$ = −,𝜆+ + 𝜆. + 𝜇(1 −𝛼) −𝛿)(1 −𝛼)/ 
 
 
𝑎8 = −(1 −𝛼)𝛽𝜇+ (1 −𝛼)𝜆+(𝜆. + 𝜇) −𝛿)(1 −𝛼),(𝜆. + 𝜆+) + 𝜇/ 
 
 
𝑎A = 𝛿)(1 −𝛼),(𝜆.𝜆+ −𝛽𝜇) + 𝜆+𝜇/. 
 
Case 4 is the most complicated regime because all adjustment frictions operate simultaneously. 
Hardware constraints break the direct mapping from desired deployment to realized output, and 
slow-capital adjustment introduces an additional state variable that accumulates past income gaps into 
future productivity capacity. As a result, stability no longer has a simple interpretation in terms of 
frontier technology convergence alone. Here, local stability means the joint dynamics of technology, 
hardware accumulation, and capital deepening dampen each other. Income-driven hardware 
investment remains proportional to realized deployment; capital deepening does not overshoot 
effective capacity; and technology advantages do not compound faster than physical and financial 
stocks can absorb.  
Instability arises when these delayed feedbacks reinforce each other. In the unstable regime, even 
small initial gaps generate persistent acceleration because income gaps feed hardware accumulation; 
hardware feeds effective deployment; deployment feeds technology; and capital responds too slowly to 
offset the process. The Hurwitz conditions on the lower 3 × 3 bloc capture this in that they rule out 
endogenous amplification cycles across x, h, and k, conditional on the deployment throttle itself being 
stabilized.

44 
Appendix B 
Imperfect Substitution Between 
Human and AGI Labor 
This appendix relaxes the baseline assumption that AGI is a perfect substitution for human labor. 
In the main model, effective labor aggregates human and AI labor linearly, implying that differences in 
deployment intensity translate into productivity differences without diminishing returns. Here, we 
replace that limiting case with a CES aggregator, derive the per-capita output expression, and show 
how the elasticity parameter affects the income-gap decomposition used in the report. The purpose is 
to make transparent how sensitive the economic dominance mapping is to the assumed degree of 
human-AI substitutability. 
The production function maintains the Harrod-neutral Cobb-Douglas specification from 
Chapter 2: 
 
𝑌= 𝐾"[𝑋⋅𝐿5]$%", 
 
where capital 𝐾 and technology parameter 𝑋 retain their interpretations from the baseline model. The 
modification centers on the aggregation of effective labor 𝐿5, which now follows a CES specification 
between human and AGI labor. 
Defining the substitution parameter as 𝜖≡
B%$
B  (where 𝜖→1 as 𝜎→∞ and 𝜖→0 as 𝜎→1), 
effective labor per capita as a CES aggregator of human labor (normalized to 1 per worker) and AGI 
labor (𝜂𝑎): 
 
&C
D = (1 + (𝜂𝑎)E)
#
&. 
 
Taking logarithms yields: 
 
ln b
&C
Dc =
$
E 
 
 
ln(1 + (𝜂𝑎)E). 
 
This specification nests the baseline model as a special case.  
Income Gap Dynamics Under Imperfect Substitution 
The effective labor gap follows from this equation:

45 
 
Δz(σ) =
$
E [ln (1 + (𝜂𝑎&)E) −ln(1 + (𝜂𝑎*)E)] .
 
 
For computational tractability and economic interpretation, we derive a local linearization around 
a reference deployment level (𝑎¯). Define the deployment elasticity of effective labor as 
 
𝑠((𝑎; 𝜎) ≡
F 56'
(
G
F 56 H =
(IH)&
$-(IH)& ∈(0,1).
 
This elasticity captures the marginal contribution of AGI deployment to effective labor, bounded 
between zero and unity. For small deployment gaps around the reference point, 
 
Δz(σ) ≈𝑠((a; 𝜎)Δ ln 𝑎.
 
 
The economic interpretations are instructive. As 𝜎→∞ and 𝜂a becomes large, the elasticity 𝑠( →
1, and deployment maps one-for-one into effective labor differences, recovering the baseline linear 
case. For a finite 𝜎 or modest 𝜂a, however, 𝑠( < 1, reflecting diminishing returns from AGI 
deployment when human labor maintains a meaningful share in the production composite. 
Substituting the equation for effective labor into the equation for Δ𝑦 yields the approximate 
income gap under fast-capital adjustment: 
 
Δ𝑦≈Δ𝑥+ Δz(σ).
 
 
Under slow-capital adjustment, the dynamics from Chapter 2 remain structurally unchanged apart 
from the addition of Δ𝑧(𝜎).  
Implications for Interpretation 
The derivation shows that imperfect substitution changes the shape of the deployment-to-output 
mapping but not the basic composition. The income gap still decomposes into capital, technology, and 
deployment channels. What changes is how a deployment gap maps into Δ𝑧(𝜎).  
Explicitly, there is no globally valid claim that 𝜎 necessarily makes decisiveness weaker or stronger. 
Whether imperfect substitution attenuates or amplifies the deployment contribution to Δ𝑦 depends 
on the level of deployment in each bloc. When both blocs are already AI-intensive (𝜂𝑎 is large), the 
CES mapping behaves approximately logarithmically, and the marginal effect of further increases is 
governed by 
(IH)&
$-(IH)& ≈1. In that region, changing 𝜎 tends to matter less for the output mapping, and 
differences in 𝑎! translate roughly into differences in the log through 𝑧!(𝜎). 
When AI deployment is still modest, the curvature induced by 𝜖 can materially change how 
quickly effective labor rises with additional deployment. In that region, a lower 𝜎 (more 
complementarity) can either dampen or accentuate the gap contribution, depending on where 𝜂𝑎& and 
𝜂𝑎* lie relative to one another.  
Because our decisive outcome concept is defined in terms of economic consequences rather than 
technological source of the asymmetry, the CES extension does not change the definition. However, it

46 
clarifies that the production side constraints are an implicit modeling choice about how easily 
deployment can translate into effective labor when humans remain economically relevant. 
Operationally, introducing 𝜎< ∞ primarily affects the magnitude of the deployment contribution 
(1 −𝛼)Δ𝑧(𝜎) to the income gap, and therefore how quickly deployment dynamics (and any 
feedbacks that run through deployment) show up as economic divergence. 
The CES extension also has implications for assessing the local stability of the competitive 
dynamics. In Chapter 2, stability conditions are assessed by the Jacobian. Under imperfect 
substitution, the mapping of deployment to effective labor becomes state dependent, and the effective 
strength of downstream feedback channels depends on the refence level of deployment.  
To be precise, the elasticity of effective labor to deployment 𝑠((𝑎; 𝜎) rises toward one as effective 
deployment becomes large and falls toward zero when deployment is small relative to human labor. As 
a result, any feedback loop that operates through deployment differences will be attenuated by a factor 
proportional to 𝑠( at the reference point. This means that, when humans remain economically 
important in the production composite, additional deployment has diminishing marginal impact on 
effective labor, dampening the propagation of deployment and capability gaps into income gaps. As 
deployment becomes dominant, this attenuation disappears, and the dynamics approach the perfect-
substitution mapping.

47 
Appendix C 
Assumptions, Limitations, and 
Interpretation 
The model developed in this report is deliberately stylized. Its purpose is not to predict specific 
AGI trajectories but to identify structural conditions under which economic competition shifts from 
convergence to divergence. This appendix discusses model assumptions, their justifications, and their 
implications for interpreting the results. 
Not all assumptions in the model play the same role. Some are intentional stress tests, designed to 
examine whether decisive dynamics can emerge even under conditions that favor equilibration. Others 
are simplifications that likely bias results in identifiable directions. Still others represent real-world 
frictions omitted for tractability, or domains that fall outside the model’s intended scope entirely. 
Distinguishing among these categories can help with evaluating which findings are robust and which 
are contingent on specific modeling choices.  
The central claim of this report, that DEA is a regime property of competition under certain 
structure conditions, does not depend on any single assumption. Rather, it emerges from the 
interaction of feedback mechanisms that are present across a wide range of specifications. The 
following discussion clarifies which assumptions matter for which results, and how relaxing them 
would affect the analysis. 
Perfect Substitution Between Human and AI Labor 
The assumption that 𝜎→∞ represents a strong claim about the nature of AGI. It implies that AI 
systems can perform any task that humans can perform with no loss of quality or efficiency beyond 
that captured by the productivity parameter 𝜂. This assumption becomes more plausible as AI 
capabilities expand but may overstate substitutability in the near term. Appendix B evaluates the 
model under imperfect substitution, which highlights how the inclusion of imperfect substitution 
makes stability state dependent. 
The assumption also implies that human welfare effects depend entirely on capital ownership and 
transfer policies rather than on maintained labor income. In a world of perfect substitution, humans 
retain economic value only through their ownership claims on capital and AI systems, not through 
their direct productive contributions. This stark implication underscores the importance of 
institutional arrangements governing property rights and redistribution.

48 
Single-Good Economy with Homogeneous Technology 
Aggregating all production into a single good abstracts from sectoral heterogeneity that may prove 
crucial for understanding AI’s economic impact. Different industries likely exhibit different 
substitution elasticities, regulatory constraints, and innovation dynamics. A sector in which AI readily 
substitutes for human labor might coexist with others in which complementarity dominates. 
The homogeneous technology assumption, where 𝑋! multiplies all forms of labor equally, implies 
that technological progress benefits human and AI labor symmetrically. In practice, AI-specific 
improvements might differ from broader technological progress. The model could be extended to 
include separate technology indices for human and AI productivity, although this would complicate 
the analysis. 
The single-good assumption also precludes analysis of structural transformation, in which AI 
deployment might shift production toward AI-intensive sectors. Such compositional effects could 
amplify or dampen the aggregate relationships captured in the model. 
Linear Dynamics and Constant Parameters 
The linear specification of gap dynamics represents a first-order approximation around a reference 
point. Actual dynamics likely exhibit nonlinearities in which feedback effects strengthen or weaken, 
depending on the current gap levels. For instance, technology diffusion might accelerate when gaps are 
large (as the benefits of imitation increase) but slow when gaps are small (as the technological frontier 
becomes harder to copy). 
Constant parameters assume that fundamental relationships remain stable over time. In reality, 
such parameters as 𝛽 (the deployment-to-quality feedback) might increase as AI systems become 
more sophisticated and generate more-valuable data. Similarly, hardware constraints might bind 
differently as technology evolves, with new bottlenecks emerging as old ones are resolved. 
The model treats innovation as deterministic, abstracting from the fundamental uncertainty in 
R&D. Breakthrough innovations could create discontinuous jumps in capabilities that violate the 
smooth dynamics assumed here. Incorporating stochastic shocks would require different analytical 
methods but might better capture the punctuated nature of technological progress. 
Exogenous Savings Rates 
Treating population as exogenous excludes potential feedback from economic outcomes to 
demographic choices. If AI deployment dramatically increases income in leading regions, it might 
attract immigration that further amplifies advantages. Conversely, regions facing AI-driven 
displacement might experience emigration that compounds their challenges. 
Fixed savings rates abstract from optimal consumption-savings decisions that would arise in a fully 
specified dynamic general equilibrium model. In practice, savings rates might respond to AI 
deployment through multiple channels: Precautionary savings might increase if AI creates labor 
market uncertainty, while wealth effects from AI-driven growth might reduce savings rates.

49 
Hardware as a Unidimensional Constraint 
Representing hardware capacity through a single state variable (ℎ!) aggregates diverse physical 
constraints, including semiconductor fabrication capacity, data center infrastructure, and energy 
availability. Different types of AI systems may face different binding constraints—training large 
models might be chip-limited, while deployment might be energy-limited. 
The specification assumes that hardware capacity can be built through investment, with dynamics 
governed by Δℎ̇ = 𝜓+ 𝜇Δ𝑦+ 𝜆.Δℎ, which abstracts from the complex supply chains, technological 
requirements, and geopolitical factors that determine semiconductor production capacity. The 
parameter 𝜇 captures how economic advantages translate into hardware capacity, but this relationship 
might be mediated by factors outside the model. 
Competitive Markets and Efficient Resource Allocation 
The assumption of competitive factor markets with marginal product pricing excludes market 
power considerations that may prove central to AI economics. If AI development exhibits strong 
economies of scale and network effects, markets might naturally concentrate, leading to markup 
pricing, rent extraction, and resource allocation inefficiencies. 
The model assumes that factors are efficiently allocated within each bloc, abstracting from internal 
frictions that might prevent optimal deployment. In practice, regulatory barriers, organizational 
inertia, and information asymmetries might create substantial gaps between potential and actual AI 
deployment. 
International Trade and Technology Transfer 
The model includes parameters representing technology diffusion (𝜆+) and deployment imitation 
(𝜆,) but does not explicitly model the channels through which such transfers occur. International 
trade in AI services, foreign direct investment, and human capital mobility might create specific 
patterns of convergence not captured by the reduced-form parameters. 
The model treats the two blocs as separate economies without explicit trade linkages beyond 
capital flows. In practice, trade in goods and services creates additional interdependencies that might 
amplify or dampen technology gaps. If the leading bloc exports AI-intensive products to the follower, 
both might benefit, potentially reducing incentives for the follower to develop domestic capabilities. 
Welfare and Distribution 
The model focuses on aggregate income differences without examining distribution within blocs. 
AI deployment might increase inequality by concentrating returns among capital and AI system 
owners. Even if aggregate income rises, welfare effects depend on how gains are distributed and 
whether policies exist to support displaced workers.

50 
The framework does not explicitly model the transition costs of AI adoption, including worker 
retraining, structural unemployment, and social adjustment. These costs might create political 
economy constraints on deployment that the model does not capture. 
By focusing on production and income, the model abstracts from broader welfare considerations, 
including leisure, job satisfaction, and social cohesion. A society in which AI performs most work 
might achieve high measured output but face challenges in providing meaning and purpose for human 
lives. 
These assumptions collectively enable a tractable analysis of AI-driven economic competition 
while abstracting from various complications. The model’s predictions should be interpreted as 
capturing first-order effects under idealized conditions rather than precise quantitative forecasts. Its 
value lies in identifying key mechanisms and relationships that shape competitive dynamics, providing 
a foundation for more-detailed future analyses that relax specific assumptions as needed for particular 
applications. 
AGI Alignment and Control 
The model assumes that AGI systems can be developed and deployed without alignment failures, 
misuse, or loss of control. This assumption implies that deployed AGI systems reliably pursue the 
operators’ intended objectives and remain under human oversight. Systems as powerful as those that 
are capable of substituting perfectly for human labor may also be able to pursue goals misaligned with 
human welfare or create unintended novel forms of coordination failures that create systemic risks (see 
Bostrom, 2014, for discussion). The competitive dynamics modeled in this report presume a stable 
economic environment. The analysis should therefore be interpreted as conditional on successful 
navigation of alignment challenges.

51 
Abbreviations 
AGI 
artificial general intelligence 
AI 
artificial intelligence 
CES 
constant elasticity of substitution 
DEA 
decisive economic advantage  
DSA 
decisive strategic advantage 
FMA 
first-mover advantage 
GDP 
gross domestic product 
R&D 
research and development 
SIE 
software intelligence explosion

52 
References 
Acemoglu, Daron, Introduction to Modern Economic Growth, Princeton University Press, 2008. 
Acemoglu, Daron, and Pascual Restrepo, “Automation and New Tasks: The Implications of the Task Content 
of Production for Labor Demand,” Journal of Economic Perspectives, Vol. 33, No. 2, Spring 2019. 
Aghion, Philippe, and Peter Howitt, “A Model of Growth Through Creative Destruction,” NBER Working 
Paper 3223, 1990. 
Aghion, Philippe, Benjamin F. Jones, and Charles I. Jones, Artificial Intelligence and Economic Growth, National 
Bureau of Economic Research, October 2017. 
Autor, David H., “The ‘Task Approach’ to Labor Markets: An Overview,” Journal for Labor Market Research, 
Vol. 46, No. 3, January 2013. 
Autor, David H., “Work of the Past, Work of the Future,” AEA Papers and Proceedings, 2019. 
Aschenbrenner, Leopold, “Situational Awareness: The Decade Ahead,” June 2024. As of February 9, 2026: 
https://situational-awareness.ai/ 
Baqaee, David Rezza, and Emmanuel Farhi, “The Macroeconomic Impact of Microeconomic Shocks: Beyond 
Hulten’s Theorem,” Econometrica, Vol. 87, No. 4, 2019. 
Barro, Robert J., and Xavier Sala-i-Martin, “Convergence,” Journal of Political Economy, Vol. 100, No. 2, April 
1992. 
Bernanke, Ben S., Mark Gertler, and Simon Gilchrist, “The Financial Accelerator in a Quantitative Business 
Cycle Framework,” Handbook of Macroeconomics, Vol. 1, 1999. 
Bostrom, Nick, Superintelligence: Paths, Dangers, Strategies, Oxford University Press, 2014. 
Bosworth, Derek, and Gregory Jobome, “The Rate of Depreciation of Technological Knowledge: Evidence 
from Patent Renewal Data,” Economic Issues, Vol. 8, No. 1, March 2003. 
Bresnahan, Timothy F., and Manuel Trajtenberg, “General Purpose Technologies ‘Engines of Growth’?” 
Journal of Econometrics, Vol. 65, No. 1, January 1995.  
Comin, Diego, and Bart Hobijn, “An Exploration of Technology Diffusion,” American Economic Review, 
Vol. 100, No. 5, 2010. 
Davidson, Tom, “Report on Whether AI Could Drive Explosive Economic Growth,” Coefficient Giving, June 
17, 2021. 
Davidson, Tom, “Could One Country Outgrow the Rest of the World?” Forethought Foundation, August 20, 
2025.  
Dohrwardt, Bray, “How Long Does It Take to Develop a Data Center? A Step-by-Step Timeline,” Avisen 
Legal, January 27, 2025.

53 
Eaton, Jonathan, and Samuel Kortum, “Trade in Ideas: Patenting and Productivity in the OECD,” Journal of 
International Economics, Vol. 40, Nos. 3–4, May 1996. 
Eth, Daniel, and Tom Davidson, “Will AI R&D Automation Cause a Software Intelligence Explosion?” 
Forethought, March 26, 2025 
Federal Reserve Bank of St. Louis, “Which War Saw the Highest Defense Spending? Depends How It’s 
Measured,” On the Economy blog, February 4, 2020. 
Fraumeni, Barbara M., "The Measurement of Depreciation in U.S. National Income and Product Accounts," 
Survey of Current Business, July 1997. 
Hayashi, Fumio, “Tobin’s Marginal q and Average q: A Neoclassical Interpretation,” Econometrica, Vol. 50, 
No. 1, January 1982. 
Hernandez, Danny, and Tom B. Brown, “Measuring the Algorithmic Efficiency of Neural Networks,” 
OpenAI, 2020. 
Karabarbounis, Loukas, and Brent Neiman, “The Global Decline of the Labor Share,” Quarterly Journal of 
Economics, Vol. 129, No. 1, February 2014. 
Karnofsky, Holden, “AI Could Defeat All of Us Combined,” Cold Takes blog, June 9, 2022. 
Kerin, Roger A., P. Rajan Varadarajan, and Robert A. Peterson, “First-Mover Advantage: A Synthesis, 
Conceptual Framework, and Research Propositions,” Journal of Marketing, Vol. 56, No. 4, October 1992. 
Kokotajlo, Daniel, “Soft Takeoff Can Still Lead to Decisive Strategic Advantage,” webpage, LessWrong, 
August 23, 2019. As of December 22, 2025: 
https://www.lesswrong.com/posts/PKy8NuNPknenkDY74/soft-takeoff-can-still-lead-to-decisive-
strategic-advantage 
Korinek, Anton, and Donghyun Suh, Scenarios for the Transition to AGI, National Bureau of Economic 
Research, March 2024. 
Lieberman, Marvin B., and David B. Montgomery, “First‐Mover Advantages,” Strategic Management Journal, 
Vol. 9, Summer 1988. 
Micron Technology, Inc., “Micron Breaks Ground on Leading-Edge Manufacturing Fab in Boise, Idaho,” press 
release, Micron Technology, Inc., September 12, 2022. 
Omdia, “Global Cloud Infrastructure Spending Hits $102.6 Billion, up 25% in Q3 2025,” webpage, December 
22, 2025. As of February 9, 2026: 
https://omdia.tech.informa.com/pr/2025/dec/global-cloud-infrastructure-spending-hits-102point6-
billion-dollars-up-25percent-in-q3-2025 
OpenAI, “OpenAI Charter,” webpage, undated As of January 15, 2026: 
https://openai.com/charter/ 
Pew Research Center, “Mobile Fact Sheet,” November 13, 2024. As of May 2025: 
https://www.pewresearch.org/internet/fact-sheet/mobile 
Restrepo, Pascual, We Won’t Be Missed: Work and Growth in the Era of AGI, National Bureau of Economic 
Research, October 22, 2025. 
Rognlie, Matthew, Deciphering the Fall and Rise in the Net Capital Share, Brookings, 2015.

54 
Romer, Paul M., “Increasing Returns and Long-Run Growth,” Journal of Political Economy, Vol. 94, No. 5, 
October 1986. 
Shilov, Anton, “Building a Chipmaking Fab in the US Costs Twice as Much, Takes Twice as Long as in 
Taiwan,” Tom’s Hardware, February 19, 2025. 
Trammell, Philip, and Anton Korinek, Economic Growth Under Transformative AI, National Bureau of 
Economic Research, 2023. 
World Bank, “GDP (current US$) (NY.GDP.MKTP.CD),” data set (World Development Indicators), 
updated July 1, 2025. As of August 1, 2025:  
https://data.worldbank.org/indicator/NY.GDP.MKTP.CD

55 
About the Author 
Tobias Sytsma is an economist at RAND. He conducts research on topics around technological 
change, international trade, and economic security. Sytsma holds a Ph.D. in economics.