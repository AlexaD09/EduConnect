import paho.mqtt.client as mqtt
from app.config import MQTT_BROKER, MQTT_PORT
from app.mqtt.topics import APPROVAL_EVENTS_TOPIC
from app.handlers.approval_handler import handle_approval_event

def on_message(client, userdata, msg):
    handle_approval_event(msg.payload.decode())

def start_mqtt():
    client = mqtt.Client()
    client.connect(MQTT_BROKER, MQTT_PORT, 60)
    client.subscribe(APPROVAL_EVENTS_TOPIC)
    client.on_message = on_message
    client.loop_forever()
