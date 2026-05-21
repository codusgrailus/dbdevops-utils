# Liquibase Rollback Demo — Explicit SQL Rollback

This directory demonstrates a **Harness pipeline rollback** scenario using explicit `--rollback` blocks in SQL-formatted changesets.

## What's in here

| File | Changeset ID | Purpose |
|------|-------------|---------|
| `000_bootstrap.sql` | `rollback-demo-0` | Creates `demo_rollback_sql` database and `orders` table — self-contained setup |
| `001_add_discount_table.sql` | `rollback-demo-1` | Creates `discount_codes` table — good change |
| `002_add_discount_column_to_orders.sql` | `rollback-demo-2` | Adds FK column to `orders` — good change |
| `003_bad_change_drop_status_default.sql` | `rollback-demo-3` | **BAD CHANGE** — removes `NOT NULL DEFAULT 'PENDING'` from `orders.status`, silently breaking app logic |
| `004_validate_status_not_null.sql` | `rollback-demo-4` | **FORCED FAILURE** — references a non-existent table to produce a hard SQL error and trigger pipeline rollback |

Every changeset has an explicit `--rollback` block so Liquibase knows exactly how to undo it.

## How the failure is triggered

Changeset 003 is a valid DDL that executes without error — MySQL happily removes the `NOT NULL DEFAULT` constraint. Liquibase sees success and moves on.

Changeset 004 is the smoke test that catches this. It runs:
```sql
SELECT * FROM demo_rollback_sql.smoke_test_intentional_failure;
```
This always throws `Table doesn't exist`, causing Liquibase to halt with an error on changeset 4. The pipeline detects the failure and triggers the rollback step.

## Pipeline steps

### Step 1 — Apply (update)
```bash
liquibase \
  --search-path=liquibase/rollback-sql-explicit \
  --url="jdbc:mysql://<host>:3306/" \
  --username=<user> \
  --password=<pass> \
  --changelog-file=changelog.yml \
  update
```

Expected: changesets 000–003 succeed, changeset 004 **fails** — pipeline triggers rollback.

### Step 2 — Rollback (triggered after failure)

Roll back the last **2** changesets (003 and 004 — though 004 never fully applied, rolling back 003 is the goal):
```bash
liquibase \
  --search-path=liquibase/rollback-sql-explicit \
  --url="jdbc:mysql://<host>:3306/" \
  --username=<user> \
  --password=<pass> \
  --changelog-file=changelog.yml \
  rollbackCount 2
```

Or roll back to a specific tag to restore the last known good state:
```bash
liquibase \
  --search-path=liquibase/rollback-sql-explicit \
  --url="jdbc:mysql://<host>:3306/" \
  --username=<user> \
  --password=<pass> \
  --changelog-file=changelog.yml \
  rollback rollback-demo-2
```

## Why this is a good demo

- The bad change (003) is realistic: removing a `NOT NULL DEFAULT` is a non-destructive DDL that looks harmless but silently breaks any insert that omits the `status` field.
- 003 does **not** fail on its own — that's the point. Without a smoke test, it would slip through undetected.
- 004 acts as the smoke test, forcing a hard failure so the pipeline can demonstrate the full apply → fail → rollback flow in a single run.
- All changesets have explicit `--rollback` blocks, so `rollbackCount` and tag-based rollback both work cleanly.
