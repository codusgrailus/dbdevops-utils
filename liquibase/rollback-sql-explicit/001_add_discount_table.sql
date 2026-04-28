--liquibase formatted sql

--changeset dbdevopsuser01:rollback-demo-1
--comment: Create discount_codes table
CREATE TABLE IF NOT EXISTS allservices02_central.discount_codes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    discount_percent DECIMAL(5,2) NOT NULL,
    valid_from DATE NOT NULL,
    valid_until DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);
--rollback DROP TABLE IF EXISTS allservices02_central.discount_codes;
