from app.domain.events.base import DomainEvent

class ActivityApprovedEvent(DomainEvent):
    event_type: str = "activity.approved"

class ActivityRejectedEvent(DomainEvent):
    event_type: str = "activity.rejected"
