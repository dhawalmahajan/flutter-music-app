# Use env var when available, otherwise fallback to local DB string
import os
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
from config import settings

DATABASE_URL = settings.database_url
engine = create_engine(DATABASE_URL, echo=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()