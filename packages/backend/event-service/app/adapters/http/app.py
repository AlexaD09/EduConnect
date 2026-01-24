from fastapi import FastAPI
from contextlib import asynccontextmanager

from app.infrastructure.messaging.kafka_event_bus import KafkaEventBus
from app.adapters.http.routes.health_routes import router as health_router
from app.adapters.http.routes.event_routes import router as event_router

@asynccontextmanager
async def lifespan(app: FastAPI):
    bus = KafkaEventBus()
    await bus.start()
    app.state.event_bus = bus
    yield
    await bus.stop()

def create_app() -> FastAPI:
    app = FastAPI(title="event-service", lifespan=lifespan)
    app.include_router(health_router)
    app.include_router(event_router)
    return app
