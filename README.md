# censo2022
Análise realizada com base no censo do IBGE de 2022

## Fonte dos dados:
SIDRA - Sistema IBGE de Recuperação Automática - https://sidra.ibge.gov.br/

## Descrição:
Devido à grande quantidade de dados e a limitação de download no site, foi necessário solicitar à SIDRA o envio dos arquivos, separados por raça para atender o limite de solicitação.
<br>Após receber os dados, foi necessário trabalhá-los, desmesclando células, filtrando valores e ajustando as colunas de acordo com o que eu precisava para trabalhar.
<br>Uni todos os dados em um dataframe, salvando-o inicialmente em arquivos excel e posteriormente em um dump da base de dados.
<br>Trabalhei com 3 containers no Docker: **python, postgres e dump**, utilizando o **docker-compose e multi-stage builds**.
<br>Com a base de dados tratada, criei endpoints com SQL queries, mostrando dados tabelados e paginados.
<br>Por fim, criei dashboards no Power BI com diversos gráficos que permitem análises variadas da população do Brasil em 2022, com relação a idade, localização, raça e sexo.

## Arquivo Power BI
O arquivo do Microsoft Power BI pode ser visualizado em: https://bit.ly/MF_Censo2022
