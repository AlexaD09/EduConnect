# backend/activity-service/models/activity.py
from sqlalchemy import Column, Integer, String, Text,DateTime
from sqlalchemy.sql import func
from app.infrastructure.persistence.database import Base

class Activity(Base):
    __tablename__ = "activities"
    
    id = Column(Integer, primary_key=True)
    student_id = Column(Integer, nullable=False)
    agreement_id = Column(Integer, nullable=False)
    description = Column(Text, nullable=False)
    entry_photo_path = Column(String(255))
    exit_photo_path = Column(String(255))
    status = Column(String(20), default="PENDING")
    created_at = Column(DateTime(timezone=True), server_default=func.now()) 