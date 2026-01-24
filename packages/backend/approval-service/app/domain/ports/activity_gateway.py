from abc import ABC, abstractmethod

class ActivityGateway(ABC):
    @abstractmethod
    def update_activity_status(self, activity_id: int, new_status: str) -> None: 
        raise NotImplementedError
