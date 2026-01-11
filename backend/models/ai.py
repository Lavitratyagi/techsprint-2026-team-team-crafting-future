from typing import List, Literal, Optional

from pydantic import BaseModel


class State(BaseModel):
    civilian_well_being: float
    economic_stability: float
    healthcare_access: float
    food_security: float
    refugee_risk: float


class StateAll(State):
    economic_sanctions: float
    trade_restrictions: float
    energy_export_controls: float
    aid_withdrawal_or_injection: float


class Behaviour(BaseModel):
    party_affiliation: str
    position_held: str
    bills_laws_supported: int
    major_projects_initiated: int
    controversies_and_legal_cases: int
    common_tone: int
    engagement_with_citizens: int
    social_media_behaviour: int
    action_taken: int


class AiContext(BaseModel):
    party1: str
    party2: str
    state_data: State
    behaviour: Behaviour
    goals_party1: List[str]
    goals_party2: List[str]
    query: str
    ruling_party: Literal["party1", "party2"]
    contradict: bool
    policy: str
    opinion_of: Optional[Literal["party1", "party2"]]


class AiResponse(BaseModel):
    response: str


class AnalysisRequest(BaseModel):
    policy: str
    index: StateAll


class AnalysisResponse(BaseModel):
    good_changes: bool
    delta_index: StateAll
    suggestion: str


class LensRequest(BaseModel):
    persona: Literal["Humantarian", "Finance", "Healthcare", "Infrastructural"]
    policy: str
    state: str
    history: list[str]
    query: str
