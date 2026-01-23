from __future__ import annotations
from abc import ABC, abstractmethod
from typing import Optional, List, Dict, Any

class TutorRepository(ABC):
    @abstractmethod
    def get_by_id(self, tutor_id: int) -> Optional[dict]:
        ...

    @abstractmethod
    def list_by_city(self, city: str) -> List[dict]:
        ...
