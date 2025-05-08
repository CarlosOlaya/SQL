use tienda;

select * from producto 
where id_fabricante =( select id from fabricante 
where nombre = "asus");

select * from fabricante 
where id =( select id_fabricante from producto order by precio asc limit 1 );

select * from producto 
where precio =(select max(precio) from producto);

select nombre, precio from producto 
where precio >=(select avg(precio) from producto);

select count(id) from producto 
where precio >(select avg(precio) from producto);


select * from producto 
where precio = (select max(precio) from producto
where id_fabricante = 2 );

select * from producto 
where precio = (select max(precio) from producto
where id_fabricante = (select id from fabricante where nombre = "lenovo") );  

select count(id) from producto 
where  id_fabricante = (select id from fabricante where nombre= "xiami");

select nombre from fabricante
where id = any (select id_fabricante from producto where precio = 120);

select nombre from fabricante
where id = any(select id_fabricante from producto group by id_fabricante having count(id_fabricante = 1));

select nombre, precio from producto
where precio=  any (select precio from producto where precio != null );

