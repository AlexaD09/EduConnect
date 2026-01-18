from fastapi import FastAPI, Depends, HTTPException, File, UploadFile, Form
from sqlalchemy.orm import Session
from database import SessionLocal, Base, engine
from services.activity_service import create_activity
from models.activity import Activity
import os
import uuid
from storage import save_file

os.makedirs("/app/storage", exist_ok=True)

app = FastAPI(title="Activity Service")


Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/activity")
async def register_activity(
    student_id: int = Form(...),
    description: str = Form(...),
    entry_photo: UploadFile = File(...),
    exit_photo: UploadFile = File(...),
    db: Session = Depends(get_db)
):
    try:
        entry_filename = f"entry_{uuid.uuid4().hex}.jpg"
        exit_filename = f"exit_{uuid.uuid4().hex}.jpg"
        
        
        entry_path = save_file(entry_photo.file, entry_filename)
        exit_path = save_file(exit_photo.file, exit_filename)
        
        # ✅ Create the activity
        new_activity = create_activity(
            db,
            student_id,
            description,
            entry_path,
            exit_path
        )
        
        return {
            "id": new_activity.id,
            "status": "PENDING",
            "message": "Activity successfully logged"
        }
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error saving photos: {str(e)}")
    
@app.get("/student/{student_id}")
def get_student_activities(student_id: int, db: Session = Depends(get_db)):
    activities = db.query(Activity).filter(Activity.student_id == student_id).all()
    return [
        {
            "id": a.id,
            "date": a.created_at.strftime("%Y-%m-%d"),
            "status": a.status,
            "description": a.description,  
            "entry_photo_path": a.entry_photo_path,  
            "exit_photo_path": a.exit_photo_path  
           
        }
        for a in activities
    ]     



@app.get("/pending-by-agreement/{agreement_id}")
def get_pending_activities_by_agreement(agreement_id: int, db: Session = Depends(get_db)):
    activities = db.query(Activity).filter(
        Activity.agreement_id == agreement_id,
        Activity.status == "PENDING"
    ).all()
    
    return [{
        "id": a.id,
        "student_id": a.student_id,
        "date": a.created_at.strftime("%Y-%m-%d")
    } for a in activities]



@app.get("/student-activity/{activity_id}")
def get_activity_details(activity_id: int, db: Session = Depends(get_db)):
    activity = db.query(Activity).filter(Activity.id == activity_id).first()
    if not activity:
        raise HTTPException(status_code=404, detail="Activity not found")
    
    return {
        "id": activity.id,
        "student_id": activity.student_id,
        "agreement_id": activity.agreement_id,
        "description": activity.description,
        "entry_photo_path": activity.entry_photo_path,
        "exit_photo_path": activity.exit_photo_path,
        "status": activity.status,
        "created_at": activity.created_at.strftime("%Y-%m-%d %H:%M:%S")
    }


@app.patch("/activities/{activity_id}/status")
def update_activity_status(
    activity_id: int,
    status_update: dict,
    db: Session = Depends(get_db)
):
    """
    Update activity status (called by approval-service)
    Expected body: {"status": "APPROVED"|"REJECTED", "observations": "optional"}
    """
    activity = db.query(Activity).filter(Activity.id == activity_id).first()
    if not activity:
        raise HTTPException(status_code=404, detail="Activity not found")
    
    # Update status
    if "status" in status_update:
        activity.status = status_update["status"]
    
    # Update observations if provided
    if "observations" in status_update:
        activity.observations = status_update["observations"]
    
    db.commit()
    return {"message": "Activity status updated successfully"}
 