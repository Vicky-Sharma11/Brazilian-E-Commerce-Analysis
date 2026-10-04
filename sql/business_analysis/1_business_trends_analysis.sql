-- Monthly trend of total revenue 

SELECT 
    DATE_TRUNC('MONTH', purchase_timestamp) AS mnth
    ,ROUND(
        SUM(ot.price + ot.freight_value)
        , 2) AS total_revenue
FROM orders AS o
JOIN order_items AS ot
    ON o.order_id = ot.order_id
    AND o.order_status = 'delivered' 
    WHERE DATE(o.purchase_timestamp) >= '2017-01-01'
GROUP BY DATE_TRUNC('MONTH', purchase_timestamp)
ORDER BY mnth ;

/*November 2017 had the highest revenue of R$1,153,364.20, driven by the 
highest number of orders in the month, during the Black Friday period. */

/*January 2017 recorded the lowest revenue of 127,482.37 driven by the 
lowest number of orders and sellers during the period. */

-- ===============================================================================================================
-- Creating monthly revenue view 
-- ===============================================================================================================

CREATE VIEW monthly_revenue AS
SELECT 
    DATE_TRUNC('MONTH', purchase_timestamp) AS mnth
    ,ROUND(
        SUM(ot.price + ot.freight_value)
        , 2) AS total_revenue
FROM orders AS o
JOIN order_items AS ot
    ON o.order_id = ot.order_id
    AND o.order_status = 'delivered' 
    WHERE DATE(o.purchase_timestamp) >= '2017-01-01'
GROUP BY DATE_TRUNC('MONTH', purchase_timestamp)
ORDER BY mnth ;


-- Monthly trend of average order value

WITH revenue_per_order AS (
    SELECT 
        order_id
        ,SUM(price + freight_value) AS rev_per_order
    FROM order_items 
    GROUP BY order_id
)
SELECT
    DATE_TRUNC('MONTH', o.purchase_timestamp) AS mnth
    ,ROUND(
        AVG(rpo.rev_per_order)
        ,2) AS avg_order_value
FROM revenue_per_order AS rpo
JOIN orders AS o
    ON rpo.order_id = o.order_id
    AND o.order_status = 'delivered'
    AND DATE(o.purchase_timestamp) >= '2017-01-01'
GROUP BY DATE_TRUNC('MONTH', o.purchase_timestamp)
ORDER BY mnth ; 

-- Jan 2017 recorded highest avg order value of 170 (aproxx) while Feb 2018 had the lowest (147.39)


-- Month over month revenue growth

WITH previous_month_sales AS (
    SELECT
        mnth
        ,total_revenue AS current_mnth_revenue
        ,LAG(total_revenue) OVER (
            ORDER BY mnth
        ) AS prev_mnth_revenue
    FROM monthly_revenue
)
SELECT
    mnth
    ,ROUND(
        (current_mnth_revenue - prev_mnth_revenue) / prev_mnth_revenue * 100.0
        ,2) AS growth_per
FROM previous_month_sales ;

/* February 2017 recorded the highest month-over-month revenue growth of approximately 112.77%, 
while December 2017 recorded the highest decline of approximately 26.90%. */


-- Monthly trend of total orders

SELECT
    DATE_TRUNC('MONTH', purchase_timestamp) AS mnth
    ,COUNT(order_id) AS total_orders
FROM orders
WHERE order_status = 'delivered'
AND DATE(purchase_timestamp) >= '2017-01-01'
GROUP BY DATE_TRUNC('MONTH', purchase_timestamp) 
ORDER BY mnth ;

/* November 2017 recorded the highest number (7289) or orders while January 2017 
had the lowest (750) */


-- Cumulative sales over the period of time 

SELECT
    mnth
    ,total_revenue
    ,SUM(total_revenue) OVER (
        ORDER BY mnth 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_monthly_revenue
FROM monthly_revenue ;

-- 3 month rolling averages

SELECT
    mnth
    ,total_revenue
    ,AVG(total_revenue) OVER(
        ORDER BY mnth 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS three_month_rolling_average
FROM monthly_revenue ;

