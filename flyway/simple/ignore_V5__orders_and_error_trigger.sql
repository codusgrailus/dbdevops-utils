CREATE TABLE IF NOT EXISTS orders (
    id          BIGINT        NOT NULL AUTO_INCREMENT,
    username    VARCHAR(100)  NOT NULL,
    product     VARCHAR(255)  NOT NULL,
    amount      DECIMAL(10,2) NOT NULL,
    ordered_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

INSERT INTO orders (username, product, amount) VALUES
    ('jdoe',    'Widget A', 19.99),
    ('asmith',  'Widget B', 49.99),
    ('bwilson', 'Widget C', 9.99);

SET @error_trigger = (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'trigger_error_table');
SET @stmt = IF(@error_trigger > 0, 'INSERT INTO this_table_does_not_exist (id) VALUES (1)', 'SELECT 1');
PREPARE stmt FROM @stmt; EXECUTE stmt; DEALLOCATE PREPARE stmt;
