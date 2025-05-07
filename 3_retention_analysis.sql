WITH purchase_history AS (
	SELECT
		customerkey,
		fullname,
		orderdate,
		ROW_NUMBER() OVER (PARTITION BY customerkey ORDER BY orderdate DESC) AS rn,
		first_purchase_date,
		cohort_year
	FROM
		cohort_analysis_view
), churned_vs_active AS (
	SELECT
		customerkey,
		fullname,
		orderdate AS last_purchase_date,
		CASE
			WHEN orderdate < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 months' THEN 'Churned'
			ELSE 'Active'
		END AS customer_status,
		cohort_year
	FROM purchase_history 
	WHERE rn = 1
		AND first_purchase_date < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 months'
)

SELECT
	cohort_year,
	customer_status,
	COUNT(customerkey) AS num_customers,
	SUM(COUNT(customerkey)) OVER(PARTITION BY cohort_year) AS total_customers,
	ROUND(COUNT(customerkey) / SUM(COUNT(customerkey)) OVER(PARTITION BY cohort_year), 2) AS status_percentage
FROM churned_vs_active 
GROUP BY cohort_year, customer_status







