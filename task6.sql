SELECT 
    ct.city,
    COUNT(CASE WHEN c.active = 1 THEN 1 END) as active_customers,
    COUNT(CASE WHEN c.active = 0 THEN 1 END) as inactive_customers,
    COUNT(*) as total_customers
FROM city ct
JOIN address ad ON ct.city_id = ad.city_id
JOIN customer c ON c.address_id = ad.address_id
GROUP BY ct.city_id, ct.city
ORDER BY inactive_customers DESC;
