from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    # app database
    database_url: str
    cloudinary_cloud_name: str | None = None
    cloudinary_api_key: str | None = None
    cloudinary_api_secret: str | None = None

    model_config = SettingsConfigDict(env_file=".env", extra="ignore")


settings = Settings()