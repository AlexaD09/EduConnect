from aiokafka import AIOKafkaProducer
from typing import Optional
import json

from app.application.ports.event_bus import EventBus
from app.domain.events.base import DomainEvent
from app.infrastructure.settings import settings

class KafkaEventBus(EventBus):
    def __init__(self) -> None:
        self._producer: Optional[AIOKafkaProducer] = None

    async def start(self) -> None:
        self._producer = AIOKafkaProducer(
            bootstrap_servers=settings.kafka_bootstrap_servers,
            client_id=settings.kafka_client_id,
            value_serializer=lambda v: json.dumps(v).encode("utf-8"),
            key_serializer=lambda v: v.encode("utf-8") if v else None,
        )
        await self._producer.start()

    async def stop(self):
        if self._producer:
            await self._producer.stop()
            self._producer = None


    async def publish(self, event: DomainEvent, topic: Optional[str] = None, key: Optional[str] = None) -> None:
        if not self._producer:
            raise RuntimeError("Kafka producer not started")
        target_topic = topic or settings.default_topic
        await self._producer.send_and_wait(target_topic, event.model_dump(), key=key)
