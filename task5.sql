WITH children_films AS (
    SELECT DISTINCT fc.film_id
    FROM film_category fc
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Children'
),
actor_counts AS (
    SELECT 
        fa.actor_id,
        COUNT(DISTINCT fa.film_id) as children_films_count
    FROM film_actor fa
    WHERE fa.film_id IN (SELECT film_id FROM children_films)
    GROUP BY fa.actor_id
),
ranked_actors AS (
    SELECT 
        ac.actor_id,
        a.first_name,
        a.last_name,
        ac.children_films_count,
        DENSE_RANK() OVER (ORDER BY ac.children_films_count DESC) as rank
    FROM actor_counts ac
    JOIN actor a ON ac.actor_id = a.actor_id
)
SELECT 
    actor_id,
    first_name,
    last_name,
    children_films_count
FROM ranked_actors
WHERE rank <= 3
ORDER BY rank, actor_id;