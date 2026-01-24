from __future__ import annotations
from fastapi import HTTPException, status

from app.domain.ports.repositories import UserRepositoryPort
from app.infrastructure.security.password_hasher import PasswordHasher
from app.infrastructure.security.jwt_service import JwtService

class LoginUseCase:
    def __init__(self, users: UserRepositoryPort, hasher: PasswordHasher, jwt_svc: JwtService):
        self.users = users
        self.hasher = hasher
        self.jwt_svc = jwt_svc

    def execute(self, username: str, password: str) -> dict:
        user = self.users.get_by_username(username)
        if not user or not self.hasher.verify(password, user.password):
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")
        token = self.jwt_svc.create_token(subject=str(user.id))
        return {"access_token": token, "token_type": "bearer", "user_id": user.id, "role_id": user.role_id}
