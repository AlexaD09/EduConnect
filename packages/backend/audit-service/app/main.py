import threading
from fastapi import FastAPI
from app.adapters.http.routes.health_routes import router as health_router
from app.adapters.http.routes.audit_routes import router as audit_router
from app.adapters.persistence.mongo_audit_repository import MongoAuditRepository
from app.application.services.audit_recorder import AuditRecorder
from app.adapters.messaging.rabbitmq_consumer import RabbitMQConsumer


app = FastAPI(title="audit-service")

app.include_router(health_router)
app.include_router(audit_router)


@app.on_event("startup")
def startup():
    repo = MongoAuditRepository()
    recorder = AuditRecorder(repo)
    consumer = RabbitMQConsumer(recorder)
    t = threading.Thread(target=consumer.start, daemon=True)
    t.start()
