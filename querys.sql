
--Construye las siguientes consultas:
--		Aquellas usadas para insertar, modificar y eliminar un Customer, Staff y Actor.

-- -----------------------------------------------
-- TABLA customer --> insert, update y delete
--OBSERVACIÓN: Se dejaron datos asignados por defecto según la definición de la tabla para los siguientes campos: 
--	activebool, create_date, last_update
--Es decir, no fueron incluídos explicitamente en el INSERT 
INSERT INTO public.customer
(
	customer_id, store_id, first_name, last_name, email, address_id, active
)
VALUES(
	900, 1, 'Nelson', 'Mori', 'nmori@email.com', 599, 1
);


select * from customer where customer_id = 900;


UPDATE public.customer
SET first_name=first_name || '2', 
	last_name= last_name || '2'
WHERE customer_id=900;

select * from customer where customer_id = 900;


-- se eliminará el mismo registro creado anteriormente, ya que todos los demás registros de la tabla customer
-- tienen datos relacionados (dependencia) con tabla payment
select * form  
DELETE FROM public.customer
WHERE customer_id = 900;

select * from customer where customer_id = 900;


-- -----------------------------------------------
-- TABLA staff --> insert, update y delete

SELECT * FROM public.staff; 
-- por tema de seguridad y por continuar la lógica de los datos almacenados previamente en la tabla staff,
-- se utilizó pgcrypto, especificamente la función 'crypt'
-- https://www.postgresql.org/docs/current/pgcrypto.html 
CREATE EXTENSION IF NOT EXISTS pgcrypto;
INSERT INTO public.staff
(staff_id, first_name, last_name, address_id, email, store_id, active, username, "password", last_update, picture)
values (3, 'Juan', 'Perez', 1, 'juan@perez.com', 1, true, 'jperez', crypt('pwd_JPerez', gen_salt('md5')), now(), NULL);

SELECT * FROM public.staff where staff_id = 3;

--si la siguiente consulta devuelve true, entonces el password quedó correctamente encryptado
SELECT (password = crypt('pwd_JPerez', password)) AS password FROM staff where staff_id = 3 ;


update staff 
set email = 'juan.perez@email.com'
where staff_id = 3;

SELECT * FROM public.staff where staff_id = 3;

delete from staff where staff_id = 3;

SELECT * FROM public.staff where staff_id = 3;



-- -----------------------------------------------
-- TABLA actor --> insert, update y delete

select * from actor order by actor_id  desc;

INSERT INTO actor
(actor_id, first_name, last_name, last_update)
VALUES(201, 'Actor201', 'Aravena', now());

select * from actor where actor_id =201;

update actor set last_name = 'Apellido201' where actor_id = 201;
select * from actor where actor_id =201;

delete from actor where actor_id = 201;
select * from actor where actor_id =201;


--==========================================================================
--Construye las siguientes consultas:
--		Listar todas las “rental” con los datos del “customer” dado un año y mes.

select * from rental order by rental_date  desc;
select distinct extract(year from rental_date) from rental;
select r.* 
from rental r 
where extract(year from r.rental_date) = 2006;
