-- Executive KPI Query
SELECT
 SUM(revenue_sar) AS total_revenue,
 COUNT(DISTINCT invoice_id) AS total_orders,
 SUM(quantity) AS total_units,
 ROUND(SUM(revenue_sar) / COUNT(DISTINCT invoice_id),2) AS AOV
FROM sales_clean;

-- Monthly Revenue Trend

SELECT 
	YEAR(date) AS year,
    MONTH(date) AS month,
    ROUND(SUM(revenue_sar),2) AS total_revenue
FROM sales_clean
GROUP BY year, month
ORDER BY year, month;

-- 3) Month-over-Month Growth

SELECT 
 year,
 month,
 revenue,
 LAG(revenue) OVER (ORDER BY year, month) AS prev_month,
 ROUND((revenue - LAG(revenue) OVER (ORDER BY year, month))
 / LAG(revenue) OVER (ORDER BY year, month) * 100,2) AS growth_pct
FROM (
   SELECT YEAR(date) year, MONTH(date) month,
   SUM(revenue_sar) revenue
   FROM sales_clean
   GROUP BY year, month
) t;

-- 4) Revenue by City (Management
SELECT 
 city,
 SUM(revenue_sar) revenue,
 ROUND(SUM(revenue_sar) / 
      (SELECT SUM(revenue_sar) FROM sales_clean) * 100,2) AS contribution_pct
FROM sales_clean
GROUP BY city
ORDER BY revenue DESC;

-- 5) Top 10 Products

SELECT
	product,
    ROUND(SUM(revenue_sar),2) AS revenue
FROM sales_clean
GROUP BY product
ORDER BY revenue DESC 
LIMIT 10;

-- 6) Best Selling Products by City

SELECT city, product, SUM(revenue_sar) as revenue
FROM sales_clean
GROUP BY city, product
ORDER BY city, revenue DESC;