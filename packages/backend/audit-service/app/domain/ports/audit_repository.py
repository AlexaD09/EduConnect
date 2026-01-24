from abc import ABC, abstractmethod
from typing import List, Optional
from app.domain.models.audit_record import AuditRecord


class AuditRepository(ABC):
    @abstractmethod
    def insert(self, record: AuditRecord) -> str:
        raise NotImplementedError

    @abstractmethod
    def find(self, event_type: Optional[str], entity_type: Optional[str], entity_id: Optional[str], limit: int) -> List[AuditRecord]:
        raise NotImplementedError
