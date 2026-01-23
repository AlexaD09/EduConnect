from typing import Optional
from app.application.ports.event_bus import EventBus
from app.domain.events.base import DomainEvent

class PublishEventCommand:
    def __init__(self, bus: EventBus) -> None:
        self._bus = bus

    async def execute(self, event: DomainEvent, topic: Optional[str], key: Optional[str]) -> None:
        await self._bus.publish(event=event, topic=topic, key=key)
