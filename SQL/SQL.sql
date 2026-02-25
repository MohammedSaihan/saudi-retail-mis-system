-- Executive KPI Query
SELECT
 SUM(revenue_sar) AS total_revenue,
 COUNT(DISTINCT invoice_id) AS total_orders,
 SUM(quantity) AS total_units,
 ROUND(SUM(revenue_sar) / COUNT(DISTINCT invoice_id),2) AS AOV
FROM sales_clean;

-- Monthly Revenue Trend


