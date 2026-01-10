import os

from langchain_google_genai import ChatGoogleGenerativeAI

from models.ai import AiContext, Behaviour, State

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


if __name__ == "__main__":
    print("Running AI Party Analysis...")
    party1 = AiContext(
        party1="Party A",
        party2="Party B",
        state_data=State(
            civilian_well_being=6.5,
            economic_stability=5.0,
            healthcare_access=7.0,
            food_security=8.0,
            refugee_risk=4.0,
        ),
        behaviour=Behaviour(
            party_affiliation="Party A",
            position_held="Minister of Finance",
            bills_laws_supported=15,
            major_projects_initiated=3,
            controversies_and_legal_cases=1,
            common_tone=5,
            engagement_with_citizens=7,
            social_media_behaviour=6,
            action_taken=8,
        ),
        goals_party1=["Improve healthcare", "Boost economy"],
        goals_party2=["Enhance education", "Reduce crime"],
        query="What is the impact of current policies on economic stability?",
        ruling_party="party1",
        contradict=False,
        policy="Economic Reform Act",
        opinion_of="party1",
    )

    party2 = AiContext(
        party1="Party A",
        party2="Party B",
        state_data=State(
            civilian_well_being=6.5,
            economic_stability=5.0,
            healthcare_access=7.0,
            food_security=8.0,
            refugee_risk=4.0,
        ),
        behaviour=Behaviour(
            party_affiliation="Party B",
            position_held="Opposition Leader",
            bills_laws_supported=10,
            major_projects_initiated=1,
            controversies_and_legal_cases=2,
            common_tone=6,
            engagement_with_citizens=8,
            social_media_behaviour=7,
            action_taken=5,
        ),
        goals_party1=["Improve healthcare", "Boost economy"],
        goals_party2=["Enhance education", "Reduce crime"],
        query="What is the impact of current policies on economic stability?",
        ruling_party="party1",
        contradict=True,
        policy="Economic Reform Act",
        opinion_of="party2",
    )

    response = ai_party(party1)
    response2 = ai_party(party2)
    print(response)
    print(response2)
