"""
Database and application configuration
"""
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

class Config:
    """Application configuration class"""
    
    # Flask settings
    SECRET_KEY = os.getenv('FLASK_SECRET_KEY', 'dev-secret-key-change-this')
    DEBUG = os.getenv('FLASK_ENV', 'development') == 'development'
    
    # Database settings
    DB_HOST = os.getenv('DB_HOST', 'db')
    DB_PORT = os.getenv('DB_PORT', '3306')
    DB_USER = os.getenv('DB_USER', 'finance_user')
    DB_PASSWORD = os.getenv('DB_PASSWORD', '')
    DB_NAME = os.getenv('DB_NAME', 'personal_finance_tracker')
    
    # SQLAlchemy settings
    SQLALCHEMY_DATABASE_URI = (
        f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_ECHO = DEBUG  # Log SQL queries in debug mode
    
    # API settings
    JSON_SORT_KEYS = False  # Don't sort JSON keys alphabetically
    JSONIFY_PRETTYPRINT_REGULAR = True  # Pretty print JSON in responses

# Create config instance
config = Config()