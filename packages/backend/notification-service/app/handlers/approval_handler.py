import json
from app.services.notification_service import send_notification

def handle_approval_event(message: str):
    data = json.loads(message)

    notification = {
        "student_id": data["student_id"],
        "activity_id": data["activity_id"],
        "status": data["status"],
        "approved_by": data["approved_by"]
    }

    send_notification(notification)
