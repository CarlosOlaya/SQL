USE new_schema;
DROP TRIGGER IF EXISTS new_schema;
DELIMITER //
CREATE TRIGGER log_tabla_alumno AFTER INSERT 
ON alumno FOR EACH ROW
BEGIN
    INSERT INTO acciones(accion) value ('Se creo un registro de alumno');
END//
DELIMITER ;

use new_schema;
select * from alumno;
select* from acciones;