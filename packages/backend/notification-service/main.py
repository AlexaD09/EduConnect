from fastapi import FastAPI
from .services.notification_service import NotificationService
from .models.notification import EmailNotification, WhatsAppNotification

app = FastAPI(title="Notification Service")

notification_service = NotificationService()

@app.get("/health")
async def health_check():
    return {
        "service": "notification-service",
        "status": "healthy",
        "architecture": "Event Driven",
        "principles": ["KISS", "Low Coupling"],
        "communication": ["REST", "MQTT"]
    }

@app.post("/notify/email")
async def send_email_notification(notification: EmailNotification):
    return notification_service.send_notification(notification)

@app.post("/notify/whatsapp")
async def send_whatsapp_notification(notification: WhatsAppNotification):
    return notification_service.send_notification(notification)

@app.get("/notifications/{notification_type}")
async def get_notifications(notification_type: str = "email"):
    return notification_service.get_pending_notifications(notification_type)