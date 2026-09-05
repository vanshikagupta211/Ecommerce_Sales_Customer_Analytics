/*
===========================================================
05 - PRODUCT ANALYSIS
===========================================================
Product and category performance analysis.
===========================================================
*/

USE ecommerce;
GO


-- ========================================================
-- 1. Revenue by Product Category
-- ========================================================

SELECT
    pr.product_category_name,
    SUM(oi.price + oi.freight_value) AS revenue
FROM dbo.order_items oi

JOIN dbo.products pr
    ON oi.product_id = pr.product_id

GROUP BY pr.product_category_name
ORDER BY revenue DESC;


-- ========================================================
-- 2. Top Product Categories
-- ========================================================

SELECT TOP 10
    pr.product_category_name,
    SUM(oi.price + oi.freight_value) AS revenue
FROM dbo.order_items oi

JOIN dbo.products pr
    ON oi.product_id = pr.product_id

GROUP BY pr.product_category_name
ORDER BY revenue DESC;


-- ========================================================
-- 3. Category Contribution %
-- ========================================================

WITH category_revenue AS
(
    SELECT
        pr.product_category_name,
        SUM(oi.price + oi.freight_value) AS revenue
    FROM dbo.order_items oi

    JOIN dbo.products pr
        ON oi.product_id = pr.product_id

    GROUP BY pr.product_category_name
)

SELECT
    product_category_name,
    revenue,
    revenue * 100.0 /
        SUM(revenue) OVER () AS contribution_percentage
FROM category_revenue
ORDER BY revenue DESC;
