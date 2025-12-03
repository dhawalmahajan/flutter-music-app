"""Development helper: drop and recreate all tables.

Warning: this will DELETE data in the database. Use only in development.
"""
from database import engine
from models.base import Base

if __name__ == "__main__":
    print("Dropping all tables...")
    Base.metadata.drop_all(bind=engine)
    print("Creating all tables...")
    Base.metadata.create_all(bind=engine)
    print("Done.")
