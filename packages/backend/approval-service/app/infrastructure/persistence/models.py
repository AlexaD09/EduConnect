from sqlalchemy import Column, Integer, String, Text
from app.infrastructure.persistence.database import Base

class ApprovalLog(Base):
    __tablename__ = "approval_logs"

    id = Column(Integer, primary_key=True, index=True)
    activity_id = Column(Integer, nullable=False, index=True)
    coordinator_id = Column(Integer, nullable=False, index=True)
    action = Column(String(20), nullable=False)
    observations = Column(Text)
