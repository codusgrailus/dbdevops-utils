--liquibase formatted sql

--changeset dbdevopsuser01:rollback-demo-2
--comment: Add discount_code_id FK column to orders table
ALTER TABLE demo_rollback_sql.orders
    ADD COLUMN discount_code_id BIGINT,
    ADD CONSTRAINT fk_orders_discount FOREIGN KEY (discount_code_id) REFERENCES demo_rollback_sql.discount_codes(id);
--rollback ALTER TABLE demo_rollback_sql.orders DROP FOREIGN KEY fk_orders_discount;
--rollback ALTER TABLE demo_rollback_sql.orders DROP COLUMN discount_code_id;
