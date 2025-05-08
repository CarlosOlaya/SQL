use jardineria;

-- 1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.
select codigo_oficina, ciudad from oficina;

-- 2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España. 
select ciudad, telefono  from oficina
where pais = "España";

-- 3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7. 
select nombre, apellido1, apellido2, email from empleado
where codigo_jefe = 7;

-- 4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa. 
select puesto,nombre,group_concats( apellido1, apellido2) as apellidos,email from empleado
where codigo_empleado= 1;

-- 5. Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas. 
select nombre, apellido1,apellido2, puesto from empleado
where puesto != "Representante Ventas";

-- 6. Devuelve un listado con el nombre de los todos los clientes españoles. 
select nombre_cliente from cliente
where pais = "spain";

-- 7. Devuelve un listado con los distintos estados por los que puede pasar un pedido. 
select estado from pedido
group by estado;

-- 8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008.
-- Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan repetidos. Resuelva la consulta: 
-- • Utilizando la función YEAR de MySQL. 
-- • Utilizando la función DATE_FORMAT de MySQL. 
-- • Sin utilizar ninguna de las funciones anteriores. 
select codigo_cliente from pago
where fecha_pago  >=  "2008-01-01" and fecha_pago <="2008-12-30"
group by codigo_cliente;

select codigo_cliente from pago
where fecha_pago  between   "2008-01-01" and "2008-12-31"
group by codigo_cliente;



select codigo_cliente,DATE_FORMAT(fecha_pago,"%Y")as año from pago 
where year(fecha_pago) = 2008
group by codigo_cliente, año;



-- 9. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo.
select codigo_pedido, codigo_cliente, fecha_esperada,fecha_entrega from pedido
where datediff(fecha_entrega,fecha_esperada) > 0;
 

-- 10. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada. 
-- • Utilizando la función ADDDATE de MySQL. 
-- • Utilizando la función DATEDIFF de MySQL. 

select codigo_pedido, codigo_cliente, fecha_esperada,fecha_entrega, datediff( fecha_entrega,fecha_esperada) as diferencia_dias  from pedido
where datediff(fecha_entrega,adddate(fecha_esperada,interval -2 DAY )) <= 0;

select codigo_pedido, codigo_cliente, fecha_esperada,fecha_entrega, datediff( fecha_entrega,fecha_esperada) as diferencia_dias  from pedido
where datediff( fecha_entrega,fecha_esperada) <=-2;



-- 11. Devuelve un listado de todos los pedidos que fueron rechazados en 2009. 
select * from pedido
where estado = "rechazado" and year(fecha_pedido)= 2009;

-- 12. Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de cualquier año. 
select * from pedido
where estado = "entregado" and month(fecha_entrega)= 01;

-- 13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. Ordene el resultado de mayor a menor. 
select * from pago
where year(fecha_pago)= 2008 and forma_pago = "paypal"
order by  total desc;

-- 14. Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en cuenta que no deben aparecer formas de pago repetidas. 
select distinct(forma_pago) from pago;

-- 15. Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más de 100 unidades en stock. El listado debe á estar ordenado por su precio de venta, mostrando en primer lugar los de mayor precio. 
select * from producto
where gama = "ornamentales" and cantidad_en_stock >= 100
order by precio_venta desc;

-- 16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo representante de ventas tenga el código de empleado 11 o 30.
select * from cliente
where ciudad="madrid" and codigo_empleado_rep_ventas = 11 or codigo_empleado_rep_ventas= 30;

-- 17. ¿Cuántos empleados hay en la compañía? 
select count(codigo_empleado)as cantidad_empleados from empleado;

-- 18. ¿Cuántos clientes tiene cada país? 
select count(codigo_cliente),pais from cliente 
group by pais;

-- 19. ¿Cuál fue el pago medio en 2009? 
select avg(total) from pago
where year(fecha_pago) = 2009 ;

-- 20. ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos. 
select count(codigo_pedido) as cantidad_pedidos ,estado from pedido
group by estado
order by cantidad_pedidos desc;

-- 21. Calcula el precio de venta del producto más caro y más barato en una misma consulta.
 select max(precio_venta)as valor_minimo, min(precio_venta) as valor_maximo from producto;
 select * from  producto; 
-- 22. Calcula el número de clientes que tiene la empresa. 
select count(codigo_cliente) as cantidad_clientes from cliente;

-- 23. ¿Cuántos clientes existen con domicilio en la ciudad de Madrid? 
select count(codigo_cliente) as cantidad_clientes from cliente
where ciudad = "madrid";

-- 24 ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M? 
select count(codigo_cliente) as cantidad_clientes  from cliente 
where ciudad like "m%";

-- 25. Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende cada uno. 
select codigo_cliente, nombre_cliente, codigo_empleado_rep_ventas, em.nombre 
from cliente
join empleado as em on codigo_empleado_rep_ventas = em.codigo_empleado;

select * from cliente;

-- 26. Calcula el número de clientes que no tiene asignado representante de ventas. 
select count(codigo_cliente) from cliente
where codigo_empleado_rep_ventas is null ;


#27. Calcula la fecha del primer y último pago realizado por cada uno de los clientes. El listado deberá mostrar el nombre y los apellidos de cada cliente. 

select group_concat( distinct cliente.codigo_cliente), nombre_cliente, min(pago.fecha_pago),max(pago.fecha_pago)
from pago 
join cliente on pago.codigo_cliente = cliente.codigo_cliente 
group by cliente.codigo_cliente;




#28. Calcula el número de productos diferentes que hay en cada uno de los pedidos.
select codigo_pedido, count(codigo_producto) from detalle_pedido
group by codigo_pedido;

#29. Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de los pedidos. 
select * from detalle_pedido;

select codigo_pedido, sum(cantidad) from detalle_pedido
group by codigo_pedido;

#30. Devuelve un listado de los 20 productos más vendidos y el número total de unidades que se han vendido de cada uno. El listado deberá estar ordenado por el número total de unidades vendidas.
select codigo_producto, sum(cantidad) as cantidad from detalle_pedido
group by codigo_producto
order by cantidad DESC LIMIT 20 ;

-- SET lc_time_names = 'es_ES' ;

select * from pedido ;

select * from( select codigo_pedido, fecha_esperada, fecha_entrega, datediff(fecha_esperada, fecha_entrega) as dias_entrega from pedido);


select * from pedido
where datediff(fecha_esperada,fecha_entrega)<0;

select curdate();
select * from pedido
where fecha_entrega < curdate();


select codigo_cliente, fecha_entrega,group_concat( codigo_pedido) as pedidos  from pedido
where fecha_entrega IS NULL
group by codigo_cliente, fecha_entrega;


select codigo_pedido, cantidad, precio_unidad,(cantidad*precio_unidad) as Valor_a_pagar from detalle_pedido;

select round(135.375,2);

select truncate(13.7778766,2);

# obtener el 10% del total pagado 
select truncate(sum(total*0.10),2) from pago; 
#nombre con solo 5 caracteres

select * from empleado
where  nombre like'_____';

#Obtener el monto total de cada pedido
select codigo_pedido,truncate(sum(cantidad*precio_unidad*1.1),1) from detalle_pedido
group by codigo_pedido;

use jardineria;

-- 6. Devuelve un listado con el nombre de los todos los clientes españoles. 
select * from cliente
where pais = "spain";

-- 9. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo.
select codigo_pedido, codigo_cliente, fecha_esperada,fecha_entrega from pedido
where datediff(fecha_entrega,fecha_esperada) > 0 or  fecha_entrega is null;

-- 24 ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M? 
select ciudad , count(codigo_cliente)as cantidad_clientes  
from cliente 
where ciudad like "m%"
group by ciudad;

-- 21. Calcula el precio de venta del producto más caro y más barato en una misma consulta.
 select min(precio_venta)as valor_minimo, max(precio_venta) as valor_maximo from producto;

 select group_concat(nombre), precio_venta from  producto
 where precio_venta = ( select max(precio_venta) from producto) or precio_venta = ( select min(precio_venta) from producto)
 group by precio_venta;
 
 select max(precio_venta), min(precio_venta) from producto;
 select nombre, precio_venta from producto where precio_venta = (select max(precio_venta) from producto);
 
 select * 
 from producto
 where precio_venta = (select max(precio_venta) from producto);
 
 
 -- Sub consultas con any all in not in  exist no exist
describe cliente;

select * from cliente 
where codigo_cliente not in (select codigo_cliente from pedido);


 
select codigo_empleado, nombre, apellido1 from empleado
where codigo_empleado in(select codigo_empleado_rep_ventas from cliente);

select nombre_cliente, limite_credito from cliente
where limite_credito =(select Max(limite_credito) from cliente);

select nombre, precio_venta from producto
where precio_venta = ( select max(precio_venta) from producto);

select codigo_cliente, nombre_cliente from cliente
where codigo_cliente in ( select codigo_cliente from pedido);

select codigo_cliente, nombre_cliente from cliente
where codigo_cliente not in ( select codigo_cliente from pedido);


select codigo_empleado, nombre, apellido1 from empleado
where codigo_empleado not in(select codigo_empleado_rep_ventas from cliente);

-- consultar con all y exist 



-- Joins 
select cliente.nombre_cliente
from cliente, pago
where cliente.codigo_cliente = pago.codigo_cliente;

select * from pedido;

select cliente.nombre_cliente,cliente.codigo_cliente
from cliente, pedido
where cliente.codigo_cliente != pedido.codigo_cliente;

select cliente.nombre_cliente, codigo_pedido ,pedido.fecha_pedido
from cliente, pedido , pago
where cliente.codigo_cliente = pedido.codigo_cliente and cliente.codigo_cliente = pago.codigo_cliente;

select nombre_cliente, pedido.codigo_pedido, sum(cantidad) as cantidad_total
from cliente,pedido, detalle_pedido
where cliente.codigo_cliente = pedido.codigo_cliente and pedido.codigo_pedido = detalle_pedido.codigo_pedido
group by pedido.codigo_pedido 
order by cantidad_total desc ;


select count(codigo_cliente) from cliente
where codigo_cliente not in ( select codigo_cliente from pedido);

select *  
from cliente
where codigo_cliente in ( select codigo_cliente from pedido) and codigo_cliente not in ( select codigo_cliente from pago);

-- 1
select *
from cliente
left join pedido ON cliente.codigo_cliente = pedido.codigo_cliente
left join pago ON cliente.codigo_cliente = pago.codigo_cliente
where pedido.codigo_cliente is null and pago.codigo_cliente is null;

-- 2
select nombre_cliente,  cliente.codigo_cliente
from cliente
left join pedido ON cliente.codigo_cliente = pedido.codigo_cliente
left join pago ON cliente.codigo_cliente = pago.codigo_cliente
where pedido.codigo_cliente is  not null and pago.codigo_cliente is  null;
-- 3
select avg(total) from pago
where year(fecha_pago) = 2009;

select avg(pago.total) 
from pago 
where extract(year from fecha_pago)=2009;

-- 4
select count(codigo_cliente), ciudad  from cliente
group by ciudad
having ciudad like binary "M%";

select count(codigo_cliente), ciudad from cliente
where ciudad like 'M%'
group by ciudad;

-- 5
select codigo_pedido, count( distinct codigo_producto) from detalle_pedido
group by codigo_pedido;

select max(limite_credito) from cliente;


select min(cantidad_en_stock) from producto;


-- select nombre_cliente from cliente
-- where codigo_cliente = any (select codigo_cliente from pedido where fecha_entrega >  fecha_esperada) ;

select *  from pago
order by total asc;

select  sum(total)*0.79 as base_imponible , sum(total)*0.21 as iva, sum(total) as total  from pago;




delimiter //
create procedure monto (out valor decimal(15,2))
begin 
select sum(total) into valor 
from pago 
where codigo_cliente = 1;
end //
call jardineria.monto (@valor);
select @valor;

delimiter //
create procedure cantidad_empleado(out valor int(15))
begin 
select count(codigo_empleado) into valor 
from empleado
where puesto = "representante  ventas";
end //

call jardineria.cantidad_rv (@valor);
select @valor;

delimiter //
create procedure monto_usuarios (in codigocliente INT,out valor decimal(15,2))
begin 
select sum(total) into valor 
from pago
where codigo_cliente = codigocliente;
end //

delimiter //
create procedure actualizar (in codigocliente INT)
begin 
update pago
set total = total*1.2
where codigo_cliente = codigocliente;
-- con los disparadores se puede mostrar a medida
end //

drop procedure if exists actualizar_dosmil;

delimiter //
create procedure actualizar_dosmil()
begin 
update pago
set total = total + 2000
where total <= 3000;
end //

delimiter //
create procedure actualizar_endiezmil()
begin 
update pago
set total = 10000
where total > 3000;
end //

drop procedure if exists dias_transcurridos;

delimiter //
CREATE PROCEDURE dias_transcurridos()
begin 
select codigo_pedido, fecha_entrega,fecha_pedido, datediff(fecha_entrega, fecha_pedido) as dias
from pedido
where datediff(fecha_entrega, fecha_pedido) is not  null;
end //

drop procedure if exists pedido_retrasado;

delimiter //
CREATE PROCEDURE pedido_retrasado()
begin 
select codigo_pedido, fecha_esperada,fecha_entrega, datediff(fecha_esperada, fecha_entrega) as dias
from pedido
where  datediff(fecha_esperada, fecha_entrega) < -2;
end //



drop procedure if exists pedido_sinentregar;

delimiter //
CREATE PROCEDURE pedido_sinentregar()
begin 
select codigo_pedido, fecha_esperada,fecha_entrega, datediff(fecha_esperada, fecha_entrega) as dias
from pedido
where  fecha_entrega is null;
end //

use jardineria;
drop procedure cantidad_compras;
delimiter //
CREATE PROCEDURE cantidad_compras(
                IN dias_antes INT,
                IN dias_despues INT,
                IN fecha_estipulada DATE)
BEGIN
        select count(codigo_pedido), group_concat(codigo_pedido) from pedido
        where fecha_entrega between DATE_SUB(fecha_estipulada, interval dias_antes day) and date_add(fecha_estipulada,interval dias_despues day);
        
END //

call jardineria.cantidad_compras(20, 20, '2008-10-28');


drop procedure cantidad_pagos;
delimiter //
CREATE PROCEDURE cantidad_pagos(OUT cantidad_mayor INT,
                                OUT cantidad_menor INT,
                                OUT diff_pagos INT)
BEGIN 
    DECLARE promedio_pagos DECIMAL(15,2);
    SET promedio_pagos = (select avg(total) from pago);
    SET cantidad_mayor = (select count(*) from pago where total>= promedio_pagos );
    SET cantidad_menor = (select count(*) from pago where total< promedio_pagos);
    SET diff_pagos = cantidad_mayor - cantidad_menor;
    
END //
call jardineria.cantidad_pagos(@cantidad_mayor, @cantidad_menor, @diff_pagos);
select @cantidad_mayor, @cantidad_menor, abs( @diff_pagos);

drop procedure cliente_compras;
delimiter //
CREATE PROCEDURE cliente_compras(
                IN fecha_antigua DATE,
                IN fecha_resiente DATE)
BEGIN
IF fecha_antigua < fecha_resiente THEN
        select cliente.nombre_cliente from cliente 
        join  pedido on cliente.codigo_cliente = pedido.codigo_cliente
        where  pedido.fecha_pedido between fecha_antigua and fecha_resiente
        group by cliente.codigo_cliente
        order by count(pedido.codigo_pedido) DESC limit 1;
    ELSE 
        select cliente.nombre_cliente from cliente 
        join  pedido on cliente.codigo_cliente = pedido.codigo_cliente
        where  pedido.fecha_pedido between fecha_resiente and fecha_antigua
        group by cliente.codigo_cliente
        order by count(pedido.codigo_pedido) DESC limit 1;
END IF;               
END //

call jardineria.cliente_compras('2010-01-01', '2007-10-28');




use jardineria;

DROP PROCEDURE IF EXISTS culta;
        q
-- case






-- LOOP

DELIMITER//
CREATE PROCEDURE potencia(
    IN N int,
    IN K int,
    OUT R int)
BEGIN 
    DECLARE control int;
    SET control = 1;
    SET R=1;
    repetir:loop
    SET R= R*N;
    SET control = control + 1;
    IF control > K THEN 
    leave repetir;
    end if;
    end loop;
END//

SELECT rand()*(10-5)+5 ;

SELECT FLOOR(rand()*(10-5+1)+5) ;

select * from pago order by rand() limit 5;




-- cursor 
DROP PROCEDURE IF EXISTS cursor_producto;
DELIMITER //

CREATE PROCEDURE cursor_producto()
BEGIN
    DECLARE vcontrol INT DEFAULT 0;
    DECLARE codigo VARCHAR(15);
    DECLARE vnombre VARCHAR(70);
    DECLARE venta DECIMAL(15,2);

    DECLARE primercursor CURSOR FOR SELECT codigo_producto, nombre, precio_venta FROM producto;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET vcontrol = 1;

    OPEN primercursor;

    repetir: LOOP
        FETCH primercursor INTO codigo, vnombre, venta;
        IF vcontrol = 1 THEN
            LEAVE repetir;
        END IF;
        
        IF venta <= 50.0 THEN
            UPDATE producto SET precio_venta = precio_venta * 1.15;
        END IF;

        SELECT codigo, vnombre, venta;
    END LOOP repetir;

    CLOSE primercursor;
END //

DELIMITER ;


select * from producto;

UPDATE producto set cantidad_en_stock = 40
WHERE cantidad_en_stock <= 18;

describe pago;
use jardineria;
select * from pago;
DROP PROCEDURE ajuste_pagos;
DELIMITER //
CREATE PROCEDURE ajuste_pagos()
BEGIN
 -- declaracion de variables para almacenar datos
  DECLARE total_ajustado_temp DECIMAL;
  DECLARE total_temp DECIMAL;
  DECLARE id_transaccion_temp VARCHAR(50);
  
  DECLARE cursor_pagos CURSOR FOR 
  -- ajuste de precio con respecto al requerimiento
  SELECT id_transaccion, total,(total + 340) * 1.065 as total_ajustado
  FROM pago
  WHERE total<= 2000;
  -- creacion de tabla temporal
  CREATE temporary TABLE IF NOT EXISTS pagos_ajustados(
    id_transaccion VARCHAR(50),
    total DECIMAL,
    total_ajustado DECIMAL);
    
    OPEN cursor_pagos;

    repetir: LOOP
        FETCH cursor_pagos INTO id_transaccion_temp, total_temp, total_ajustado_temp;

        IF id_transaccion_temp IS NULL THEN
            -- terminacion del bucle si no existen mas registros
            LEAVE repetir;
        END IF;
        -- Agregar un SELECT para depurar
        SELECT id_transaccion_temp, total_temp, total_ajustado_temp;
        -- Insertar datos modificados a la tabla temporal para registrar los cambios
        INSERT INTO pagos_ajustados (id_transaccion, total , total_ajustado)
               VALUES (id_transaccion_temp, total_temp, total_ajustado_temp);
          -- Actualizar los precios en la tabla original
        UPDATE pago
        SET total = total_ajustado_temp
        WHERE id_transaccion = id_transaccion_temp;
        
    END LOOP repetir;

    CLOSE cursor_pagos;
    
    SELECT * FROM pagos_ajustados;
    
    DROP TABLE pagos_ajustados;
END //
DELIMITER ;
call jardineria.ajuste_pagos();



use jardineria;
describe cliente;
select * from empleado;
DROP PROCEDURE eliminar_asesor;
DELIMITER //
CREATE PROCEDURE eliminar_asesor(
    IN codigo INT,
    OUT mensaje VARCHAR(255))
BEGIN
    DECLARE nombre_asesor VARCHAR(50);
    SET nombre_asesor = '';
    SET FOREIGN_KEY_CHECKS = 0;

    -- Obtenemos el nombre del asesor
    SELECT CONCAT(nombre, ' ', apellido1) INTO nombre_asesor
    FROM empleado
    WHERE codigo_empleado = codigo AND puesto = 'Representante Ventas';
    
    IF nombre_asesor = '' THEN
        SET mensaje = 'El representante de ventas no existe. Intenta nuevamente con otro código.';
    ELSE 
        -- Actualizar las referencias en la tabla "cliente"
        UPDATE cliente  
        SET codigo_empleado_rep_ventas = 0
        WHERE codigo_empleado_rep_ventas = codigo;
        
        -- Eliminar al asesor
        DELETE FROM empleado 
        WHERE codigo_empleado = codigo; 
        
        SET mensaje = CONCAT('El empleado ', nombre_asesor, ' ha sido eliminado. Todas las actividades relacionadas se han asignado a un representante de ventas con código 0.');
        
    END IF;
    SET FOREIGN_KEY_CHECKS = 1;
END //
DELIMITER ;
CALL eliminar_asesor(8, @mensaje);
SELECT @mensaje;

use jardineria ;
select * from oficina; 
select  * from empleado where codigo_oficina = 'TOK-JP';
select * from empleado  where codigo_empleado = 22;
select * from empleado where codigo_oficina = 'BCN-ES';
DROP PROCEDURE reasignar_empleados;
DELIMITER //
CREATE PROCEDURE reasignar_empleados(
     IN oficina_origen VARCHAR(50),
     IN oficina_destino VARCHAR(50))
 BEGIN
     -- Variables para almacenar información de los empleados reasignados
     DECLARE ciudad_origen_temp VARCHAR(50);
     DECLARE pais_origen_temp VARCHAR(50);
     DECLARE ciudad_destino_temp  VARCHAR(50); 
     DECLARE pais_destino_temp VARCHAR(50);
     DECLARE codigo_empleado_temp INT;
     DECLARE nombre_empleado_temp VARCHAR(50);
     
     DECLARE done INT DEFAULT FALSE;
     DECLARE reasignar CURSOR FOR
         SELECT codigo_empleado, nombre
         FROM empleado 
         WHERE codigo_oficina = oficina_origen;
     
     DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
     
     -- Almacenamos la información de origen
     SELECT ciudad, pais INTO ciudad_origen_temp, pais_origen_temp
     FROM oficina
     WHERE codigo_oficina = oficina_origen;
     
     -- Almacenamos la información de destino
     SELECT ciudad, pais INTO ciudad_destino_temp, pais_destino_temp
     FROM oficina
     WHERE codigo_oficina = oficina_destino;
     
     -- Creamos una tabla temporal para almacenar los empleados reasignados
     CREATE TEMPORARY TABLE IF NOT EXISTS empleados_reasignados(
         codigo_empleado INT,
         nombre_empleado VARCHAR(50),
         codigo_oficina_origen VARCHAR(50),
         ciudad_origen VARCHAR(50),   
         pais_origen VARCHAR(50),
         codigo_oficina_destino VARCHAR(50),
         ciudad_destino VARCHAR(50),
         pais_destino VARCHAR(50)
     );
 
     OPEN reasignar;
     
     repetir: LOOP
         FETCH reasignar INTO codigo_empleado_temp, nombre_empleado_temp;
         
         IF done THEN
             LEAVE repetir;
         END IF;
         
         -- Insertamos los datos modificados a la tabla temporal
         INSERT INTO empleados_reasignados (
             codigo_empleado, nombre_empleado, codigo_oficina_origen, ciudad_origen, pais_origen,
             codigo_oficina_destino, ciudad_destino, pais_destino
         )
         VALUES (
             codigo_empleado_temp, nombre_empleado_temp, oficina_origen, ciudad_origen_temp, pais_origen_temp,
             oficina_destino, ciudad_destino_temp, pais_destino_temp
         );
 
         -- Actualizamos la oficina del empleado
         UPDATE empleado
         SET codigo_oficina = oficina_destino
         WHERE codigo_empleado = codigo_empleado_temp;
         
     END LOOP repetir;
 
     CLOSE reasignar;
     
     -- Mostramos la tabla temporal con los empleados reasignados
     SELECT * FROM empleados_reasignados;
     
     -- Eliminamos la tabla temporal
     DROP TABLE empleados_reasignados;
     
 END //
DELIMITER ;

call jardineria.reasignar_empleados('TOK-JP', 'BCN-ES');



DROP PROCEDURE modificar_Entrega;

DELIMITER //
CREATE PROCEDURE modificar_Entrega(
    IN region_cliente VARCHAR(50),
    IN ciudad_cliente VARCHAR(50)
)
BEGIN
    -- Variables temporales para almacenar información de los pedidos afectados
    DECLARE codigo_pedido_temp INT;
    DECLARE fecha_entrega_anterior_temp DATE;
    DECLARE fecha_entrega_nueva_temp DATE;
    
    -- Cursor para obtener los pedidos afectados
    DECLARE done INT DEFAULT FALSE;
    DECLARE modificar CURSOR FOR
        SELECT codigo_pedido, fecha_entrega
        FROM pedido
        WHERE codigo_cliente IN (
            SELECT codigo_cliente
            FROM cliente
            WHERE region = region_cliente AND ciudad = ciudad_cliente
        );
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Creamos una tabla temporal para almacenar los datos de los pedidos afectados
    CREATE TEMPORARY TABLE IF NOT EXISTS pedidos_modificados(
        codigo_pedido INT,
        fecha_entrega_anterior DATE,
        fecha_entrega_nueva DATE
    );
    
    OPEN modificar;
    
    repetir: LOOP
        FETCH modificar INTO codigo_pedido_temp, fecha_entrega_anterior_temp;
        
        IF done THEN
            LEAVE repetir;
        END IF;
        
        -- Calculamos la nueva fecha de entrega
        SET fecha_entrega_nueva_temp = DATE_ADD(fecha_entrega_anterior_temp, INTERVAL 15 DAY);
        
        -- Actualizamos la fecha de entrega del pedido
        UPDATE pedido
        SET fecha_entrega = fecha_entrega_nueva_temp
        WHERE codigo_pedido = codigo_pedido_temp;
        
        -- Insertamos los datos en la tabla temporal
        INSERT INTO pedidos_modificados (codigo_pedido, fecha_entrega_anterior, fecha_entrega_nueva)
        VALUES (codigo_pedido_temp, fecha_entrega_anterior_temp, fecha_entrega_nueva_temp);
        
    END LOOP repetir;
    
    CLOSE modificar;
    
    -- Mostramos la información de los pedidos afectados
    SELECT *
    FROM pedidos_modificados;
    
    -- Eliminamos la tabla temporal
    DROP TABLE pedidos_modificados;
    
END //
DELIMITER ;


DROP TRIGGER IF EXISTS fecha_1;
DELIMITER //
CREATE TRIGGER fecha_1
BEFORE INSERT
ON pedido FOR EACH ROW
BEGIN
    IF DATEDIFF(NEW.fecha_entrega, NEW.fecha_pedido) < 0 THEN
        SET NEW.fecha_entrega = DATE_ADD(curdate(), INTERVAL 5 DAY);
    END IF;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS aumentar_precio;
DELIMITER //
CREATE TRIGGER aumentar_precio
BEFORE INSERT
ON detalle_pedido FOR EACH ROW
BEGIN
    IF NEW.precio_unidad < 4 THEN
    SET NEW.precio_unidad = NEW.precio_unidad * 1.16;
    END IF;
END//
DELIMITER ;
INSERT INTO detalle_pedido VALUES (1, 'FR-40', 1, 3.9, 1);

DROP TRIGGER IF EXISTS oficina_inicial;
DELIMITER //
CREATE TRIGGER oficina_inicial
BEFORE INSERT
ON empleado FOR EACH ROW
BEGIN
    SET NEW.codigo_oficina = 'MAD-ES';
END//
DELIMITER ;
select * from empleado;
select * from oficina;
INSERT INTO empleado VALUES (32,'Juan', 'Pérez', 'García', '1234', 'juan@example.com', 'BCN-ES', 1, 'JEFE');

DROP TRIGGER IF EXISTS unidades_minimas;
DELIMITER //
CREATE TRIGGER unidades_minimas
BEFORE INSERT
ON detalle_pedido FOR EACH ROW
BEGIN
    IF NEW.cantidad < 10 THEN
    SET NEW.precio_unidad = NEW.precio_unidad * 1.033;
    END IF;
END//
DELIMITER ;
select * from  detalle_pedido;
INSERT INTO detalle_pedido VALUES (1, 'FR-31', 1, 9 , 1);


USE JARDINERIA;

DROP TRIGGER IF EXISTS cambio_total;
DELIMITER //
CREATE TRIGGER cambio_total
BEFORE UPDATE
ON producto FOR EACH ROW
BEGIN
    IF NEW.precio_proveedor <> OLD.precio_proveedor THEN
        SET NEW.precio_venta = OLD.precio_venta * 1.015;
    END IF;
END//
DELIMITER ;

UPDATE producto
SET precio_proveedor = precio_proveedor - precio_proveedor*0.045;


-- Trigers completos 
USE jardineria;
DROP TABLE log_eventos;
CREATE TABLE log_eventos(
   id_log int NOT NULL AUTO_INCREMENT,
   fecha DATETIME,
   ejecucion VARCHAR (2000) DEFAULT NULL,
   revertir VARCHAR (2000) DEFAULT NULL,
   usuario VARCHAR(350) DEFAULT NULL,
   PRIMARY KEY (id_log)
   );
   
/*** TRIGGER DE INSERCION *******************/
DROP TRIGGER IF EXISTS insercion;

DELIMITER //
CREATE TRIGGER insercion
AFTER INSERT ON pedido
FOR EACH ROW 
BEGIN
INSERT INTO log_eventos(fecha, ejecucion, revertir, usuario) 
VALUES(NOW(), CONCAT("INSERT INTO pedido (codigo_pedido,fecha_pedido, fecha_esperada, fecha_entrega, estado,comentarios,codigo_cliente ) 
VALUES(",UPPER(NEW.codigo_pedido),"  ",UPPER(NEW.fecha_pedido), "  "
,UPPER(NEW.fecha_esperada),"  ",UPPER(NEW.fecha_entrega),"  ",UPPER(NEW.estado)," ",UPPER(NEW.comentarios)," ",UPPER(NEW.codigo_cliente)),
CONCAT("delete from pedido where codigo_pedido= ", NEW.codigo_pedido,";"),
current_user()  
);
end //
DELIMITER;

INSERT INTO pedido VALUES (210,'2024-04-10','2024-05-10','2024-04-29','Rechazado','El pedido ha sido rechazado por el cliente por defecto de fabrica',1);
select * from pedido where codigo_pedido = 210;
select * from log_eventos;
/********TRIGGER DE ACTUALIZACION*******/

DROP TRIGGER IF EXISTS CAMBIO;
DELIMITER //
CREATE TRIGGER CAMBIO
AFTER UPDATE ON pedido
FOR EACH ROW 
BEGIN
INSERT INTO log_eventos(fecha, ejecucion, revertir,usuario) 
VALUES(NOW(), CONCAT("update pedido set codigo_pedido= ",UPPER(NEW.codigo_pedido),"  ""fecha_pedido=  ",UPPER(NEW.fecha_pedido), "fecha_esperada=  "
,UPPER(NEW.fecha_esperada),"fecha_entrega=  ",UPPER(NEW.fecha_entrega),"estado=  ",UPPER(NEW.estado),"comentarios= ", UPPER(NEW.comentarios),
"codigo_cliente= ",UPPER(NEW.codigo_cliente),"WHERE codigo_pedido =", OLD.codigo_pedido, ";"),
CONCAT("UPDATE pedido SET codigo_pedido = """,OLD.codigo_pedido,""", fecha_pedido = """,OLD.fecha_pedido,""", fecha_esperada = """,OLD.fecha_esperada,
""", fecha_entrega = """,OLD.fecha_entrega,""", estado =""", OLD.estado,""", comentarios =""", OLD.comentarios,""", codigo_cliente =""", OLD.codigo_cliente,
 """, WHERE codigo_pedido = ", NEW.codigo_pedido,";")
, current_user()
);
end //
DELIMITER;

UPDATE `jardineria`.`pedido` SET `estado` = 'Rechazado', `comentarios` = 'Pagado a plazos aaaa' WHERE (`codigo_pedido` = '1');
select * from log_eventos;


/********TRIGGER DE ELIMINACION*******/
use ventas;
DROP TRIGGER IF EXISTS ELIMINAR;
DELIMITER //
CREATE TRIGGER ELIMINAR
AFTER DELETE ON pedido
FOR EACH ROW 
BEGIN
INSERT INTO log_eventos(fecha, ejecucion, revertir,usuario) 
VALUES(NOW(), CONCAT("DELETE FROM pedido WHERE codigo_pedido = ",OLD.codigo_pedido,";"),
CONCAT("INSERT INTO pedido (codigo_pedido,fecha_pedido, fecha_esperada, fecha_entrega, estado,comentarios,codigo_cliente )
VALUES(""",OLD.codigo_pedido,""", """,OLD.fecha_pedido,""",""",OLD.fecha_esperada,""", """,OLD.fecha_entrega,""", """,OLD.estado,
""", """,OLD.comentarios,""", """,OLD.codigo_cliente,""");")
,current_user()
);
end //

DELETE FROM pedido WHERE codigo_pedido="130";
select * from log_eventos;

DROP TRIGGER IF EXISTS CAMBIO_especifico;
DELIMITER //
CREATE TRIGGER CAMBIO_especifico
AFTER UPDATE ON cliente
FOR EACH ROW 
BEGIN
    IF OLD.codigo_cliente <> NEW.codigo_cliente THEN
        -- Insertar en la tabla de log de eventos
        INSERT INTO log_eventos(fecha, ejecucion, revertir, usuario) 
        VALUES (NOW(),
                CONCAT('Se modificó el código del pedido a :',NEW.codigo_cliente),
                CONCAT(''),
                CURRENT_USER() 
        );
    END IF;
END//

DELIMITER ;
UPDATE `jardineria`.`cliente` SET `codigo_cliente` = '100' WHERE (`codigo_cliente` = '10');

select * from cliente;
select * from log_eventos;


-- Vistas ---------------------------------------

 CREATE or replace view view_oficinas AS 
 SELECT codigo_oficina, ciudad from oficina
 where codigo_oficina is not null;
 
 select * from view_oficinas;
 
CREATE or replace view view_pedidos AS 
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega,datediff(fecha_esperada,fecha_entrega) 
 from pedido
where datediff(fecha_esperada,fecha_entrega) > 2;
 
select * from view_pedidos;
 
CREATE or replace view view_cliente AS 

select cliente.nombre_cliente, empleado.nombre, empleado.codigo_oficina from cliente 
LEFT JOIN pago on  cliente.codigo_cliente = pago. codigo_cliente
 JOIN empleado on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado;
 
 select * from view_cliente;
 
 CREATE or replace view view_gamas AS 
 select * from detalle_pedido d
 left join producto p on d.codigo_producto = p.codigo_producto;


-- 5 empleado
CREATE VIEW vista_empleado_oficina_asociada AS
SELECT 
    e.codigo_empleado AS Codigo_Empleado,
    e.nombre AS Nombre_Empleado,
    CASE
        WHEN o.codigo_oficina IS NOT NULL THEN 'Sí'
        ELSE 'No'
    END AS Tiene_Oficina_Asociada
FROM 
    empleado e
LEFT JOIN 
    oficina o ON e.codigo_oficina = o.codigo_oficina;


SELECT * FROM vista_empleado_oficina_asociada WHERE Codigo_Empleado = 5;

-- 6 
CREATE VIEW view_empleado_nocliente AS
select e.codigo_empleado, e.nombre, e.codigo_oficina, o.ciudad as ciudad_oficina
FROM empleado e
left join cliente c on e.codigo_empleado = c.codigo_empleado_rep_ventas
JOIN oficina o on e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_cliente is null;

select * from view_empleado_nocliente;


-- 7 
 -- 9
 CREATE VIEW clientes_por_pais AS
SELECT 
    pais, 
    COUNT(codigo_cliente) AS numero_de_clientes
FROM 
    cliente
GROUP BY 
    pais;


select * from clientes_por_pais;


-- 10 
 CREATE VIEW clientes_por_ciudad AS
SELECT ciudad, COUNT(codigo_cliente) AS numero_de_clientes
FROM 
    cliente
GROUP BY 
    ciudad;


select * from empleado;



