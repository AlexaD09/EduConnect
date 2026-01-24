import time
import pika
from app.infrastructure.settings import settings

def get_connection(max_retries: int = 30, delay_sec: float = 2.0):
    params = pika.URLParameters(settings.RABBITMQ_URL)

    last_err = None
    for attempt in range(1, max_retries + 1):
        try:
            return pika.BlockingConnection(params)
        except Exception as e:
            last_err = e
            print(f"[audit-service] RabbitMQ not ready (attempt {attempt}/{max_retries}): {e}")
            time.sleep(delay_sec)

    raise last_err
