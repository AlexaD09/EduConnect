from app.infrastructure.redis_client import redis_client
import json
import paho.mqtt.publish as publish 


def send_notification(payload: dict):

    redis_client.lpush("notifications", json.dumps(payload))
    print(f"NOTIFICATION SENT → {payload}")
    
    publish.single(
        topic="academic/approval/events",
        payload=json.dumps({
            "student_id": payload.get("student_id"),
            "activity_id": payload.get("activity_id"),
            "status": payload.get("status"),
            "approved_by": payload.get("approved_by"),
        }),
        hostname="mqtt-broker",
        port=1883
    )
    print(f"NOTIFICATION SENT → {payload}")
