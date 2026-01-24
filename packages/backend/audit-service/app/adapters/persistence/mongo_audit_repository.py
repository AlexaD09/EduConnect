from typing import List, Optional
from app.domain.ports.audit_repository import AuditRepository
from app.domain.models.audit_record import AuditRecord
from app.infrastructure.mongo import get_collection


class MongoAuditRepository(AuditRepository):
    def __init__(self):
        self._col = get_collection()

    def insert(self, record: AuditRecord) -> str:
        doc = record.model_dump()
        result = self._col.insert_one(doc)
        return str(result.inserted_id)

    def find(self, event_type: Optional[str], entity_type: Optional[str], entity_id: Optional[str], limit: int) -> List[AuditRecord]:
        q = {}
        if event_type:
            q["event_type"] = event_type
        if entity_type:
            q["entity_type"] = entity_type
        if entity_id:
            q["entity_id"] = entity_id

        cur = self._col.find(q).sort("occurred_at", -1).limit(limit)
        items = []
        for d in cur:
            d.pop("_id", None)
            items.append(AuditRecord(**d))
        return items
