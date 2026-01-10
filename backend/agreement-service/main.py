# backend/agreement-service/main.py
from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from sqlalchemy import text
from database import SessionLocal
from services.assignment_service import assign_agreement_and_tutor
from models import Assignment, Tutor
import requests

# --------------------------
# App initialization
# --------------------------
app = FastAPI(title="Agreement Assignment Service")

# --------------------------
# CORS configuration
# --------------------------
origins = ["http://localhost:3000"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --------------------------
# Database session dependency
# --------------------------
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# --------------------------
# Endpoints
# --------------------------
@app.get("/assignment/{student_id}")
def get_assignment(student_id: int, db: Session = Depends(get_db)):
    assignment = db.query(Assignment).filter(Assignment.student_id == student_id).first()
    if assignment:
        return {
            "has_assignment": True,
            "student_id": assignment.student_id,
            "agreement_id": assignment.agreement_id,
            "tutor_id": assignment.tutor_id
        }
    return {"has_assignment": False}

@app.post("/assign/{student_id}")
def assign_resources(student_id: int, db: Session = Depends(get_db)):
    return assign_agreement_and_tutor(db, student_id)

@app.get("/tutors/{tutor_id}")
def get_tutor_details(tutor_id: int, db: Session = Depends(get_db)):
    tutor = db.query(Tutor).filter(Tutor.id == tutor_id).first()
    if not tutor:
        raise HTTPException(status_code=404, detail="Tutor not found")
    return {
        "id": tutor.id,
        "full_name": tutor.full_name,
        "contact_email": tutor.contact_email,
        "contact_phone": tutor.contact_phone,
        "city": tutor.city
    }

@app.get("/assignments/coordinator/{coordinator_id}")
def get_assignments_by_coordinator(coordinator_id: int, db: Session = Depends(get_db)):
    
    try:
        coord_response = requests.get(f"http://user-service:8000/users/{coordinator_id}")
        if not coord_response.ok:
            return []
        coordinator_data = coord_response.json()
        agreement_id = coordinator_data.get("agreement_id")
        
        if not agreement_id:
            return []
            
    except Exception as e:
        print(f"Error fetching coordinator: {e}")
        return []
    
    
    assignments = db.query(Assignment).filter(
        Assignment.agreement_id == agreement_id
    ).all()
    
    result = []
    for assignment in assignments:
        try:
            student_response = requests.get(f"http://user-service:8000/students/{assignment.student_id}")
            if student_response.ok:
                student_data = student_response.json()
                result.append({
                    "student_id": assignment.student_id,
                    "student_username": student_data.get("username", f"Student {assignment.student_id}"),
                    "city": student_data.get("city", "Unknown")
                })
        except Exception as e:
            print(f"Error fetching student: {e}")
            result.append({
                "student_id": assignment.student_id,
                "student_username": f"Student {assignment.student_id}",
                "city": "Unknown"
            })
    
    return result