--liquibase formatted sql

--changeset dbdevopsuser01:HOTFIX-2026-04-01
--comment: Insert additional order items as part of HOTFIX-2026-04-01
INSERT INTO demo_versioned_sql.order_items (order_id, product_name, quantity, unit_price)
VALUES
    (1, 'Bluetooth Speaker', 1, 45.99),
    (1, 'HDMI Cable', 3, 12.50),
    (2, 'Webcam HD 1080p', 1, 79.00),
    (3, 'Sticky Notes Pack', 5, 3.25);
