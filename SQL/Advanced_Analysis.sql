/*
===========================================================
07 - ADVANCED ANALYSIS
===========================================================
Cohort and customer retention analysis.
===========================================================
*/

USE ecommerce;
GO


-- ========================================================
-- 1. First Purchase Month
-- ========================================================

WITH first_order AS
(
    SELECT
        customer_id,
        MIN(order_purchase_timestamp) AS first_purchase
    FROM dbo.orders
    GROUP BY customer_id
)

SELECT *
FROM first_order;


-- ========================================================
-- 2. Customer Cohort Analysis
-- ========================================================

WITH first_order AS
(
    SELECT
        customer_id,
        MIN(order_purchase_timestamp) AS first_purchase
    FROM dbo.orders
    GROUP BY customer_id
),

cohort_data AS
(
    SELECT
        o.customer_id,

        FORMAT(
            f.first_purchase,
            'yyyy-MM'
        ) AS cohort_month,

        FORMAT(
            o.order_purchase_timestamp,
            'yyyy-MM'
        ) AS order_month

    FROM dbo.orders o

    JOIN first_order f
        ON o.customer_id = f.customer_id
)

SELECT
    cohort_month,
    order_month,
    COUNT(DISTINCT customer_id) AS customers

FROM cohort_data

GROUP BY
    cohort_month,
    order_month

ORDER BY
    cohort_month,
    order_month;
