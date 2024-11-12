import pandas as pd
import numpy as np


orders_df = pd.read_csv('Orders.csv')
products_df = pd.read_csv('products.csv')
orders_items_df = pd.read_csv('order_items.csv')
customers_df = pd.read_csv('customers.csv')
inventory_df = pd.read_csv('inventory.csv')
suppliers_df = pd.read_csv('suppliers_data.csv')

dataframes = [orders_df, products_df, orders_items_df, customers_df, inventory_df, suppliers_df]

# # Clean all the dataframes
# # date columns available in the dataframes order_date | join_date | stock_date
date_columns = ['order_date', 'join_date', 'stock_date']



for df in dataframes:
    df.dropna(inplace=True)
    df.drop_duplicates(inplace=True)
    # if date column exists, convert it to datetime
    if any(col in df.columns for col in date_columns):
        for col in date_columns:
            if col in df.columns:
                df[col] = pd.to_datetime(df[col])

suppliers_df.drop_duplicates(subset=['supplier_name', 'supplier_address', 'email', 'contact_number', 'fax', 'account_number', 'supplier_country', 'supplier_city', 'country_code'], inplace=True)

sales_df = orders_df.merge(products_df, on='product_id')
# Data Cleaning: Handle missing values, remove duplicates, and convert data types appropriately
# Make your own sales dataframe that will have the following columns: order_id, order_date, customer_id, product_id, quantity, and price
sales_df.dropna(inplace=True)
sales_df.drop_duplicates(inplace=True)
sales_df['order_date'] = pd.to_datetime(sales_df['order_date'])
sales_df['total_revenue']  = np.multiply(sales_df['quantity'], sales_df['price'])
print(sales_df.head())
# 5. Visualization: Plot the monthly sales trend using Pandas' plotting capabilities.

# Step 4: Data Transformation - Extract year, month, and day from 'order_date'
sales_df['year'] = sales_df['order_date'].dt.year
sales_df['month'] = sales_df['order_date'].dt.month
print(suppliers_df.head())
 # orders columns: order_id,Cutomer_id,order_date,product_id,quantity
 # products columns: product_id,product_name,category,price
 # order_items columns: order_detail_id,order_id,quantity,product_id
 # customers columns: customer_id,customer_name,email,join_date
 # inventory columns: product_name,stock_quantity,stock_date,supplier,warehouse_location
 # suppliers columns: supplier_name,supplier_address,email,contact_number,fax,account_number,order_history,contract,supplier_country,supplier_city,country_code

# # verify the dataframes
# # for df in dataframes:
# #     print(df.shape)
# print(orders_df.head())

import psycopg2 as pg
from dotenv import load_dotenv
import os


load_dotenv('.env.local')
connectionString = os.getenv('POSTGRESQL_CRED')
connection = pg.connect(connectionString)
cursor = connection.cursor()

# Create Sales schema
# cursor.execute('''
# CREATE SCHEMA IF NOT EXISTS sales;
# ''')

# # Create tables in sales schema
# cursor.execute('''
# CREATE TABLE IF NOT EXISTS sales.sales (
#     order_id INT,
#     customer_id INT,
#     order_date DATE,
#     product_id INT,
#     quantity INT,
#     product_name VARCHAR(50),
#     category VARCHAR(50),
#     price FLOAT,
#     total_revenue FLOAT,
#     year INT,
#     month INT
# );
# ''')
    
# cursor.execute('''
# CREATE TABLE IF NOT EXISTS sales.orders (
#     order_id SERIAL PRIMARY KEY,
#     customer_id INTEGER,
#     order_date DATE,
#     product_id INTEGER,
#     quantity INTEGER
# );
# ''')

# cursor.execute('''
# CREATE TABLE IF NOT EXISTS sales.products (
#     product_id INTEGER PRIMARY KEY,
#     product_name VARCHAR(50),
#     category VARCHAR(50),
#     price DECIMAL
# );
# ''')

# cursor.execute('''
# CREATE TABLE IF NOT EXISTS sales.order_items (
#     order_detail_id SERIAL PRIMARY KEY,
#     order_id INTEGER,
#     quantity INTEGER,
#     product_id INTEGER
# );
# ''')

# cursor.execute('''
# CREATE TABLE IF NOT EXISTS sales.customers (
#     customer_id INTEGER PRIMARY KEY,
#     customer_name VARCHAR(50),
#     email VARCHAR(50),
#     join_date DATE
# );
# ''')

# cursor.execute('''
# CREATE TABLE IF NOT EXISTS sales.inventory (
#     product_name VARCHAR(50),
#     stock_quantity INTEGER,
#     stock_date DATE,
#     supplier VARCHAR(50),
#     warehouse_location VARCHAR(50)
# );
# ''')

# cursor.execute('''
# CREATE TABLE IF NOT EXISTS sales.suppliers (
#     supplier_id SERIAL PRIMARY KEY,
#     supplier_name VARCHAR(50),
#     supplier_address VARCHAR(50),
#     email VARCHAR(50),
#     contact_number VARCHAR(50),
#     fax VARCHAR(50),
#     account_number VARCHAR(50),
#     order_history VARCHAR(50),
#     contract VARCHAR(50),
#     supplier_country VARCHAR(50),
#     supplier_city VARCHAR(50),
#     country_code VARCHAR(50)
# );
# ''')

# Insert data into the tables
# for index, row in sales_df.iterrows():
#     cursor.execute('''
#     INSERT INTO sales.sales (order_id, customer_id, order_date, product_id, quantity, product_name, category, price, total_revenue, year, month)
#     VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
#     ''', (row['order_id'], row['Cutomer_id'], row['order_date'], row['product_id'], row['quantity'], row['product_name'], row['category'], row['price'], row['total_revenue'], row['year'], row['month']))

# for index, row in orders_df.iterrows():
#     cursor.execute('''
#     INSERT INTO sales.orders (customer_id, order_date, product_id, quantity)
#     VALUES (%s, %s, %s, %s)
#     ''', (row['Cutomer_id'], row['order_date'], row['product_id'], row['quantity']))

# for index, row in products_df.iterrows():
#     cursor.execute('''
#     INSERT INTO sales.products (product_id, product_name, category, price)
#     VALUES (%s, %s, %s, %s)
#     ''', (row['product_id'],row['product_name'], row['category'], row['price']))

# print(orders_items_df.dtypes)
# for index, row in orders_items_df.iterrows():
#     cursor.execute('''
#     INSERT INTO sales.order_items (order_id, quantity, product_id)
#     VALUES (%s, %s, %s)
#     ''', (int(row['order_id']), int(row['quantity']), int(row['product_id'])))

# for index, row in customers_df.iterrows():
#     cursor.execute('''
#     INSERT INTO sales.customers (customer_id, customer_name, email, join_date)
#     VALUES (%s, %s, %s, %s)
#     ''', (row['customer_id'], row['customer_name'], row['email'], row['join_date']))

# print(inventory_df.columns.str.strip())
# print(inventory_df.head())
# for index, row in inventory_df.iterrows():
#     cursor.execute('''
#     INSERT INTO sales.inventory (product_name, stock_quantity, stock_date, supplier, warehouse_location)
#     VALUES (%s, %s, %s, %s, %s)
#     ''', (row['product_name'], row['stock_quantity'], row['stock_date'], row['supplier'], row['warehouse_location']))

# for index, row in suppliers_df.iterrows():
#     cursor.execute('''
#     INSERT INTO sales.suppliers (supplier_name, supplier_address, email, contact_number, fax, account_number, order_history, contract, supplier_country, supplier_city, country_code)
#     VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
#     ''', (row['supplier_name'], row['supplier_address'], row['email'], row['contact_number'], row['fax'], row['account_number'], row['order_history'], row['contract'], row['supplier_country'], row['supplier_city'], row['country_code']))


# CREATE TABLE IF NOT EXISTS sales.supplier_info (
#     info_id SERIAL PRIMARY KEY,
#     supplier_id INTEGER,
#     supplier_address VARCHAR(50),
#     email VARCHAR(50),
#     contact_number VARCHAR(50),
#     fax VARCHAR(50),
#     account_number VARCHAR(50),
#     order_history VARCHAR(50),
#     contract VARCHAR(50),
#     FOREIGN KEY (supplier_id) REFERENCES sales.suppliers(supplier_id)
# );

# Select from supplier table to get the supplier_id

# for index, row in suppliers_df.iterrows():
#     cursor.execute('''
#     SELECT supplier_id FROM sales.suppliers WHERE supplier_name = %s
#     ''', (row['supplier_name'],))
#     supplier_id = cursor.fetchone()[0]
    
#     cursor.execute('''
#     INSERT INTO sales.supplier_info (supplier_id, supplier_address, email, contact_number, fax, account_number, order_history, contract)
#     VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
#     ''', (supplier_id, row['supplier_address'], row['email'], row['contact_number'], row['fax'], row['account_number'], row['order_history'], row['contract']))

# Commit the transaction
# Now drop the supplier_address, email, contact_number, fax, account_number, order_history, contract columns from the suppliers table
# cursor.execute('''
# ALTER TABLE sales.suppliers DROP COLUMN supplier_address, DROP COLUMN email, DROP COLUMN contact_number, DROP COLUMN fax, DROP COLUMN account_number, DROP COLUMN order_history, DROP COLUMN contract
# ''')

# Normalize inventory table too 
# cursor.execute('''
# ALTER TABLE sales.inventory
# ADD FOREIGN KEY (supplier_id) REFERENCES sales.suppliers(supplier_id);
# ''')
# Fetch the supplier_id and supplier_name from the suppliers table
# cursor.execute('''
# SELECT supplier_id, supplier_name FROM sales.suppliers
# ''')
# supplier_ids = cursor.fetchall()

# Create a dictionary for quick lookup
# supplier_dict = {name: sid for sid, name in supplier_ids}

# Update each row in the inventory table with the corresponding supplier_id
# for index, row in inventory_df.iterrows():
#     supplier_name = row['supplier']
#     supplier_id = supplier_dict.get(supplier_name)
    
#     if supplier_id:
#         cursor.execute('''
#         UPDATE sales.inventory
#         SET supplier_id = %s
#         WHERE supplier = %s
#         ''', (supplier_id, supplier_name))

# there are only orders for 2024 and 2025, create partitions for each year
cursor.execute('''
CREATE TABLE sales.orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE,
    product_id INTEGER,
    quantity INTEGER
) PARTITION BY RANGE (order_date);
''')


connection.commit()

connection.close()

# JOIN Operations: Write SQL queries to join the orders, products, and customers tables 
# to get a comprehensive view of each order.
# query to join orders, products and customers tables
# cursor.execute('''
# SELECT orders.order_id, orders.customer_id, orders.order_date, orders.product_id, orders.quantity, products.product_name, products.category, products.price, customers.customer_name, customers.email, customers.join_date FROM sales.orders as orders
# JOIN sales.products as products
# ON orders.product_id = products.product_id
# JOIN sales.customers as customers
# ON orders.customer_id = customers.customer_id
# ''')

# data = cursor.fetchall()
# print(data)

# connection.close()