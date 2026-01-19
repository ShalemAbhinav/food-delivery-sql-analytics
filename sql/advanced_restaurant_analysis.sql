-- Area-wise Restaurant Rating

SELECT
    restaurant_name,
    area,
    cost_for_two,
    rating,
    RANK() OVER (
        PARTITION BY area
        ORDER BY rating DESC
    ) AS area_rating_rank
FROM restaurants
WHERE rating IS NOT NULL;


-- Overpriced restaurants vs area median rating
WITH area_median AS (
  SELECT area,
         PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rating) AS median_rating
  FROM restaurants
  WHERE rating IS NOT NULL
  GROUP BY area
)
SELECT r.restaurant_name,
       r.area,
       r.cost_for_two,
       r.rating,
       m.median_rating
FROM restaurants r
JOIN area_median m
  ON r.area = m.area
WHERE r.cost_for_two > 600
  AND r.rating < m.median_rating;


-- Cuisine Availability In Restaurants

SELECT jt.cuisine,count(*) AS restaurant_count
FROM Restaurants r
JOIN JSON_TABLE(
    CONCAT('["',REPLACE(r.cuisines,', ','","'),'"]'), '$[*]'
    COLUMNS(cuisine varchar(100) PATH '$')
) AS jt
GROUP BY jt.cuisine
ORDER BY restaurant_count DESC;