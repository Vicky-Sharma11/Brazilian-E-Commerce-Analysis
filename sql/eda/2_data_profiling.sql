-- ============================================================
-- 1. Customers
-- ============================================================

-- Total rows

SELECT 
    COUNT(*) AS total_rows
FROM customers ;


-- Total customers

SELECT 
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers ;


-- Distinct customer state

SELECT 
    DISTINCT customer_state
FROM customers ;


-- ============================================================
-- 2. Orders
-- ============================================================

-- Total rows

SELECT 
    COUNT(*) AS total_rows
FROM orders ; 


-- Dates exploration

SELECT 
    MIN(purchase_timestamp) AS first_purchase_date
    ,MAX(purchase_timestamp) AS latest_purchase_date
FROM orders ;    


-- ============================================================
-- 3. Order Items
-- ============================================================

-- Total rows

SELECT 
    COUNT(*) AS total_rows          
FROM order_items ;


-- Average price

SELECT
    AVG(price) AS avg_price
FROM order_items ;


-- Max price

SELECT
    MAX(price) AS max_price
FROM order_items ;


-- Min price

SELECT
    MIN(price) AS min_price
FROM order_items ;


-- Average freight

SELECT 
    AVG(freight_value) AS avg_freight
FROM order_items ;


-- ============================================================
-- 4. Order Reviews
-- ============================================================

-- Total rows

SELECT
    COUNT(*) AS total_rows
FROM order_reviews ;


-- Average review score

SELECT
    AVG(review_score) AS avg_review_score
FROM order_reviews ;


-- Distinct review scores

SELECT
    DISTINCT(review_score) AS distinct_review
FROM order_reviews ;


-- ============================================================
-- 5. Order Payments
-- ============================================================

-- Total rows

SELECT 
    COUNT(*) AS total_rows
FROM order_payments ; 


-- Total payment value

SELECT 
    SUM(payment_value) AS total_payment_value
FROM order_payments ;


-- Average payment value

SELECT 
    AVG(payment_value) AS avg_payment_value
FROM order_payments ;


-- Valid payment checking

SELECT *
FROM order_payments
WHERE payment_value < 0 ;


-- There are zeros that automatically don't mean wrong since
-- payment_type are voucher and not_defined, so we won't consider
-- them invalid without further contextual investigation.


-- ============================================================
-- 6. Sellers
-- ============================================================

-- Total rows

SELECT 
    COUNT(*) AS total_rows
FROM sellers ;


-- ============================================================
-- 7. Products
-- ============================================================

-- Total rows

SELECT 
    COUNT(*) AS total_rows
FROM products ;


-- Products with no categories

SELECT
    COUNT(product_id) AS no_category_product_count
FROM products
WHERE product_category_name IS NULL ;


-- Most/Least weighted product

SELECT
     MAX(product_weight_g) AS most_weighted_product_g
    ,MIN(product_weight_g) AS least_weighted_product_g
FROM products ;


-- Invalid weight 

SELECT *
FROM products
WHERE product_weight_g <= 0 ;


-- Tallest/Tiniest product

SELECT 
    MAX(product_height_cm) AS tallest_product
    ,MIN(product_height_cm) AS tiniest_product
FROM products ;


-- ============================================================
-- 8. Product Category Name Translation
-- ============================================================

-- Total rows 

SELECT
    COUNT(*) AS total_rows
FROM product_category_name_translation ;


-- ============================================================
-- 9. Geolocation
-- ============================================================

-- Total rows

SELECT 
    COUNT(*) AS total_rows
FROM geolocation ;


-- Distinct states

SELECT
    DISTINCT geolocation_state AS distinct_states
FROM geolocation ;


-- Distinct cities

SELECT
    DISTINCT geolocation_city AS distinct_city
FROM geolocation ;


-- Total DISTINCT zip code prefix

SELECT
    COUNT(DISTINCT geolocation_zip_code) AS distinct_zip_code
FROM geolocation ;
