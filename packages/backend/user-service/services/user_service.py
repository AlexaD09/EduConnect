# RNF8: SOLID / DRY / KISS / YAGNI applied
from passlib.context import CryptContext
from sqlalchemy.orm import Session
from models import User, Role

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

class UserService:
    def __init__(self, db: Session):
        self.db = db

    def create_role(self, name: str):
        role = self.db.query(Role).filter_by(name=name).first()
        if not role:
            role = Role(name=name)
            self.db.add(role)
            self.db.commit()
        return role

    def create_user(self, email: str, password: str, role_name: str):
        role = self.db.query(Role).filter_by(name=role_name).first()
        if not role:
            role = self.create_role(role_name)
        user = self.db.query(User).filter_by(email=email).first()
        if not user:
            hashed = pwd_context.hash(password)
            user = User(email=email, password=hashed, role_id=role.id)
            self.db.add(user)
            self.db.commit()
        return user
