use restaurante;

/* Creación de las tablas para manejo de inventario */

drop table if exists ventas;
drop table if exists libros;

create table libros(
  codigo int auto_increment,
  titulo varchar(50),
  autor varchar(50),
  editorial varchar(30),
  precio float, 
  stock int,
  primary key (codigo)
 );

 create table ventas(
  numero int auto_increment,
  codigolibro int,
  precio float,
  cantidad int,
  primary key (numero)
 );
/*--Insertamos algunas filas de prueba en la tabla "libros--*/
 insert into libros(titulo, autor, editorial, precio, stock)
  values('Uno','Richard Bach','Planeta',15,100);   
 insert into libros(titulo, autor, editorial, precio, stock)
  values('Ilusiones','Richard Bach','Planeta',18,50);
 insert into libros(titulo, autor, editorial, precio, stock)
  values('El aleph','Borges','Emece',25,200);
 insert into libros(titulo, autor, editorial, precio, stock)
  values('Aprenda PHP','Mario Molina','Emece',45,200);


DROP TRIGGER IF EXISTS ventas_libros;
DELIMITER //
CREATE TRIGGER ventas_libros BEFORE INSERT
ON ventas FOR EACH ROW
BEGIN
    UPDATE libros set stock = stock-new.cantidad
    WHERE new.codigolibro=libros.codigo;
END//
DELIMITER ;

INSERT INTO ventas(codigolibro, precio, cantidad) VALUES(1,14.67,8);

DROP TRIGGER IF EXISTS devoluciones;
DELIMITER //
CREATE TRIGGER devoluciones BEFORE DELETE
ON ventas FOR EACH ROW
BEGIN
    UPDATE libros set stock = stock+new.cantidad
    WHERE new.codigolibro=libros.codigo;
END//
DELIMITER ;
DELETE FROM ventas
WHERE NUMERO=2;

SELECT * FROM ventas;