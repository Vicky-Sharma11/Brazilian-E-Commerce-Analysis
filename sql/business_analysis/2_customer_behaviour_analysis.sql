-- -- Monthly active customers (with delivered orders)

SELECT 
    DATE_TRUNC('MONTH', o.purchase_timestamp) AS mnth
    ,COUNT(DISTINCT c.customer_unique_id) AS customer_count
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
    AND o.order_status = 'delivered'
    AND DATE(o.purchase_timestamp) >= '2017-01-01'
GROUP BY DATE_TRUNC('MONTH', o.purchase_timestamp) 
ORDER BY mnth ;

-- Top 50 Customers based on revenue

SELECT 
    c.customer_unique_id
    ,SUM(ot.price + ot.freight_value) AS total_revenue
    ,COUNT(DISTINCT o.order_id) AS total_orders
    ,COUNT(ot.order_item_id) AS item_purchased
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
    AND o.order_status = 'delivered' 
JOIN order_items AS ot
    ON ot.order_id = o.order_id 
GROUP BY c.customer_unique_id 
ORDER BY total_revenue DESC
LIMIT 50 ;


-- Repeat customer percentage

WITH customer_type AS (
    SELECT
        c.customer_unique_id
        ,CASE
            WHEN COUNT(o.order_id) > 1 
            THEN 'repeat'
            ELSE 'single'
        END AS customer_type
    FROM orders AS o
    INNER JOIN customers AS c
        ON o.customer_id = c.customer_id
        AND o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
ROUND(
    COUNT(*) FILTER(WHERE customer_type = 'repeat') 
    * 1.0 / COUNT(*) * 100.0
    , 2) AS repeat_customers_rate
FROM customer_type ;


-- Approximately 3% of customers placed more than one delivered order, indicating low 
-- repeat purchasing.

-- Customer segmentation

WITH customer_wise_revenue_orders AS (
    SELECT 
        c.customer_unique_id
        ,SUM(ot.price + ot.freight_value) AS total_revenue
        ,COUNT(DISTINCT o.order_id) AS total_orders
    FROM customers AS c
    JOIN orders AS o
        ON c.customer_id = o.customer_id
        AND o.order_status = 'delivered' 
    JOIN order_items AS ot
        ON ot.order_id = o.order_id 
    GROUP BY c.customer_unique_id
)
,customer_segmentation AS (
    SELECT
        customer_unique_id
        ,total_revenue
        ,total_orders
        ,CASE
            WHEN total_revenue >= 500  THEN 'High-value customers'
            WHEN total_revenue >= 200 THEN 'Mid-value customers'
            ELSE 'Low-value customers'
        END AS customer_segment
    FROM customer_wise_revenue_orders
)
SELECT
    customer_segment 
    ,COUNT(customer_unique_id) AS customer_count
    ,SUM(total_revenue) AS total_revenue
    ,SUM(total_orders) AS total_orders
    ,SUM(total_revenue) / SUM(SUM(total_revenue)) OVER() * 100.0  AS perc_share_revenue
    ,SUM(total_revenue) / COUNT(customer_unique_id)  AS avg_revenue_per_cust
    ,SUM(total_revenue) / SUM(total_orders) AS avg_order_value_per_segment
FROM customer_segmentation 
GROUP BY customer_segment ;

/* 
Low-value customers represent the largest customer group (73,372) and contribute approximately 44.73% 
of revenue. while mid-value customers (15,772) contribute 29.73% and high-value customers (4,264) contribute 25.53%
*/

-- Repeat customer analysis

SELECT 
    c.customer_unique_id
    ,COUNT(DISTINCT o.order_id) AS total_orders
    ,SUM(ot.price + ot.freight_value) AS total_revenue
    ,COUNT(ot.order_item_id) AS item_purchased
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
    AND o.order_status = 'delivered'
JOIN order_items AS ot
    ON ot.order_id = o.order_id 
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) > 1 
ORDER BY total_revenue DESC ;

-- Among repeat customers customer da122df9eeddfedc1dc1f5349a1a690c generated the highest 
-- total revenue with roughly R$7,571.63 from 2 delivered orders having 2 order items.




