from flask import Flask, jsonify, request, render_template_string
import connect_postgres
from psycopg2 import sql
from collections import OrderedDict

app = Flask(__name__)
app.config['JSON_SORT_KEYS'] = False

def get_db_connection():
    return connect_postgres.create_connection().raw_connection()

@app.route('/')
def hello():
    return "Oi Mirella"

@app.route('/test_db')
def test_db():
    try:
        get_db_connection()
        return "Conexão com o banco de dados bem-sucedida!"
    except Exception as e:
        return f"Erro ao conectar ao banco de dados: {e}"

@app.route('/total_registros', methods=['GET'])
def total_registros():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(sql.SQL("SELECT COUNT(*) FROM censo2022"))
        total_reg = cur.fetchone()[0]
        cur.close()
        conn.close()
        return jsonify({"total_registros": total_reg})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/total_pessoas', methods=['GET'])
def total_pessoas():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute(sql.SQL("SELECT SUM(pessoas) FROM censo2022"))
    total_p = cur.fetchone()[0]
    cur.close()
    conn.close()
    return jsonify({"total_pessoas": total_p})

def create_endpoint(endpoint, query, endpoint_name):
    @app.route(f"{endpoint}/<int:page>", methods=['GET'], endpoint=endpoint_name)
    def generic_endpoint(page):
        # Definir paginação
        per_page = request.args.get('per_page', 10, type=int)
        offset = (page - 1) * per_page
        # Definir a query do endpoint
        paginated_query = f"""
            {query}
            LIMIT {per_page} OFFSET {offset}
        """

        # Criar conecção com psql e rodar a query puxando todos os resultados
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(sql.SQL(paginated_query))
        rows = cur.fetchall()
        columns = [desc[0] for desc in cur.description]
        
        # Descobrir a quantidade de registros
        count_query = sql.SQL(f"SELECT COUNT(*) FROM ({query}) AS subquery")
        cur.execute(count_query)
        total_records = cur.fetchone()[0]
        
        # Fechar a conecção com o psql
        cur.close()
        conn.close()
        
        # Definir a quantidade de páginas de acordo com a quantidade de registros
        total_pages = (total_records + per_page - 1) // per_page

        response = {
            'page': page,
            'per_page': per_page,
            'total_pages': total_pages,
            'total_records': total_records,
            'data': [dict(zip(columns, row)) for row in rows]
        }
        # Gerar HTML com botões de navegação e tabela para os dados
        prev_page = max(page - 1, 1)
        next_page = min(page + 1, total_pages)
        table_header = "".join(f"<th>{col}</th>" for col in columns)
        table_rows = "".join(
            "<tr>" + "".join(f"<td>{value}</td>" for value in row.values()) + "</tr>"
            for row in response['data']
        )
        html_content = f"""
            <h1>Data for Page {page}</h1>
            <table border="1">
                <thead>
                    <tr>{table_header}</tr>
                </thead>
                <tbody>
                    {table_rows}
                </tbody>
            </table>
            <button onclick="location.href='{endpoint}/{prev_page}'">Previous</button>
            <button onclick="location.href='{endpoint}/{next_page}'">Next</button>
        """
        return render_template_string(html_content)
        ## Retorno sem botões e tabela:
        # return jsonify(response)
    
    generic_endpoint.__name__ = endpoint_name
    app.route(f"{endpoint}/<int:page>", methods=['GET'], endpoint=endpoint_name)(generic_endpoint)

# Lista de endpoints (\nome_do_endpoint, query, nome_do_endpoint)
endpoints = [
    ("/pessoas_estado", """
        SELECT e.estado, SUM(c2.pessoas) 
        FROM censo2022 AS c2 
        LEFT JOIN estados AS e 
        ON c2.uf = e.uf 
        GROUP BY e.estado 
        ORDER BY e.estado
    """, "pessoas_estado") , 
    ('/pessoas_estado_raca', """
        SELECT e.estado 
            , SUM(CASE WHEN c2.raca = 'Amarela' THEN c2.pessoas ELSE 0 END) AS Amarelos
            , SUM(CASE WHEN c2.raca = 'Branca' THEN c2.pessoas ELSE 0 END) AS Brancos
            , SUM(CASE WHEN c2.raca = 'Indígena' THEN c2.pessoas ELSE 0 END) AS Indigenas
            , SUM(CASE WHEN c2.raca = 'Parda' THEN c2.pessoas ELSE 0 END) AS Pardos
            , SUM(CASE WHEN c2.raca = 'Preta' THEN c2.pessoas ELSE 0 END) AS Pretos 
        FROM censo2022 AS c2 
        LEFT JOIN estados AS e 
            ON c2.uf = e.uf 
        GROUP BY e.estado 
        ORDER BY e.estado
    """, "pessoas_estado_raca") ,
    ('/Mais_Mulheres', """
        SELECT c2.municipio 
            , c2.uf
            , ROUND(CAST(SUM(CASE WHEN c2.sexo = 'Mulheres' THEN c2.pessoas ELSE 0 END)AS NUMERIC)/SUM(pessoas)*100,1)  || '%' AS Mulheres
            , SUM(CASE WHEN c2.sexo = 'Mulheres' THEN c2.pessoas ELSE 0 END) AS total_Mulheres
        FROM censo2022 AS c2
        GROUP BY c2.municipio, c2.uf
        ORDER BY Mulheres DESC
        -- LIMIT 10
    """, "Mais_Mulheres") , 
    ('/disp_idade', """
        SELECT c2.municipio 
            , c2.uf
            , ROUND(CAST(SUM(CASE WHEN i.age >=65 THEN c2.pessoas ELSE 0 END) AS NUMERIC)/SUM(c2.pessoas)*100,3) || '%' AS idosos
            , ROUND(CAST(SUM(CASE WHEN i.age <=16 THEN c2.pessoas ELSE 0 END) AS NUMERIC)/SUM(c2.pessoas)*100,3) || '%' AS crianças
            , ROUND(CAST(SUM(PESSOAS) - (SUM(CASE WHEN i.age >=65 THEN c2.pessoas ELSE 0 END) + SUM(CASE WHEN i.age <=16 THEN c2.pessoas ELSE 0 END)) AS NUMERIC)/SUM(c2.pessoas)*100,3) || '%'  AS Adultos
            , ROUND(ABS(CAST((SUM(CASE WHEN i.age >=65 THEN c2.pessoas ELSE 0 END)-SUM(CASE WHEN i.age <=16 THEN c2.pessoas ELSE 0 END)) AS NUMERIC)) *100 /SUM(c2.pessoas), 3) AS dif
        FROM censo2022 AS c2
        LEFT JOIN idades AS i
            ON c2.idade = i.idade
        GROUP BY c2.municipio, c2.uf
        ORDER BY adultos --DESC
        -- LIMIT 5;
    """, "disp_idade") , 
    ('/disp_sexo', """
        SELECT c2.municipio
            , c2.uf
            , ROUND(CAST(SUM(CASE WHEN c2.sexo = 'Mulheres' THEN c2.pessoas ELSE 0 END)AS NUMERIC)/SUM(pessoas)*100,1)  || '%' AS Mulheres
            , ROUND(CAST(SUM(CASE WHEN c2.sexo = 'Homens' THEN c2.pessoas ELSE 0 END)AS NUMERIC)/SUM(pessoas)*100,1)  || '%' AS Homens
            , ROUND(ABS(CAST(SUM(CASE WHEN c2.sexo = 'Mulheres' THEN c2.pessoas ELSE 0 END)-SUM(CASE WHEN c2.sexo = 'Homens' THEN c2.pessoas ELSE 0 END) AS NUMERIC))*100/SUM(pessoas),2)  || '%' AS dif 
        FROM censo2022 AS c2
        GROUP BY c2.municipio, c2.uf
        ORDER BY dif DESC
        -- LIMIT 5;
     """, "disp_sexo") , 
    ('/media_idade', """
        (SELECT c2.municipio
            , c2.uf
            , ROUND(SUM(age*pessoas)/sum(pessoas),1) AS idade_media
        FROM censo2022 AS c2
        LEFT JOIN idades AS i
            ON c2.idade = i.idade
        GROUP BY c2.municipio, c2.uf
        ORDER BY idade_media 
        LIMIT 5)
        UNION
        (SELECT c2.municipio
            , c2.uf
            , ROUND(SUM(age*pessoas)/sum(pessoas),1) AS idade_media
        FROM censo2022 AS c2
        LEFT JOIN idades AS i
            ON c2.idade = i.idade
        GROUP BY c2.municipio, c2.uf
        ORDER BY idade_media DESC
        LIMIT 5)
        ORDER BY idade_media
    """, "media_idade") 
    # Adicionar mais endpoints aqui
]

# Executar a função de criar endpoint com a lista de endpoints
for endpoint, query, endpoint_name in endpoints:
    create_endpoint(endpoint, query, endpoint_name)


if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5000)
