# models.py
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from database import Base  

class Role(Base):
    __tablename__ = "roles"
    id = Column(Integer, primary_key=True)
    name = Column(String(50), unique=True, nullable=False)

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    email = Column(String, unique=True, index=True)
    username = Column(String, unique=True, index=True)
    password = Column(String)
    role_id = Column(Integer, ForeignKey("roles.id"))
    student_id = Column(Integer, ForeignKey("students.id"), nullable=True)
    agreement_id = Column(Integer, ForeignKey("agreements.id"), nullable=True)

    role = relationship("Role")

class Agreement(Base):
    __tablename__ = "agreements"
    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    institution = Column(String(255), nullable=False)
    city = Column(String(100), nullable=False)
    coordinator_name = Column(String(255), nullable=False)
    coordinator_id_number = Column(String(15), nullable=False)

    
class Student(Base):
    __tablename__ = "students"
    id = Column(Integer, primary_key=True)
    full_name = Column(String(255), nullable=False)
    id_number = Column(String(15), nullable=False)
    city = Column(String(100), nullable=False)
    career = Column(String(150), nullable=False)
    
    