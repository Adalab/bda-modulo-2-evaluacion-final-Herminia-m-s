USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT
	DISTINCT title AS 'Title'
FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13"
SELECT
	title As 'Title',
	rating AS 'Rating'
FROM film
WHERE rating = "PG-13";

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT 
	title AS 'Title', 
description AS 'Description'
FROM film 
WHERE description LIKE '%amazing%'; -- Usamos el filtro para buscar una palabra dentro de una descripcion.

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT 
	title AS 'Title',
	length AS 'Length'
FROM film
WHERE length > 120;

-- 5. Encuentra los nombres de todos los actores, muestralos en una sola columna que se llame nombre_actor y contenga nombre y apellido.
SELECT 
	CONCAT( first_name, " ", last_name) AS 'Actor'
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT 
	CONCAT(first_name, " ",last_name) AS 'Actor'
FROM actor
WHERE last_name = 'Gibson';

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT 
	first_name As 'Actor',
	actor_id As 'Actor ID'
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no tengan clasificacion "R" ni "PG-13".
SELECT 
	title AS 'Title',
	rating As 'Rating'
FROM film
WHERE rating NOT IN ("R", "PG-13");

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT 
	COUNT(film_id) AS 'Total films',
	rating AS 'Rating'
FROM film
GROUP BY rating;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT 
	COUNT(r.rental_id) AS 'Total rented',
	CONCAT(c.first_name, " " ,c.last_name) AS 'Customer',
	c.customer_id AS 'Customer ID'
FROM customer c
INNER JOIN rental r
	ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT 
	COUNT(r.rental_id) AS 'Total rented',
	c.name AS 'Categoy name'
FROM category c
INNER JOIN film_category fc
	ON c.category_id = fc.category_id
INNER JOIN film f
	ON fc.film_id = f.film_id
INNER JOIN inventory i
	ON i.film_id = f.film_id
INNER JOIN rental r
	ON r.inventory_id = i.inventory_id
GROUP BY c.name;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT 
	rating AS 'Rating',
	COUNT(film_id) AS 'Total film',
AVG(length) AS 'Average duration'
FROM film
GROUP BY rating;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
SELECT 
	CONCAT(a.first_name, " ", a.last_name) AS 'Actor'
FROM film f
INNER JOIN film_actor fa
	ON f.film_id = fa.film_id
INNER JOIN actor a
	ON fa.actor_id = a.actor_id
WHERE f.title = "Indian Love";

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT 
	title AS 'Title', 
	description AS 'Description'
FROM film 
WHERE description LIKE '%dog%' 
OR description LIKe '%cat%';


SELECT 
	title AS 'Title', 
    description AS 'Description'
FROM film 
WHERE description LIKE '%dog%'
UNION
SELECT 
	title AS 'Title', 
    description AS 'Description'
FROM film 
WHERE description LIKE '%cat%';


-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
SELECT 
	CONCAT(a.first_name, " ", a.last_name) AS 'Actor' ,
	a.actor_id AS 'Actor ID'
FROM actor a 
LEFT JOIN film_actor fa
	ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL; -- Sale vacio, porque he comprobado haciendo select* que hay los mismos actores, 200 en total

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT 
	title AS 'Title'
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT 
	f.title AS 'Title',
	c.name AS 'Category'
FROM film f
INNER JOIN film_category fc
	ON f.film_id = fc.film_id
INNER JOIN category c
	ON fc.category_id = c.category_id
WHERE c.name = "Family";

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
SELECT
	CONCAT( a.first_name, "", a.last_name) AS 'Actor'
FROM actor a 
INNER JOIN film_actor fa
	ON a.actor_id = fa.actor_id
INNER JOIN film f
	ON fa.film_id = f.film_id
GROUP BY a.actor_id
HAVING a.actor_id > 10;


-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
SELECT 
	title AS 'Title'
FROM film 
WHERE rating = "R" AND length = 120;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
SELECT 
	AVG(length) AS 'Average duration',
	rating AS 'Rating'
FROM film
GROUP BY rating
HAVING AVG(Length) > 120;

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
SELECT 
	a.first_name AS 'Actor'
FROM actor a
INNER JOIN film_actor fa
	ON a.actor_id = fa.actor_id
INNER JOIN film f
	ON f.film_id = fa.film_id
GROUP BY a.first_name
HAVING COUNT(f.film_id) > 5;

-- 22. Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días.
SELECT 
	f.title AS 'Title'
FROM film f 
INNER JOIN inventory i 
	ON f.film_id = i.film_id
INNER JOIN rental r 
	ON i.inventory_id = r.inventory_id
WHERE r.rental_id IN ( 
	SELECT r.rental_id 
	FROM rental r
	WHERE DATEDIFF(r.return_date, r.rental_date) > 5
);

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".
SELECT 
	CONCAT(a. first_name, " ", a.last_name) AS 'Actor'
FROM actor a
WHERE a.actor_id NOT IN ( -- Con este not in, lo estamos excluyendo de la lista
	SELECT a.actor_id
	FROM actor a
	INNER JOIN film_actor fa
		ON a.actor_id = fa.actor_id
	INNER JOIN film f
		ON fa.film_id = f.film_id
	INNER JOIN film_category fc 
		ON f.film_id = fc.film_id
	INNER JOIN category c 
		ON fc.category_id = c.category_id
	WHERE c.name = 'Horror');

--  24.Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film con subconsultas.
SELECT 
	f.title AS 'Title'
FROM film f
WHERE film_id IN (
	SELECT f.film_id
	FROM film f
	INNER JOIN film_category fc
		ON f.film_id = fc.film_id
	INNER JOIN category c
		ON fc.category_id = c.category_id
	WHERE c.name = 'Comedy'
) AND length > 180;

-- 25.Encuentra todos los actores que han actuado juntos en al menos una película. 
SELECT 
	CONCAT(a1.first_name, ' ', a1.last_name) AS 'Actor1',
	CONCAT(a2.first_name, ' ', a2.last_name) AS 'Actor2',
	COUNT(fa1.film_id) AS 'Films together'
FROM actor a1
INNER JOIN film_actor fa1 
	ON a1.actor_id = fa1.actor_id
INNER JOIN film_actor fa2 
	ON fa1.film_id = fa2.film_id
INNER JOIN actor a2 
	ON fa2.actor_id = a2.actor_id
WHERE a1.actor_id < a2.actor_id -- Esta linea nos sirve para diferenciar para los actores del a1 y los actores del a2
GROUP BY a1.actor_id, a2.actor_id
HAVING COUNT(fa1.film_id) >= 1;

