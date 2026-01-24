from __future__ import annotations
from sqlalchemy import Column, Integer, String, ForeignKey, TIMESTAMP
from sqlalchemy.sql import func
from .database import Base

class Tutor(Base):
    __tablename__ = "tutors"

    id = Column(Integer, primary_key=True)
    full_name = Column(String(255), nullable=False)
    id_number = Column(String(15), nullable=False, unique=True)
    city = Column(String(100), nullable=False)
    contact_email = Column(String(100))
    contact_phone = Column(String(20))

class Assignment(Base):
    __tablename__ = "assignments"

    id = Column(Integer, primary_key=True)
    student_id = Column(Integer, nullable=False)
    agreement_id = Column(Integer, nullable=False)
    tutor_id = Column(Integer, ForeignKey("tutors.id"), nullable=False)
    assigned_at = Column(TIMESTAMP, server_default=func.now())
