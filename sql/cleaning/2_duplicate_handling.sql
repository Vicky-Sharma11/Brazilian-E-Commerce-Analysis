-- Duplicte check

-- Most tables do not have duplicates however 2 table may require business logic handling

-- order_reviews

SELECT 
    COUNT(*)  
    -- 551 orders with more than 1 review out of 
    -- 98763 reviewd orders
FROM (
    SELECT
        order_id
        ,COUNT(*)
    FROM order_reviews
    GROUP BY order_id 
    HAVING COUNT(*) > 1 
) ;


/*Assuming an order having more than 1 review may be realted to 
when customer update their rating multiple times */

-- I will keep only order with latest review by review_answer_timestamp

WITH duplicates AS (
SELECT
     order_id
    ,review_id
    ,ROW_NUMBER() OVER(
        PARTITION BY order_id 
        ORDER BY review_answer_timestamp DESC
        ) AS rn
FROM order_reviews 
)
DELETE
FROM order_reviews
WHERE (order_id, review_id) IN (
    SELECT
        order_id
        ,review_id
        FROM duplicates 
        WHERE rn > 1
) ;

-- Deleted orders with more than one review

CREATE TABLE clean_geolocation AS (
    SELECT 
        geolocation_zip_code_prefix
        ,PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY geolocation_lat) AS median_lat
        ,PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY geolocation_long) AS median_lng
    FROM geolocation
    GROUP BY geolocation_zip_code_prefix
) ;

ALTER TABLE clean_geolocation
ADD PRIMARY KEY (geolocation_zip_code_prefix) ;

/* Zip code contains many different address so I will aggregated lat/long by median
to have one representative cordinates for one zip code to prevent duplication while joining
with customers and sellers table */

/* This cleaned table can be used as a coordinate lookup when joining
with the customers and sellers tables in future */


