import os
import random
import requests

from app.infrastructure.persistence.database import SessionLocal
from app.infrastructure.persistence.repositories.approval_log_repository_pg import ApprovalLogRepositoryPostgres
from app.infrastructure.clients.activity_client import ActivityServiceClient

from app.application.commands.approve_activity import ApproveActivityCommand
from app.application.commands.reject_activity import RejectActivityCommand


def env_int(name: str, default: int) -> int:
    v = os.getenv(name)
    return int(v) if v and v.isdigit() else default


def seed_approvals(max_per_agreement: int) -> None:
    activity_base = os.getenv("ACTIVITY_SERVICE_URL", "http://activity-service:8000")
    user_base = os.getenv("USER_SERVICE_URL", "http://user-service:8000")

    agreements = []
    try:
        r = requests.get(f"{user_base}/agreements", timeout=8)
        r.raise_for_status()
        agreements = r.json()
    except Exception:
        agreements = []

    db = SessionLocal()
    try:
        repo = ApprovalLogRepositoryPostgres(db)
        gateway = ActivityServiceClient()
        approve_cmd = ApproveActivityCommand(activity_gateway=gateway, approval_repo=repo)
        reject_cmd = RejectActivityCommand(activity_gateway=gateway, approval_repo=repo)

        total = 0
        for ag in agreements:
            agreement_id = ag.get("id")
            if not agreement_id:
                continue

            try:
                pending = requests.get(
                    f"{activity_base}/pending-by-agreement/{agreement_id}",
                    timeout=8,
                ).json()
            except Exception:
                continue

            for item in pending[:max_per_agreement]:
                activity_id = item.get("id")
                if not activity_id:
                    continue

                try:
                    if random.random() < 0.7:
                        approve_cmd.execute(activity_id=activity_id, coordinator_id=1, observations="Seed approve")
                    else:
                        reject_cmd.execute(activity_id=activity_id, coordinator_id=1, observations="Seed reject")
                    total += 1
                except Exception:
                    continue

        print(f"✅ Approval logs created: {total}")
    finally:
        db.close()


if __name__ == "__main__":
    seed_approvals(env_int("SEED_MAX_PER_AGREEMENT", 3))
