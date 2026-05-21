--liquibase formatted sql

--changeset dbdevopsuser01:3
--comment: Add an index on orders.user_id for faster lookups
CREATE INDEX idx_orders_user_id ON demo_versioned_sql.orders (user_id);

--changeset dbdevopsuser01:4
--comment: Add a shipping_address column to orders
ALTER TABLE demo_versioned_sql.orders ADD COLUMN shipping_address VARCHAR(500);
