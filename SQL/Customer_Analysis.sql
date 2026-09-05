/*
===========================================================
04 - CUSTOMER ANALYSIS
===========================================================
Customer ranking, segmentation, retention and AOV.
===========================================================
*/

USE ecommerce;
GO


-- ========================================================
-- 1. Top 10 Customers
-- ========================================================

SELECT TOP 10
    o.customer_id,
    SUM(p.payment_value) AS total_spent
FROM dbo.orders o
JOIN dbo.payments p
    ON o.order_id = p.order_id
GROUP BY o.customer_id
ORDER BY total_spent DESC;


-- ========================================================
-- 2. Top Customers Using RANK()
-- ========================================================

WITH customer_revenue AS
(
    SELECT
        o.customer_id,
        SUM(p.payment_value) AS revenue
    FROM dbo.orders o
    JOIN dbo.payments p
        ON o.order_id = p.order_id
    GROUP BY o.customer_id
),

ranked_customers AS
(
    SELECT
        customer_id,
        revenue,
        RANK() OVER (
            ORDER BY revenue DESC
        ) AS customer_rank
    FROM customer_revenue
)

SELECT *
FROM ranked_customers
WHERE customer_rank <= 10
ORDER BY customer_rank;


-- ========================================================
-- 3. Customer Segmentation
-- ========================================================

SELECT
    o.customer_id,
    SUM(p.payment_value) AS total_spent,

    CASE
        WHEN SUM(p.payment_value) > 1000
            THEN 'High Value'

        WHEN SUM(p.payment_value) BETWEEN 500 AND 1000
            THEN 'Medium'

        ELSE 'Low'
    END AS customer_segment

FROM dbo.orders o

JOIN dbo.payments p
    ON o.order_id = p.order_id

GROUP BY o.customer_id;


-- ========================================================
-- 4. Repeat Customers
-- ========================================================

WITH customer_orders AS
(
    SELECT
        customer_id,
        COUNT(order_id) AS order_count
    FROM dbo.orders
    GROUP BY customer_id
)

SELECT
    COUNT(*) AS total_customers,
    SUM(
        CASE
            WHEN order_count > 1 THEN 1
            ELSE 0
        END
    ) AS repeat_customers
FROM customer_orders;


-- ========================================================
-- 5. Average Order Value
-- ========================================================

SELECT
    SUM(payment_value) /
    COUNT(DISTINCT order_id) AS average_order_value
FROM dbo.payments;
