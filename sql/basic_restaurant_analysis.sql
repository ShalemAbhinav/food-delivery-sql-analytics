-- Top 10 Restaurants By Rating 

SELECT restaurant_name,rating
FROM Restaurants
Where rating IS NOT NULL
ORDER BY rating DESC
LIMIT 10;


-- Average Rating By Area

SELECT area,round(avg(rating),2) as avg_rating
From Restaurants
Where rating IS NOT NULL
GROUP BY area
ORDER BY avg_rating DESC;


-- Average cost_for_two Per Area

SELECT area,round(avg(cost_for_two),2) as avg_cost
From Restaurants
Group By area
ORDER BY avg_cost DESC;


-- Rating vs Cost Relationship

SELECT CASE 
    WHEN cost_for_two<300 THEN 'Low'
    WHEN cost_for_two BETWEEN 300 AND 600 THEN 'Medium'
    ELSE 'High'
    END as price_bucket,
    round(avg(rating),2) as avg_rating
FROM Restaurants
WHERE rating IS NOT NULL
GROUP BY price_bucket;


-- Most Common Cuisines

SELECT cuisines, COUNT(*) AS restaurant_count
FROM Restaurants
GROUP BY cuisines
ORDER BY restaurant_count DESC
LIMIT 10;


-- Online Order vs Offline Rating

SELECT CASE
    WHEN online_order=1 THEN 'Available'
    ELSE 'Unavailable'
    END as online_order,
    ROUND(AVG(rating), 2) AS avg_rating
FROM Restaurants
WHERE rating IS NOT NULL
GROUP BY online_order;


-- High Cost but Low Rating (RISKY RESTAURANTS)

SELECT restaurant_name,cost_for_two,rating
FROM Restaurants
WHERE cost_for_two>700 AND rating<3.5
ORDER BY rating;