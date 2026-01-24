from dataclasses import dataclass
from app.domain.ports.activity_gateway import ActivityGateway
from app.domain.ports.approval_log_repository import ApprovalLogRepository

@dataclass(frozen=True)
class RejectActivityCommand:
    activity_gateway: ActivityGateway
    approval_repo: ApprovalLogRepository

    def execute(self, activity_id: int, coordinator_id: int, observations: str = "") -> None:
        self.activity_gateway.update_activity_status(activity_id, "REJECTED")
        self.approval_repo.create(
            activity_id=activity_id,
            coordinator_id=coordinator_id,
            action="REJECTED",
            observations=observations or "",
        )
