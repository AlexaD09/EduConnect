from __future__ import annotations
import os
from fastapi import FastAPI
from app.adapters.http.routes.activity_routes import router as activity_router

def create_app() -> FastAPI:
    os.makedirs("/app/storage", exist_ok=True)
    app = FastAPI(title="Activity Service")
    app.include_router(activity_router)
    return app
