import cmd
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session

from app.infrastructure.persistence.database import get_db
from app.infrastructure.persistence.repositories.approval_log_repository_pg import ApprovalLogRepositoryPostgres
from app.infrastructure.clients.activity_client import ActivityServiceClient
from app.infrastructure.clients.user_client import UserServiceClient

from app.infrastructure.security.jwt_auth import require_coordinator

from app.application.commands.approve_activity import ApproveActivityCommand
from app.application.commands.reject_activity import RejectActivityCommand
from app.infrastructure.clients.event_client import EventServiceClient


router = APIRouter()

class ApprovalRequest(BaseModel):
    observations: str = ""

@router.patch("/activities/{activity_id}/approve")
def approve_activity(
    activity_id: int,
    request: ApprovalRequest,
    db: Session = Depends(get_db),
    user=Depends(require_coordinator),
):
    try:
        approval_repo = ApprovalLogRepositoryPostgres(db)
        activity_gateway = ActivityServiceClient()
        cmd = ApproveActivityCommand(activity_gateway=activity_gateway, approval_repo=approval_repo)
         
        user_client = UserServiceClient()
        coordinator_id = user_client.get_coordinator_id_by_username(user["username"])
        cmd.execute(activity_id=activity_id, coordinator_id=coordinator_id, observations=request.observations)

        EventServiceClient().publish(
            "activity.approved",
            {
                "activity_id": activity_id,
                "coordinator_username": user["username"],
                "observations": request.observations,
            },
        )

        return {"message": "Activity approved successfully"}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.patch("/activities/{activity_id}/reject")
def reject_activity(
    activity_id: int,
    request: ApprovalRequest,
    db: Session = Depends(get_db),
    user=Depends(require_coordinator),
):
    try:
        approval_repo = ApprovalLogRepositoryPostgres(db)
        activity_gateway = ActivityServiceClient()
        cmd = RejectActivityCommand(activity_gateway=activity_gateway, approval_repo=approval_repo)
        user_client = UserServiceClient()
        coordinator_id = user_client.get_coordinator_id_by_username(user["username"])
        cmd.execute(activity_id=activity_id, coordinator_id=coordinator_id, observations=request.observations)

        EventServiceClient().publish(
            "activity.rejected",
            {
                "activity_id": activity_id,
                "coordinator_username": user["username"],
                "observations": request.observations,
            },
        )


        return {"message": "Activity rejected successfully"}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
