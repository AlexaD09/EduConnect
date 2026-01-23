import os
import requests
from app.domain.ports.activity_gateway import ActivityGateway

class ActivityServiceClient(ActivityGateway):
    def __init__(self, base_url: str | None = None, timeout_s: int = 10):
        self._base_url = base_url or os.getenv("ACTIVITY_SERVICE_URL", "http://activity-service:8000")
        self._timeout_s = timeout_s

    def update_activity_status(self, activity_id: int, new_status: str) -> None:
        try:
            resp = requests.patch(
                f"{self._base_url}/activities/{activity_id}/status",
                json={"status": new_status},
                timeout=self._timeout_s,
            )
            resp.raise_for_status()
        except Exception as e:
            raise Exception(f"Failed to update activity status: {str(e)}")
