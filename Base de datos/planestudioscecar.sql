-- CREATE DATABASE IF NOT EXISTS planestudiocecar;
USE planestudiocecar;

-- Desactivar las restricciones de clave externa
SET FOREIGN_KEY_CHECKS = 0;
-- luego toca activarlos con =1 

create table if not exists  planestudiocecar.facultad (

idFacultad INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombreFacultad VARCHAR(55),
correoElectronico VARCHAR(55)
);

create table if not exists  planestudiocecar.programa (

idPrograma INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombrePrograma VARCHAR(55),
correoElectronico VARCHAR(55),
numSemestre INT,
facultad_idFacultad INT,
FOREIGN KEY (facultad_idFacultad)
REFERENCES facultad(idFacultad)
);

create table if not exists  planestudiocecar.estudiante (

idEstudiante INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombreEstudiante VARCHAR(55),
direccion VARCHAR(55),
telefono BIGINT,
sexo CHAR,
programa_idPrograma INT,
FOREIGN KEY (programa_idPrograma)
REFERENCES programa(idPrograma)
);



create table if not exists  planestudiocecar.materia (

idMateria INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombreMateria VARCHAR(55),
semestre INT,
numCreditos INT
);

create table if not exists planestudiocecar.programa_materia(
programa_idPrograma INT,
materia_idMateria INT,
PRIMARY KEY (programa_idPrograma ,materia_idMateria ),
FOREIGN KEY (programa_idPrograma)
REFERENCES programa(idPrograma),
FOREIGN KEY (materia_idMateria)
REFERENCES materia(idMateria)
);


create table if not exists planestudiocecar.estudiante_materia(
estudiante_idEstudiante INT,
materia_idMateria INT,
PRIMARY KEY (estudiante_idEstudiante ,materia_idMateria ),
FOREIGN KEY (estudiante_idEstudiante)
REFERENCES estudiante(idEstudiante),
FOREIGN KEY (materia_idMateria)
REFERENCES materia(idMateria)
);
 
-- Describo tabla para mirar sus filas y poder insertar datos de forma exacta
DESCRIBE facultad;
-- Elimino los datos de la tabla para no tener duplicados 
TRUNCATE TABLE facultad;
-- creacion de tabla  los valores autoincrementables toca insertar en null 
INSERT INTO facultad
VALUES 
( null ,"ciencias basicas, ingenieria y arquitectura", "ingenieria@cecar.edu.co"),
( null ,"derecho y ciencias politicas", "derecho@cecar.edu.co"),
( null ,"humanidades y educacion", "humanidades@cecar.edu.co"),
( null ,"ciencias economicas y administrativas", "ingenieria@cecar.edu.co");


-- Creacion de los programas con sus respectivas facultades
DESCRIBE programa; 
TRUNCATE TABLE programa; 
INSERT INTO programa 
VALUES 
( NULL , "ingenieria industrial" , "ingindustrial@cecar.edu.co" , 10 , 1),
( NULL , "ingenieria de sistemas" , "ingsistemas@cecar.edu.co" , 10 , 1),
( NULL , "diseño industrial" , "diseñoindustrial@cecar.edu.co" , 9 , 1),
( NULL , "arquitectura" , "arquitectura@cecar.edu.co" , 9 , 1),
( NULL , "derecho" , "derecho@cecar.edu.co" , 10 , 2),
( NULL , "ciencias del deporte y actividad fisica" , "industrial@cecar.edu.co" , 9 , 3),
( NULL , "psicologia" , "industrial@cecar.edu.co" , 9 , 3),
( NULL , "trabajo social" , "industrial@cecar.edu.co" , 9 , 3),
( NULL , "licenciatura en educacion infantil" , "industrial@cecar.edu.co" , 9 , 3),
( NULL , "licenciatura en literatura y lengua castellana" , "industrial@cecar.edu.co" , 9 , 3),
( NULL , "administracion de empresas" , "industrial@cecar.edu.co" , 9 , 4),
( NULL , "contaduria publica" , "industrial@cecar.edu.co" , 9 , 4),
( NULL , "economia" , "industrial@cecar.edu.co" , 9 , 4);
 
 DESCRIBE materia;
 TRUNCATE TABLE materia;
 INSERT INTO materia 
 VALUES
( NULL , "Introduccion Ing.sistemas", 1 , 3),
( NULL , "taller de lengua 1 ", 1 , 3),
( NULL , "tecnicas de aprendizaje", 1 , 2),
( NULL , "ingles 1", 1 , 2),
( NULL , "matematicas", 1 , 2),
( NULL , "vida universitaria", 1 , 1),
( NULL , " programacion de computadores", 1 , 3),
( NULL , "algebra lineal", 2 , 3),
( NULL , "taller de lengua", 2 , 3),
( NULL , "optativa 1", 2 , 2),
( NULL , "ingles 2", 2 , 2),
( NULL , "logica teorica", 2 , 2),
( NULL , "alculo diferencial", 2 , 3),
( NULL , "programacion avanzada", 2 , 3),
( NULL , "constitucion politica y democracia", 3 , 2),
( NULL , "optativa 2", 3 , 2),
( NULL , "ingles 3", 3 , 2),
( NULL , "calculo integral", 3 , 3),
( NULL , "mecanica", 3 , 3),
( NULL , "programacion web", 3 , 3),
( NULL , "arquitectura y modelamiento de datos", 3 , 2);

DESCRIBE estudiante;
TRUNCATE TABLE estudiante;
INSERT INTO estudiante 
VALUES 
( NULL, "Carlos Olaya", "TRVS 28B", 3215039258, "M",2),
( NULL, "Anahy Cabeza", "TRVS 27B", 3215039257, "F", 7),
( NULL, "Juan ramirez", "TRVS 26B", 3215039256, "M",3),
( NULL, "Jose cabeza", "TRVS 25B", 3215039255, "M",2),
( NULL, "Elkin silgado", "TRVS 24B", 3215039254, "M",5);


DESCRIBE estudiante_materia;
TRUNCATE TABLE estudiante_materia;
INSERT INTO estudiante_materia
VALUES 
( 4 , 1),
( 4 , 2),
( 4 , 3),
( 4 , 4),
( 4 , 5),
( 4 , 6),
( 4 , 7),
( 1 , 1),
( 1 , 14),
( 1 , 18),
( 1 , 21),
( 1 , 17),
( 3 , 1),
( 3 , 17),
( 3 , 9);

SELECT  * FROM estudiante
WHERE idEstudiante =1 or idEstudiante=3;

select MAX(idEstudiante) ,MIN(IdEstudiante) FROM estudiante;


SELECT* FROM estudiante_materia;
describe materia;

SELECT GROUP_CONCAT(DISTINCT nombreMateria)AS Materias,nombreEstudiante

FROM estudiante_materia
JOIN estudiante ON estudiante_materia.estudiante_idEstudiante = estudiante.idEstudiante
JOIN materia ON estudiante_materia.materia_idMateria = materia.idMateria
GROUP BY nombreEstudiante;

SELECT nombreMateria , nombreEstudiante
FROM estudiante_materia
JOIN estudiante ON estudiante_materia.estudiante_idEstudiante = estudiante.idEstudiante
JOIN materia ON estudiante_materia.materia_idMateria = materia.idMateria
GROUP BY nombreMateria , nombreEstudiante;

SELECT * FROM estudiante
ORDER BY nombreEstudiante;



