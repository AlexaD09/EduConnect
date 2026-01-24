import os
import requests


class EventServiceClient:
    def __init__(self) -> None:
        self.base_url = os.getenv("EVENT_SERVICE_URL", "http://event-service:8000").rstrip("/")

    def publish(self, event_type: str, payload: dict) -> None:
        url = f"{self.base_url}/events/publish"
        r = requests.post(url, json={"event_type": event_type, "payload": payload}, timeout=5)
        r.raise_for_status()
