from sqlalchemy import TEXT, VARCHAR, Column, LargeBinary, String
from models.base import Base


class User(Base):
    __tablename__ = 'users'
    id = Column(TEXT, primary_key=True, index=True)
    name = Column(VARCHAR(100))
    email = Column(VARCHAR(100), unique=True, index=True)
    password = Column(LargeBinary)
    # Keep relationship declaration for when Favorite model is added
    # favorites = relationship('Favorite', back_populates='user')