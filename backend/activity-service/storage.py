import os

def save_file(file, filename: str) -> str:
    
    UPLOAD_DIR = "/app/storage"
    os.makedirs(UPLOAD_DIR, exist_ok=True)
    
    
    file.seek(0)
    
    filepath = os.path.join(UPLOAD_DIR, filename)
    with open(filepath, "wb") as f:
        f.write(file.read())
    
    return f"/storage/{filename}"