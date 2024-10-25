FROM python:3

WORKDIR /app

# Copiar os arquivos de requisitos para o diretório de trabalho
COPY requirements.txt /app/

# Instalar as dependências do Python
RUN pip install --no-cache-dir -r requirements.txt

# Copiar o resto dos arquivos do projeto para o diretório de trabalho
COPY . /app/

# Comando padrão para executar quando o contêiner inicia
CMD ["python", "app.py"]