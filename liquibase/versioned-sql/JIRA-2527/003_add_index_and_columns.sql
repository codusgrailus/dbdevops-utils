--liquibase formatted sql

--changeset dbdevopsuser01:3
--comment: Add an index on orders.user_id for faster lookups
CREATE INDEX idx_orders_user_id ON allservices02_central.orders (user_id);

--changeset dbdevopsuser01:4
--comment: Add a shipping_address column to orders
ALTER TABLE allservices02_central.orders ADD COLUMN shipping_address VARCHAR(500);
