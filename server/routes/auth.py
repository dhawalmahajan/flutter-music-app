import uuid
import bcrypt
from fastapi import HTTPException

from models.user import User
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
from database import db
router = APIRouter()

@router.post("/signup")
async def signup_user(user: UserCreate):
   
    try:
        user_db = db.query(User).filter(User.email == user.email).first()
        if user_db:
            raise HTTPException(status_code=400, detail="User with this email already exists")  
        
        
        hashed_pw = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())
        user_db = User(
            id=str(uuid.uuid4()),
            name=user.name,
            email=user.email,
            password=hashed_pw,
        )
        db.add(user_db)
        db.commit()
        db.refresh(user_db)
        return user_db
    finally:
        db.close()