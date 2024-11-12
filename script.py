import pandas as pd
import numpy as np

customers = pd.read_csv('customers.csv')
inventory = pd.read_csv('inventory.csv')
order_items = pd.read_csv('order_items.csv')
orders = pd.read_csv('Orders.csv')
products = pd.read_csv('products.csv')
suppliers = pd.read_csv('suppliers_data.csv')

dataframes = [customers, inventory, order_items, orders, suppliers, products]

date_columns = ['order_date', 'join_date', 'stock_date']



for df in dataframes:
    df.dropna(inplace=True)
    df.drop_duplicates(inplace=True)
    if any(col in df.columns for col in date_columns):
        for col in date_columns:
            if col in df.columns:
                df[col] = pd.to_datetime(df[col])

suppliers.drop_duplicates(subset=['supplier_name', 'supplier_address', 'email', 'contact_number', 'fax', 'account_number', 'supplier_country', 'supplier_city', 'country_code'], inplace=True)

sales_df = orders.merge(products, on='product_id')

# Data Cleaning: Handle missing values, remove duplicates, and convert data types appropriately
# Make your own sales dataframe that will have the following columns: order_id, order_date, customer_id, product_id, quantity, and price
sales_df.dropna(inplace=True)
sales_df.drop_duplicates(inplace=True)
sales_df['order_date'] = pd.to_datetime(sales_df['order_date'])
sales_df['total_revenue']  = np.multiply(sales_df['quantity'], sales_df['price'])
print(sales_df.head())
