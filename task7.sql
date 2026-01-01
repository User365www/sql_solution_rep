WITH city_stats AS (
    SELECT 
        c.city_id,
        c.city,
        cat.category_id,
        cat.name as category_name,
        SUM(f.length) as total_minutes,
        ROW_NUMBER() OVER (
            PARTITION BY c.city_id 
            ORDER BY SUM(f.length) DESC
        ) as rank,
        CASE 
            WHEN c.city LIKE '%-%' THEN 'Has dash'
            ELSE 'No dash'
        END as city_type
    FROM city c
    JOIN address a ON c.city_id = a.city_id
    JOIN customer cust ON a.address_id = cust.address_id
    JOIN rental r ON cust.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
    WHERE f.title ILIKE 'a%'
    GROUP BY c.city_id, c.city, cat.category_id, cat.name
)
SELECT 
    city_type,
    city,
    category_name,
    ROUND(total_minutes / 60.0, 2) as total_hours
FROM city_stats
WHERE rank = 1
ORDER BY 
    city_type,
    CASE city_type 
        WHEN 'Has dash' THEN 1 
        ELSE 2 
    END,
    city;