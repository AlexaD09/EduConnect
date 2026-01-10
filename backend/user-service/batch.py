# batch.py
"""
Generates students FIRST, then creates users from student data.
- Step 1: Create students table records
- Step 2: Generate email/username from student's full_name
- Step 3: Create users in 'users' table
"""

import requests
import random
import unidecode
from database import SessionLocal
from models import User, Student
from passlib.hash import bcrypt

# --------------------------------------
# Data sources
# --------------------------------------
def fetch_list(url):
    try:
        clean_url = url.strip()
        res = requests.get(clean_url, timeout=5)
        res.raise_for_status()
        return [line.strip() for line in res.text.splitlines() if line.strip()]
    except:
        return ["Carlos", "María", "Juan", "Ana"], ["Pérez", "García", "Rodríguez", "López"]

first_names_url = "https://raw.githubusercontent.com/dominictarr/random-name/master/first-names.txt"
last_names_url = "https://raw.githubusercontent.com/dominictarr/random-name/master/names.txt"

try:
    first_names = fetch_list(first_names_url)
    last_names = fetch_list(last_names_url)
except:
    first_names = ["Carlos", "María", "Juan", "Ana"]
    last_names = ["Pérez", "García", "Rodríguez", "López"]

CITIES = ["Quito", "Guayaquil", "Cuenca", "Santo Domingo", "Machala", "Ambato", "Loja"]
CAREERS = [
    "Ingeniería en Sistemas", "Medicina", "Derecho", "Contabilidad",
    "Psicología", "Arquitectura", "Enfermería", "Administración de Empresas"
]

# --------------------------------------
# Generate student profile
# --------------------------------------
def generate_student_profile():
    full_name = f"{random.choice(first_names)} {random.choice(first_names)} {random.choice(last_names)}"
    return {
        "full_name": full_name,
        "id_number": str(random.randint(1000000000, 2999999999)),
        "city": random.choice(CITIES),
        "career": random.choice(CAREERS)
    }

# --------------------------------------
# Generate credentials FROM student name
# --------------------------------------
def generate_credentials_from_name(full_name: str):
    clean_name = unidecode.unidecode(full_name.lower())
    parts = clean_name.split()
    first_letter = parts[0][0]
    second_letter = parts[1][1] if len(parts[1]) > 1 else parts[1][0]
    last_name = parts[2]
    username = f"{first_letter}{second_letter}{last_name}"
    email = f"{username}@uce.edu.ec"
    return username, email

# --------------------------------------
# Main batch process
# --------------------------------------
def create_students_and_users(total=100):
    db = SessionLocal()
    added = 0
    attempts = 0
    
    while added < total and attempts < total * 5:
        attempts += 1
        
        # Step 1: Create student record
        student_data = generate_student_profile()
        student = Student(**student_data)
        db.add(student)
        db.flush()  # Get student.id
        
        # Step 2: Generate credentials from student's name
        username, email = generate_credentials_from_name(student_data["full_name"])
        password_hash = bcrypt.hash("123456")
        
        # Step 3: Check if user already exists
        existing_user = db.query(User).filter(
            (User.username == username) | (User.email == email)
        ).first()
        
        if existing_user:
            db.rollback()  # Remove student if user exists
            continue
        
        # Step 4: Create user
        user = User(
            username=username,
            email=email,
            password=password_hash,
            role_id=2, 
            student_id=student.id,
            agreement_id=None
        )
        db.add(user)
        added += 1 
    
    db.commit()
    db.close()
    print(f"✅ ¡{added} students and users created!")

if __name__ == "__main__":
    create_students_and_users(total=100)