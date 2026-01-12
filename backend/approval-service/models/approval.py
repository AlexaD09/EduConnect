from sqlalchemy import Column, Integer, String, Text, ForeignKey
from database import Base

class ApprovalLog(Base):
    __tablename__ = "approval_logs"
    
    id = Column(Integer, primary_key=True)
    activity_id = Column(Integer, nullable=False)
    coordinator_id = Column(Integer, nullable=False)
    action = Column(String(20), nullable=False)
    observations = Column(Text)