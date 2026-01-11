from typing import Literal

from pymongo.collection import Collection

from models.auth import Ngo, Political, TokenPayload


def login(
    username: str,
    password: str,
    collection: Collection,
    role: Literal["user", "ngo", "political"],
):
    if usr := collection.find_one({"username": username, "password": password}):
        if role == "ngo":
            ngo = Ngo(**usr)
            return TokenPayload(username=ngo.username, role=role)
        elif role == "political":
            political = Political(**usr)
            return TokenPayload(username=political.username, role=role)
        else:
            return TokenPayload(username=usr["username"], role=role)
    return False


def register(
    user_data: dict,
    collection: Collection,
    role: Literal["user", "ngo", "political"],
):
    if collection.find_one({"username": user_data["username"]}):
        return False
    collection.insert_one(user_data)
    if role == "ngo":
        ngo = Ngo(**user_data)
        return TokenPayload(username=ngo.username, role=role)
    elif role == "political":
        political = Political(**user_data)
        return TokenPayload(username=political.username, role=role)
    else:
        return TokenPayload(username=user_data["username"], role=role)
