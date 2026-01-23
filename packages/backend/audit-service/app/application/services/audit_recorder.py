from app.domain.ports.audit_repository import AuditRepository
from app.application.commands.record_audit_command import RecordAuditCommand
from app.domain.models.audit_record import AuditRecord


class AuditRecorder:
    def __init__(self, repo: AuditRepository):
        self._repo = repo

    def record(self, cmd: RecordAuditCommand) -> str:
        record = AuditRecord(
            event_type=cmd.event_type,
            entity_type=cmd.entity_type,
            entity_id=cmd.entity_id,
            actor_username=cmd.actor_username,
            actor_id=cmd.actor_id,
            previous_state=cmd.previous_state,
            new_state=cmd.new_state,
            payload=cmd.payload,
        )
        return self._repo.insert(record)
