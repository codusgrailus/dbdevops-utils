--liquibase formatted sql

-- THIS CHANGESET INTENTIONALLY FAILS:
-- Simulates a post-deploy smoke test catching the bad change in 003.
-- References a non-existent table to force a hard SQL error and trigger pipeline rollback.

--changeset dbdevopsuser01:rollback-demo-4
--comment: [SMOKE TEST] Force failure to trigger rollback — simulates post-deploy validation catching 003's bad change
SELECT * FROM demo_rollback_sql.smoke_test_intentional_failure;
--rollback SELECT 1;
