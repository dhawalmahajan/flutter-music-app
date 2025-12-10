import jwt
from fastapi.param_functions import Header
import token
import uuid
import bcrypt
from fastapi import Depends, HTTPException

from database import get_db
from models.user import User
from pydantic_schemas.user_create import UserCreate
from pydantic_schemas.user_login import UserLogin
from fastapi import APIRouter
from sqlalchemy.orm import Session
import jwt
router = APIRouter()

@router.post("/signup",status_code=201)
def signup_user(user: UserCreate, db: Session = Depends(get_db)):
   
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
        
@router.post("/login")
def login_user(user: UserLogin, db:Session = Depends(get_db)):
    try:
        user_db = db.query(User).filter(User.email == user.email).first()
        if not user_db:
            raise HTTPException(status_code=400, detail="User with this email does not exist")
        
        if not bcrypt.checkpw(user.password.encode(), user_db.password):
            raise HTTPException(status_code=400, detail="Incorrect password")
        token = jwt.encode({'id': user_db.id}, 'password_key')
        return {'token': token,'user': user_db}
    finally:
        db.close()
       
@router.get("/")
def current_user_data(db: Session = Depends(get_db),x_auth_token = Header()):
    try:
        if not x_auth_token:
            raise HTTPException(status_code=401, detail="No auth token, Access denied ")
        verified_token = jwt.decode(x_auth_token, 'password_key', algorithms=['HS256'])
        if not verified_token:
            raise HTTPException(status_code=401, detail="Token verification failed, Authorization denied ")
        uid = verified_token.get('id')
        return uid
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail="Token verification failed, Authorization denied ")
    