WITH ltv_data AS (SELECT 
customerkey,
fullname,
SUM(net_revenue) AS customer_ltv
FROM
cohort_analysis_view
GROUP BY
customerkey,
fullname ),

partition_criteria AS(
SELECT
PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY customer_ltv) AS low_value_ltv,
PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY customer_ltv) AS high_value_ltv
FROM ltv_data

),

customer_segmentation AS(SELECT l.* ,
CASE WHEN l.customer_ltv <= p.low_value_ltv THEN '1.Low-value'
WHEN l.customer_ltv >= p.high_value_ltv THEN '3.High-value'
ELSE '2.Mid-value'
END AS customer_segment

FROM ltv_data l,
partition_criteria p)

SELECT cs.customer_segment,
sum(cs.customer_ltv),
count(cs.customerkey),
sum(cs.customer_ltv) / count(cs.customerkey) AS avg_ltv
FROM
customer_segmentation cs
GROUP BY
customer_segment
ORDER BY
customer_segment DESC 