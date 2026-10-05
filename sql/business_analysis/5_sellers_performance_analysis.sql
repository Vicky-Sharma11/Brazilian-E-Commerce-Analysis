-- Monthy active sellers

SELECT 
    DATE_TRUNC('MONTH', purchase_timestamp) AS mnth
    ,COUNT(DISTINCT ot.seller_id) AS total_sellers
FROM orders AS o
JOIN order_items AS ot
    ON o.order_id = ot.order_id
    AND o.order_status = 'delivered'
    AND DATE(o.purchase_timestamp) >= '2017-01-01'
GROUP BY DATE_TRUNC('MONTH', purchase_timestamp)
ORDER BY mnth ;

/*The number of active sellers generally increased over time, with the highest 
number recorded in October 2018 (1261) and the lowest in January 2017 (219).*/


-- Are sellers shipping the orders at time ?


WITH shipping_status AS (
SELECT 
    DISTINCT
    ot.order_id
    ,CASE 
        WHEN o.delivered_to_carrier_at > ot.shipping_limit_date
        THEN 'Late'
        ELSE 'On time'
    END AS order_shipping_status
FROM orders AS o
JOIN order_items AS ot
    ON o.order_id = ot.order_id
    AND o.order_status = 'delivered'
)
SELECT
    order_shipping_status
    ,COUNT(*) * 1.0  / (SELECT COUNT(*) FROM shipping_status) * 100.0 AS pct
FROM shipping_status
WHERE order_shipping_status = 'Late'
GROUP BY order_shipping_status ;

-- About 9% of delivered orders were shipped late.

-- Top 50 sellers by revenue

SELECT
    ot.seller_id
    ,SUM(ot.price + ot.freight_value) AS total_revenue
    ,COUNT(*) AS item_sold
    ,COUNT(DISTINCT ot.order_id) AS total_orders
FROM order_items AS ot
JOIN orders AS o
    ON o.order_id = ot.order_id
    AND o.order_status = 'delivered'
GROUP BY ot.seller_id
ORDER BY total_revenue DESC 
LIMIT 50 ;

-- The highest-revenue seller generated approximately R$247,007.06 from 
-- 1,124 delivered orders and 1,148 items sold

