--liquibase formatted sql

-- THIS CHANGESET INTRODUCES A PROBLEM:
-- It removes the DEFAULT 'PENDING' and NOT NULL constraint from orders.status,
-- which breaks application logic that relies on a default order status.
-- This is the changeset we will roll back in the pipeline demo.

--changeset dbdevopsuser01:rollback-demo-3
--comment: [BAD CHANGE] Remove default and NOT NULL from orders.status — breaks app logic
ALTER TABLE demo_rollback_sql.orders
    MODIFY COLUMN status VARCHAR(50) NULL DEFAULT NULL;
--rollback ALTER TABLE demo_rollback_sql.orders MODIFY COLUMN status VARCHAR(50) NOT NULL DEFAULT 'PENDING';
