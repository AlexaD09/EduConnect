from fastapi import APIRouter, Query
from typing import Optional
from app.adapters.persistence.mongo_audit_repository import MongoAuditRepository

router = APIRouter()
repo = MongoAuditRepository()


@router.get("/audit")
def list_audit(
    event_type: Optional[str] = None,
    entity_type: Optional[str] = None,
    entity_id: Optional[str] = None,
    limit: int = Query(default=50, ge=1, le=500),
):
    items = repo.find(event_type=event_type, entity_type=entity_type, entity_id=entity_id, limit=limit)
    return [i.model_dump() for i in items]
