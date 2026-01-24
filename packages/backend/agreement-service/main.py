from fastapi import FastAPI
from app.adapters.http.routes.agreement_routes import router as agreement_router

app = FastAPI(title="Agreement Assignment Service")

app.include_router(agreement_router)
