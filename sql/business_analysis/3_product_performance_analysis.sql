-- Top 10 products by revenue


SELECT
    p.product_id
    ,SUM(ot.price + ot.freight_value) AS revenue
    ,COUNT(order_item_id) AS item_sold
FROM products AS p
JOIN order_items AS ot
    ON p.product_id = ot.product_id
GROUP BY p.product_id
ORDER BY revenue DESC
LIMIT 10 ;


-- Worst 10 prouducts by revenue

SELECT
    p.product_id
    ,SUM(ot.price + ot.freight_value) AS revenue
    ,COUNT(order_item_id) AS item_sold
FROM products AS p
JOIN order_items AS ot
    ON p.product_id = ot.product_id
GROUP BY p.product_id
ORDER BY revenue 
LIMIT 10 ;

/*
The lowest revenue products are driven by low demand, each had 1 items sold generating 
roughly R$9 to R$13 in revenue the products are spreaded acorss categories means the low 
sales isn't concerntrated in particular category
*/


-- Pareto analysis — products

WITH product_revenue AS (
    SELECT
        p.product_id
        ,SUM(ot.price + ot.freight_value) AS total_revenue
    FROM products AS p
    JOIN order_items AS ot
        ON p.product_id = ot.product_id
    GROUP BY p.product_id 
)
,pareto AS (
    SELECT 
        product_id
        ,total_revenue
        ,ROW_NUMBER() OVER(
            ORDER BY total_revenue DESC
            ) * 1.0 / COUNT(*) OVER() * 100.0 AS product_pct
        ,SUM(total_revenue) OVER(
            ORDER BY total_revenue DESC
            ) / SUM(total_revenue)  OVER() * 100.0 AS revenue_pct
    FROM product_revenue 
)
SELECT
    product_id
    ,total_revenue
    ,product_pct
    ,revenue_pct
FROM pareto
WHERE revenue_pct >= 80
ORDER BY revenue_pct
LIMIT 1 ;

-- Approximately 28% of product accounts for 80% of the revenue
