-- Database: inventory_central (distinct from allservices02_central used in 001.yml)

CREATE DATABASE IF NOT EXISTS inventory_central;

CREATE TABLE IF NOT EXISTS inventory_central.product_catalog (
    id         BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    sku        VARCHAR(100) NOT NULL UNIQUE,
    name       VARCHAR(255) NOT NULL,
    category   VARCHAR(100),
    unit_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    stock_qty  INT          NOT NULL DEFAULT 0,
    is_active  BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS inventory_central.warehouse_location (
    id           BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    code         VARCHAR(50)  NOT NULL UNIQUE,
    display_name VARCHAR(255) NOT NULL,
    city         VARCHAR(100),
    country      VARCHAR(100) NOT NULL DEFAULT 'US',
    created_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT IGNORE INTO inventory_central.product_catalog (sku, name, category, unit_price, stock_qty)
VALUES
    ('SKU-001', 'Wireless Mouse',    'Peripherals', 29.99, 150),
    ('SKU-002', 'Mechanical Keyboard','Peripherals', 89.99,  75),
    ('SKU-003', 'USB-C Hub',         'Accessories', 49.99, 200);

INSERT IGNORE INTO inventory_central.warehouse_location (code, display_name, city, country)
VALUES
    ('WH-US-EAST', 'East Coast Warehouse', 'New York',    'US'),
    ('WH-US-WEST', 'West Coast Warehouse', 'Los Angeles', 'US'),
    ('WH-IN-MUM',  'Mumbai Warehouse',     'Mumbai',      'IN');
