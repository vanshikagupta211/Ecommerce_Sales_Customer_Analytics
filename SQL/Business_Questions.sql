/*
===========================================================
08 - BUSINESS QUESTIONS
===========================================================
Business questions answered using SQL.
===========================================================
*/

USE ecommerce;
GO


-- ========================================================
-- 1. Which city generates the highest revenue?
-- ========================================================

SELECT
    c.customer_city,
    SUM(p.payment_value) AS revenue

FROM dbo.orders o

JOIN dbo.customers c
    ON o.customer_id = c.customer_id

JOIN dbo.payments p
    ON o.order_id = p.order_id

GROUP BY c.customer_city

ORDER BY revenue DESC;


-- ========================================================
-- 2. Which month has the highest number of orders?
-- ========================================================

SELECT
    FORMAT(
        order_purchase_timestamp,
        'yyyy-MM'
    ) AS month,

    COUNT(order_id) AS total_orders

FROM dbo.orders

GROUP BY FORMAT(
    order_purchase_timestamp,
    'yyyy-MM'
)

ORDER BY total_orders DESC;


-- ========================================================
-- 3. Which product categories generate the most sales?
-- ========================================================

SELECT
    pr.product_category_name,
    SUM(oi.price + oi.freight_value) AS sales

FROM dbo.order_items oi

JOIN dbo.products pr
    ON oi.product_id = pr.product_id

GROUP BY pr.product_category_name

ORDER BY sales DESC;


-- ========================================================
-- 4. What is the average delivery time?
-- ========================================================

SELECT
    AVG(
        DATEDIFF(
            DAY,
            order_purchase_timestamp,
            order_delivered_customer_date
        )
    ) AS average_delivery_days

FROM dbo.orders

WHERE order_delivered_customer_date IS NOT NULL;


-- ========================================================
-- 5. What percentage of orders were delivered late?
-- ========================================================

SELECT
    SUM(
        CASE
            WHEN order_delivered_customer_date >
                 order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS late_delivery_percentage

FROM dbo.orders

WHERE order_delivered_customer_date IS NOT NULL;


-- ========================================================
-- 6. Who are the top 10 customers by spending?
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
-- 7. Which customer segment is most valuable?
-- ========================================================

WITH customer_spending AS
(
    SELECT
        o.customer_id,
        SUM(p.payment_value) AS total_spent

    FROM dbo.orders o

    JOIN dbo.payments p
        ON o.order_id = p.order_id

    GROUP BY o.customer_id
)

SELECT
    CASE
        WHEN total_spent > 1000
            THEN 'High Value'

        WHEN total_spent BETWEEN 500 AND 1000
            THEN 'Medium'

        ELSE 'Low'
    END AS customer_segment,

    COUNT(*) AS customers,
    SUM(total_spent) AS segment_revenue

FROM customer_spending

GROUP BY
    CASE
        WHEN total_spent > 1000
            THEN 'High Value'

        WHEN total_spent BETWEEN 500 AND 1000
            THEN 'Medium'

        ELSE 'Low'
    END

ORDER BY segment_revenue DESC;
