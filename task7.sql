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
        ) as rank
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
),
top_categories AS (
    SELECT 
        city_id,
        city,
        category_name,
        ROUND(total_minutes / 60.0, 2) as total_hours
    FROM city_stats
    WHERE rank = 1
)
SELECT 
    'All cities (movies starting with A)' as query_type,
    city,
    category_name,
    total_hours
FROM top_categories
ORDER BY city

UNION ALL

SELECT 
    'Cities with "-" (movies starting with A)' as query_type,
    city,
    category_name,
    total_hours
FROM top_categories
WHERE city LIKE '%-%'
ORDER BY query_type, city;
