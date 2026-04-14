--liquibase formatted sql

--changeset dbdevopsuser01:5
--comment: Insert sample seed data into orders
INSERT INTO allservices02_central.orders (user_id, status, total_amount, shipping_address)
VALUES
    (1, 'PENDING', 99.99, '123 Main St'),
    (1, 'SHIPPED', 249.50, '123 Main St'),
    (2, 'DELIVERED', 15.00, '456 Oak Ave');

--changeset dbdevopsuser01:6
--comment: Insert sample seed data into order_items
INSERT INTO allservices02_central.order_items (order_id, product_name, quantity, unit_price)
VALUES
    (1, 'Wireless Mouse', 1, 29.99),
    (1, 'USB-C Cable', 2, 35.00),
    (2, 'Mechanical Keyboard', 1, 249.50),
    (3, 'Notebook', 3, 5.00);
