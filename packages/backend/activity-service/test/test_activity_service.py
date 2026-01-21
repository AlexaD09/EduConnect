import pytest
from unittest.mock import MagicMock
import services.activity_service as service

def test_activity_without_assignment(monkeypatch):
    """Objetivo: No permitir actividad sin asignación"""
    monkeypatch.setattr(service, "get_assignment", lambda x: {"has_assignment": False})

    with pytest.raises(ValueError):
        service.create_activity(MagicMock(), 1, "desc", "a.jpg", "b.jpg")


def test_activity_created(monkeypatch):
    """Objetivo: Crear actividad correctamente"""
    monkeypatch.setattr(service, "get_assignment", lambda x: {"has_assignment": True, "agreement_id": 2})

    db = MagicMock()
    activity = service.create_activity(db, 1, "desc", "a.jpg", "b.jpg")

    assert activity is not None
    db.add.assert_called_once()
    db.commit.assert_called_once()
