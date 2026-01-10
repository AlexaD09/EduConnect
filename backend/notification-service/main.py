"""
Notification Service: sends alerts via logs and MQTT (RNF15c mandatory).
RNF19: n8n (future), RNF15c: MQTT.
"""
from fastapi import FastAPI
import logging
import paho.mqtt.client as mqtt
import os

app = FastAPI(title="Notification Service")

MQTT_HOST = os.getenv("MQTT_HOST", "emqx")
MQTT_PORT = int(os.getenv("MQTT_PORT", "1883"))

mqtt_client = mqtt.Client()
mqtt_client.connect(MQTT_HOST, MQTT_PORT, 60)
mqtt_client.loop_start()

logging.basicConfig(level=logging.INFO)

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/notify")
def send_notification(to: str, subject: str, body: str):
    logging.info(f"📧 Email to {to}: {subject} | {body}")
    mqtt_client.publish("notifications/alert", payload=f'{{"to":"{to}","subject":"{subject}","body":"{body}"}}', qos=1)
    return {"sent": True, "via": "log + mqtt"}