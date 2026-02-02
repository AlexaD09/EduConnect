from __future__ import annotations

from fastapi import APIRouter, Depends, HTTPException, File, UploadFile, Form
from pydantic import BaseModel
from typing import Optional, Dict, Any

from app.adapters.http.deps import get_activity_repo, get_assignment_gateway, get_storage
from app.application.commands.create_activity import CreateActivityCommand
from app.application.commands.update_activity_status import UpdateActivityStatusCommand
from app.application.queries.get_student_activities import GetStudentActivitiesQuery
from app.application.queries.get_pending_by_agreement import GetPendingActivitiesByAgreementQuery
from app.application.queries.get_activity_details import GetActivityDetailsQuery

router = APIRouter()

class StatusUpdate(BaseModel):
    status: str
    observations: Optional[str] = None

@router.post("/activity")
async def register_activity(
    student_id: int = Form(...),
    description: str = Form(...),
    entry_photo: UploadFile = File(...),
    exit_photo: UploadFile = File(...),
    activity_repo = Depends(get_activity_repo),
    assignment_gateway = Depends(get_assignment_gateway),
    storage = Depends(get_storage),
) -> Dict[str, Any]:
    try:
        cmd = CreateActivityCommand(activity_repo, assignment_gateway, storage)
        activity = cmd.execute(
            student_id=student_id,
            description=description,
            entry_photo=entry_photo.file,
            exit_photo=exit_photo.file,
        )
        return {
            "id": activity.id,
            "status": "PENDING",
            "message": "Activity successfully logged",
        }
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error saving photos: {str(e)}")

@router.get("/student/{student_id}")
def get_student_activities(
    student_id: int,
    activity_repo = Depends(get_activity_repo),
):
    q = GetStudentActivitiesQuery(activity_repo)
    activities = q.execute(student_id)
    return [
        {
            "id": a.id,
            "date": a.created_at.strftime("%Y-%m-%d"),
            "status": a.status,
            "description": a.description,
            "entry_photo_path": a.entry_photo_path,
            "exit_photo_path": a.exit_photo_path,
        }
        for a in activities
    ]

@router.get("/pending-by-agreement/{agreement_id}")
def get_pending_activities_by_agreement(
    agreement_id: int,
    activity_repo = Depends(get_activity_repo),
):
    q = GetPendingActivitiesByAgreementQuery(activity_repo)
    activities = q.execute(agreement_id)
    return [
        {
            "id": a.id,
            "student_id": a.student_id,
            "date": a.created_at.strftime("%Y-%m-%d"),
        }
        for a in activities
    ]

@router.get("/student-activity/{activity_id}")
def get_activity_details(
    activity_id: int,
    activity_repo = Depends(get_activity_repo),
):
    q = GetActivityDetailsQuery(activity_repo)
    try:
        activity = q.execute(activity_id)
    except LookupError:
        raise HTTPException(status_code=404, detail="Activity not found")

    return {
        "id": activity.id,
        "student_id": activity.student_id,
        "agreement_id": activity.agreement_id,
        "description": activity.description,
        "entry_photo_path": activity.entry_photo_path,
        "exit_photo_path": activity.exit_photo_path,
        "status": activity.status,
        "created_at": activity.created_at.strftime("%Y-%m-%d %H:%M:%S"),
    }

@router.patch("/activities/{activity_id}/status")
def update_activity_status(
    activity_id: int,
    status_update: StatusUpdate,
    activity_repo = Depends(get_activity_repo),
):
    
    cmd = UpdateActivityStatusCommand(activity_repo)
    try:
        cmd.execute(activity_id=activity_id, status=status_update.status, observations=status_update.observations)
    except LookupError:
        raise HTTPException(status_code=404, detail="Activity not found")

    return {"message": "Activity status updated successfully"}
