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

-- Task 3
CREATE TABLE IF NOT exists shopease.warehouses (
  warehouse_id INT PRIMARY KEY,
  warehouse_location VARCHAR(50)
);

-- Change the supplier_name to be a unique key instead of primary key
ALTER TABLE shopease.suppliers
DROP PRIMARY KEY,
ADD UNIQUE KEY (supplier_name);

-- Add supplier_id column to suppliers table
ALTER TABLE shopease.suppliers
ADD COLUMN supplier_id INT AUTO_INCREMENT PRIMARY KEY FIRST;

-- Add supplier_id and warehouse_id columns to the inventory table
ALTER TABLE shopease.inventory 
ADD COLUMN supplier_id INT,
ADD COLUMN warehouse_id INT;

-- Create the foreign key relationships
ALTER TABLE shopease.inventory
ADD CONSTRAINT fk_supplier
FOREIGN KEY (supplier_id) REFERENCES shopease.suppliers(supplier_id);

ALTER TABLE shopease.inventory
ADD CONSTRAINT fk_warehouse
FOREIGN KEY (warehouse_id) REFERENCES shopease.warehouses(warehouse_id);

-- Create supplier_info table
CREATE TABLE shopease.supplier_info (
    info_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT,
    supplier_name VARCHAR(50),
    supplier_address VARCHAR(50),
    email VARCHAR(50),
    contact_number VARCHAR(50),
    fax VARCHAR(50),
    account_number VARCHAR(50),
    order_history VARCHAR(50),
    contract VARCHAR(50),
    FOREIGN KEY (supplier_id) REFERENCES shopease.suppliers(supplier_id)
);

-- Remove redundant columns from suppliers
ALTER TABLE shopease.suppliers
DROP COLUMN supplier_address,
DROP COLUMN email,
DROP COLUMN contact_number,
DROP COLUMN fax,
DROP COLUMN account_number,
DROP COLUMN order_history,
DROP COLUMN contract;

SELECT * FROM shopease.inventory;

-- Task 4
-- Create the partitioned inventory table by date range
CREATE TABLE shopease.inventory_partitioned (
    inventory_id INT NOT NULL AUTO_INCREMENT,
    product_name VARCHAR(50),
    stock_quantity INT,
    stock_date DATE NOT NULL,
    supplier_id INT,
    warehouse_id INT,
    PRIMARY KEY (inventory_id, stock_date)
)
PARTITION BY RANGE (YEAR(stock_date)) (
    PARTITION inventory_2023 VALUES LESS THAN (2024),
    PARTITION inventory_2024 VALUES LESS THAN (2025),
    PARTITION inventory_2025 VALUES LESS THAN (2026)
);

SHOW COLUMNS FROM shopease.inventory;

-- Insert data from the original inventory table into the new partitioned table
INSERT INTO shopease.inventory_partitioned (product_name, stock_quantity, stock_date, supplier_id, warehouse_id)
SELECT product_name, stock_quantity, stock_date, supplier_id, warehouse_id
FROM shopease.inventory;

-- Drop the original inventory table
DROP TABLE shopease.inventory;

-- Rename the partitioned table to inventory
ALTER TABLE shopease.inventory_partitioned RENAME TO inventory;
