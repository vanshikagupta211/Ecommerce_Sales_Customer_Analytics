/*
===========================================================
06 - DELIVERY ANALYSIS
===========================================================
Delivery performance and late delivery analysis.
===========================================================
*/

USE ecommerce;
GO


-- ========================================================
-- 1. Average Delivery Time
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
-- 2. Late Delivery Orders
-- ========================================================

SELECT
    COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN order_delivered_customer_date >
                 order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_orders

FROM dbo.orders
WHERE order_delivered_customer_date IS NOT NULL;


-- ========================================================
-- 3. Late Delivery Percentage
-- ========================================================

SELECT
    COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN order_delivered_customer_date >
                 order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_orders,

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
-- 4. Average Delivery Days by Customer City
-- ========================================================

SELECT
    c.customer_city,

    AVG(
        DATEDIFF(
            DAY,
            o.order_purchase_timestamp,
            o.order_delivered_customer_date
        )
    ) AS average_delivery_days

FROM dbo.orders o

JOIN dbo.customers c
    ON o.customer_id = c.customer_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY c.customer_city

ORDER BY average_delivery_days DESC;
