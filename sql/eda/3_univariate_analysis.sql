-- Order distribution by order status

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
    FROM orders AS o
    INNER JOIN customers AS c
        ON o.customer_id = c.customer_id
        AND o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
    HAVING COUNT(*) > 1 
) ;

-- There are only 2997 customes who placed more than one delivered order
-- and 93,099 with only one delivered order


-- Orders cancellation rate

SELECT 
ROUND(
    COUNT(*) * 1.0 / (SELECT COUNT(*) FROM orders ) * 100
    , 2) AS cancellation_rate
FROM orders
WHERE order_status = 'canceled' ;

-- Late order percentage share

SELECT 
    ROUND(
        COUNT(*) * 1.0 / (SELECT COUNT(*) FROM orders WHERE order_status = 'delivered' ) * 100.0
        ,2)
FROM orders
WHERE order_status = 'delivered'
    AND delivered_to_customer_at > estimated_delivery_timestamp ;

-- 7826 late deliveries, representing approximately 8.11% of delivered orders.


-- Average time taken to deliver an order ( from purchase date to delivered date)

SELECT 
    ROUND(
        EXTRACT(
            EPOCH FROM AVG(delivered_to_customer_at - purchase_timestamp)
            ) / 86400
        , 2) AS delivery_time
FROM orders
WHERE order_status = 'delivered' ;


-- Product wise revenue

SELECT 
    product_id
    ,SUM(ot.price + ot.freight_value) AS sales
FROM order_items AS ot 
INNER JOIN orders AS o
    ON ot.order_id = o.order_id
    AND o.order_status = 'delivered'
GROUP BY product_id
ORDER BY sales DESC ;

-- Seller wise revenue

SELECT
    seller_id
    ,SUM(ot.price + ot.freight_value) AS sales
FROM order_items AS ot 
INNER JOIN orders AS o
    ON ot.order_id = o.order_id
    AND o.order_status = 'delivered'
GROUP BY seller_id 
ORDER BY sales DESC ;

-- Payment value by payment type

SELECT 
    payment_type
    ,SUM(payment_value) AS total_payment_value
FROM order_payments AS op 
INNER JOIN orders AS o 
    ON op.order_id = o.order_id
    AND o.order_status = 'delivered'
GROUP BY payment_type 
ORDER BY total_payment_value DESC;

-- Total revenue by states

SELECT
    c.customer_state
    ,SUM(ot.price + ot.freight_value) AS total_revenue
FROM customers  AS c 
JOIN orders AS o 
    ON c.customer_id = o.customer_id
    AND o.order_status = 'delivered'
JOIN order_items AS ot 
    ON o.order_id = ot.order_id 
GROUP BY c.customer_state
ORDER BY total_revenue DESC ;

-- Total revenue by category

SELECT 
    c.product_category_name_english
    ,SUM(ot.price + ot.freight_value) AS total_revenue
FROM products AS p
JOIN product_category_name_translation AS c
    ON c.product_category_name = p.product_category_name
JOIN order_items AS ot
    ON p.product_id = ot.product_id
JOIN orders AS o
    ON o.order_id = ot.order_id
    AND o.order_status = 'delivered'
GROUP BY c.product_category_name_english 
ORDER BY total_revenue DESC ;



