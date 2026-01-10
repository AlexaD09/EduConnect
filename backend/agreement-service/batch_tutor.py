# backend/agreement-service/batch/init_tutors.py
"""
Generates random academic tutors automatically.
- Full name, ID number (cedula), city, contact info
- Inserts into tutors table in agreement_db
- Uses same pattern as student batch
"""

import requests
import random
import unidecode
from database import SessionLocal
from models import Tutor

# --------------------------------------
# Fetch names from public URLs
# --------------------------------------
def fetch_list(url):
    try:
        clean_url = url.strip()
        res = requests.get(clean_url, timeout=5)
        res.raise_for_status()
        return [line.strip() for line in res.text.splitlines() if line.strip()]
    except Exception as e:
        print(f"⚠️  Using fallback names due to error: {e}")
        return ["Dr. Carlos", "Dra. María", "Prof. Juan", "Ing. Ana"], ["Pérez", "García", "Rodríguez", "López"]

first_names_url = "https://raw.githubusercontent.com/dominictarr/random-name/master/first-names.txt"
last_names_url = "https://raw.githubusercontent.com/dominictarr/random-name/master/names.txt"

try:
    first_names = fetch_list(first_names_url)
    last_names = fetch_list(last_names_url)
except:
    first_names = ["Dr. Carlos", "Dra. María", "Prof. Juan", "Ing. Ana"]
    last_names = ["Pérez", "García", "Rodríguez", "López"]

# Ecuadorian data
CITIES = ["Quito", "Guayaquil", "Cuenca", "Santo Domingo", "Machala", "Ambato", "Loja"]
EMAIL_DOMAINS = ["@uce.edu.ec", "@gmail.com", "@yahoo.com"]
PHONE_PREFIXES = ["099", "098", "097", "096"]

# --------------------------------------
# Generate tutor profile
# --------------------------------------
def generate_tutor_profile():
    """Generates complete tutor profile"""
    full_name = f"{random.choice(first_names)} {random.choice(last_names)}"
    return {
        "full_name": full_name,
        "id_number": str(random.randint(1000000000, 2999999999)),  # Cédula ecuatoriana
        "city": random.choice(CITIES),
        "contact_email": f"{unidecode.unidecode(full_name.lower().replace(' ', '.'))}{random.choice(EMAIL_DOMAINS)}",
        "contact_phone": f"{random.choice(PHONE_PREFIXES)}{random.randint(1000000, 9999999)}"
    }

# --------------------------------------
# Insert tutors into database
# --------------------------------------
def insert_random_tutors(total=30):
    db = SessionLocal()
    added = 0
    attempts = 0
    
    while added < total and attempts < total * 5:
        attempts += 1
        tutor_data = generate_tutor_profile()
        
        # Check if tutor already exists (by ID number)
        exists = db.query(Tutor).filter(
            Tutor.id_number == tutor_data["id_number"]
        ).first()
        
        if exists:
            continue
        
        tutor = Tutor(**tutor_data)
        db.add(tutor)
        added += 1
    
    db.commit()
    db.close()
    print(f"✅ ¡{added} tutores académicos generados automáticamente!")

# --------------------------------------
# Execute the insertion
# --------------------------------------
if __name__ == "__main__":
    insert_random_tutors(total=30)