--liquibase formatted sql

--changeset dbdevopsuser01:2
--comment: Create the order_items table
CREATE TABLE IF NOT EXISTS demo_versioned_sql.order_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL
);
