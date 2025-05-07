SELECT
cohort_year,
SUM(net_revenue)  AS total_revenue,
COUNT(DISTINCT customerkey)  AS total_customers,
SUM(net_revenue) / COUNT(DISTINCT customerkey) AS avg_customer_revenue
FROM 
cohort_analysis_view
GROUP BY
cohort_year
ORDER BY 
cohort_year;


/*
SELECT
DATE_TRUNC('month',orderdate)::DATE AS year_month,
SUM(net_revenue)  AS total_revenue,
COUNT(DISTINCT customerkey)  AS total_customers,
SUM(net_revenue) / COUNT(DISTINCT customerkey) AS avg_customer_revenue
FROM 
cohort_analysis 
GROUP BY
year_month
ORDER BY 
year_month 
*/