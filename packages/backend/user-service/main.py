from fastapi import FastAPI
from app.adapters.http.routes.user_routes import router as user_router

app = FastAPI(title="User Service (Hexagonal)")

app.include_router(user_router)


@app.get("/health")
def health():
    return {"status": "ok"}
