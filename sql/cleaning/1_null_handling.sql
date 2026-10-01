-- Missing value check

-- There are 3 main tables having nulls 

-- orders 

SELECT 
     COUNT(*) FILTER (WHERE purchase_timestamp IS NULL) AS purchase_date_null  
            -- 0 rows 
    ,COUNT(*) FILTER (WHERE approved_at IS NULL) AS approve_date_null
            -- 160 rows approx 0.16% 
    ,COUNT(*) FILTER (WHERE delivered_to_carrier_at IS NULL) AS carrier_date_null
            -- 1783 rows approx 1.79%
    ,COUNT(*) FILTER (WHERE delivered_to_customer_at IS NULL) AS delivery_date_null
            -- 2965 rows approx 2.98%
    ,COUNT(*) FILTER (WHERE estimated_delivery_timestamp IS NULL) AS estimated_delivery_date_null
            -- 0 rows
FROM orders ;

/*These are not errors since being null may represents useful order information such as
orders that are not yet delivered, order that are not yet shipped, or approved order with no further process 
For further analysis I will keep the orders with status 'delivered' 
*/


-- order_reviews table

SELECT 
     COUNT(*) FILTER (WHERE review_comment_title IS NULL) AS review_comment_null      
            -- 87656 null detected approx 88.34%
    ,COUNT(*) FILTER(WHERE review_comment_message IS NULL) AS review_message_null
            -- 58247 null detected approx  58.70%
FROM order_reviews ;

/*Not an error since giving comment or message while revewing an order can be optional 
*/

ALTER TABLE order_reviews
DROP COLUMN review_comment_title ;

/*Removed the review_comment_title since it doesn't help in any analysis 
and about 88% rows are null
Retained review_comment_message for customer feedback and potential text-based analysis.
*/

-- products

SELECT 
    COUNT(*) -- 610 rows approx 1.85%
FROM products
WHERE product_category_name IS NULL ;

-- I Will update category name to unknown

UPDATE products
SET product_category_name = 'Unknown'
WHERE product_category_name IS NULL ;

-- Updated 610 null product_category_name rows with 'Unknown'


SELECT 
    COUNT(*) -- 2 rows found
FROM products 
WHERE product_weight_g IS NULL ;

/*Will keep these two rows since product associated to these rows may have been placed
in an order in order_items table */

