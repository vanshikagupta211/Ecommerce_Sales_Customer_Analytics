/*
===========================================================
02 - DATA PREPARATION
===========================================================
Creates a reusable analytical dataset using CTEs.
===========================================================
*/

USE ecommerce;
GO


-- ========================================================
-- 1. Order-Level Payment Summary
-- ========================================================

WITH payment_summary AS
(
    SELECT
        order_id,
        SUM(payment_value) AS total_payment_value
    FROM dbo.payments
    GROUP BY order_id
)

SELECT TOP 100
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    ps.total_payment_value
FROM dbo.orders o
LEFT JOIN payment_summary ps
    ON o.order_id = ps.order_id
ORDER BY o.order_purchase_timestamp;
GO


-- ========================================================
-- 2. Order-Level Analytical Dataset
-- ========================================================

WITH payment_summary AS
(
    SELECT
        order_id,
        SUM(payment_value) AS total_payment_value
    FROM dbo.payments
    GROUP BY order_id
)

SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_estimated_delivery_date,
    o.order_delivered_customer_date,
    ps.total_payment_value,
    c.customer_city,
    c.customer_state
FROM dbo.orders o

LEFT JOIN payment_summary ps
    ON o.order_id = ps.order_id

LEFT JOIN dbo.customers c
    ON o.customer_id = c.customer_id;
GO
