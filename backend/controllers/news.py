from typing import Literal

from pymongo.collection import Collection

from models.news import News


def insert_news(data: News, collection: Collection) -> bool:
    result = collection.insert_one(data.dict())
    return result.acknowledged


def get_news_by_category(
    collection: Collection,
    category: Literal["trending", "education", "healthcare", "finance", "all"],
) -> list[News]:
    if category != "all":
        news_documents = collection.find({"category": category}).sort("_id", -1)
    else:
        news_documents = collection.find().sort("_id", -1)
    return [News(**doc) for doc in list(news_documents)]


def get_news_by_keyword(
    collection: Collection,
    keyword: str,
) -> list[News]:
    news_documents = collection.find(
        {
            "$or": [
                {"title": {"$regex": keyword, "$options": "i"}},
                {"description": {"$regex": keyword, "$options": "i"}},
                {"author": {"$regex": keyword, "$options": "i"}},
            ]
        }
    ).sort("_id", -1)
    return [News(**doc) for doc in list(news_documents)]
