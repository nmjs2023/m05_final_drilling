
--Construye las siguientes consultas:

--=========================================================================================
--		Aquellas usadas para insertar, modificar y eliminar un Customer, Staff y Actor.

-- -----------------------------------------------
-- TABLA customer --> insert, update y delete

-- Observación: Se dejaron datos asignados por defecto según la definición de la tabla para los siguientes campos: 
--				activebool, create_date, last_update
--				Es decir, no fueron incluídos explicitamente en el INSERT 

INSERT INTO public.customer
(	customer_id, store_id, 
	first_name, last_name, 
	email, address_id, active
)
VALUES(
	900, 1, 
	'Nelson', 'Mori', 
	'nmori@email.com', 599, 1
);


--select * from customer where customer_id = 900;


UPDATE public.customer
SET
	first_name = first_name || '2', 
	last_name = last_name || '2'
WHERE customer_id = 900;

-- select * from customer where customer_id = 900;


-- se eliminará el mismo registro creado anteriormente, ya que todos los demás registros de la tabla customer
-- tienen datos relacionados (dependencia) con tabla payment
  
DELETE
FROM public.customer
WHERE customer_id = 900;

-- select * from customer where customer_id = 900;


-- -----------------------------------------------
-- TABLA staff --> insert, update y delete

--SELECT * FROM public.staff; 

-- por tema de seguridad y por continuar la lógica de los datos almacenados previamente en la tabla staff,
-- se utilizó pgcrypto, especificamente la función 'crypt'
-- https://www.postgresql.org/docs/current/pgcrypto.html 

CREATE EXTENSION IF NOT EXISTS pgcrypto;

INSERT INTO public.staff
(	staff_id, first_name, last_name, 
	address_id, email, store_id, 
	active, username, 
	"password", 
	last_update, picture
)
VALUES (3, 'Juan', 'Perez', 1, 'juan@perez.com', 1, TRUE, 'jperez', crypt('pwd_JPerez', gen_salt('md5')), now(), NULL);


/* si la siguiente consulta devuelve true, entonces el password quedó correctamente encryptado
SELECT(PASSWORD = crypt('pwd_JPerez', PASSWORD)) AS PASSWORD
FROM staff
WHERE staff_id = 3 ;
*/
-- select * from staff; 


UPDATE staff
SET
email = 'juan.perez@email.com'
WHERE staff_id = 3;

-- SELECT * FROM public.staff where staff_id = 3;

DELETE
FROM staff
WHERE staff_id = 3;

SELECT *
FROM public.staff
WHERE staff_id = 3;



-- -----------------------------------------------
-- TABLA actor --> insert, update y delete


INSERT INTO actor
(
	actor_id, first_name, 
	last_name, last_update
)
VALUES
(	
	201, 'Actor201', 
	'Aravena', now()
);

-- select * from actor where actor_id =201;

UPDATE actor
SET
	last_name = 'Apellido201'
WHERE actor_id = 201;

-- select * from actor where actor_id =201;

DELETE
FROM actor
WHERE actor_id = 201;

-- select * from actor where actor_id =201;


--=========================================================================================
-- Listar todas las “rental” con los datos del “customer” dado un año y mes.


SELECT r.rental_date, r.rental_id, r.customer_id, c.first_name, c.last_name, c.email , c.address_id, a.address, c2.city, c3.country
FROM rental r
INNER JOIN customer c ON
	r.customer_id = c.customer_id
INNER JOIN address a ON
	c.address_id = a.address_id
INNER JOIN city c2 ON
	a.city_id = c2.city_id
INNER JOIN country c3 ON
	c2.country_id = c3.country_id
WHERE EXTRACT(YEAR FROM r.rental_date) = 2006
	AND EXTRACT(MONTH FROM r.rental_date) = 2
ORDER BY r.rental_date ASC

/* Validación (182 registros):
 	select count(*) from rental r 
	where extract(year from r.rental_date) = 2006 
	and extract(month from r.rental_date) = 2;
	
 	select count(*) 
	from rental r inner join customer c on r.customer_id = c.customer_id 
	where extract(year from r.rental_date) = 2006 
	and extract(month from r.rental_date) = 2
	
	 
*/

--===============================================================================
--	Listar Número, Fecha (payment_date) y Total (amount) de todas las “payment”
-- Observación: 
--		1) no se solicita algún orden de datos en especifico por lo cual no fue incluído
-- 		2) se asumió que "Número", "Fecha" y "Total" era el nombre con el cual se estaba solicitando la salida de datos por lo que se dejaron con dicho nombre.
SELECT 
	payment_id AS Número, 
	to_char(payment_date, 'dd/MM/yyyy') AS "Fecha", 
	amount AS Total
FROM payment;


--===============================================================================
--	Listar todas las “film” del año 2006 que contengan un (rental_rate) mayor a 4.0.

-- Observación:  Se muestran todos los campos de la tabla "film" debido a que en el requerimiento no se especifican campos (datos) en particular.

SELECT *
FROM film
WHERE release_year = 2006
AND rental_rate > 4




--===============================================================================
--===============================================================================
-- Realiza un Diccionario de datos que contenga el nombre de las tablas y columnas, si
-- éstas pueden ser nulas, y su tipo de dato correspondiente.

-- Observación 1: 	la consulta fue generada a partir de la información proporcionada por el 
-- 					schema de postgresql, especificamente a través de information_schema: 
--
--					SELECT *FROM information_schema.TABLES;
--					SELECT * FROM information_schema.COLUMNS;
--
-- Observación 2: 	sólo se muestra la información solicitada (por ejemplo no se mostrará el tamaño máximo para los campos de tipo varchar,.... etc.)
-- Observación 3: 	En el requerimiento no se especifica de los encabezados (titulo/nombre columna) deben tener el nombre original 
--					de los campos o algún nombre en particular, por ejemplo: table_name AS Tabla, así que se dejaron los nombres de las columnas.


SELECT 
	t.table_name, 
	c.column_name, 
	c.is_nullable, 
	data_type
FROM information_schema.TABLES t
INNER JOIN information_schema.COLUMNS c 
	ON c.table_name = t.table_name
WHERE t.table_schema = 'public'
AND t.table_type = 'BASE TABLE'
ORDER BY t.table_name ASC, c.ordinal_position ASC;



