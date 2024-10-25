import psycopg2
from sqlalchemy import create_engine

def create_connection():
    # Configurações da conexão
    host = "db"  # Nome do serviço no docker-compose.yml # "localhost"  # ou "127.0.0.1"
    port = "5432"
    database = "mydatabase"
    user = "myuser"
    password = "mypassword"

    connection_str = f"postgresql://{user}:{password}@{host}:{port}/{database}"
    engine = create_engine(connection_str)
    return engine