-- Task 1
DELIMITER //

CREATE TRIGGER update_inventory
AFTER INSERT ON shopease.order_items
FOR EACH ROW
BEGIN
    -- Check if there is enough stock in the inventory
    DECLARE current_stock INT;

    -- Get the current stock quantity for the product
    SELECT stock_quantity INTO current_stock
    FROM shopease.inventory
    WHERE product_id = NEW.product_id
    LIMIT 1;

    -- If stock is insufficient, signal an error
    IF current_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock for product ' || NEW.product_id;
    ELSE
        -- Decrease the inventory count
        UPDATE shopease.inventory
        SET stock_quantity = stock_quantity - NEW.quantity
        WHERE product_id = NEW.product_id;
    END IF;
END;

DELIMITER ;

-- Test
INSERT INTO shopease.order_items (order_id, product_id, quantity)
VALUES (1, 101, 5);  -- product_id 101 and quantity 5


-- Task 2

ALTER TABLE shopease.customers
ADD COLUMN status VARCHAR(20);

DELIMITER //

CREATE PROCEDURE update_customer_status(IN p_customer_id INT)
BEGIN
    DECLARE total_order_value DECIMAL(10,2);

    -- Calculate the total order value for the customer
    SELECT SUM(o.quantity * p.price) 
    INTO total_order_value
    FROM shopease.orders o
    JOIN shopease.order_items oi ON o.order_id = oi.order_id
    JOIN shopease.products p ON oi.product_id = p.product_id
    WHERE o.customer_id = p_customer_id;

    -- Check if total order value exceeds $10,000 and update the status
    IF total_order_value > 10000 THEN
        UPDATE shopease.customers
        SET status = 'VIP'
        WHERE customer_id = p_customer_id;
    ELSE
        UPDATE shopease.customers
        SET status = 'Regular'
        WHERE customer_id = p_customer_id;
    END IF;
END //

DELIMITER ;

-- Test
CALL update_customer_status(123);  -- 123 is the customer_id
