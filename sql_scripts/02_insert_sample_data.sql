-- ================================================
-- Insert Sample Data for dbt Practice
-- Run this after creating the tables
-- ================================================

USE dbt_analytics;
GO

-- Insert sample customers
INSERT INTO raw_data.customers (first_name, last_name, email, phone, address, city, state, zip_code) VALUES
('John', 'Smith', 'john.smith@email.com', '555-0123', '123 Main St', 'New York', 'NY', '10001'),
('Jane', 'Doe', 'jane.doe@email.com', '555-0124', '456 Oak Ave', 'Los Angeles', 'CA', '90210'),
('Bob', 'Johnson', 'bob.johnson@email.com', '555-0125', '789 Pine Rd', 'Chicago', 'IL', '60601'),
('Alice', 'Williams', 'alice.williams@email.com', '555-0126', '321 Elm St', 'Houston', 'TX', '77001'),
('Charlie', 'Brown', 'charlie.brown@email.com', '555-0127', '654 Maple Dr', 'Phoenix', 'AZ', '85001'),
('Diana', 'Davis', 'diana.davis@email.com', '555-0128', '987 Cedar Ln', 'Philadelphia', 'PA', '19101'),
('Frank', 'Miller', 'frank.miller@email.com', '555-0129', '147 Birch Way', 'San Antonio', 'TX', '78201'),
('Grace', 'Wilson', 'grace.wilson@email.com', '555-0130', '258 Spruce St', 'San Diego', 'CA', '92101');

-- Insert sample products
INSERT INTO raw_data.products (product_name, category, price, cost, stock_quantity) VALUES
('Laptop Pro 15"', 'Electronics', 1299.99, 899.99, 50),
('Wireless Mouse', 'Electronics', 29.99, 15.99, 200),
('Office Chair', 'Furniture', 299.99, 199.99, 30),
('Desk Lamp', 'Furniture', 79.99, 49.99, 100),
('Coffee Maker', 'Appliances', 149.99, 89.99, 75),
('Bluetooth Speaker', 'Electronics', 89.99, 59.99, 120),
('Standing Desk', 'Furniture', 499.99, 329.99, 25),
('Monitor 24"', 'Electronics', 199.99, 129.99, 60),
('Keyboard Mechanical', 'Electronics', 129.99, 79.99, 80),
('Tablet 10"', 'Electronics', 399.99, 259.99, 40);

-- Insert sample orders
INSERT INTO raw_data.orders (customer_id, order_date, status, total_amount, shipping_address) VALUES
(1, '2025-06-01 10:30:00', 'completed', 1329.98, '123 Main St, New York, NY 10001'),
(2, '2025-06-02 14:15:00', 'completed', 299.99, '456 Oak Ave, Los Angeles, CA 90210'),
(3, '2025-06-03 09:45:00', 'shipped', 529.98, '789 Pine Rd, Chicago, IL 60601'),
(4, '2025-06-04 16:20:00', 'completed', 89.99, '321 Elm St, Houston, TX 77001'),
(5, '2025-06-05 11:10:00', 'processing', 1799.97, '654 Maple Dr, Phoenix, AZ 85001'),
(6, '2025-06-06 13:30:00', 'completed', 209.98, '987 Cedar Ln, Philadelphia, PA 19101'),
(7, '2025-06-07 15:45:00', 'shipped', 579.98, '147 Birch Way, San Antonio, TX 78201'),
(8, '2025-06-08 08:20:00', 'completed', 1699.97, '258 Spruce St, San Diego, CA 92101');

-- Insert sample order items
INSERT INTO raw_data.order_items (order_id, product_id, quantity, unit_price, total_price) VALUES
-- Order 1: Laptop + Mouse
(1, 1, 1, 1299.99, 1299.99),
(1, 2, 1, 29.99, 29.99),
-- Order 2: Office Chair
(2, 3, 1, 299.99, 299.99),
-- Order 3: Standing Desk + Desk Lamp
(3, 7, 1, 499.99, 499.99),
(3, 4, 1, 79.99, 79.99),
-- Order 4: Bluetooth Speaker
(4, 6, 1, 89.99, 89.99),
-- Order 5: Laptop + Monitor + Keyboard
(5, 1, 1, 1299.99, 1299.99),
(5, 8, 1, 199.99, 199.99),
(5, 9, 1, 129.99, 129.99),
-- Order 6: Coffee Maker + Desk Lamp
(6, 5, 1, 149.99, 149.99),
(6, 4, 1, 79.99, 79.99),
-- Order 7: Monitor + Keyboard + Mouse
(7, 8, 1, 199.99, 199.99),
(7, 9, 1, 129.99, 129.99),
(7, 2, 1, 29.99, 29.99),
-- Order 8: Laptop + Tablet + Speaker
(8, 1, 1, 1299.99, 1299.99),
(8, 10, 1, 399.99, 399.99);

-- Insert sample payments
INSERT INTO raw_data.payments (order_id, payment_method, payment_amount, payment_date, payment_status) VALUES
(1, 'Credit Card', 1329.98, '2025-06-01 10:35:00', 'completed'),
(2, 'PayPal', 299.99, '2025-06-02 14:20:00', 'completed'),
(3, 'Credit Card', 529.98, '2025-06-03 09:50:00', 'completed'),
(4, 'Debit Card', 89.99, '2025-06-04 16:25:00', 'completed'),
(5, 'Credit Card', 1799.97, '2025-06-05 11:15:00', 'completed'),
(6, 'PayPal', 209.98, '2025-06-06 13:35:00', 'completed'),
(7, 'Credit Card', 579.98, '2025-06-07 15:50:00', 'completed'),
(8, 'Debit Card', 1699.97, '2025-06-08 08:25:00', 'completed');

PRINT 'Sample data inserted successfully!';
PRINT 'You now have:';
PRINT '- 8 customers';
PRINT '- 10 products';
PRINT '- 8 orders';
PRINT '- 16 order items';
PRINT '- 8 payments';
