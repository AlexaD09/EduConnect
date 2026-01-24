from __future__ import annotations
import os
import time
from typing import Dict, Any

import requests

from app.domain.ports.assignment_gateway import AssignmentGateway

class AgreementServiceAssignmentGateway(AssignmentGateway):
    def __init__(self, base_url: str | None = None):
        self._base_url = base_url or os.getenv("AGREEMENT_SERVICE_URL", "http://agreement-service:8000")

    def get_assignment(self, student_id: int) -> Dict[str, Any]:
        max_retries = int(os.getenv("AGREEMENT_MAX_RETRIES", "5"))
        delay = float(os.getenv("AGREEMENT_RETRY_DELAY", "2"))

        last_error: Exception | None = None
        for attempt in range(max_retries):
            try:
                r = requests.get(f"{self._base_url}/assignment/{student_id}", timeout=5)
                r.raise_for_status()
                return r.json()
            except requests.exceptions.RequestException as e:
                last_error = e
                if attempt == max_retries - 1:
                    break
                time.sleep(delay * (2 ** attempt))  # exponential backoff

        raise ValueError(
            f"Failed to connect to agreement-service after {max_retries} attempts: {str(last_error)}"
        )
