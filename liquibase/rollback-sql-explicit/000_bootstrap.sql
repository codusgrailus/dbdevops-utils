--liquibase formatted sql

--changeset dbdevopsuser01:rollback-demo-0
--comment: Create database and orders table so this example is self-contained
CREATE DATABASE IF NOT EXISTS demo_rollback_sql;

CREATE TABLE IF NOT EXISTS demo_rollback_sql.orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status VARCHAR(50) DEFAULT 'PENDING' NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
--rollback DROP TABLE IF EXISTS demo_rollback_sql.orders;
--rollback DROP DATABASE IF EXISTS demo_rollback_sql;
