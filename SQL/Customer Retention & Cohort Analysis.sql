-- customer first purchase table

CREATE VIEW customer_first_purchase AS
SELECT
    customer_id,
    MIN(DATE(date)) AS first_purchase_date,
    DATE_FORMAT(MIN(DATE(date)), '%Y-%m-01') AS cohort_month
FROM sales_clean
GROUP BY customer_id;

# select * from customer_first_purchase


-- Join transactions with cohort
CREATE VIEW cohort_transactions AS
SELECT
    r.customer_id,
    r.date,
    c.cohort_month,
    PERIOD_DIFF(
        DATE_FORMAT(r.date,'%Y%m'),
        DATE_FORMAT(c.first_purchase_date,'%Y%m')
    ) AS months_since_first_purchase
FROM sales_clean r
JOIN customer_first_purchase c
ON r.customer_id = c.customer_id;

# select * from cohort_transactions


-- Build retention table

CREATE VIEW cohort_retention AS
SELECT
    cohort_month,
    months_since_first_purchase,
    COUNT(DISTINCT customer_id) AS active_customers
FROM cohort_transactions
GROUP BY cohort_month, months_since_first_purchase
ORDER BY cohort_month, months_since_first_purchase;

# SELECT * FROM cohort_retention

-- Cohort size

CREATE VIEW cohort_size AS
SELECT
    cohort_month,
    COUNT(DISTINCT customer_id) AS cohort_customers
FROM customer_first_purchase
GROUP BY cohort_month;

SELECT * FROM cohort_size


-- Final retention percentage table

SELECT
    r.cohort_month,
    r.months_since_first_purchase,
    r.active_customers,
    c.cohort_customers,
    ROUND(r.active_customers / c.cohort_customers * 100, 2) AS retention_rate
FROM cohort_retention r
JOIN cohort_size c
ON r.cohort_month = c.cohort_month;
