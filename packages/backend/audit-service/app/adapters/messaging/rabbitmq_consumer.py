import json
from typing import Any, Dict
import pika
from app.infrastructure.rabbitmq import get_connection
from app.infrastructure.settings import settings
from app.application.services.audit_recorder import AuditRecorder
from app.application.commands.record_audit_command import RecordAuditCommand


class RabbitMQConsumer:
    def __init__(self, recorder: AuditRecorder):
        self._recorder = recorder

    def _declare(self, channel: pika.adapters.blocking_connection.BlockingChannel):
        channel.exchange_declare(
            exchange=settings.RABBITMQ_EXCHANGE,
            exchange_type=settings.RABBITMQ_EXCHANGE_TYPE,
            durable=True,
        )

        channel.queue_declare(queue=settings.RABBITMQ_QUEUE, durable=True)

        keys = [k.strip() for k in settings.RABBITMQ_BINDING_KEYS.split(",") if k.strip()]
        for k in keys:
            channel.queue_bind(
                exchange=settings.RABBITMQ_EXCHANGE,
                queue=settings.RABBITMQ_QUEUE,
                routing_key=k,
            )

    def _parse(self, body: bytes) -> Dict[str, Any]:
        return json.loads(body.decode("utf-8"))

    def _on_message(self, ch, method, properties, body: bytes):
        msg = self._parse(body)

        cmd = RecordAuditCommand(
            event_type=msg.get("event_type", method.routing_key),
            entity_type=msg.get("entity_type", "unknown"),
            entity_id=str(msg.get("entity_id", "unknown")),
            actor_username=msg.get("actor_username"),
            actor_id=str(msg["actor_id"]) if msg.get("actor_id") is not None else None,
            previous_state=msg.get("previous_state"),
            new_state=msg.get("new_state"),
            payload=msg,
        )

        self._recorder.record(cmd)
        ch.basic_ack(delivery_tag=method.delivery_tag)

    def start(self) -> None:
        conn = get_connection()
        channel = conn.channel()
        self._declare(channel)

        channel.basic_qos(prefetch_count=50)
        channel.basic_consume(queue=settings.RABBITMQ_QUEUE, on_message_callback=self._on_message)
        channel.start_consuming()
