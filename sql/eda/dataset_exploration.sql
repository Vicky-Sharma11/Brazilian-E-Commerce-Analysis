
-- Exploring customers table

SELECT
    column_name
    ,data_type
    ,is_nullable
    ,column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'customers'
ORDER BY ordinal_position ;

SELECT *
FROM customers ;  


/*
Observation: customer_id represents the system level id associated with order 
while customer_uniqe_id is the real identifier of a customer

Grain: Each row represents a customer_id and its associated customer_unique_id, 
along with the customer's zip code, city and state.

PK : customer_id
*/


-- Exploring orders table

SELECT
    column_name
    ,data_type
    ,is_nullable
    ,column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'orders'
ORDER BY ordinal_position ;

SELECT *
FROM orders ;


/*
Grain: Grain: Each row in the orders table represents an order associated 
with a customer_id.

PK: order_id
FK : customer_id
*/


-- Exploring  sellers table

SELECT
    column_name
    ,data_type
    ,is_nullable
    ,column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'sellers'
ORDER BY ordinal_position ;

SELECT *
FROM sellers ;


/*
Grain: each row represents unique seller_id and the information associated to it
PK : seller_id
*/


-- Exploring product_category_name_translation table

SELECT
    column_name
    ,data_type
    ,is_nullable
    ,column_default
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name = 'product_category_name_translation'
ORDER BY ordinal_position ; 

SELECT *
FROM product_category_name_translation ;

/*
Grain: each row reprents the category_name and it's transalation in english
PK : product_category_name
*/


-- Exploring Geolocation table

SELECT
    column_name
    ,data_type
    ,is_nullable
    ,column_default
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name = 'geolocation'
ORDER BY ordinal_position ;

SELECT *
FROM geolocation ;


/*
Grain: each row represents the zip_code_prefix its latitude and longtitude, city and state
observation: geolocation_zip_code are repeated that means combination of each zip_code_prefix,
lan and lot is unique
*/


-- Exploring  products table

SELECT *
FROM products ;

SELECT
    column_name
    ,data_type
    ,is_nullable
    ,column_default
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name = 'products'
ORDER BY ordinal_position ;


/*
Grain: each row reprsents one product identified by product_id along with category name 
and other product information 

Observation: There are two additional category values in the products table,
so a complete relationship with the product_category_name_translation table
cannot be established.
*/


-- Exploring order_items table

SELECT
    column_name
    ,data_type
    ,is_nullable
    ,column_default
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name = 'order_items'
ORDER BY ordinal_position ;

SELECT *
FROM order_items ;

/*
Grain: each row represents one order item within an order 
PK: order_id + order_item_id
FK: order_id
FK : product_id
FK : seller_id
*/


-- Exploring order_payment table

SELECT
    column_name
    ,data_type
    ,is_nullable
    ,column_default
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name = 'order_payments'
ORDER BY ordinal_position ;

SELECT *
FROM order_payments ;


/*
Grain: each raw represents one payment_sequence within an order 
PK: order_id + payment_sequential
FK: order_id
*/


-- Exploring order_reviews

SELECT
    column_name
    ,data_type
    ,is_nullable
    ,column_default
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name = 'order_reviews'
ORDER BY ordinal_position ;

SELECT *
FROM order_reviews ;

/*
Grain: each raw represents one review within an order
PK: order_id + review_id
FK: order_id
*/
