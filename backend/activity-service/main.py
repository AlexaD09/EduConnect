from fastapi import FastAPI, Depends, HTTPException, File, UploadFile, Form
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from database import SessionLocal, Base, engine
from services.activity_service import create_activity
from models.activity import Activity
import os
import uuid
from storage import save_file

os.makedirs("/app/storage", exist_ok=True)

app = FastAPI(title="Activity Service")

origins = ["http://localhost:3000"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/activities")
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
    
@app.get("/activities/student/{student_id}")
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



@app.get("/activities/pending-by-agreement/{agreement_id}")
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



@app.get("/activities/{activity_id}")
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
