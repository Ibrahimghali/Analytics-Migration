-- ================================================
-- Create Sample Source Tables for dbt Practice
-- Run this script in SQL Server Management Studio
-- ================================================

USE dbt_analytics;
GO

-- Create Customers table
CREATE TABLE raw_data.customers (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    phone NVARCHAR(20),
    address NVARCHAR(200),
    city NVARCHAR(50),
    state NVARCHAR(50),
    zip_code NVARCHAR(10),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
);

-- Create Products table
CREATE TABLE raw_data.products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    product_name NVARCHAR(100) NOT NULL,
    category NVARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    cost DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
);

-- Create Orders table
CREATE TABLE raw_data.orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT NOT NULL,
    order_date DATETIME2 DEFAULT GETDATE(),
    status NVARCHAR(20) DEFAULT 'pending',
    total_amount DECIMAL(10,2),
    shipping_address NVARCHAR(200),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES raw_data.customers(customer_id)
);

-- Create Order Items table
CREATE TABLE raw_data.order_items (
    order_item_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (order_id) REFERENCES raw_data.orders(order_id),
    FOREIGN KEY (product_id) REFERENCES raw_data.products(product_id)
);

-- Create Payments table
CREATE TABLE raw_data.payments (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    payment_method NVARCHAR(50) NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME2 DEFAULT GETDATE(),
    payment_status NVARCHAR(20) DEFAULT 'completed',
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (order_id) REFERENCES raw_data.orders(order_id)
);

PRINT 'Source tables created successfully!';
