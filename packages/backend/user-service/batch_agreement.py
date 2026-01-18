# batch_agreement.py
"""
Generates random agreements AND coordinator users AUTOMATICALLY.
- Creates agreements table data
- Creates coordinator users in users table (role_id=3)
- Username: same format as students (c.m.perez → cmperez)
- Email: based on username
- Password: random number 1-5 (hashed)
"""

import requests
import random
import unidecode
from database import SessionLocal
from models import Agreement, User
from passlib.hash import bcrypt

def fetch_list(url):
    """Fetch names from public URLs"""
    try:
        clean_url = url.strip()
        res = requests.get(clean_url, timeout=5)
        res.raise_for_status()
        return [line.strip() for line in res.text.splitlines() if line.strip()]
    except Exception as e:
        print(f"⚠️  Error fetching names: {e}. Using fallback.")
        return ["Carlos", "María", "Juan", "Ana"], ["Pérez", "García", "Rodríguez", "López"]

# Get names
first_names_url = "https://raw.githubusercontent.com/dominictarr/random-name/master/first-names.txt  "
last_names_url = "https://raw.githubusercontent.com/dominictarr/random-name/master/names.txt  "

try:
    first_names = fetch_list(first_names_url)
    last_names = fetch_list(last_names_url)
except:
    first_names = ["Carlos", "María", "Juan", "Ana"]
    last_names = ["Pérez", "García", "Rodríguez", "López"]

# Ecuadorian data
CITIES = ["Quito", "Guayaquil", "Cuenca", "Santo Domingo", "Machala", "Ambato", "Loja"]
INSTITUTIONS = [
    "Fundación Sambiza", "Municipio de Quito", "Ministerio de Salud Pública",
    "GAD Parroquial de Calderón", "Universidad Técnica Particular de Loja",
    "Corporación Favorita", "Banco del Pacífico", "Fiscalía General del Estado"
]

def generate_username_from_name(full_name: str) -> str:
    """Generates username like students: Carlos María Pérez → cmperez"""
    clean_name = unidecode.unidecode(full_name.lower())
    parts = clean_name.split()
    
    if len(parts) < 2:
        parts.append("x")  # Fallback
    
    first_letter = parts[0][0]
    second_letter = parts[1][1] if len(parts[1]) > 1 else parts[1][0]
    last_name = parts[-1]  # Last part is last name
    
    username = f"{first_letter}{second_letter}{last_name}"
    return username

def insert_agreements_and_coordinators(total=30):
    """Inserts agreements and their coordinators into DB"""
    db = SessionLocal()
    added_agreements = 0
    added_users = 0
    
    for _ in range(total):
        # Generate agreement data FIRST
        institution = random.choice(INSTITUTIONS)
        city = random.choice(CITIES)
        full_name = f"{random.choice(first_names)} {random.choice(first_names)} {random.choice(last_names)}"
        cedula = str(random.randint(1000000000, 2999999999))
        
        agreement_data = {
            "name": f"Convenio UCE - {institution}",
            "institution": institution,
            "city": city,
            "coordinator_name": full_name,
            "coordinator_id_number": cedula
        }
        
        # Create agreement record
        agreement = Agreement(**agreement_data)
        db.add(agreement)
        db.flush()  # Critical: Gets the agreement.id immediately
        
        # Generate coordinator user data WITH agreement_id
        username = generate_username_from_name(full_name)
        email = f"{username}@{unidecode.unidecode(institution.lower().replace(' ', '-'))}.uce.edu.ec"
        password_hash = bcrypt.hash("12345")
        
        user_data = {
            "email": email,
            "username": username,
            "password": password_hash,
            "role_id": 3,  # Coordinator role
            "student_id": None,
            "agreement_id": agreement.id  # Now has valid ID
        }
        
        # Create coordinator user
        user = User(**user_data)
        db.add(user)
        
        added_agreements += 1
        added_users += 1
    
    db.commit()
    db.close()
    print(f"✅ Successfully generated {added_agreements} agreements and {added_users} coordinators!")
    if added_users > 0:
        print(f"📧 Example: username={user_data['username']}, email={user_data['email']}, password=12345")

if __name__ == "__main__":
    insert_agreements_and_coordinators(total=30)