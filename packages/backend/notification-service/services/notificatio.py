from pydantic import BaseModel
from typing import Optional

class NotificationBase(BaseModel):
    recipient: str
    subject: str
    message: str
    notification_type: str = "email"

class EmailNotification(NotificationBase):
    pass

class WhatsAppNotification(NotificationBase):
    phone: str
    notification_type: str = "whatsapp"