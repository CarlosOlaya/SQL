DROP DATABASE IF EXISTS ventas;
CREATE DATABASE ventas CHARACTER SET utf8mb4;
USE ventas;

CREATE TABLE cliente (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido1 VARCHAR(100) NOT NULL,
  apellido2 VARCHAR(100),
  ciudad VARCHAR(100),
  categoria INT UNSIGNED
);

CREATE TABLE comercial (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido1 VARCHAR(100) NOT NULL,
  apellido2 VARCHAR(100),
  comision FLOAT
);

CREATE TABLE pedido (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  total DOUBLE NOT NULL,
  fecha DATE,
  id_cliente INT UNSIGNED NOT NULL,
  id_comercial INT UNSIGNED NOT NULL,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (id_comercial) REFERENCES comercial(id) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE log_eventos;
CREATE TABLE ventas.log_eventos(
   id_log int NOT NULL AUTO_INCREMENT,
   fecha DATETIME,
   ejecucion VARCHAR (2000) DEFAULT NULL,
   revertir VARCHAR (2000) DEFAULT NULL,
   usuario VARCHAR(350) DEFAULT NULL,
   PRIMARY KEY (id_log)
   );
INSERT INTO cliente VALUES(1, 'Aarón', 'Rivero', 'Gómez', 'Almería', 100);
INSERT INTO cliente VALUES(2, 'Adela', 'Salas', 'Díaz', 'Granada', 200);
INSERT INTO cliente VALUES(3, 'Adolfo', 'Rubio', 'Flores', 'Sevilla', NULL);
INSERT INTO cliente VALUES(4, 'Adrián', 'Suárez', NULL, 'Jaén', 300);
INSERT INTO cliente VALUES(5, 'Marcos', 'Loyola', 'Méndez', 'Almería', 200);
INSERT INTO cliente VALUES(6, 'María', 'Santana', 'Moreno', 'Cádiz', 100);
INSERT INTO cliente VALUES(7, 'Pilar', 'Ruiz', NULL, 'Sevilla', 300);
INSERT INTO cliente VALUES(8, 'Pepe', 'Ruiz', 'Santana', 'Huelva', 200);
INSERT INTO cliente VALUES(9, 'Guillermo', 'López', 'Gómez', 'Granada', 225);
INSERT INTO cliente VALUES(10, 'Daniel', 'Santana', 'Loyola', 'Sevilla', 125);

INSERT INTO comercial VALUES(1, 'Daniel', 'Sáez', 'Vega', 0.15);
INSERT INTO comercial VALUES(2, 'Juan', 'Gómez', 'López', 0.13);
INSERT INTO comercial VALUES(3, 'Diego','Flores', 'Salas', 0.11);
INSERT INTO comercial VALUES(4, 'Marta','Herrera', 'Gil', 0.14);
INSERT INTO comercial VALUES(5, 'Antonio','Carretero', 'Ortega', 0.12);
INSERT INTO comercial VALUES(6, 'Manuel','Domínguez', 'Hernández', 0.13);
INSERT INTO comercial VALUES(7, 'Antonio','Vega', 'Hernández', 0.11);
INSERT INTO comercial VALUES(8, 'Alfredo','Ruiz', 'Flores', 0.05);

INSERT INTO pedido VALUES(1, 150.5, '2017-10-05', 5, 2);
INSERT INTO pedido VALUES(2, 270.65, '2016-09-10', 1, 5);
INSERT INTO pedido VALUES(3, 65.26, '2017-10-05', 2, 1);
INSERT INTO pedido VALUES(4, 110.5, '2016-08-17', 8, 3);
INSERT INTO pedido VALUES(5, 948.5, '2017-09-10', 5, 2);
INSERT INTO pedido VALUES(6, 2400.6, '2016-07-27', 7, 1);
INSERT INTO pedido VALUES(7, 5760, '2015-09-10', 2, 1);
INSERT INTO pedido VALUES(8, 1983.43, '2017-10-10', 4, 6);
INSERT INTO pedido VALUES(9, 2480.4, '2016-10-10', 8, 3);
INSERT INTO pedido VALUES(10, 250.45, '2015-06-27', 8, 2);
INSERT INTO pedido VALUES(11, 75.29, '2016-08-17', 3, 7);
INSERT INTO pedido VALUES(12, 3045.6, '2017-04-25', 2, 1);
INSERT INTO pedido VALUES(13, 545.75, '2019-01-25', 6, 1);
INSERT INTO pedido VALUES(14, 145.82, '2017-02-02', 6, 1);
INSERT INTO pedido VALUES(15, 370.85, '2019-03-11', 1, 5);
INSERT INTO pedido VALUES(16, 2389.23, '2019-03-11', 1, 5);


/*** TRIGGER DE INSERCION *******************/
DROP TRIGGER IF EXISTS insercion;
DELIMITER //
CREATE TRIGGER insercion
AFTER INSERT ON cliente
FOR EACH ROW 
BEGIN
INSERT INTO log_eventos(fecha, ejecucion, revertir, usuario) 
VALUES(NOW(), CONCAT("INSERT INTO cliente (nombre, apellido1, apellido2, ciudad, categoria) VALUES(",UPPER(NEW.nombre),"  ",UPPER(NEW.apellido1), "  "
,UPPER(NEW.Apellido2),"  ",UPPER(NEW.ciudad),"  ",UPPER(NEW.categoria)),
CONCAT("delete from cliente where id= ", NEW.id,";"),
current_user()  
);
end //


/********TRIGGER DE ACTUALIZACION*******/
DROP TRIGGER IF EXISTS CAMBIO;
DELIMITER //
CREATE TRIGGER CAMBIO
AFTER UPDATE ON cliente
FOR EACH ROW 
BEGIN
INSERT INTO log_eventos(fecha, ejecucion, revertir,usuario) 
VALUES(NOW(), CONCAT("update cliente set nombre= ",UPPER(NEW.nombre),"  ""apellido1=  ",UPPER(NEW.apellido1), "apellido2=  "
,UPPER(NEW.Apellido2),"ciudad=  ",UPPER(NEW.ciudad),"categoria=  ",UPPER(NEW.categoria), "WHERE id =", OLD.id, ";"),
CONCAT("UPDATE cliente SET nombre = """,OLD.nombre,""", apellido1 = """,OLD.apellido1,""", Apellido2 = """,OLD.Apellido2,""", ciudad = """,OLD.ciudad,""", categoria =""", OLD.categoria, """ WHERE id = ", NEW.id,";")
, current_user()
);
end //

/********TRIGGER DE ELIMINACION*******/
use ventas;
DROP TRIGGER IF EXISTS ELIMINAR;
DELIMITER //
CREATE TRIGGER ELIMINAR
AFTER DELETE ON cliente
FOR EACH ROW 
BEGIN
INSERT INTO log_eventos(fecha, ejecucion, revertir,usuario) 
VALUES(NOW(), CONCAT("DELETE FROM cliente WHERE id = ",OLD.id,";"),
CONCAT("INSERT INTO cliente (nombre, apellido1, apellido2, ciudad, categoria) VALUES(""",OLD.Nombre,""", """,OLD.Apellido1,""",""",OLD.apellido2,""", """,OLD.ciudad,""", """,OLD.categoria,""");")
,current_user()
);
end //


use ventas;

DROP TRIGGER IF EXISTS CAMBIO_especifico;
DELIMITER //
CREATE TRIGGER CAMBIO_especifico
AFTER UPDATE ON cliente
FOR EACH ROW 
BEGIN
    DECLARE ejecucion VARCHAR(1000); 
    
    -- Inicializar la variable de ejecución
    SET ejecucion = '';
    -- Verificar y concatenar cada cambio
    IF OLD.nombre <> NEW.nombre THEN
        SET ejecucion = CONCAT(ejecucion, 'Nombre: ', OLD.nombre, ' -> ', NEW.nombre, '; ');
    END IF;
    IF OLD.apellido1 <> NEW.apellido1 THEN
        SET ejecucion = CONCAT(ejecucion, 'Apellido1: ', OLD.apellido1, ' -> ', NEW.apellido1, '; ');
    END IF;
    IF OLD.apellido2 <> NEW.apellido2 THEN
        SET ejecucion = CONCAT(ejecucion, 'Apellido2: ', OLD.apellido2, ' -> ', NEW.apellido2, '; ');
    END IF;
    IF OLD.ciudad <> NEW.ciudad THEN
        SET ejecucion = CONCAT(ejecucion, 'ciudad: ', OLD.ciudad, ' -> ', NEW.ciudad, '; ');
    END IF;
    IF OLD.categoria <> NEW.categoria THEN
        SET ejecucion = CONCAT(ejecucion, 'Categoría: ', OLD.categoria, ' -> ', NEW.categoria, '; ');
    END IF;
    IF ejecucion <> '' THEN
        INSERT INTO log_eventos(fecha, ejecucion, revertir, usuario) 
        VALUES (NOW(), ejecucion, '', CURRENT_USER());
    END IF;
END//
DELIMITER ;

select * from log_eventos;
UPDATE `ventas`.`cliente` SET `nombre` = 'Pepita', `apellido1` = 'Perez', `apellido2` = 'Olaya', `categoria` = '1' WHERE (`id` = '2');
select * from log_eventos;


