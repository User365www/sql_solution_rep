SELECT c.category_id, c.name, SUM(p.amount) as sum_spent
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN payment p ON p.rental_id = r.rental_id
GROUP BY c.category_id
ORDER BY sum_spent DESC
LIMIT 1;
