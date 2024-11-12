-- Join operations
SELECT o.order_id, o.order_date, c.customer_name, p.product_name, p.category, o.quantity, p.price, (o.quantity * p.price) AS total_amount
FROM shopease.orders o
INNER JOIN shopease.products p ON o.product_id = p.product_id
INNER JOIN shopease.customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC
LIMIT 10;

-- Subqueries
SELECT p.product_id, p.product_name, p.category, 
       SUM(o.quantity) as total_quantity_sold,
       SUM(o.quantity * p.price) as total_revenue
FROM shopease.products p
JOIN shopease.orders o ON p.product_id = o.product_id
WHERE o.order_date >= (
    SELECT DATE_SUB(MAX(order_date), INTERVAL 1 MONTH)
    FROM shopease.orders
)
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC
LIMIT 5;

-- Case statements
SELECT 
    o.order_id,
    o.order_date,
    c.customer_name,
    SUM(o.quantity * p.price) AS total_order_value,
    CASE
        WHEN SUM(o.quantity * p.price) > 1000 THEN 'High'
        WHEN SUM(o.quantity * p.price) BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'Low'
    END AS revenue_category
FROM 
    shopease.orders o
    JOIN shopease.products p ON o.product_id = p.product_id
    JOIN shopease.customers c ON o.customer_id = c.customer_id
GROUP BY 
    o.order_id, o.order_date, c.customer_name
ORDER BY 
    total_order_value DESC
LIMIT 50;

-- Query Optimization

EXPLAIN
SELECT 
    o.order_id,
    o.order_date,
    c.customer_name,
    SUM(o.quantity * p.price) AS total_order_value,
    CASE
        WHEN SUM(o.quantity * p.price) > 1000 THEN 'High'
        WHEN SUM(o.quantity * p.price) BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'Low'
    END AS revenue_category
FROM 
    shopease.orders o
    JOIN shopease.products p ON o.product_id = p.product_id
    JOIN shopease.customers c ON o.customer_id = c.customer_id
GROUP BY 
    o.order_id, o.order_date, c.customer_name
ORDER BY 
    total_order_value DESC
LIMIT 20;

-- Create indexes to optimize the query
CREATE INDEX idx_orders_product_id ON shopease.orders(product_id);
CREATE INDEX idx_orders_customer_id ON shopease.orders(customer_id);
CREATE INDEX idx_products_product_id ON shopease.products(product_id);
CREATE INDEX idx_customers_customer_id ON shopease.customers(customer_id);

-- Task 3

