"""
Audit Service: logs actions (RF10).
RNF16a: trazabilidad.
"""
from fastapi import FastAPI, Depends
import asyncpg
import os
from datetime import datetime

app = FastAPI(title="Audit Service")
DB_URL = f"postgresql://admin:securepass123@{os.getenv('DB_HOST', 'db')}:5432/academic_linkage"

async def get_db():
    conn = await asyncpg.connect(DB_URL)
    try:
        yield conn
    finally:
        await conn.close()

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/log")
async def log_action(user_id: int, action: str, entity: str, entity_id: int, ip_address: str, db=Depends(get_db)):
    await db.execute("""
        INSERT INTO audit_log (user_id, action, entity, entity_id, ip_address, created_at)
        VALUES ($1, $2, $3, $4, $5, $6)
    """, user_id, action, entity, entity_id, ip_address, datetime.utcnow())
    return {"logged": True}