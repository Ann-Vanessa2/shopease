-- Task 1
EXPLAIN ANALYZE
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

-- Task 2
-- Where clause
CREATE INDEX idx_orders_order_date ON shopease.orders(order_date);
CREATE INDEX idx_products_category ON shopease.products(category);

-- Join clause
-- Indexes for `product_id` in both `orders` and `products`
CREATE INDEX idx_orders_product_id ON shopease.orders(product_id);
CREATE INDEX idx_products_product_id ON shopease.products(product_id);

-- Indexes for `customer_id` in both `orders` and `customers`
CREATE INDEX idx_orders_customer_id ON shopease.orders(customer_id);
CREATE INDEX idx_customers_customer_id ON shopease.customers(customer_id);





