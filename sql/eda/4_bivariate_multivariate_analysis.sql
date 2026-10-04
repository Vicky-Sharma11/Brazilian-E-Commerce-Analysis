
-- =====================================================================================================================
-- Bivariate analysis
-- =====================================================================================================================

-- Do late deliveries tend to receive lower review scores?

WITH order_type AS (
    SELECT 
        order_id
        ,CASE
            WHEN DATE(delivered_to_customer_at) > DATE(estimated_delivery_timestamp)  THEN 'Late'
            ELSE 'On time'
        END AS order_type
    FROM orders
    WHERE order_status = 'delivered'
)
SELECT
     odt.order_type
    ,AVG(ors.review_score) AS avg_review_score
FROM order_type AS odt
JOIN order_reviews AS ors
    ON odt.order_id = ors.order_id
GROUP BY odt.order_type ;

-- Do higher freight costs tend to be related with higher prices?

SELECT 
    CORR(price, freight_value) AS price_freight_correlation
FROM order_items ;

-- A correlation of 0.43 suggests a moderate positive relationship between
-- freight cost and product price.

-- Do repeat customers have a higher average order value?

WITH customer_type AS (
    SELECT
        c.customer_unique_id
        ,CASE 
            WHEN COUNT(o.order_id) > 1 THEN 'Repeat'
            ELSE 'Single' 
        END AS customer_type
    FROM customers AS c
    JOIN orders AS o
        ON c.customer_id = o.customer_id
        AND o.order_status = 'delivered'
    GROUP BY c.customer_unique_id 
)
, total_value_per_customer_per_order AS (
    SELECT 
        c.customer_unique_id
        ,o.order_id
        ,SUM(price + freight_value) AS per_cust_order_value
    FROM orders AS o
    JOIN order_items AS ot
        ON o.order_id = ot.order_id
        AND order_status = 'delivered'
    JOIN customers AS c
        ON c.customer_id = o.customer_id 
    GROUP BY c.customer_unique_id, o.order_id 
)
SELECT
    ct.customer_type
    ,AVG(per_cust_order_value) AS avg_order_value
FROM customer_type AS ct
JOIN total_value_per_customer_per_order AS tv
    ON ct.customer_unique_id = tv.customer_unique_id
GROUP BY ct.customer_type ;

-- Single-order customers have a higher average order value (138.62)
-- compared to repeat customers (124.91).

-- Does total revenue varies across states?

SELECT
    c.customer_state
    ,SUM(price + freight_value) AS total_revenue
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
    AND o.order_status = 'delivered'
JOIN order_items AS ot
    ON ot.order_id = o.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC ;

-- Does high weighted product tend to have higher freight cost?


SELECT 
    CORR(product_weight_g, freight_value)
FROM products AS p
JOIN order_items AS ot
    ON p.product_id = ot.product_id ;

-- correlation of 0.61 suggest there is moderate to strong relationship between product weight
-- and freight value

-- =====================================================================================================================
-- Multivariate analysis
-- =====================================================================================================================

-- How do monthly revenue trends vary across states?

SELECT
    DATE_TRUNC('MONTH', o.purchase_timestamp) AS mnth
    ,c.customer_state
    ,SUM(ot.price + ot.freight_value) AS total_revenue
FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
    AND o.order_status = 'delivered'
JOIN order_items AS ot
    ON o.order_id = ot.order_id
GROUP BY DATE_TRUNC('MONTH', o.purchase_timestamp), c.customer_state
ORDER BY c.customer_state, DATE_TRUNC('MONTH', o.purchase_timestamp)  ;

-- How do products perform in their respective category based on revenue?

SELECT
    p.product_category_name
    ,p.product_id
    ,SUM(ot.price + ot.freight_value) AS sales
FROM order_items AS ot
JOIN products AS p
    ON ot.product_id = p.product_id
GROUP BY p.product_category_name, p.product_id
ORDER BY product_category_name, sales DESC ;

