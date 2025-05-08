select  count(codigo_empleado) as cantidad_empleados, codigo_oficina from empleado
group by codigo_oficina
having cantidad_empleados >= 5;

select codigo_cliente, max(fecha_pago)from pago
where total >=1000 
group by codigo_cliente ;

select nombre, proveedor, precio_venta, precio_proveedor, 
        (precio_venta - precio_proveedor)  as ganancia_neta,
        (((precio_venta - precio_proveedor) / precio_proveedor)*100) as ganancia_porcentaje 
from producto;



update empleado set codigo_jefe = null where codigo_jefe = 15;
select * from empleado where codigo_jefe is null;
 
 select gama, sum(cantidad_en_stock) from  producto
 group by gama;
 
 
 
 
 select nombre_cliente from cliente where codigo_cliente = (
 select codigo_cliente from pago order by fecha_pago desc limit 1);
 
 
 
 select codigo_cliente, max(fecha_pago) from pago
  where codigo_cliente = ( select codigo_cliente from cliente where nombre_cliente = "Beragua")
 group by codigo_cliente;

select * from cliente;