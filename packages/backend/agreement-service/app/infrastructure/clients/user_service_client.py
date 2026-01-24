from __future__ import annotations
import os
from typing import List, Dict, Any, Optional
import requests
from app.domain.ports.user_service_port import UserServicePort

class UserServiceClient(UserServicePort):
    def __init__(self, base_url: Optional[str] = None, timeout: int = 5):
        self.base_url = base_url or os.getenv("USER_SERVICE_URL", "http://user-service:8000")
        self.timeout = timeout

    def _get(self, path: str) -> requests.Response:
        url = f"{self.base_url}{path}"
        return requests.get(url, timeout=self.timeout)

    def get_student_city(self, student_id: int) -> str:
        res = self._get(f"/students/{student_id}")
        res.raise_for_status()
        return res.json()["city"]

    def get_agreements_by_city(self, city: str) -> List[Dict[str, Any]]:
        res = self._get(f"/agreements?city={city}")
        res.raise_for_status()
        return res.json()

    def get_user(self, user_id: int) -> Optional[Dict[str, Any]]:
        res = self._get(f"/users/{user_id}")
        if not res.ok:
            return None
        return res.json()

    def get_student(self, student_id: int) -> Optional[Dict[str, Any]]:
        res = self._get(f"/students/{student_id}")
        if not res.ok:
            return None
        return res.json()
