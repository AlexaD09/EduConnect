from fastapi import Depends, FastAPI, HTTPException, Request
from jose import jwt
from pydantic import BaseModel
from sqlalchemy.orm import Session

from database import Base, SessionLocal, engine
from services.approval_service import create_approval_log, update_activity_status
from src.core.env import require_env


Base.metadata.create_all(bind=engine)

app = FastAPI(title="Approval Service")


SECRET_KEY = require_env("SECRET_KEY")


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_current_user(request: Request):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Invalid token")
    token = auth_header.split(" ")[1]
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        username = payload.get("sub")
        role = payload.get("role")
        if role != "COORDINATOR":
            raise HTTPException(status_code=403, detail="Only coordinators can approve activities")
        return {"username": username, "role": role}
    except jwt.JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")


class ApprovalRequest(BaseModel):
    activity_id: int
    observations: str = ""


@app.patch("/activities/{activity_id}/approve")
def approve_activity(
    activity_id: int,
    request: ApprovalRequest,
    current_user: dict = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    try:
        update_activity_status(activity_id, "APPROVED", db)
        create_approval_log(activity_id=activity_id, coordinator_id=1, action="APPROVED", observations="", db=db)
        return {"message": "Activity approved successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.patch("/activities/{activity_id}/reject")
def reject_activity(
    activity_id: int,
    request: ApprovalRequest,
    current_user: dict = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    try:
        update_activity_status(activity_id, "REJECTED", db)
        create_approval_log(
            activity_id=activity_id,
            coordinator_id=1,
            action="REJECTED",
            observations=request.observations,
            db=db,
        )
        return {"message": "Activity rejected successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
