from __future__ import annotations
import os
from typing import BinaryIO

from app.domain.ports.storage_port import StoragePort

class LocalStorage(StoragePort):
    def __init__(self, upload_dir: str | None = None):
        self._upload_dir = upload_dir or os.getenv("UPLOAD_DIR", "/app/storage")
        os.makedirs(self._upload_dir, exist_ok=True)

    def save(self, fileobj: BinaryIO, filename: str) -> str:
        fileobj.seek(0)
        filepath = os.path.join(self._upload_dir, filename)
        with open(filepath, "wb") as f:
            f.write(fileobj.read())
        return f"/storage/{filename}"
