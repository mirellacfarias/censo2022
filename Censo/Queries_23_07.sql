-- 1. Pessoas por estado
SELECT e.estado, SUM(c2.pessoas) 
FROM censo2022 AS c2 
LEFT JOIN estados AS e 
    ON c2.uf = e.uf 
GROUP BY e.estado 
ORDER BY e.estado;

-- 2. Pessoas por raça por estado
SELECT e.estado, SUM(c2.pessoas) 
FROM censo2022 AS c2 
LEFT JOIN estados AS e 
    ON c2.uf = e.uf 
GROUP BY e.estado, c2.raca 
ORDER BY e.estado;

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
ORDER BY e.estado;

-- 3. 10 Municípios com maior proporção de mulheres/total
SELECT c2.municipio 
    , c2.uf
    , ROUND(CAST(SUM(CASE WHEN c2.sexo = 'Mulheres' THEN c2.pessoas ELSE 0 END)AS NUMERIC)/SUM(pessoas)*100,1)  || '%' AS Mulheres
FROM censo2022 AS c2
GROUP BY c2.municipio, c2.uf
ORDER BY Mulheres DESC
LIMIT 10;

-- 4. 5 Municípios com maior disparidade de idade (crianças 0~16 anos, idosos 65+ anos)
SELECT c2.municipio 
    , c2.uf
    , ROUND(CAST(SUM(CASE WHEN i.age >=65 THEN c2.pessoas ELSE 0 END) AS NUMERIC)/SUM(c2.pessoas)*100,3) || '%' AS idosos
    , ROUND(CAST(SUM(CASE WHEN i.age <=16 THEN c2.pessoas ELSE 0 END) AS NUMERIC)/SUM(c2.pessoas)*100,3) || '%' AS crianças
    , ROUND(CAST(SUM(PESSOAS) - (SUM(CASE WHEN i.age >=65 THEN c2.pessoas ELSE 0 END) + SUM(CASE WHEN i.age <=16 THEN c2.pessoas ELSE 0 END)) AS NUMERIC)/SUM(c2.pessoas)*100,3) || '%'  AS Adultos
    , ROUND(ABS(CAST((SUM(CASE WHEN i.age >=65 THEN c2.pessoas ELSE 0 END)-SUM(CASE WHEN i.age <=16 THEN c2.pessoas ELSE 0 END)) AS NUMERIC)) *100 /SUM(c2.pessoas), 3) || '%' AS dif
FROM censo2022 AS c2
LEFT JOIN idades AS i
    ON c2.idade = i.idade
GROUP BY c2.municipio, c2.uf
ORDER BY adultos --DESC
LIMIT 5;

-- 5. 5 Municípios com maior disparidade de sexo (homens e mulheres)
SELECT c2.municipio
    , c2.uf
    , ROUND(CAST(SUM(CASE WHEN c2.sexo = 'Mulheres' THEN c2.pessoas ELSE 0 END)AS NUMERIC)/SUM(pessoas)*100,1)  || '%' AS Mulheres
    , ROUND(CAST(SUM(CASE WHEN c2.sexo = 'Homens' THEN c2.pessoas ELSE 0 END)AS NUMERIC)/SUM(pessoas)*100,1)  || '%' AS Homens
    , ROUND(ABS(CAST(SUM(CASE WHEN c2.sexo = 'Mulheres' THEN c2.pessoas ELSE 0 END)-SUM(CASE WHEN c2.sexo = 'Homens' THEN c2.pessoas ELSE 0 END) AS NUMERIC))*100/SUM(pessoas),2)  || '%' AS dif 
FROM censo2022 AS c2
GROUP BY c2.municipio, c2.uf
ORDER BY dif DESC
LIMIT 5;

-- 6. 5 Municípios com maior idade média e 5 com menor idade média
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
ORDER BY idade_media;