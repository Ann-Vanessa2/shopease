-- Task 1
-- Using ROW_NUMBER() to rank products based on total revenue
SELECT product_id, product_name, total_revenue,
ROW_NUMBER() OVER (ORDER BY total_revenue DESC) as row_num
FROM shopease.sales;

-- Using RANK() to rank products based on total revenue
SELECT product_id, product_name, total_revenue,
RANK() OVER (ORDER BY total_revenue DESC) as rank1
FROM shopease.sales;

-- Using DENSE_RANK() to rank products based on total revenue
SELECT product_id, product_name, total_revenue,
DENSE_RANK() OVER (ORDER BY total_revenue DESC) as dense_rank1
FROM shopease.sales;

-- Task 2
SELECT 
    product_id,
    product_name,
    category,
    order_date,
    total_revenue,
    SUM(total_revenue) OVER (PARTITION BY category ORDER BY order_date) AS running_total
FROM 
    shopease.sales
ORDER BY 
    category, order_date;

-- Task 3
SELECT 
    customer_id,
    order_id,
    total_revenue,
    AVG(total_revenue) OVER (PARTITION BY customer_id) AS average_order_value
FROM 
    shopease.sales
ORDER BY 
    customer_id, order_id;
    
-- Task 4
SELECT 
    month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY month) AS previous_month_revenue,
    LEAD(total_revenue) OVER (ORDER BY month) AS next_month_revenue
FROM 
	(SELECT month,
            SUM(total_revenue) AS total_revenue
	FROM 
		shopease.sales
	GROUP BY 
		month
	) AS monthly_sales
ORDER BY 
    month;

-- Task 5
SELECT 
    customer_id,
    order_date,
    total_revenue,
    SUM(total_revenue) OVER (PARTITION BY customer_id ORDER BY order_date) AS running_total_revenue,
    AVG(total_revenue) OVER (PARTITION BY customer_id) AS average_order_value,
    LAG(total_revenue) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_revenue,
    LEAD(total_revenue) OVER (PARTITION BY customer_id ORDER BY order_date) AS next_order_revenue,
    RANK() OVER (PARTITION BY customer_id ORDER BY total_revenue DESC) AS revenue_rank
FROM 
    shopease.sales
ORDER BY 
    customer_id, order_date;