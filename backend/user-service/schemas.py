from pydantic import BaseModel

class UserLogin(BaseModel):
    username: str
    password: str

class UserCreate(BaseModel):
    email: str
    username: str
    password: str
    role_id: int

class UserResponse(BaseModel):
    id: int
    email: str
    username: str
    role_id: int

    class Config:
        from_attributes = True  