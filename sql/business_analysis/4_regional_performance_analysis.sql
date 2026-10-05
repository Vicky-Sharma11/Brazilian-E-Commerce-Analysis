
-- Top 3 state by revenue

SELECT 
    c.customer_state
    ,SUM(ot.price + freight_value) AS total_revenue
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
JOIN order_items AS ot
    ON ot.order_id = o.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 3 ;

-- SP generates the highest revenue among states, with approximately R$5,921,678.12.

WITH state_late_orders AS (
    SELECT 
        c.customer_state
        ,COUNT(o.order_id) AS total_orders
        ,SUM(CASE WHEN o.delivered_to_customer_at > o.estimated_delivery_timestamp 
             THEN 1 ELSE 0 END
             ) AS late_orders
    FROM orders AS o
    JOIN customers AS c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_state 
)
SELECT
    customer_state
    ,total_orders
    ,late_orders
    ,ROUND(late_orders * 1.0 / total_orders * 100.0, 2) AS late_orders_rate
FROM state_late_orders
ORDER BY late_orders_rate DESC ; 


-- AL records the highest late order rate with roughly 23.93%
-- followed by MA with 19.67% 