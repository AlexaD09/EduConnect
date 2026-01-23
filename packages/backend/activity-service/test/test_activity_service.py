import pytest
from unittest.mock import MagicMock

from app.application.commands.create_activity import CreateActivityCommand


def test_activity_without_assignment():
   
    activity_repo = MagicMock()
    assignment_gateway = MagicMock()
    assignment_gateway.get_assignment.return_value = {"has_assignment": False}
    storage = MagicMock()

    cmd = CreateActivityCommand(activity_repo, assignment_gateway, storage)

    with pytest.raises(ValueError):
        cmd.execute(1, "desc", MagicMock(), MagicMock())


def test_activity_created():
    
    activity_repo = MagicMock()
    assignment_gateway = MagicMock()
    assignment_gateway.get_assignment.return_value = {"has_assignment": True, "agreement_id": 2}
    storage = MagicMock()
    storage.save.side_effect = ["/storage/a.jpg", "/storage/b.jpg"]

    cmd = CreateActivityCommand(activity_repo, assignment_gateway, storage)
    cmd.execute(1, "desc", MagicMock(), MagicMock())

    activity_repo.create.assert_called_once()
