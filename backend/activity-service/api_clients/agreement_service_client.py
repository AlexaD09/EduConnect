import requests
import time

AGREEMENT_SERVICE_URL = "http://agreement-service:8000"

def get_assignment(student_id: int, max_retries=5, delay=2):
    """Verifica si el estudiante tiene asignación vigente con reintentos"""
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
            time.sleep(delay * (2 ** attempt))  # Exponential backoff
    
    raise ValueError("Unexpected error in get_assignment")