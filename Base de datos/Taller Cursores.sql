use jardineria;

-- Ejercio 1 Ajustes de pagos
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
-- Ejemplo
call jardineria.ajuste_pagos();

-- Ejercicio 2 eliminar_asesor

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
-- Ejemplo
CALL eliminar_asesor(8, @mensaje);
SELECT @mensaje;
SELECT * from cliente where codigo_empleado_rep_ventas = 0;
-- Ejercicio 3 reasignar empleados

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
-- Ejemplo
call jardineria.reasignar_empleados('TOK-JP', 'BCN-ES');


-- Ejercicio 4 modificar_entrega

DROP PROCEDURE modificar_Entrega;
DELIMITER //
CREATE PROCEDURE modificar_Entrega(
    IN region_cliente VARCHAR(50),
    IN ciudad_cliente VARCHAR(50)
)
BEGIN
    
    -- Actualizar la fecha de entrega de los pedidos para 15 días después
    UPDATE pedido
    SET fecha_entrega = DATE_ADD(fecha_entrega, INTERVAL 15 DAY)
    WHERE codigo_cliente IN (
        SELECT codigo_cliente
        FROM cliente
        WHERE region = region_cliente AND ciudad = ciudad_cliente
    );

    -- Mostrar la información de los pedidos afectados
    SELECT *
    FROM pedido
    WHERE codigo_cliente IN (
        SELECT codigo_cliente
        FROM cliente
        WHERE region = region_cliente AND ciudad = ciudad_cliente
    );
END //
DELIMITER ;

-- Ejemplo
call jardineria.modificar_Entrega('madrid', 'madrid');



