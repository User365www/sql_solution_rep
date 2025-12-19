WITH category_payments AS (
    SELECT 
        fc.category_id,
        p.amount
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
)
SELECT 
    c.category_id,
    c.name,
    SUM(cp.amount) as sum_spent
FROM category c
JOIN category_payments cp ON c.category_id = cp.category_id
GROUP BY c.category_id, c.name
ORDER BY sum_spent DESC
LIMIT 1;
