from typing import Literal, Optional

from pydantic import BaseModel, Field


class Signin(BaseModel):
    username: str
    password: str
    role: Literal["user", "ngo", "political"]


class TokenPayload(BaseModel):
    username: str
    role: Literal["user", "ngo", "political"]


class User(Signin):
    nationality: str


class Ngo(User):
    ngo_name: str
    ngo_id: str
    address: str
    emp_id: str


class Political(User):
    state: str
    party_name: Literal["bjp", "cong"]
    position: str
    emp_id: str


class Response(BaseModel):
    token: Optional[str] = Field(default=None)
    error: Optional[str] = Field(default=None)
    success: bool
