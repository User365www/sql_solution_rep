SELECT 
    ct.city,
    COUNT(*) FILTER (WHERE c.active = 1) as active_customers,
    COUNT(*) FILTER (WHERE c.active = 0) as inactive_customers
FROM city ct
JOIN address ad ON ct.city_id = ad.city_id
JOIN customer c ON c.address_id = ad.address_id
GROUP BY ct.city_id, ct.city
ORDER BY inactive_customers DESC, city;