import os

class Settings:
    def __init__(self) -> None:
        self.service_name = os.getenv("SERVICE_NAME", "event-service")
        self.kafka_bootstrap_servers = os.getenv("KAFKA_BOOTSTRAP_SERVERS", "kafka:9092")
        self.kafka_client_id = os.getenv("KAFKA_CLIENT_ID", "event-service")
        self.default_topic = os.getenv("KAFKA_DEFAULT_TOPIC", "system.events")

settings = Settings()
