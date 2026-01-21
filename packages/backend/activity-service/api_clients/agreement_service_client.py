import os
import time

import requests


AGREEMENT_SERVICE_URL = os.getenv("AGREEMENT_SERVICE_URL")
if not AGREEMENT_SERVICE_URL:
    raise RuntimeError("Missing environment variable: AGREEMENT_SERVICE_URL")

def get_assignment(student_id: int, max_retries=5, delay=2):
    for attempt in range(max_retries):
        try:
            response = requests.get(
                f"{AGREEMENT_SERVICE_URL}/assignment/{student_id}",
                timeout=5
            )
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            if attempt == max_retries - 1:
                raise ValueError(f"Failed to connect to agreement-service after {max_retries} attempts: {str(e)}")
            time.sleep(delay * (2 ** attempt))
    
    raise ValueError("Unexpected error in get_assignment")