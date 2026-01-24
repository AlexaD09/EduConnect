from __future__ import annotations
from abc import ABC, abstractmethod
from typing import List, Dict, Any, Optional

class UserServicePort(ABC):
    @abstractmethod
    def get_student_city(self, student_id: int) -> str:
        ...

    @abstractmethod
    def get_agreements_by_city(self, city: str) -> List[Dict[str, Any]]:
        ...

    @abstractmethod
    def get_user(self, user_id: int) -> Optional[Dict[str, Any]]:
        ...

    @abstractmethod
    def get_student(self, student_id: int) -> Optional[Dict[str, Any]]:
        ...
