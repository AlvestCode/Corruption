/***************************************
Asociación España Relimpia
***************************************/

-- CONSTRUCCIÓN DE LA BASE DE DATOS 
-- Se crea la base de datos y se utiliza el comando USE para operar en ella

DROP DATABASE IF EXISTS CasosCorrupcion;

CREATE DATABASE CasosCorrupcion;
USE CasosCorrupcion;

-- Se crean las tablas

CREATE TABLE periodico (
codPeriodico SMALLINT, 
nombre VARCHAR(50) NOT NULL,
direccion VARCHAR(88) NOT NULL,
formato VARCHAR(7) NOT NULL,
pagWeb VARCHAR(40),
ambito VARCHAR(30) NOT NULL,
PRIMARY KEY(codPeriodico)
);

-- Se establece un grupo de posibles valores para los atributos formato y ámbito
ALTER TABLE periodico ADD CONSTRAINT CHECK (formato IN ('Papel', 'Digital'));
ALTER TABLE periodico ADD CONSTRAINT CHECK (ambito IN ('Local', 'Comarcal', 'Nacional', 'Internacional'));

CREATE TABLE parPolitico (
codParpolitico SMALLINT,
nombre VARCHAR(50) NOT NULL,
direccion VARCHAR(88) NOT NULL,
PRIMARY KEY(codparPolitico)
);

CREATE TABLE persona (
codPersona SMALLINT,
DNI CHAR(9) NOT NULL UNIQUE,
nombre VARCHAR(50) NOT NULL, 
calle VARCHAR(44) NOT NULL, 
ciudad VARCHAR(44) NOT NULL,
patrimonio NUMERIC(13,2) NOT NULL, 
cargo VARCHAR(50),
PRIMARY KEY(codPersona)
);

CREATE TABLE juez (
codJuez SMALLINT,
nombre VARCHAR(50) NOT NULL, 
direccion VARCHAR(88) NOT NULL,
fecNacimiento DATE NOT NULL,
fecAlta DATE NOT NULL,
PRIMARY KEY(codJuez)
);

CREATE TABLE caso (
codCaso SMALLINT,
nombre VARCHAR(50) NOT NULL,
descripcion VARCHAR(500) NOT NULL,
dinDesviado NUMERIC(12,2) NOT NULL,
dictamen VARCHAR(200) NOT NULL,
idJuez SMALLINT,
fecha DATE NOT NULL,
idPeriodico SMALLINT,
PRIMARY KEY(codCaso),
FOREIGN KEY(idJuez) REFERENCES juez(codJuez) 
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY(idPeriodico) REFERENCES periodico(codPeriodico) 
ON DELETE RESTRICT
ON UPDATE CASCADE
);

CREATE TABLE ambito (
idCaso SMALLINT,  
ambito VARCHAR(15),
PRIMARY KEY(idCaso, ambito),
FOREIGN KEY(idCaso) REFERENCES caso(codCaso) 
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE familia (
idPersona1 SMALLINT,
idPersona2 SMALLINT,
parentesco VARCHAR(15) NOT NULL,
PRIMARY KEY(idPersona1, idPersona2),
FOREIGN KEY(idPersona1) REFERENCES persona(codPersona) 
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY(idPersona2) REFERENCES persona(codPersona) 
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE telefonos (
idparPolitico SMALLINT,
telefono NUMERIC(9,0),
PRIMARY KEY(idparPolitico, telefono),
FOREIGN KEY (idparPolitico) REFERENCES parPolitico(codparPolitico)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE implica (
idCaso SMALLINT,
idPersona SMALLINT,
PRIMARY KEY(idCaso, idPersona),
FOREIGN KEY (idCaso) REFERENCES caso(codCaso)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (idPersona) REFERENCES persona(codPersona)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE pertenece (
idPersona SMALLINT,
idparPolitico SMALLINT,
puesto VARCHAR(50),
PRIMARY KEY(idPersona, idparPolitico),
FOREIGN KEY (idPersona) REFERENCES persona(codPersona)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (idparPolitico) REFERENCES parPolitico(codparPolitico)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE afin (
idparPolitico SMALLINT,
idPeriodico SMALLINT,
PRIMARY KEY(idparPolitico, idPeriodico),
FOREIGN KEY (idparPolitico) REFERENCES parPolitico(codparPolitico)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (idPeriodico) REFERENCES periodico(codPeriodico)
ON DELETE CASCADE
ON UPDATE CASCADE
);

-- CARGA DE LOS DATOS
-- Se cargan datos mediante archivos

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/parPolitico.csv' 
IGNORE INTO TABLE parPolitico
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/juez.csv' 
IGNORE INTO TABLE juez
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n';

-- Se cargan datos con la claúsula INSERT INTO

INSERT INTO  periodico VALUES (1, 'ABC', 'Calle de Juan Ignacio Luca de Tena 7 ,Madrid', 'Digital', 'www.abc.es', 'Nacional');
INSERT INTO  periodico VALUES (2, 'La Vanguardia', 'Avenida Diagonal 477  ,Barcelona', 'Digital', 'www.lavanguardia.com', 'Nacional');
INSERT INTO  periodico VALUES (3, 'El Mundo', 'Avenida de San Luis 25 ,Madrid', 'Digital', 'www.elmundo.es', 'Nacional');
INSERT INTO  periodico VALUES (4, 'Diario Barcelona', 'Carrer de Neptu 6 ,Barcelona', 'Digital', 'www.diariobarcelona.com', 'Local');
INSERT INTO  periodico VALUES (5, 'Noticias para Municipios', 'Calle Ferrocarril 22 ,Getafe', 'Digital', 'www.noticiasparamunicipios.com', 'Comarcal');


INSERT INTO  telefonos VALUES (1, 956874622);
INSERT INTO  telefonos VALUES (1, 967423155);
INSERT INTO  telefonos VALUES (1, 956875622);
INSERT INTO  telefonos VALUES (2, 982215467);
INSERT INTO  telefonos VALUES (2, 974235614);
INSERT INTO  telefonos VALUES (3, 953462815);
INSERT INTO  telefonos VALUES (3, 932648758);
INSERT INTO  telefonos VALUES (4, 967823415);
INSERT INTO  telefonos VALUES (4, 982245761);
INSERT INTO  telefonos VALUES (4, 963823415);
INSERT INTO  telefonos VALUES (5, 969674521);
INSERT INTO  telefonos VALUES (5, 995124245);

INSERT INTO afin VALUES (2, 1);
INSERT INTO afin VALUES (4, 2);
INSERT INTO afin VALUES (2, 3);
INSERT INTO afin VALUES (4, 4);

INSERT INTO caso VALUES (1,	'Caso Pujol',	'Se investiga al Expresidente de la Generalidad de Catalunna Jordi Puyol Soley su  mujer Marta Ferrusola Llados y otros miembros de su familia por los delitos de cohecho, trafico de influencias, delito fiscal, blanqueo de capitales, prevaricacion, malversacion y falsedad.',	69000000,	'Pendiente de dictamen.',	1,	'2014-05-07',	4);
INSERT INTO caso VALUES (2,	'Caso Aceinsa',	'Se investiga al alcalde de Salamanca, Alfonso Fernandez Mannueco, dos concejales y el jefe de la Policia Local por los contratos ilegales de Aceinsa, concesionaria del alumbrado y la sennalizacion, a la que se ha seguido pagando fuertes cantidades por contratos que habian agotado todas sus prorrogas y estaban caducados.',	300000,	'Se declara a los implicados culpables.',	2,	'2017-12-23',	1);
INSERT INTO caso VALUES (3,	'Caso Valle Gran Rey',	'Se investiga  a Ruyman Garcia, por un delito de prevaricacion y otro de malversacion de fondos publicos de manera continuada.',	7412,	'Se declara culpable al implicado.',	3,	'2012-05-03',	3);
INSERT INTO caso VALUES (4,	'Caso Somos Alcala',	'Se investiga a varios concejales del Ayuntamiento de Alcala de Henares por un delito de prevaricacion administrativa.',	40000,	'Pendiente de dictamen.', 	4,	'2018-12-30',	5);
INSERT INTO caso VALUES (5,	'Caso Banna',	'Se investiga a Ricardo Banna por cometer un delito fiscal relacionado con la compra venta de un terreno.',	877120,	'Se declara a los implicados culpables.',	5,	'2016-07-26',	2);

INSERT INTO persona VALUES (1, '42291432K', 'Fernando Javier Rodriguez Alonso' , 'Calle de Balmes 5', 'Salamanca', 150000, 'Ex-concejal de Salamanca');
INSERT INTO persona VALUES (2, '77339437M',	'Carlos Manuel Garcia Carbayo', 'Camino de las Aguas 2', 'Salamanca', 300000, 'Alcalde de Salamanca');
INSERT INTO persona VALUES (3, '18407290E', 'Alfonso Fernandez Mannueco', 'Plaza de Breton 7', 'Salamanca', 200000, 'Ex-Alcalde de Salamanca');
INSERT INTO persona VALUES (4, '89033629P', 'Jose Manuel Fernandez Martin', 'Calle de Caleros 13', 'Salamanca', 200000, 'Jefe de la Policia Local de Salamanca');
INSERT INTO persona VALUES (5, '17176866Y', 'Ruyman Garcia', 'Calle San Cristobal 45',	'Santa Cruz de Tenerife', 200000, 'Ex-Alcalde de Santa Cruz de Tenerife');
INSERT INTO persona VALUES (6, '77492373Z', 'Laura Martin', 'Avenida de Madrid 9', 'Alcala de Henares', 70000, 'Concejal de Alcala de Henares');
INSERT INTO persona VALUES (7, '92866836N', 'Jesus Abad', 'Calle de Libreros 10', 'Alcala de Henares', 80000, 'Concejal de Alcala de Henares');
INSERT INTO persona VALUES (8, '47623423Z', 'Brianda Yannez', 'Plaza de San Diego 9', 'Alcala de Henares', 60000, 'Concejal de Alcala de Henares');
INSERT INTO persona VALUES (9, '42455715S', 'Alberto Egido', 'Plaza de Palacio 1', 'Alcala de Henares', 70000, 'Concejal de Alcala de Henares');
INSERT INTO persona VALUES (10, '31380926W', 'Ricardo Ramon Banna Oubinna', 'Calle Murillo 30', 'Las Palmas de Gran Canaria', 120000, 'Administrador Ibertowers Canarias SL');
INSERT INTO persona VALUES (11, '11687829B', 'Jorge Javier Pousada Doural', 'Calle de los Manzanos 21' ,'Las Palmas de Gran Canaria', 90000, 'Administrador Ibertowers Canarias SL');
INSERT INTO persona VALUES (12, '37742064F', 'Jordi Pujol Soley', 'Avenida Felix Millet 3', 'Barcelona', 2000000, 'Presidente de la Generalidad');

INSERT INTO persona(codPersona, DNI, Nombre, Calle, Ciudad, Patrimonio) VALUES (13, '42236444A', 'Marta Ferrusola Llados', 'Avenida Felix Millet 3', 'Barcelona', 2000000);
INSERT INTO persona(codPersona, DNI, Nombre, Calle, Ciudad, Patrimonio) VALUES (14, '88123260W', 'Jordi Pujol Ferrusola', 'Rambla del Raval 8', 'Barcelona', 1000000);
INSERT INTO persona(codPersona, DNI, Nombre, Calle, Ciudad, Patrimonio) VALUES (15, '71552110F', 'Oleguer Pujol Ferrusola', 'Rambla del Poblenau 2', 'Barcelona', 1000000);
INSERT INTO persona(codPersona, DNI, Nombre, Calle, Ciudad, Patrimonio) VALUES (16, '46340323S', 'Mireia Pujol Ferrusola', 'Calle de Andrade 5', 'Barcelona', 1000000);
INSERT INTO persona(codPersona, DNI, Nombre, Calle, Ciudad, Patrimonio) VALUES (17, '61418679P', 'Marta Pujol Ferrusola','Calle de Aragón 8',	'Barcelona', 1000000);
INSERT INTO persona(codPersona, DNI, Nombre, Calle, Ciudad, Patrimonio) VALUES (18, '20898705P','Pere Pujol Ferrusola', 'Calle de Avinyo 12', 'Barcelona', 1000000);
INSERT INTO persona(codPersona, DNI, Nombre, Calle, Ciudad, Patrimonio) VALUES (19, '36963846V', 'Oriol Pujol Ferrusola', 'Avenida del Paralelo 5','Barcelona',1000000);
INSERT INTO persona(codPersona, DNI, Nombre, Calle, Ciudad, Patrimonio) VALUES (20, '90435423K', 'Anna Vidal Maragall', 'Avenida del Paralelo 5', 'Barcelona', 1000000);

INSERT INTO pertenece(idPersona, idparPolitico) VALUES (1, 2);
INSERT INTO pertenece(idPersona, idparPolitico) VALUES (2, 2);
INSERT INTO pertenece(idPersona, idparPolitico) VALUES (5, 1);
INSERT INTO pertenece(idPersona, idparPolitico) VALUES (6, 3);
INSERT INTO pertenece(idPersona, idparPolitico) VALUES (7, 3);
INSERT INTO pertenece(idPersona, idparPolitico) VALUES (8, 3);
INSERT INTO pertenece(idPersona, idparPolitico) VALUES (9, 3);

INSERT INTO pertenece VALUES (3, 2, 'Presidente del PP en Castilla y Leon');
INSERT INTO pertenece VALUES (10, 5, 'Presidente de VOX en Las Palmas de Gran Canaria');
INSERT INTO pertenece VALUES (12, 4, 'Presidente del CDC');

INSERT INTO ambito VALUES (1, 'Ayuntamiento');
INSERT INTO ambito VALUES (1, 'Comunidad');
INSERT INTO ambito VALUES (1, 'Estado');
INSERT INTO ambito VALUES (2, 'Ayuntamiento');
INSERT INTO ambito VALUES (3, 'Ayuntamiento');
INSERT INTO ambito VALUES (4, 'Ayuntamiento');
INSERT INTO ambito VALUES (5, 'Ayuntamiento');

INSERT INTO implica VALUES (2, 1);
INSERT INTO implica VALUES (2, 2);
INSERT INTO implica VALUES (2, 3);
INSERT INTO implica VALUES (2, 4);
INSERT INTO implica VALUES (3, 5);
INSERT INTO implica VALUES (4, 6);
INSERT INTO implica VALUES (4, 7);
INSERT INTO implica VALUES (4, 8);
INSERT INTO implica VALUES (4, 9);
INSERT INTO implica VALUES (5, 10);
INSERT INTO implica VALUES (5, 11);
INSERT INTO implica VALUES (1, 12);
INSERT INTO implica VALUES (1, 13);
INSERT INTO implica VALUES (1, 14);
INSERT INTO implica VALUES (1, 15);
INSERT INTO implica VALUES (1, 16);
INSERT INTO implica VALUES (1, 17);
INSERT INTO implica VALUES (1, 18);
INSERT INTO implica VALUES (1, 19);
INSERT INTO implica VALUES (1, 20);

INSERT INTO familia VALUES (12, 13, 'Mujer');
INSERT INTO familia VALUES (12, 14, 'Hijo');
INSERT INTO familia VALUES (12, 15, 'Hijo');
INSERT INTO familia VALUES (12, 16, 'Hija');
INSERT INTO familia VALUES (12, 17, 'Hija');
INSERT INTO familia VALUES (12, 18, 'Hijo');
INSERT INTO familia VALUES (12, 19, 'Hijo');
INSERT INTO familia VALUES (12, 20, 'Nuera');

INSERT INTO familia VALUES (13, 12, 'Marido');
INSERT INTO familia VALUES (13, 14, 'Hijo');
INSERT INTO familia VALUES (13, 15, 'Hijo');
INSERT INTO familia VALUES (13, 16, 'Hija');
INSERT INTO familia VALUES (13, 17, 'Hija');
INSERT INTO familia VALUES (13, 18, 'Hijo');
INSERT INTO familia VALUES (13, 19, 'Hijo');
INSERT INTO familia VALUES (13, 20, 'Nuera');

INSERT INTO familia VALUES (14, 12, 'Padre');
INSERT INTO familia VALUES (14, 13, 'Madre');
INSERT INTO familia VALUES (14, 15, 'Hermano');
INSERT INTO familia VALUES (14, 16, 'Hermana');
INSERT INTO familia VALUES (14, 17, 'Hermana');
INSERT INTO familia VALUES (14, 18, 'Hermano');
INSERT INTO familia VALUES (14, 19, 'Hermano');
INSERT INTO familia VALUES (14, 20, 'Cuñada');

INSERT INTO familia VALUES (15, 12, 'Padre');
INSERT INTO familia VALUES (15, 13, 'Madre');
INSERT INTO familia VALUES (15, 14, 'Hermano');
INSERT INTO familia VALUES (15, 16, 'Hermana');
INSERT INTO familia VALUES (15, 17, 'Hermana');
INSERT INTO familia VALUES (15, 18, 'Hermano');
INSERT INTO familia VALUES (15, 19, 'Hermano');
INSERT INTO familia VALUES (15, 20, 'Cuñada');

INSERT INTO familia VALUES (16, 12, 'Padre');
INSERT INTO familia VALUES (16, 13, 'Madre');
INSERT INTO familia VALUES (16, 14, 'Hermano');
INSERT INTO familia VALUES (16, 15, 'Hermano');
INSERT INTO familia VALUES (16, 17, 'Hermana');
INSERT INTO familia VALUES (16, 18, 'Hermano');
INSERT INTO familia VALUES (16, 19, 'Hermano');
INSERT INTO familia VALUES (16, 20, 'Cuñada');

INSERT INTO familia VALUES (17, 12, 'Padre');
INSERT INTO familia VALUES (17, 13, 'Madre');
INSERT INTO familia VALUES (17, 14, 'Hermano');
INSERT INTO familia VALUES (17, 15, 'Hermano');
INSERT INTO familia VALUES (17, 16, 'Hermana');
INSERT INTO familia VALUES (17, 18, 'Hermano');
INSERT INTO familia VALUES (17, 19, 'Hermano');
INSERT INTO familia VALUES (17, 20, 'Cuñada');

INSERT INTO familia VALUES (18, 12, 'Padre');
INSERT INTO familia VALUES (18, 13, 'Madre');
INSERT INTO familia VALUES (18, 14, 'Hermano');
INSERT INTO familia VALUES (18, 15, 'Hermano');
INSERT INTO familia VALUES (18, 16, 'Hermana');
INSERT INTO familia VALUES (18, 17, 'Hermana');
INSERT INTO familia VALUES (18, 19, 'Hermano');
INSERT INTO familia VALUES (18, 20, 'Cuñada');

INSERT INTO familia VALUES (19, 12, 'Padre');
INSERT INTO familia VALUES (19, 13, 'Madre');
INSERT INTO familia VALUES (19, 14, 'Hermano');
INSERT INTO familia VALUES (19, 15, 'Hermano');
INSERT INTO familia VALUES (19, 16, 'Hermana');
INSERT INTO familia VALUES (19, 17, 'Hermana');
INSERT INTO familia VALUES (19, 18, 'Hermano');
INSERT INTO familia VALUES (19, 20, 'Mujer');

INSERT INTO familia VALUES (20, 12, 'Suegro');
INSERT INTO familia VALUES (20, 13, 'Suegra');
INSERT INTO familia VALUES (20, 14, 'Cuñado');
INSERT INTO familia VALUES (20, 15, 'Cuñado');
INSERT INTO familia VALUES (20, 16, 'Cuñada');
INSERT INTO familia VALUES (20, 17, 'Cuñada');
INSERT INTO familia VALUES (20, 18, 'Cuñado');
INSERT INTO familia VALUES (20, 19, 'Marido');

-- CONSULTAS

-- Ciudad con mayor número de corruptos 
SELECT Ciudad, COUNT(*) AS Corruptos
FROM caso AS c , persona AS p , implica AS I
WHERE c.codCaso = i.idCaso AND p.codPersona = i.idPersona AND dictamen LIKE '%culpable%'
GROUP BY ciudad
ORDER BY Corruptos DESC
LIMIT 1;

-- Edad media para conseguir la plaza de juez 
SELECT ROUND(AVG(YEAR(fecAlta) - YEAR(fecNacimiento)),0) AS Edad_media FROM juez;

-- Patrimonio medio de los corruptos 
SELECT ROUND(AVG(patrimonio),2) AS Patrimonio_medio
FROM caso AS c , persona AS p , implica AS i
WHERE c.codCaso = i.idCaso AND p.codPersona = i.idPersona AND dictamen LIKE '%culpable%';

-- Partido político y número de corruptos  
SELECT par.Nombre, COUNT(t.codPersona) AS Corruptos
FROM (SELECT p.codPersona FROM caso AS c , persona AS p , implica AS i
	  WHERE c.codCaso = i.idCaso AND p.codPersona = i.idPersona AND dictamen LIKE '%culpable%') AS t,
      pertenece AS per, parPolitico AS par
WHERE t.codPersona = per.idPersona 
AND par.codparPoliticO = per.idparPolitico
GROUP BY par.Nombre
ORDER BY Corruptos DESC;

-- Partido político y número de periódicos afines 
SELECT par.Nombre, COUNT(codPeriodico) AS N_periodicos
FROM parPolitico AS par, periodico AS p, afin AS a
WHERE par.codparPolitico = a.idparPolitico
AND p.codPeriodico = a.idPeriodico 
GROUP BY par.Nombre;

-- Número de personas implicadas en cada caso 
SELECT c.Nombre, COUNT(i.idPersona) AS Implicados
FROM caso AS c
INNER JOIN implica AS i
ON c.codCaso = i.idCaso
GROUP BY c.Nombre
ORDER BY Implicados DESC;

-- Periódicos de ámbito nacional con página web
SELECT Nombre, Ambito, pagWeb
FROM periodico 
WHERE ambito = 'Nacional';

-- Top 3 casos que más dinero han desviado 
SELECT nombre, dinDesviado 
FROM caso
ORDER BY dinDesviado DESC
LIMIT 3;

-- Casos descubiertos por periódicos de ámbito Nacional
SELECT c.Nombre, p.Nombre, p.Ambito
FROM caso AS c
INNER JOIN periodico AS p
ON c.idPeriodico = p.codPeriodico
WHERE ambito = 'Nacional';

-- Personas con más de 100000 euros de patrimonio implicadas en un caso de prevaricación
SELECT p.Nombre, p.Patrimonio, c.Nombre AS Nombre_caso
FROM persona AS p
INNER JOIN implica AS i
ON p.codPersona = i.idPersona
INNER JOIN caso AS c
ON c.codCaso = i.idCaso
WHERE p.Patrimonio > 100000 AND c.descripcion LIKE '%prevaricacion%';

-- Partidos políticos con más de dos números de teléfono
SELECT p.Nombre, COUNT(t.telefono) AS N_telefonos
FROM parPolitico AS p
INNER JOIN telefonos AS t
ON p.codparPolitico = t.idparPolitico
GROUP BY p.Nombre
HAVING N_telefonos > 2; 

-- Personas con más de 1000000 euros de patrimonio y más de dos familiares implicados 
SELECT p.Nombre, COUNT(f.idPersona2) AS N_familiares
FROM persona AS p
INNER JOIN familia AS f
ON p.codPersona = f.idPersona1
WHERE patrimonio > 1000000
GROUP BY p.Nombre
HAVING N_familiares > 2;

-- Personas que desempeñan algún puesto en un partido político 
SELECT p.nombre, per.puesto
FROM persona AS p 
INNER JOIN pertenece AS per
ON p.codPersona = per.idPersona
WHERE puesto IS NOT NULL;

-- Personas y jueces con su dirección
SELECT Nombre, CONCAT (Calle, ', ',Ciudad) AS Direccion 
FROM persona 
UNION ALL
SELECT Nombre, direccion 
FROM juez;

-- Casos pendientes de resolución con un número de implicados superior a la media 
SELECT c.Nombre, COUNT(i.idPersona) AS N_implicados
FROM caso AS c, implica AS i 
WHERE c.codCaso = i.idCaso AND dictamen NOT LIKE '%culpable%' OR '%inocente%'
GROUP BY c.Nombre
HAVING N_implicados > (SELECT AVG(l.N_implicados)
					   FROM (SELECT c.Nombre, COUNT(i.idPersona) AS N_implicados
							 FROM caso AS c, implica AS i 
							 WHERE c.codCaso = i.idCaso
							 GROUP BY c.Nombre) AS l);
