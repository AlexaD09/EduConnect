from dataclasses import dataclass
from app.domain.ports.approval_log_repository import ApprovalLogRepository

@dataclass(frozen=True)
class GetApprovalLogQuery:
    approval_repo: ApprovalLogRepository

    def execute(self, log_id: int):
        return self.approval_repo.get_by_id(log_id)
