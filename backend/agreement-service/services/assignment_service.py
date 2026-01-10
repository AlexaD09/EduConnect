from sqlalchemy.orm import Session
from models import Assignment, Tutor
from api_clients.user_service_client import get_student_city, get_agreements_by_city
import random

def assign_agreement_and_tutor(db: Session, student_id: int):
    # 1. Obtener ciudad del estudiante
    city = get_student_city(student_id)
    
    # 2. Obtener convenios disponibles
    agreements = get_agreements_by_city(city)
    if not agreements:
        raise ValueError(f"No hay convenios en {city}")
    
    agreement_id = agreements[0]["id"]
    
    # 3. Asignar tutor aleatorio (CUALQUIERA, no solo de la ciudad)
    tutors = db.query(Tutor).all()
    if not tutors:
        raise ValueError("No hay tutores disponibles")
    
    tutor = random.choice(tutors)
    
    # 4. Guardar asignación
    assignment = Assignment(
        student_id=student_id,
        agreement_id=agreement_id,
        tutor_id=tutor.id
    )
    db.add(assignment)
    db.commit()
    
    return {
        "student_id": student_id,
        "agreement_id": agreement_id,
        "tutor_id": tutor.id,
        "tutor_name": tutor.full_name
    }