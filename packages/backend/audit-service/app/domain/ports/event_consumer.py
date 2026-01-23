from abc import ABC, abstractmethod


class EventConsumer(ABC):
    @abstractmethod
    def start(self) -> None:
        raise NotImplementedError
