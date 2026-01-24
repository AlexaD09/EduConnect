import os
from fastapi import HTTPException, Request
from jose import jwt

def require_coordinator(request: Request) -> dict: 
    auth = request.headers.get("Authorization")
    if not auth or not auth.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Missing token")

    token = auth.split(" ", 1)[1].strip()
    secret = os.getenv("JWT_SECRET_KEY", "mysecretkey")
    try:
        payload = jwt.decode(token, secret, algorithms=["HS256"])
        username = payload.get("sub")
        role = payload.get("role")
        if role != "COORDINATOR":
            raise HTTPException(status_code=403, detail="Only coordinators can approve activities")
        return {"username": username, "role": role}
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid token")
