import pytest
from unittest.mock import MagicMock
import services.assignment_service as service

def test_assign_success(monkeypatch):
    
    db = MagicMock()

    monkeypatch.setattr(service, "get_student_city", lambda x: "Quito")
    monkeypatch.setattr(service, "get_agreements_by_city", lambda x: [{"id": 1}])

    tutor = MagicMock()
    tutor.id = 10
    tutor.full_name = "Tutor Uno"
    db.query.return_value.all.return_value = [tutor]

    monkeypatch.setattr(service.random, "choice", lambda x: x[0])

    result = service.assign_agreement_and_tutor(db, 5)

    assert result["agreement_id"] == 1
    assert result["tutor_id"] == 10


def test_assign_without_agreements(monkeypatch):
    
    monkeypatch.setattr(service, "get_student_city", lambda x: "Quito")
    monkeypatch.setattr(service, "get_agreements_by_city", lambda x: [])

    with pytest.raises(ValueError):
        service.assign_agreement_and_tutor(MagicMock(), 1)
