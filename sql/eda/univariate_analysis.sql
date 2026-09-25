
-- Orders by order status

SELECT 
    order_status
    ,ROUND(
        COUNT(*) * 1.0 / (SELECT COUNT(*) FROM orders) * 100
        ,2 )
FROM orders 
GROUP BY order_status ;

-- Orders by customers 

SELECT
    c.customer_unique_id
    ,COUNT(*) AS total_orders
FROM orders AS o
INNER JOIN customers AS c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id ;

-- Count of customers who placed more than one order

SELECT
    COUNT(*) 
FROM (
    SELECT
        c.customer_unique_id
        ,COUNT(*) AS total_orders
    FROM orders AS o
    INNER JOIN customers AS c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(*) > 1 
) ;

-- There are only 2997 customes who placed more than single order
-- and 93,099 with only one order

-- Late order percentage share

SELECT 
    ROUND(
        COUNT(*)-- * 1.0 / (SELECT COUNT(*) FROM orders WHERE delivered_to_customer_at IS NOT NULL) * 100.0
        ,2)
FROM orders
WHERE delivered_to_customer_at IS NOT NULL
    AND DATE(delivered_to_customer_at) > DATE(estimated_delivery_timestamp) ;

-- 6,535 late deliveries, representing approximately 6.77% of delivered orders.
-- Note: Only orders with a recorded delivery date are considered. 
-- This can include orders with a canceled status if they were delivered before cancellation.

-- Average time taken to deliver an order ( from purchase date to delivered date)

SELECT 
    ROUND(
        EXTRACT(EPOCH FROM AVG(delivered_to_customer_at - purchase_timestamp)) / 86400
        , 2) AS delivery_time
FROM orders
WHERE delivered_to_customer_at IS NOT NULL ;

