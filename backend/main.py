import logging
from typing import Literal

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pymongo import MongoClient
from pymongo.collection import Collection, Mapping

from controllers.ai import ai_party, impact_analysis, lens
from controllers.login import login, register
from controllers.news import get_news_by_category, get_news_by_keyword, insert_news
from manager import JWTmanager, JWTSettings
from models.ai import (
    AiContext,
    AnalysisRequest,
    AnalysisResponse,
    LensRequest,
    StateAll,
)
from models.auth import Ngo, Political, Signin, User
from models.news import News


class Mymongo(FastAPI):
    mongodb_client: MongoClient
    collection_users: Collection[Mapping]
    collection_news: Collection[Mapping]


logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

jwt_manager = JWTmanager(JWTSettings())

policies = {
    "delhi": [
        {
            "title": "Delhi Government Launches New Education Initiative",
            "description": "The Delhi government has announced a new education initiative aimed at improving literacy rates among underprivileged children.",
            "image_url": "https://example.com/images/delhi_education.jpg",
            "present_index": {
                "civilian_well_being": 75,
                "economic_stability": 65,
                "healthcare_access": 80,
                "food_security": 70,
                "refugee_risk": 30,
                "economic_sanctions": 20,
                "trade_restrictions": 25,
                "energy_export_controls": 15,
                "aid_withdrawal_or_injection": 10,
            },
            "past_index": {
                "civilian_well_being": 70,
                "economic_stability": 60,
                "healthcare_access": 75,
                "food_security": 65,
                "refugee_risk": 35,
                "economic_sanctions": 30,
                "trade_restrictions": 28,
                "energy_export_controls": 18,
                "aid_withdrawal_or_injection": 12,
            },
        },
        {
            "title": "Delhi's Infrastructure Development Accelerates",
            "description": "Significant progress has been made in Delhi's infrastructure development, with new roads and public transport systems being introduced.",
            "image_url": "https://example.com/images/delhi_infrastructure.jpg",
            "present_index": {
                "civilian_well_being": 78,
                "economic_stability": 68,
                "healthcare_access": 82,
                "food_security": 72,
                "refugee_risk": 28,
                "economic_sanctions": 18,
                "trade_restrictions": 22,
                "energy_export_controls": 12,
                "aid_withdrawal_or_injection": 8,
            },
            "past_index": {
                "civilian_well_being": 72,
                "economic_stability": 62,
                "healthcare_access": 77,
                "food_security": 67,
                "refugee_risk": 33,
                "economic_sanctions": 25,
                "trade_restrictions": 26,
                "energy_export_controls": 16,
                "aid_withdrawal_or_injection": 11,
            },
        },
    ],
    "maharashtra": [
        {
            "title": "Maharashtra Sees Growth in Healthcare Sector",
            "description": "The healthcare sector in Maharashtra has witnessed significant growth, with new hospitals and clinics being established across the state.",
            "image_url": "https://example.com/images/maharashtra_healthcare.jpg",
            "present_index": {
                "civilian_well_being": 80,
                "economic_stability": 70,
                "healthcare_access": 85,
                "food_security": 75,
                "refugee_risk": 25,
                "economic_sanctions": 15,
                "trade_restrictions": 20,
                "energy_export_controls": 10,
                "aid_withdrawal_or_injection": 5,
            },
            "past_index": {
                "civilian_well_being": 75,
                "economic_stability": 65,
                "healthcare_access": 80,
                "food_security": 70,
                "refugee_risk": 30,
                "economic_sanctions": 20,
                "trade_restrictions": 22,
                "energy_export_controls": 12,
                "aid_withdrawal_or_injection": 8,
            },
        },
        {
            "title": "Maharashtra Implements New Economic Policies",
            "description": "The Maharashtra government has introduced new economic policies aimed at boosting local businesses and attracting foreign investment.",
            "image_url": "https://example.com/images/maharashtra_economy.jpg",
            "present_index": {
                "civilian_well_being": 82,
                "economic_stability": 75,
                "healthcare_access": 83,
                "food_security": 78,
                "refugee_risk": 22,
                "economic_sanctions": 12,
                "trade_restrictions": 18,
                "energy_export_controls": 11,
                "aid_withdrawal_or_injection": 6,
            },
            "past_index": {
                "civilian_well_being": 77,
                "economic_stability": 70,
                "healthcare_access": 78,
                "food_security": 73,
                "refugee_risk": 27,
                "economic_sanctions": 18,
                "trade_restrictions": 20,
                "energy_export_controls": 14,
                "aid_withdrawal_or_injection": 9,
            },
        },
    ],
    "karnataka": [
        {
            "title": "Karnataka Government Focuses on Tech Industry Expansion",
            "description": "The Karnataka government is implementing policies to support the expansion of the tech industry, aiming to attract more startups and investments.",
            "image_url": "https://example.com/images/karnataka_tech.jpg",
            "present_index": {
                "civilian_well_being": 78,
                "economic_stability": 72,
                "healthcare_access": 82,
                "food_security": 74,
                "refugee_risk": 28,
                "economic_sanctions": 18,
                "trade_restrictions": 22,
                "energy_export_controls": 14,
                "aid_withdrawal_or_injection": 9,
            },
            "past_index": {
                "civilian_well_being": 73,
                "economic_stability": 68,
                "healthcare_access": 78,
                "food_security": 70,
                "refugee_risk": 33,
                "economic_sanctions": 25,
                "trade_restrictions": 24,
                "energy_export_controls": 16,
                "aid_withdrawal_or_injection": 11,
            },
        },
        {
            "title": "Karnataka Launches Agricultural Development Programs",
            "description": "New agricultural development programs have been launched in Karnataka to support farmers and improve crop yields across the state.",
            "image_url": "https://example.com/images/karnataka_agriculture.jpg",
            "present_index": {
                "civilian_well_being": 80,
                "economic_stability": 70,
                "healthcare_access": 80,
                "food_security": 76,
                "refugee_risk": 26,
                "economic_sanctions": 16,
                "trade_restrictions": 20,
                "energy_export_controls": 12,
                "aid_withdrawal_or_injection": 7,
            },
            "past_index": {
                "civilian_well_being": 75,
                "economic_stability": 66,
                "healthcare_access": 76,
                "food_security": 72,
                "refugee_risk": 31,
                "economic_sanctions": 22,
                "trade_restrictions": 23,
                "energy_export_controls": 15,
                "aid_withdrawal_or_injection": 10,
            },
        },
    ],
}


def debug_log(out, inp=None):
    if inp:
        logger.info(f"In: {inp}, Out: {out}")
    else:
        logger.info(f"Out: {out}")


app = Mymongo()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

DB_URL = "mongodb+srv://test:test@cluster0.yvlq9mj.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"


@app.on_event("startup")
async def startup_db_client():
    app.mongodb_client = MongoClient(DB_URL)
    app.collection_users = app.mongodb_client["evidex"]["users"]
    app.collection_news = app.mongodb_client["evidex"]["news"]


BASE_API = "/api/v1"


@app.post(f"{BASE_API}/signin")
async def signin(details: Signin):
    payload = login(
        username=details.username,
        password=details.password,
        collection=app.collection_users,
        role=details.role,
    )
    if not payload:
        return {"success": False, "error": "Invalid Credentials"}
    resp = jwt_manager.encode(payload)
    debug_log(inp=details, out=resp)
    return resp


@app.post(f"{BASE_API}/signup")
async def signup(details: Ngo | User | Political):
    payload = register(
        user_data=details.dict(),
        collection=app.collection_users,
        role=details.role,
    )

    if not payload:
        return {"success": False, "error": "User already exists"}
    resp = jwt_manager.encode(payload)
    debug_log(inp=details, out=resp)
    return resp


@app.post(f"{BASE_API}/ai/{{partyno}}")
async def post_ai_state(partyno: Literal["party1", "party2"], data: AiContext):
    resp = ai_party(data)
    data.opinion_of = partyno
    debug_log(inp=data, out=resp)
    return resp


@app.get(f"{BASE_API}/news/{{category}}")
async def news(
    category: Literal["trending", "education", "healthcare", "finance", "all"],
):
    try:
        resp = get_news_by_category(collection=app.collection_news, category=category)
    except Exception as e:
        logger.error(f"Error fetching news for category {category}: {e}")
        resp = {"success": False, "error": "Failed to fetch news"}
    debug_log(out=resp)
    return resp


@app.get(f"{BASE_API}/news/k/{{keyword}}")
async def news_by_keyword(
    keyword: str,
):
    resp = get_news_by_keyword(collection=app.collection_news, keyword=keyword)
    debug_log(out=resp)
    return resp


@app.post(f"{BASE_API}/news")
async def add_news(data: News):
    resp = insert_news(data=data, collection=app.collection_news)
    debug_log(inp=data, out=resp)
    return resp


@app.get(f"{BASE_API}/policy/{{state}}")
async def get_policy(state: str):
    resp = policies.get(
        state, "No specific policy information available for this state."
    )
    debug_log(inp=state, out=resp)
    return resp


@app.post(f"{BASE_API}/analysis/{{state}}")
async def analyze_state(state: str, details: AnalysisRequest):
    policy_data = policies.get(state)
    if not policy_data:
        resp = {
            "success": False,
            "error": "No policy data available for this state.",
        }
        debug_log(inp=state, out=resp)
        return resp

    data = next((item for item in policy_data if item["title"] == details.policy), {})
    deltaidx = StateAll(
        civilian_well_being=(
            (
                details.index.civilian_well_being
                - data["present_index"]["civilian_well_being"]
            )
            * -100
        )
        / data["past_index"]["civilian_well_being"],
        economic_stability=(
            (
                details.index.economic_stability
                - data["present_index"]["economic_stability"]
            )
            * -100
        )
        / data["past_index"]["economic_stability"],
        healthcare_access=(
            (
                details.index.healthcare_access
                - data["present_index"]["healthcare_access"]
            )
            * -100
        )
        / data["past_index"]["healthcare_access"],
        food_security=(
            (details.index.food_security - data["present_index"]["food_security"])
            * -100
        )
        / data["past_index"]["food_security"],
        refugee_risk=(
            (details.index.refugee_risk - data["present_index"]["refugee_risk"]) * -100
        )
        / data["past_index"]["refugee_risk"],
        economic_sanctions=(
            (
                details.index.economic_sanctions
                - data["present_index"]["economic_sanctions"]
            )
            * -100
        )
        / data["past_index"]["economic_sanctions"],
        trade_restrictions=(
            (
                details.index.trade_restrictions
                - data["present_index"]["trade_restrictions"]
            )
            * -100
        )
        / data["past_index"]["trade_restrictions"],
        energy_export_controls=(
            (
                details.index.energy_export_controls
                - data["present_index"]["energy_export_controls"]
            )
            * -100
        )
        / data["past_index"]["energy_export_controls"],
        aid_withdrawal_or_injection=(
            (
                details.index.aid_withdrawal_or_injection
                - data["present_index"]["aid_withdrawal_or_injection"]
            )
            * -100
        )
        / data["past_index"]["aid_withdrawal_or_injection"],
    )
    try:
        suggestion = impact_analysis(deltaidx)
        print(
            f"detail: {details.index.civilian_well_being} -{data['present_index']['civilian_well_being']}"
        )
        good_changes = False
        if "negative" in suggestion.lower():
            good_changes = False
        return AnalysisResponse(
            good_changes=good_changes, delta_index=deltaidx, suggestion=suggestion
        )
    except Exception as e:
        logger.error(f"Error analyzing state {state}: {e}")
        resp = {"success": False, "error": "Failed to analyze state"}
        debug_log(inp=state, out=resp)
        return resp


@app.post(f"{BASE_API}/lens")
async def lens_analysis(data: LensRequest):

    resp = lens(
        persona=data.persona,
        policy=data.policy,
        state=data.state,
        history=data.history,
        query=data.query,
    )
    debug_log(inp=data, out=resp)
    return {"response": resp}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
