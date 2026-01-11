from pydantic import BaseModel


class Report(BaseModel):
    acceptance_rate: float
    suggestions: str
    market_impact: str
