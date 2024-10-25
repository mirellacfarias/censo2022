# Primeira imagem (0) : Python
FROM python:3

# Definir o diretório de trabalho
WORKDIR /app

# Copiar o arquivo requirements.txt
COPY requirements.txt /app/

# Instalar as dependências Python
RUN python3 -m pip install --no-cache-dir -r requirements.txt

# Copiar o restante dos arquivos para o diretório de trabalho
COPY . /app/


# Segunda imagem (1): Postgres 16
FROM postgres:16

# Instalar o Python e o pip
RUN apt-get update && apt-get install -y python3 python3-pip

# Copiar os arquivos da primeira imagem (0)
COPY --from=0 /app .

# Executar o script de dump
CMD ["python3", "dump_db.py"]