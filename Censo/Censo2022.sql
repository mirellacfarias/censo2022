-- -- Apagar Tabelas caso já existam, para subscrevê-las
DROP TABLE IF EXISTS censo2022;
DROP TABLE IF EXISTS estados;
DROP TABLE IF EXISTS idades;
DROP TABLE IF EXISTS capitais;

-- Criar tabelas
CREATE TABLE censo2022(
    municipio VARCHAR(100),
    uf VARCHAR(2),
    idade VARCHAR(20),
    raca VARCHAR(10),
    sexo VARCHAR(10),
    pessoas INTEGER
);

CREATE TABLE estados (
    uf VARCHAR(2) PRIMARY KEY,
    estado VARCHAR(100),
    regiao VARCHAR(20),
    pais VARCHAR(20)
);

CREATE TABLE idades (
    idade VARCHAR(20),
    faixa_etaria VARCHAR(20),
    age NUMERIC
);

CREATE TABLE capitais (
    uf VARCHAR(2),
    capital VARCHAR(100)
);

-- Inserir os dados
INSERT INTO estados (uf, estado, regiao, pais) VALUES
('RO', 'Rondônia', 'Norte', 'Brasil'),
('AC', 'Acre', 'Norte', 'Brasil'),
('AM', 'Amazonas', 'Norte', 'Brasil'),
('RR', 'Roraima', 'Norte', 'Brasil'),
('PA', 'Pará', 'Norte', 'Brasil'),
('AP', 'Amapá', 'Norte', 'Brasil'),
('TO', 'Tocantins', 'Norte', 'Brasil'),
('MA', 'Maranhão', 'Nordeste', 'Brasil'),
('PI', 'Piauí', 'Nordeste', 'Brasil'),
('CE', 'Ceará', 'Nordeste', 'Brasil'),
('RN', 'Rio Grande do Norte', 'Nordeste', 'Brasil'),
('PB', 'Paraíba', 'Nordeste', 'Brasil'),
('PE', 'Pernambuco', 'Nordeste', 'Brasil'),
('AL', 'Alagoas', 'Nordeste', 'Brasil'),
('SE', 'Sergipe', 'Nordeste', 'Brasil'),
('BA', 'Bahia', 'Nordeste', 'Brasil'),
('MG', 'Minas Gerais', 'Sudeste', 'Brasil'),
('ES', 'Espírito Santo', 'Sudeste', 'Brasil'),
('RJ', 'Rio de Janeiro', 'Sudeste', 'Brasil'),
('SP', 'São Paulo', 'Sudeste', 'Brasil'),
('PR', 'Paraná', 'Sul', 'Brasil'),
('SC', 'Santa Catarina', 'Sul', 'Brasil'),
('RS', 'Rio Grande do Sul', 'Sul', 'Brasil'),
('MS', 'Mato Grosso do Sul', 'Centro-Oeste', 'Brasil'),
('MT', 'Mato Grosso', 'Centro-Oeste', 'Brasil'),
('GO', 'Goiás', 'Centro-Oeste', 'Brasil'),
('DF', 'Distrito Federal', 'Centro-Oeste', 'Brasil');

INSERT INTO capitais (uf, capital) VALUES
('RO', 'Porto Velho'),
('AC', 'Rio Branco'),
('AM', 'Manaus'),
('RR', 'Boa Vista'),
('PA', 'Belém'),
('AP', 'Macapá'),
('TO', 'Palmas'),
('MA', 'São Luis'),
('PI', 'Teresina'),
('CE', 'Fortaleza'),
('RN', 'Natal'),
('PB', 'João Pessoa'),
('PE', 'Recife'),
('AL', 'Maceió'),
('SE', 'Aracaju'),
('BA', 'Salvador'),
('MG', 'Belo Horizonte'),
('ES', 'Vitória'),
('RJ', 'Rio de Janeiro'),
('SP', 'São Paulo'),
('PR', 'Curitiba'),
('SC', 'Florianópolis'),
('RS', 'Porto Alegre'),
('MS', 'Campo Grande'),
('MT', 'Cuiabá'),
('GO', 'Goiânia'),
('DF', 'Brasília');

INSERT INTO idades (idade, faixa_etaria, age) VALUES
('Menos de 1 mês', '0 a 4 anos', 0),
('1 mês', '0 a 4 anos', 0.08),
('2 meses', '0 a 4 anos', 0.17),
('3 meses', '0 a 4 anos', 0.25),
('4 meses', '0 a 4 anos', 0.33),
('5 meses', '0 a 4 anos', 0.42),
('6 meses', '0 a 4 anos', 0.5),
('7 meses', '0 a 4 anos', 0.58),
('8 meses', '0 a 4 anos', 0.67),
('9 meses', '0 a 4 anos', 0.75),
('10 meses', '0 a 4 anos', 0.83),
('11 meses', '0 a 4 anos', 0.92),
('1 ano', '0 a 4 anos', 1),
('2 anos', '0 a 4 anos', 2),
('3 anos', '0 a 4 anos', 3),
('4 anos', '0 a 4 anos', 4),
('5 anos', '5 a 9 anos', 5),
('6 anos', '5 a 9 anos', 6),
('7 anos', '5 a 9 anos', 7),
('8 anos', '5 a 9 anos', 8),
('9 anos', '5 a 9 anos', 9),
('10 anos', '10 a 14 anos', 10),
('11 anos', '10 a 14 anos', 11),
('12 anos', '10 a 14 anos', 12),
('13 anos', '10 a 14 anos', 13),
('14 anos', '10 a 14 anos', 14),
('15 anos', '15 a 19 anos', 15),
('16 anos', '15 a 19 anos', 16),
('17 anos', '15 a 19 anos', 17),
('18 anos', '15 a 19 anos', 18),
('19 anos', '15 a 19 anos', 19),
('20 anos', '20 a 24 anos', 20),
('21 anos', '20 a 24 anos', 21),
('22 anos', '20 a 24 anos', 22),
('23 anos', '20 a 24 anos', 23),
('24 anos', '20 a 24 anos', 24),
('25 anos', '25 a 29 anos', 25),
('26 anos', '25 a 29 anos', 26),
('27 anos', '25 a 29 anos', 27),
('28 anos', '25 a 29 anos', 28),
('29 anos', '25 a 29 anos', 29),
('30 anos', '30 a 34 anos', 30),
('31 anos', '30 a 34 anos', 31),
('32 anos', '30 a 34 anos', 32),
('33 anos', '30 a 34 anos', 33),
('34 anos', '30 a 34 anos', 34),
('35 anos', '35 a 39 anos', 35),
('36 anos', '35 a 39 anos', 36),
('37 anos', '35 a 39 anos', 37),
('38 anos', '35 a 39 anos', 38),
('39 anos', '35 a 39 anos', 39),
('40 anos', '40 a 44 anos', 40),
('41 anos', '40 a 44 anos', 41),
('42 anos', '40 a 44 anos', 42),
('43 anos', '40 a 44 anos', 43),
('44 anos', '40 a 44 anos', 44),
('45 anos', '45 a 49 anos', 45),
('46 anos', '45 a 49 anos', 46),
('47 anos', '45 a 49 anos', 47),
('48 anos', '45 a 49 anos', 48),
('49 anos', '45 a 49 anos', 49),
('50 anos', '50 a 54 anos', 50),
('51 anos', '50 a 54 anos', 51),
('52 anos', '50 a 54 anos', 52),
('53 anos', '50 a 54 anos', 53),
('54 anos', '50 a 54 anos', 54),
('55 anos', '55 a 59 anos', 55),
('56 anos', '55 a 59 anos', 56),
('57 anos', '55 a 59 anos', 57),
('58 anos', '55 a 59 anos', 58),
('59 anos', '55 a 59 anos', 59),
('60 anos', '60 a 64 anos', 60),
('61 anos', '60 a 64 anos', 61),
('62 anos', '60 a 64 anos', 62),
('63 anos', '60 a 64 anos', 63),
('64 anos', '60 a 64 anos', 64),
('65 anos', '65 a 69 anos', 65),
('66 anos', '65 a 69 anos', 66),
('67 anos', '65 a 69 anos', 67),
('68 anos', '65 a 69 anos', 68),
('69 anos', '65 a 69 anos', 69),
('70 anos', '70 a 74 anos', 70),
('71 anos', '70 a 74 anos', 71),
('72 anos', '70 a 74 anos', 72),
('73 anos', '70 a 74 anos', 73),
('74 anos', '70 a 74 anos', 74),
('75 anos', '75 a 79 anos', 75),
('76 anos', '75 a 79 anos', 76),
('77 anos', '75 a 79 anos', 77),
('78 anos', '75 a 79 anos', 78),
('79 anos', '75 a 79 anos', 79),
('80 anos', '80 a 84 anos', 80),
('81 anos', '80 a 84 anos', 81),
('82 anos', '80 a 84 anos', 82),
('83 anos', '80 a 84 anos', 83),
('84 anos', '80 a 84 anos', 84),
('85 anos', '85 a 89 anos', 85),
('86 anos', '85 a 89 anos', 86),
('87 anos', '85 a 89 anos', 87),
('88 anos', '85 a 89 anos', 88),
('89 anos', '85 a 89 anos', 89),
('90 anos', '90 a 94 anos', 90),
('91 anos', '90 a 94 anos', 91),
('92 anos', '90 a 94 anos', 92),
('93 anos', '90 a 94 anos', 93),
('94 anos', '90 a 94 anos', 94),
('95 anos', '95 a 99 anos', 95),
('96 anos', '95 a 99 anos', 96),
('97 anos', '95 a 99 anos', 97),
('98 anos', '95 a 99 anos', 98),
('99 anos', '95 a 99 anos', 99),
('100 anos ou mais', '100 anos ou mais', 100);
