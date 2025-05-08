-- CREATE DATABASE ventas CHARACTER SET utf8mb4;
USE ventas;
CREATE TABLE cliente (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 nombre VARCHAR(100) NOT NULL,
 apellido1 VARCHAR(100) NOT NULL,
 apellido2 VARCHAR(100),
 ciudad VARCHAR(100),
 categoría INT UNSIGNED
);
CREATE TABLE comercial (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 nombre VARCHAR(100) NOT NULL,
 apellido1 VARCHAR(100) NOT NULL,
 apellido2 VARCHAR(100),
 comisión FLOAT 
);
CREATE TABLE pedido (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 total DOUBLE NOT NULL,
 fecha DATE,
 id_cliente INT UNSIGNED NOT NULL,
 id_comercial INT UNSIGNED NOT NULL,
 FOREIGN KEY (id_cliente) REFERENCES cliente(id),
 FOREIGN KEY (id_comercial) REFERENCES comercial(id)
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


/* 1. Devuelve un listado con todos los pedidos que se han realizado. Los pedidos deben estar
ordenados por la fecha de realización, mostrando en primer lugar los pedidos más
recientes. Investigar lo referente a fechas.*/
select fecha,id_cliente,total from pedido
order by fecha desc;

/*2. Devuelve todos los datos del o los pedidos de mayor valor.*/
select * from pedido
order by total desc limit 3 ;

/*3. Devuelve un listado con los identificadores de los clientes que han realizado algún pedido.
Tenga en cuenta que no debe mostrar identificadores que estén repetidos.*/
select id_cliente from pedido
group by id_cliente;

-- Vamos a consultar el nombre del cliente y la cantidad de pedidos
-- usamos concat para mostrar todo el nombre en una sola columna la palabra reservada distinct 
-- es necesaria para que no tome valores repetidos 

select id_cliente, group_concat( distinct nombre, apellido1 )as Nombre, count(distinct pedido.id) AS 'Cantidad de pedidos'
from pedido 
-- los join se usan para tomar valores de otra tabla se llama la palabra reservada join
--  se indica el nombre de la tabla a llamar on clave foranea igual a clave primaria de la tabla 
-- se hace para llamar los datos que comparten llaves
join cliente on pedido.id_cliente = cliente.id
group by id_cliente, Nombre;

/*4. Devuelve un listado de todos los pedidos que se realizaron durante el año 2017, cuya
cantidad total sea superior a 500€. 
substring toca una cadena de caracteres , el inicio , la cantidad de caracters a tomar  
year= toma solo el valor del año en el dato). */
select substring(fecha, 1, 4) AS Año, id, total, id_cliente, id_comercial  from pedido
where YEAR(fecha) = 2017 AND total >= 500;
--  tambien se puede con un having
select substring(fecha, 1, 4) AS Año, id, total, id_cliente, id_comercial  from pedido
where YEAR(fecha) = 2017 
group by id
having total >=500;
 
/*5. Devuelve un listado con el nombre y los apellidos de los comerciales que tienen una
comisión entre 0.05 y 0.11.*/
select group_concat(distinct nombre, apellido1) AS comercial, comisión 
from  comercial
where comisión between 0.05 AND 0.11
group by id;

/*6. Devuelve el valor de la comisión de mayor valor que existe en la tabla comercial.*/
select MAX(comisión) AS comisión from comercial;
select comisión from comercial limit 1;

/*7. Diseñar una consulta que devuelva el promedio de los pedidos que tiene el asesor con
código igual a 2.*/
select AVG(total) AS 'Promedio de pedidos' from pedido 
where id_comercial = 2;

/*9. Determinar cuantas compras hay entre 2015-06-27 y 2019-01-25.*/
select count(id) as 'Total de ventas', min(fecha) as Fechainicial, max(fecha) as FechaFinal from pedido
where fecha between '2015-06-27' AND '2019-01-25';

/*10. Determinar cuantos clientes hay con categoría 100.*/
select count(id) AS  clientes_por_categoria , categoría from cliente
where categoría = 100;

/*11. Ordenar de mayor a menor las categorías donde hay mayor numero de clientes.*/
select count(id) AS  clientes_por_categoria, categoría from cliente
group by categoría
order by  clientes_por_categoria desc;

/*12. Definir la categoría donde hay menor número de clientes.*/
select count(id) AS  clientes_por_categoria, categoría from cliente
group by categoría
having  clientes_por_categoria =( 
    select min(clientes_por_categoria)
    from (
        select count(id) AS clientes_por_categoria
        from cliente
        group by categoría
    ) as subconsulta
);










/*13. Se quiere saber el asesor comercial con mayor comisión. (nombre, apellido1 y
apellido2)*/
-- Consultamos el que tiene mayor comisión 
select nombre, apellido1, apellido2, comisión from comercial
where comisión =(
select max(comisión) 
from comercial 
);

-- consultamos las comisiones de comerciales hasta la fecha
select comercial.id,nombre,apellido1,comisión,
		SUM(total) as total_ventas, (comisión * SUM(total)) as comiciones_totales from comercial
join pedido on comercial.id = pedido.id_comercial
group by comercial.id

