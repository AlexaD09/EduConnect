import os
import requests

class UserServiceClient:
    def __init__(self):
        self.base_url = os.getenv("USER_SERVICE_URL", "http://user-service:8000")

    def get_coordinator_id_by_username(self, username: str) -> int:
        url = f"{self.base_url}/coordinators/by-username/{username}"
        r = requests.get(url, timeout=5)
        r.raise_for_status()
        data = r.json()
        return int(data["id"])
