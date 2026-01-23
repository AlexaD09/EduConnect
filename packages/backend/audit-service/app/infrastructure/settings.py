from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    SERVICE_NAME: str = "audit-service"

    MONGO_URI: str = "mongodb://audit-mongo:27017"
    MONGO_DB: str = "audit_db"
    MONGO_COLLECTION: str = "audit_records"

    RABBITMQ_URL: str = "amqp://guest:guest@rabbitmq:5672/"
    RABBITMQ_EXCHANGE: str = "domain_events"
    RABBITMQ_EXCHANGE_TYPE: str = "topic"
    RABBITMQ_QUEUE: str = "audit_service_queue"
    RABBITMQ_BINDING_KEYS: str = "approval.*"

    class Config:
        env_file = ".env"


settings = Settings()
