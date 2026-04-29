--liquibase formatted sql

-- THIS CHANGESET INTENTIONALLY FAILS:
-- Checks that the status column still has NOT NULL enforced by attempting an insert
-- with status explicitly set to NULL. If 003 was applied (NULL allowed), the insert
-- succeeds but a follow-up constraint check fails. If schema is healthy, insert fails immediately.
-- Either way this acts as a forced failure to demonstrate pipeline rollback.

--changeset dbdevopsuser01:rollback-demo-4
--comment: [SMOKE TEST] Force failure to trigger rollback — simulates post-deploy validation catching 003's bad change
INSERT INTO demo_rollback_sql.orders (user_id, total_amount, status) VALUES (99999, 0.00, NULL);
--rollback DELETE FROM demo_rollback_sql.orders WHERE user_id = 99999;
