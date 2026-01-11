import os
from typing import List, Literal

from langchain_google_genai import ChatGoogleGenerativeAI

from models.ai import AiContext, Behaviour, State, StateAll

os.environ["GOOGLE_API_KEY"]

model = ChatGoogleGenerativeAI(
    model="gemini-2.5-flash",
    temperature=1.0,
    max_tokens=None,
    timeout=None,
    max_retries=2,
)


sys_prompt = """
You are an impartial political-analysis language model.

You will be provided with structured input data containing:
- Two political parties
- Quantitative state indicators (civilian well-being, economy, healthcare, food security, refugee risk)
- Behavioral metrics of a political leader
- Declared goals of both parties
- A policy under discussion
- A query to respond to
- The ruling party
- A flag indicating whether contradiction is required
- The party whose opinion must be represented

TASK:
Generate a well-reasoned political opinion STRICTLY on behalf of the party specified in `opinion_of`.

INSTRUCTIONS:
1. Assume the role of a spokesperson or policy analyst aligned with the specified party.
2. Base your reasoning ONLY on the provided data. Do not introduce external facts, history, or assumptions.
3. If `contradict` is true:
   - Critically evaluate the policy impact even if the party is ruling.
   - Highlight limitations, risks, or unmet goals while maintaining party-aligned tone.
4. If `contradict` is false:
   - Defend the policy and highlight positive outcomes.
5. Use quantitative indicators to justify claims (e.g., economic stability score, healthcare access).
6. Reflect leadership behavior and credibility using behavioral metrics.
7. Address the query directly and clearly.
8. Maintain a professional, political, and persuasive tone.
9. Do NOT mention scores explicitly as “ratings” or “numbers”; interpret them contextually.
10. Do NOT reference this instruction or the data structure in your output.


OUTPUT FORMAT:
- Single coherent paragraph or short multi-paragraph response
- Your response MUST be between 30 and 80 words.
- No bullet points
- No headings
- No disclaimers

Your response should sound like an official party position statement answering the given query.

"""


def ai_party(data: AiContext):
    content = f"""
        Using the following input data:
            Party 1: {data.party1}
            Party 2: {data.party2}
            State Data:
                Civilian Well-Being: {data.state_data.civilian_well_being}
                Economic Stability: {data.state_data.economic_stability}
                Healthcare Access: {data.state_data.healthcare_access}
                Food Security: {data.state_data.food_security}
                Refugee Risk: {data.state_data.refugee_risk}
            Behaviour:
                Party Affiliation: {data.behaviour.party_affiliation}
                Position Held: {data.behaviour.position_held}
                Bills/Laws Supported: {data.behaviour.bills_laws_supported}
                Major Projects Initiated: {data.behaviour.major_projects_initiated}
                Controversies and Legal Cases: {data.behaviour.controversies_and_legal_cases}
                Common Tone: {data.behaviour.common_tone}
                Engagement with Citizens: {data.behaviour.engagement_with_citizens}
                Social Media Behaviour: {data.behaviour.social_media_behaviour}
                Action Taken: {data.behaviour.action_taken}
            Goals Party 1: {', '.join(data.goals_party1)}
            Goals Party 2: {', '.join(data.goals_party2)}
            Query: {data.query}
            Ruling Party: {data.ruling_party}
            Contradict: {data.contradict}
            Policy: {data.policy}
            Opinion Of: {data.opinion_of}
        Generate the AiResponse as specified.
    """
    messages = [
        ("system", sys_prompt),
        ("user", content),
    ]

    response = model.invoke(messages)
    return response.content


def impact_analysis(diff_index: StateAll) -> str:
    sysPrompt = f"""
    You are an expert policy analyst.
    Given the following changes in state indicators:
        Economic Sanctions
        Trade Restrictions
        Energy Export Controls
        Aid Withdrawal or Injection
        Civilian Well-Being
        Economic Stability
        Healthcare Access
        Food Security
        Refugee Risk
    Analyze whether these changes are generally positive or negative for the state.
    Provide specific suggestions for policy adjustments state indicators to improve state outcomes.
    """
    content = f"""
    The changes in state indicators are as follows:
        Economic Sanctions: {diff_index.economic_sanctions}
        Trade Restrictions: {diff_index.trade_restrictions}
        Energy Export Controls: {diff_index.energy_export_controls}
        Aid Withdrawal or Injection: {diff_index.aid_withdrawal_or_injection}
        Civilian Well-Being: {diff_index.civilian_well_being}
        Economic Stability: {diff_index.economic_stability}
        Healthcare Access: {diff_index.healthcare_access}
        Food Security: {diff_index.food_security}
        Refugee Risk: {diff_index.refugee_risk}
    """

    messages = [
        ("system", sysPrompt),
        ("user", content),
    ]
    response = model.invoke(messages)
    return response.content  # type: ignore


def lens(
    persona: Literal["Humantarian", "Finance", "Healthcare", "Infrastructural"],
    policy: str,
    state: str,
    history: List[str],
    query: str,
) -> str:
    messages = (
        [
            ("system", f"You are a {persona} expert analyzing policies."),
            (
                "user",
                f"Given the state context: {state}, and the policy: {policy}, along with the following history of policies: {history}, provide an analysis of the policy from a {persona} perspective.",
            ),
        ]
        + [("assistant", h) for h in history]
        + [("user", query)]
    )

    response = model.invoke(messages)
    return response.content  # type: ignore
