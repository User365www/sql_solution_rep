EXPLAIN ANALYZE
SELECT COUNT(*) as count_f, c.name
FROM film_category fc
JOIN category c ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY count_f DESC;