from fastapi import FastAPI
from app.infrastructure.persistence.database import Base, engine
from app.adapters.http.routes.approval_routes import router as approval_router

def create_app() -> FastAPI:
    Base.metadata.create_all(bind=engine)
    app = FastAPI(title="Approval Service")
    app.include_router(approval_router)
    return app
