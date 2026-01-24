from __future__ import annotations
from abc import ABC, abstractmethod
from typing import BinaryIO

class StoragePort(ABC):
    @abstractmethod
    def save(self, fileobj: BinaryIO, filename: str) -> str:
        """Persist file and return the public path (e.g., /storage/xxx.jpg)."""
        raise NotImplementedError
