from fastapi import APIRouter, Request, HTTPException
from pydantic import BaseModel
from typing import Any, Dict, Optional

from app.domain.events.base import DomainEvent
from app.application.commands.publish_event import PublishEventCommand

router = APIRouter(prefix="/events", tags=["events"])

class PublishRequest(BaseModel):
    topic: Optional[str] = None
    key: Optional[str] = None
    event_type: str
    source: str
    data: Dict[str, Any]
    correlation_id: Optional[str] = None

@router.post("/publish")
async def publish_event(payload: PublishRequest, request: Request):
    try:
        bus = request.app.state.event_bus
        cmd = PublishEventCommand(bus=bus)
        event = DomainEvent(
            event_type=payload.event_type,
            source=payload.source,
            data=payload.data,
            correlation_id=payload.correlation_id,
        )
        await cmd.execute(event=event, topic=payload.topic, key=payload.key)
        return {"status": "published", "event_id": event.event_id}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
