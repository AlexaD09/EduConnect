from pymongo import MongoClient
from app.infrastructure.settings import settings


def get_mongo_client() -> MongoClient:
    return MongoClient(settings.MONGO_URI)


def get_collection():
    client = get_mongo_client()
    db = client[settings.MONGO_DB]
    return db[settings.MONGO_COLLECTION]
