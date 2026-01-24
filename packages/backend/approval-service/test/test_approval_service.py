import pytest
from unittest.mock import MagicMock
import services.approval_service as service

def test_update_activity_status_success(monkeypatch):
    
    class FakeResponse:
        def raise_for_status(self): pass

    monkeypatch.setattr(service.requests, "patch", lambda *a, **k: FakeResponse())
    assert service.update_activity_status(1, "APPROVED", MagicMock()) is True


def test_create_approval_log():
    
    db = MagicMock()
    log = service.create_approval_log(1, 2, "APPROVED", "ok", db)

    assert log is not None
    db.add.assert_called_once()
    db.commit.assert_called_once()


def test_update_activity_status_failure(monkeypatch):
     
    def fake_patch(*args, **kwargs):
        raise Exception("Error externo")

    monkeypatch.setattr(service.requests, "patch", fake_patch)

    with pytest.raises(Exception):
        service.update_activity_status(1, "REJECTED", MagicMock())
