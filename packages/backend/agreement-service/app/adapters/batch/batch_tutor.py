
import requests
import random
import unidecode
from database import SessionLocal
from models import Tutor


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

CITIES = ["Quito", "Guayaquil", "Cuenca", "Santo Domingo", "Machala", "Ambato", "Loja"]
EMAIL_DOMAINS = ["@uce.edu.ec", "@gmail.com", "@yahoo.com"]
PHONE_PREFIXES = ["099", "098", "097", "096"]


def generate_tutor_profile():
    """Generates complete tutor profile"""
    full_name = f"{random.choice(first_names)} {random.choice(last_names)}"
    return {
        "full_name": full_name,
        "id_number": str(random.randint(1000000000, 2999999999)),  
        "city": random.choice(CITIES),
        "contact_email": f"{unidecode.unidecode(full_name.lower().replace(' ', '.'))}{random.choice(EMAIL_DOMAINS)}",
        "contact_phone": f"{random.choice(PHONE_PREFIXES)}{random.randint(1000000, 9999999)}"
    }


def insert_random_tutors(total=30):
    db = SessionLocal()
    added = 0
    attempts = 0
    
    while added < total and attempts < total * 5:
        attempts += 1
        tutor_data = generate_tutor_profile()
        
      
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
    print(f"✅ ¡{added} automatically generated academic tutors!")


if __name__ == "__main__":
    insert_random_tutors(total=50)