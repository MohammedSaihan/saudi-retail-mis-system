-- Total Customers

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM sales_clean;

-- Customers With At Least One Purchase

SELECT COUNT(DISTINCT customer_id) AS customers_with_purchase
FROM sales_clean
WHERE quantity > 0;

-- Repeat Customers

SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT customer_id
    FROM sales_clean
    GROUP BY customer_id
    HAVING COUNT(DISTINCT invoice_id) > 1
)t ;

-- High Value Customers

SELECT COUNT(*) AS high_value_customers
FROM (
    SELECT
        customer_id,
        SUM(quantity * unit_price_sar) AS total_spend
    FROM sales_clean
    GROUP BY customer_id
    HAVING SUM(quantity * unit_price_sar) > 500
) t;


SELECT
    COUNT(DISTINCT customer_id) AS total_customers,

    SUM(CASE WHEN order_count >= 1 THEN 1 ELSE 0 END) AS customers_with_purchase,

    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,

    SUM(CASE WHEN total_spend > 500 THEN 1 ELSE 0 END) AS high_value_customers

FROM
(
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_id) AS order_count,
        SUM(quantity * unit_price_sar) AS total_spend
    FROM sales_clean
    GROUP BY customer_id
) t;

-- Repeat Purchase Rate

SELECT
    ROUND(
        SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)
        /
        COUNT(customer_id) * 100
    ,2) AS repeat_purchase_rate
FROM
(
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_id) AS order_count
    FROM sales_clean
    GROUP BY customer_id
) t;

-- Average Customer Lifetime Value (CLV)

SELECT
    AVG(total_spend) AS avg_customer_lifetime_value
FROM
(
    SELECT
        customer_id,
        SUM(quantity * unit_price_sar) AS total_spend
    FROM sales_clean
    GROUP BY customer_id
) t;