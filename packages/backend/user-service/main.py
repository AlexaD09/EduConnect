# main.py - User Service with login, JWT
from fastapi import FastAPI, Depends, HTTPException, status, Request
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session
from passlib.hash import bcrypt
from jose import jwt
from datetime import datetime, timedelta
import os
from fastapi import Body
from database import SessionLocal
from models import User,Student, Agreement
from schemas import UserLogin


# --------------------------
# App initialization
# --------------------------
app = FastAPI(title="User Service")

# --------------------------
# JWT configuration
# --------------------------
SECRET_KEY = os.getenv("SECRET_KEY") or "mysecretkey"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 15

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
# Create JWT access token
# --------------------------
def create_access_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

# --------------------------
# Login endpoint
# -------------------------- 
@app.post("/login") 
async def login(credentials: UserLogin, db: Session = Depends(get_db)):    
    print("Received credentials:", credentials.username)
    """
    Validate user credentials and return JWT token with role.
    """
    # Fetch user by username
    user = db.query(User).filter(User.username == credentials.username).first()

    # Check if user exists and password matches
    if not user or not bcrypt.verify(credentials.password, user.password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid username or password"
        )

    # Safely get role name
    role_name = user.role.name if user.role else "STUDENT"

    # Create JWT token
    token = create_access_token({"sub": user.username, "role": role_name})

    # Return token and role
    return {"access_token": token, "token_type": "bearer", "role": role_name}




@app.get("/students/{student_id}")
def get_student_details(student_id: int, db: Session = Depends(get_db)):
    """
    Retrieves complete student information including username.
    """
    
    student = db.query(Student).filter(Student.id == student_id).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")
    
    
    user = db.query(User).filter(User.student_id == student_id).first()
    username = user.username if user else f"student_{student_id}"
    
    
    return {
        "id": student.id,
        "username": username,
        "city": student.city,
        "full_name": student.full_name,
        "career": student.career
    }

@app.get("/agreements")
def get_agreements_by_city(city: str, db: Session = Depends(get_db)):
    """
    Retrieves available agreements in a specific city.
Used by agreement-service to assign agreements.
    """
    agreements = db.query(Agreement).filter(Agreement.city == city).all()
    return [
        {
            "id": a.id,
            "name": a.name,
            "institution": a.institution,
            "coordinator_name": a.coordinator_name
        }
        for a in agreements
    ]


@app.get("/students/by-username/{username}")
def get_student_by_username(username: str, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == username).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    
    student = db.query(Student).filter(Student.id == user.id).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")
    
    return {"id": student.id,
             "username": username, 
             "city": student.city,
             "career": student.career,
             "full_name": student.full_name 
             }


@app.get("/agreements/{agreement_id}")
def get_agreement_details(agreement_id: int, db: Session = Depends(get_db)):
    agreement = db.query(Agreement).filter(Agreement.id == agreement_id).first()
    if not agreement:
        raise HTTPException(status_code=404, detail="Agreement not found")
    return {
        "id": agreement.id,
        "name": agreement.name,
        "institution": agreement.institution,
        "city": agreement.city,
        "coordinator_name": agreement.coordinator_name,
        
    }

@app.get("/coordinators/by-username/{username}")
def get_coordinator_by_username(username: str, db: Session = Depends(get_db)):
    
    user = db.query(User).filter(
        User.username == username,
        User.role_id == 3  
    ).first()
    
    if not user:
        raise HTTPException(status_code=404, detail="Coordinator not found")
    
    return {"id": user.id,
             "username": user.username, 
             "agreement_id": user.agreement_id,
             "full_name": user.username
             }