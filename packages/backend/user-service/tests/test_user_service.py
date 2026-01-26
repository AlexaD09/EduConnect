from unittest.mock import MagicMock
from app.application.services.user_service import UserService

def test_create_role_creates_when_missing():
    
    db = MagicMock()
    db.query.return_value.filter_by.return_value.first.return_value = None

    service = UserService(db)
    role = service.create_role("admin")

    assert role is not None
    db.add.assert_called_once()
    db.commit.assert_called_once()


def test_create_user_creates_user_and_role():
    
    db = MagicMock()

    role_query = MagicMock()
    role_query.filter_by.return_value.first.return_value = None

    user_query = MagicMock()
    user_query.filter_by.return_value.first.return_value = None

    db.query.side_effect = [role_query, user_query]

    service = UserService(db)

    fake_role = MagicMock()
    fake_role.id = 1
    service.create_role = lambda r: fake_role

    user = service.create_user("test@mail.com", "1234", "student")

    assert user is not None
    db.add.assert_called()
    db.commit.assert_called()


def test_create_role_returns_existing_role():
    
    db = MagicMock()
    existing_role = MagicMock()
    db.query.return_value.filter_by.return_value.first.return_value = existing_role

    service = UserService(db)
    role = service.create_role("student")

    assert role == existing_role
    db.add.assert_not_called()
    db.commit.assert_not_called()
