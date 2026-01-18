import redis
import json
from datetime import datetime
from ..models.notification import NotificationBase

class NotificationService:
    def __init__(self):
        self.redis_client = redis.Redis(host='redis', port=6379, decode_responses=True)
    
    def send_notification(self, notification: NotificationBase):
        """Envía notificación y la guarda en cola Redis"""
        notification_data = {
            "recipient": notification.recipient,
            "subject": notification.subject,
            "message": notification.message,
            "type": notification.notification_type,
            "timestamp": datetime.now().isoformat()
        }
        
        # Guardar en cola según tipo
        if notification.notification_type == "whatsapp":
            self.redis_client.lpush('whatsapp_notifications', json.dumps(notification_data))
        else:
            self.redis_client.lpush('email_notifications', json.dumps(notification_data))
        
        return {"status": "queued", "notification_id": notification_data["timestamp"]}
    
    def get_pending_notifications(self, notification_type: str = "email"):
        """Obtiene notificaciones pendientes"""
        queue_key = f"{notification_type}_notifications"
        notifications = []
        
        # Obtener todas las notificaciones sin eliminarlas
        length = self.redis_client.llen(queue_key)
        for i in range(length):
            notification = self.redis_client.lindex(queue_key, i)
            if notification:
                notifications.append(json.loads(notification))
        
        return notifications