use empleados;

select * from empleado 
where id_departamento = (select id from departamento where nombre = 'Sistemas');

select * from departamento
where presupuesto = (select Max(presupuesto) from departamento);
select * from departamento
where presupuesto = (select min(presupuesto) from departamento);

-- subconsultas all y any 
select nombre from departamento;

select d.nombre, d.presupuesto from departamento d
where d.presupuesto >= all (select presupuesto from departamento);

