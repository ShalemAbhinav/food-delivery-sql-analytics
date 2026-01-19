-- Ranking Delivery Partners

SELECT delivery_partner_id,
    round(avg(time_taken_min), 2) AS avg_time,
    rank() OVER (ORDER BY avg(time_taken_min)) AS performance_rank
FROM delivery_details
GROUP BY delivery_partner_id;


-- Delivery Time Prcentile Count

WITH ordered AS (
  SELECT
    time_taken_min,
    ROW_NUMBER() OVER (ORDER BY time_taken_min) AS rn,
    COUNT(*) OVER () AS cnt
  FROM delivery_details
)
SELECT
  MAX(CASE
        WHEN rn IN (FLOOR((cnt + 1) / 2), CEIL((cnt + 1) / 2))
        THEN time_taken_min
      END) AS median_time,
  MAX(CASE
        WHEN rn = CEIL(cnt * 0.9)
        THEN time_taken_min
      END) AS p90_time
FROM ordered;


-- Partner performance vs overall average (CTE)

WITH avg_delivery AS (
    SELECT AVG(time_taken_min) AS overall_avg
    FROM delivery_details
),
partner_perf AS (
    SELECT
        delivery_partner_id,
        AVG(time_taken_min) AS partner_avg
    FROM delivery_details
    GROUP BY delivery_partner_id
)
SELECT
    p.delivery_partner_id,
    ROUND(p.partner_avg, 2) AS partner_avg_time,
    ROUND(a.overall_avg, 2) AS overall_avg_time,
    CASE
        WHEN p.partner_avg < a.overall_avg THEN 'Better than average'
        ELSE 'Worse than average'
    END AS performance_flag
FROM partner_perf p
CROSS JOIN avg_delivery a;


-- Top performer per vehicle type (WINDOW)

SELECT *
FROM (
    SELECT
        p.vehicle_type,
        d.delivery_partner_id,
        ROUND(AVG(d.time_taken_min), 2) AS avg_time,
        RANK() OVER (
            PARTITION BY p.vehicle_type
            ORDER BY AVG(d.time_taken_min)
        ) AS vehicle_rank
    FROM delivery_details d
    JOIN delivery_partners p
      ON d.delivery_partner_id = p.delivery_partner_id
    GROUP BY p.vehicle_type, d.delivery_partner_id
) ranked
WHERE vehicle_rank = 1;


-- Delivery time percentile bucket (WINDOW)

SELECT
    order_id,
    time_taken_min,
    NTILE(4) OVER (ORDER BY time_taken_min) AS delivery_quartile
FROM delivery_details;


-- Partner consistency (variance analysis)

SELECT
    delivery_partner_id,
    ROUND(AVG(time_taken_min), 2) AS avg_time,
    ROUND(STDDEV(time_taken_min), 2) AS time_variance
FROM delivery_details
GROUP BY delivery_partner_id
ORDER BY time_variance DESC;


-- Extreme slow deliveries (outliers)

SELECT *
FROM delivery_details
WHERE time_taken_min >(
    SELECT AVG(time_taken_min) + 2 * STDDEV(time_taken_min)
    FROM delivery_details
);


-- Running average delivery time (WINDOW)

SELECT
    order_id,
    time_taken_min,
    ROUND(
        AVG(time_taken_min) OVER (
            ORDER BY order_id
            ROWS BETWEEN 10 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS rolling_avg_time
FROM delivery_details;