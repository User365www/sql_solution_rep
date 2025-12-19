SELECT 
    a.actor_id,
    a.first_name,
    a.last_name,
    SUM(film_rentals.rental_count) as total_rentals
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN (
    SELECT 
        i.film_id,
        COUNT(*) as rental_count
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    GROUP BY i.film_id
) film_rentals ON fa.film_id = film_rentals.film_id
GROUP BY a.actor_id
ORDER BY total_rentals DESC
LIMIT 10;