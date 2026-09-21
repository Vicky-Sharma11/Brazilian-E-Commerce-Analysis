-- ============================================================
-- Database Creation
-- Creates the database for the Olist e-commerce analysis.
-- ============================================================

CREATE DATABASE olist_ecommerce ;

-- ============================================================
-- Table Creation
-- Creates the tables required to store customers, orders,
-- products, sellers, payments, reviews, and location data.
-- ============================================================

-- Customer table
-- Stores customer details and location information.

CREATE TABLE Customers (
    customer_id VARCHAR(100) PRIMARY KEY
    ,customer_unique_id VARCHAR(100)
    ,zip_code_prefix VARCHAR(5)
    ,customer_city VARCHAR(100)
    ,customer_state VARCHAR(2)
) ;

-- Orders table
-- Stores order status, timestamps, and the customer linked
-- to each order.

CREATE TABLE orders(
    order_id VARCHAR(100) PRIMARY KEY
    ,customer_id VARCHAR(100)
    ,order_status VARCHAR(30)
    ,purchase_timestamp TIMESTAMP
    ,approved_at TIMESTAMP
    ,delivered_to_carrier_at TIMESTAMP
    ,delivered_to_customer_at TIMESTAMP
    ,estimated_delivery_timestamp TIMESTAMP

    ,CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customers (customer_id)
) ;

-- Product category translation table
-- Converts the original Portuguese category names into English.

CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(50) PRIMARY KEY
    ,product_category_name_english VARCHAR(50)
) ;

-- Product table
-- Stores product attributes such as category, dimensions,
-- weight, description length, and number of photos.

CREATE TABLE products (
    product_id VARCHAR(100) PRIMARY KEY
    ,product_category_name VARCHAR(50)
    ,product_name_length INT
    ,product_description_length INT
    ,product_photos_quantity INT
    ,product_weight_g INT
    ,product_length_cm INT
    ,product_height_cm INT
    ,product_width_cm INT

    ,CONSTRAINT fk_products_product_category
        FOREIGN KEY (product_category_name)
        REFERENCES product_category_name_translation (product_category_name)

) ;

-- Sellers table
-- Stores seller identification and location information.

CREATE TABLE sellers (
    seller_id VARCHAR(100) PRIMARY KEY
    ,seller_zip_code_prefix VARCHAR(5)
    ,seller_city VARCHAR (100)
    ,seller_state VARCHAR (2)
) ;

-- Order items table
-- Stores the products and sellers associated with each order,
-- along with item price and freight charges.

CREATE TABLE order_items(
    order_id VARCHAR (100)
    ,order_item_id INT
    ,product_id VARCHAR(100)
    ,seller_id VARCHAR(100)
    ,shipping_limit_date TIMESTAMP
    ,price NUMERIC (10, 2)
    ,freight_value NUMERIC (10,2)

    ,PRIMARY KEY(order_id, order_item_id)

    ,CONSTRAINT fk_order_items_orders
        FOREIGN KEY (order_id)
        REFERENCES orders (order_id)
        
    ,CONSTRAINT fk_order_items_products
        FOREIGN KEY (product_id)
        REFERENCES products (product_id)

    ,CONSTRAINT fk_order_items_sellers
        FOREIGN KEY (seller_id)
        REFERENCES sellers (seller_id)
) ;

-- Order payments table
-- Stores payment methods, installments, and payment values
-- for each order.

CREATE TABLE order_payments (
    order_id VARCHAR (100)
    ,payment_sequential INT
    ,payment_type VARCHAR (20)
    ,payment_installments INT
    ,payment_value NUMERIC (10,2)

    ,PRIMARY KEY (order_id, payment_sequential)

    ,CONSTRAINT fk_order_payments_orders
        FOREIGN KEY (order_id)
        REFERENCES orders (order_id)
) ;

-- Order reviews table
-- Stores customer ratings, comments, and review timestamps.

CREATE TABLE order_reviews  (
    review_id VARCHAR (100)
    ,order_id VARCHAR (100)
    ,review_score INT
    ,review_comment_title TEXT
    ,review_comment_message TEXT
    ,review_creation_timestamp TIMESTAMP
    ,review_answer_timestamp TIMESTAMP
    
    ,PRIMARY KEY (order_id, review_id)

    ,CONSTRAINT fk_order_reviews_orders
        FOREIGN KEY (order_id)
        REFERENCES orders (order_id)
)
;

-- Geolocation table
-- Stores geographic coordinates and location details
-- associated with Brazilian zip code prefixes.

CREATE TABLE geolocation (
    geolocation_zip_code VARCHAR(5)
    ,geolocation_lat NUMERIC(10,8)
    ,geolocation_long NUMERIC(11,8)
    ,geolocation_city VARCHAR (100)
    ,geolocation_state VARCHAR(2)
)
;

-- ============================================================
-- Loading Data
-- Imports the raw CSV files into their corresponding tables.
-- ============================================================

-- Load customer data

COPY customers
FROM 'C:/Users/VICKY/OneDrive/Desktop/Brazilian-E-Commerce-Analysis/data/raw/olist_customers_dataset.csv'
DELIMITER ','
CSV HEADER ;

-- Load orders data

COPY orders
FROM 'C:\Users\VICKY\OneDrive\Desktop\Brazilian-E-Commerce-Analysis\data\raw\olist_orders_dataset.csv'
DELIMITER ','
CSV HEADER ;

-- Load sellers data

COPY sellers
FROM 'C:\Users\VICKY\OneDrive\Desktop\Brazilian-E-Commerce-Analysis\data\raw\olist_sellers_dataset.csv'
DELIMITER ','
CSV HEADER ;

-- Load product category translation data

COPY product_category_name_translation
FROM 'C:\Users\VICKY\OneDrive\Desktop\Brazilian-E-Commerce-Analysis\data\raw\product_category_name_translation.csv'
DELIMITER ','
CSV HEADER ;

-- Remove the foreign key because some product categories
-- do not have a matching entry in the translation table.

ALTER TABLE products
DROP CONSTRAINT fk_products_product_category ;

-- Load products data

COPY products
FROM 'C:\Users\VICKY\OneDrive\Desktop\Brazilian-E-Commerce-Analysis\data\raw\olist_products_dataset.csv'
DELIMITER ','
CSV HEADER ;

-- Load order items data

COPY order_items
FROM 'C:\Users\VICKY\OneDrive\Desktop\Brazilian-E-Commerce-Analysis\data\raw\olist_order_items_dataset.csv'
DELIMITER ','
CSV HEADER ;

-- Load order payments data

COPY order_payments
FROM 'C:\Users\VICKY\OneDrive\Desktop\Brazilian-E-Commerce-Analysis\data\raw\olist_order_payments_dataset.csv'
DELIMITER ','
CSV HEADER ;

-- Load order reviews data

COPY order_reviews
FROM 'C:\Users\VICKY\OneDrive\Desktop\Brazilian-E-Commerce-Analysis\data\raw\olist_order_reviews_dataset.csv'
DELIMITER ','
CSV HEADER ;

-- Load geolocation data

COPY geolocation
FROM 'C:\Users\VICKY\OneDrive\Desktop\Brazilian-E-Commerce-Analysis\data\raw\olist_geolocation_dataset.csv'
DELIMITER ','
CSV HEADER ;



