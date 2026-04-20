--liquibase formatted sql

--changeset dbdevopsuser01:rollback-demo-2
--comment: Add discount_code_id FK column to orders table
ALTER TABLE allservices02_central.orders
    ADD COLUMN discount_code_id BIGINT,
    ADD CONSTRAINT fk_orders_discount FOREIGN KEY (discount_code_id) REFERENCES allservices02_central.discount_codes(id);
--rollback ALTER TABLE allservices02_central.orders DROP FOREIGN KEY fk_orders_discount;
--rollback ALTER TABLE allservices02_central.orders DROP COLUMN discount_code_id;
