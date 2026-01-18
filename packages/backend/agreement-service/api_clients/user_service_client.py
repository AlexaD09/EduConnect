# agreement-service/api_clients/user_service_client.py
import requests

USER_SERVICE_URL = "http://user-service:8000"

def get_student_city(student_id: int) -> str:
    """Obtiene la ciudad del estudiante desde user-service"""
    response = requests.get(f"{USER_SERVICE_URL}/students/{student_id}")
    response.raise_for_status()
    return response.json()["city"]

def get_agreements_by_city(city: str):
    """Obtiene convenios disponibles en una ciudad"""
    response = requests.get(f"{USER_SERVICE_URL}/agreements?city={city}")
    response.raise_for_status()
    return response.json()