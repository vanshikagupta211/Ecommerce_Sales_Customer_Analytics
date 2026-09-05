/*
===========================================================
03 - SALES ANALYSIS
===========================================================
Revenue, monthly sales, order trends and running revenue.
===========================================================
*/

USE ecommerce;
GO


-- ========================================================
-- 1. Total Revenue
-- ========================================================

SELECT
    SUM(payment_value) AS total_revenue
FROM dbo.payments;


-- ========================================================
-- 2. Monthly Revenue
-- ========================================================

SELECT
    FORMAT(o.order_purchase_timestamp, 'yyyy-MM') AS month,
    SUM(p.payment_value) AS monthly_revenue
FROM dbo.orders o
JOIN dbo.payments p
    ON o.order_id = p.order_id
GROUP BY FORMAT(o.order_purchase_timestamp, 'yyyy-MM')
ORDER BY month;


-- ========================================================
-- 3. Monthly Order Volume
-- ========================================================

SELECT
    FORMAT(order_purchase_timestamp, 'yyyy-MM') AS month,
    COUNT(order_id) AS total_orders
FROM dbo.orders
GROUP BY FORMAT(order_purchase_timestamp, 'yyyy-MM')
ORDER BY month;


-- ========================================================
-- 4. Revenue by Product Category
-- ========================================================

SELECT
    pr.product_category_name,
    SUM(oi.price + oi.freight_value) AS sales_value
FROM dbo.order_items oi
JOIN dbo.products pr
    ON oi.product_id = pr.product_id
GROUP BY pr.product_category_name
ORDER BY sales_value DESC;


-- ========================================================
-- 5. Running Revenue
-- ========================================================

WITH monthly_revenue AS
(
    SELECT
        FORMAT(o.order_purchase_timestamp, 'yyyy-MM') AS month,
        SUM(p.payment_value) AS revenue
    FROM dbo.orders o
    JOIN dbo.payments p
        ON o.order_id = p.order_id
    GROUP BY FORMAT(o.order_purchase_timestamp, 'yyyy-MM')
)

SELECT
    month,
    revenue,
    SUM(revenue) OVER (
        ORDER BY month
    ) AS running_revenue
FROM monthly_revenue
ORDER BY month;
