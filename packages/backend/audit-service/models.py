from sqlalchemy import Column, Integer, String, DateTime, Text
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime

Base = declarative_base()

class AuditLog(Base):
    __tablename__ = "audit_logs"
    
    id = Column(Integer, primary_key=True, index=True)
    timestamp = Column(DateTime, default=datetime.utcnow)
    user_id = Column(String, index=True)
    action = Column(String, index=True)  # LOGIN, APPROVE, REJECT, etc.
    resource = Column(String)  # activity/1, student/5, etc.
    details = Column(Text, nullable=True)