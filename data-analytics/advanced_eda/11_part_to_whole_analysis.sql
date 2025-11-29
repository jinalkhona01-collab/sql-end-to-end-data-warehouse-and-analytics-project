/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/

--10. Part-to-Whole Analysis (Proportional) (individual part is performing compared to overall, understand which category has the greatest impact on the business)

--Which categories contribute the most of overall sales?
WITH category_sales AS (
SELECT 
p.category,
SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.category)  -- Grouping by the category


SELECT 
category, 
total_sales,
SUM(total_sales) OVER () AS overall_sales,
CONCAT(ROUND(total_sales/SUM(total_sales) OVER () * 100,2),'%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;


--Overall sales contribution by region 
WITH region_sales AS (
SELECT
c.country AS region,  
SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c 
ON f.customer_key = c.customer_key
GROUP BY c.country -- Grouping by the region
)

SELECT
region,
total_sales,
SUM(total_sales) OVER () AS overall_sales,
CONCAT(ROUND(total_sales/ SUM(total_sales) OVER ()*100,2),'%') AS percentage_of_total
FROM region_sales
ORDER BY percentage_of_total DESC;
