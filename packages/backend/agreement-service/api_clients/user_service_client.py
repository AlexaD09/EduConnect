from app.infrastructure.clients.user_service_client import UserServiceClient

USER_SERVICE_URL = "http://user-service:8000"

_client = UserServiceClient(base_url=USER_SERVICE_URL)

def get_student_city(student_id: int) -> str:
    return _client.get_student_city(student_id)

def get_agreements_by_city(city: str):
    return _client.get_agreements_by_city(city)
