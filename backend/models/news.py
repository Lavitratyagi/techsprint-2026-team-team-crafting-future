from typing import Literal

from pydantic import BaseModel


class News(BaseModel):
    title: str
    description: str
    author: str
    image_url: str
    category: Literal["trending", "education", "healthcare", "finance", "all"]
