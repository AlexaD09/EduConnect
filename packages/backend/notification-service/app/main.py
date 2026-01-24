from fastapi import FastAPI
from threading import Thread
from app.mqtt.client import start_mqtt

app = FastAPI()

@app.get("/health")
def health():
    return {"status": "notification-service-ok"}

Thread(target=start_mqtt, daemon=True).start()
