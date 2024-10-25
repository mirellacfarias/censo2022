import pandas as pd
import subprocess
from connect_postgres import create_connection

# Lista de arquivos
arquivos = [
    r"/app/Censo/Censo2022_Arquivos/Dados_Completos_parte1.xlsx",
    r"/app/Censo/Censo2022_Arquivos/Dados_Completos_parte2.xlsx",
    r"/app/Censo/Censo2022_Arquivos/Dados_Completos_parte3.xlsx",
    r"/app/Censo/Censo2022_Arquivos/Dados_Completos_parte4.xlsx",
    r"/app/Censo/Censo2022_Arquivos/Dados_Completos_parte5.xlsx",
    r"/app/Censo/Censo2022_Arquivos/Dados_Completos_parte6.xlsx",
    r"/app/Censo/Censo2022_Arquivos/Dados_Completos_parte7.xlsx",
    r"/app/Censo/Censo2022_Arquivos/Dados_Completos_parte8.xlsx"
]

# Valores de idade desejados
idades_desejadas = [
    "Menos de 1 mês", "1 mês", "2 meses", "3 meses", "4 meses", "5 meses", "6 meses", "7 meses", "8 meses", "9 meses", "10 meses", "11 meses", 
    "1 ano", "2 anos", "3 anos", "4 anos", "5 anos", "6 anos", "7 anos", "8 anos", "9 anos", "10 anos", "11 anos", "12 anos", "13 anos", "14 anos", 
    "15 anos", "16 anos", "17 anos", "18 anos", "19 anos", "20 anos", "21 anos", "22 anos", "23 anos", "24 anos", "25 anos", "26 anos", "27 anos", 
    "28 anos", "29 anos", "30 anos", "31 anos", "32 anos", "33 anos", "34 anos", "35 anos", "36 anos", "37 anos", "38 anos", "39 anos", "40 anos", 
    "41 anos", "42 anos", "43 anos", "44 anos", "45 anos", "46 anos", "47 anos", "48 anos", "49 anos", "50 anos", "51 anos", "52 anos", "53 anos", 
    "54 anos", "55 anos", "56 anos", "57 anos", "58 anos", "59 anos", "60 anos", "61 anos", "62 anos", "63 anos", "64 anos", "65 anos", "66 anos", 
    "67 anos", "68 anos", "69 anos", "70 anos", "71 anos", "72 anos", "73 anos", "74 anos", "75 anos", "76 anos", "77 anos", "78 anos", "79 anos", 
    "80 anos", "81 anos", "82 anos", "83 anos", "84 anos", "85 anos", "86 anos", "87 anos", "88 anos", "89 anos", "90 anos", "91 anos", "92 anos", 
    "93 anos", "94 anos", "95 anos", "96 anos", "97 anos", "98 anos", "99 anos", "100 anos ou mais"
]

# Função para renomear as colunas
def rename_columns(df):
    df.columns = df.columns.str.lower()  # Convertendo todas as colunas para minúsculas
    df.columns = df.columns.str.replace(' ', '_')  # Substituindo espaços por underscores
    df.columns = df.columns.str.normalize('NFKD').str.encode('ascii', errors='ignore').str.decode('utf-8')  # Removendo acentos
    return df

def process_files():
    engine = create_connection()
    for arquivo in arquivos:
        print(f"Lendo dados de {arquivo}")
        try:
            df = pd.read_excel(arquivo)
            # Renomeando as colunas
            df = rename_columns(df)
            # Substituindo valores "-" por 0 na coluna pessoas
            df['pessoas'] = df['pessoas'].replace('-', 0)
            # Filtrando os dados pela coluna de idade
            df_filtrado = df[df['idade'].isin(idades_desejadas)]
            print(f"Inserindo dados filtrados de {arquivo} no banco de dados")
            df_filtrado.to_sql('censo2022', engine, if_exists='append', index=False)
        except Exception as e:
            print(f"Erro ao processar {arquivo}: {e}")

if __name__ == "__main__":
    process_files()
