from __future__ import annotations
from datetime import datetime, timedelta, timezone
from jose import jwt

class JwtService:
    def __init__(self, secret_key: str, algorithm: str = "HS256", expires_minutes: int = 60):
        self.secret_key = secret_key
        self.algorithm = algorithm
        self.expires_minutes = expires_minutes

    def create_token(self, subject: str) -> str:
        now = datetime.now(timezone.utc)
        payload = {"sub": subject, "iat": int(now.timestamp()), "exp": int((now + timedelta(minutes=self.expires_minutes)).timestamp())}
        return jwt.encode(payload, self.secret_key, algorithm=self.algorithm)
