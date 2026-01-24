from abc import ABC, abstractmethod
from typing import Optional, Any

class ApprovalLogRepository(ABC):
    @abstractmethod
    def create(self, activity_id: int, coordinator_id: int, action: str, observations: str) -> Any: 
        raise NotImplementedError

    @abstractmethod
    def get_by_id(self, log_id: int) -> Optional[Any]:
        raise NotImplementedError
