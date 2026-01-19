-- Average Delivery Time Overall

SELECT round(avg(time_taken_min),2) as avg_delivery_time
FROM delivery_details;


-- Average Delivery Time By Vehicle

SELECT dp.vehicle_type, round(avg(dd.time_taken_min),2) as avg_time
FROM delivery_partners dp
JOIN delivery_details dd ON dp.delivery_partner_id=dd.delivery_partner_id
GROUP BY dp.vehicle_type
ORDER BY avg_time;


-- Rider rating vs delivery time

SELECT CASE
    WHEN dp.partner_rating< 3 THEN 'Low'
    WHEN dp.partner_rating BETWEEN 3 AND 4 THEN 'Medium'
    ELSE 'High'
    END as rating_bucket,
    round(avg(dd.time_taken_min),2) as avg_time
FROM delivery_partners dp
JOIN delivery_details dd ON dp.delivery_partner_id=dd.delivery_partner_id
GROUP BY rating_bucket;


-- Age vs delivery time
SELECT CASE
    WHEN dp.age< 25 THEN 'Young'
    WHEN dp.age BETWEEN 25 AND 35 THEN 'Mid'
    ELSE 'Senior'
    END as age_group,
    round(avg(dd.time_taken_min),2) as avg_time
FROM delivery_partners dp
JOIN delivery_details dd ON dp.delivery_partner_id=dd.delivery_partner_id
GROUP BY age_group;