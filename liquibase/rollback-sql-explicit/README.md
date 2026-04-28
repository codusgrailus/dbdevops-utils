# Liquibase Rollback Demo

This directory demonstrates a **Harness pipeline rollback** scenario.

## What's in here

| File | Changeset ID | Purpose |
|------|-------------|---------|
| `001_add_discount_table.sql` | `rollback-demo-1` | Creates `discount_codes` table — good change |
| `002_add_discount_column_to_orders.sql` | `rollback-demo-2` | Adds FK column to `orders` — good change |
| `003_bad_change_drop_status_default.sql` | `rollback-demo-3` | **BAD CHANGE** — removes `NOT NULL DEFAULT 'PENDING'` from `orders.status`, breaking app logic |

Every changeset has an explicit `--rollback` block so Liquibase knows exactly how to undo it.

## Pipeline steps

### Step 1 — Apply (update)
```bash
liquibase \
  --url="jdbc:mysql://<host>:3306/" \
  --username=<user> \
  --password=<pass> \
  --changeLogFile=liquibase/rollback/changelog.yml \
  update
```

### Step 2 — Rollback (triggered after bad change is detected)

Roll back the last **1** changeset (only `rollback-demo-3`):
```bash
liquibase \
  --url="jdbc:mysql://<host>:3306/" \
  --username=<user> \
  --password=<pass> \
  --changeLogFile=liquibase/rollback/changelog.yml \
  rollbackCount 1
```

Or roll back to a specific tag / changeset ID:
```bash
liquibase \
  --url="jdbc:mysql://<host>:3306/" \
  --username=<user> \
  --password=<pass> \
  --changeLogFile=liquibase/rollback/changelog.yml \
  rollback rollback-demo-2
```

## Why this is a good demo

- Steps 1 and 2 run back-to-back in the **same Harness stage**, making the apply→rollback flow visible in one pipeline run.
- The bad change is realistic: removing a `NOT NULL DEFAULT` is a non-destructive DDL that looks harmless but silently breaks inserts that omit the `status` field.
- All three changesets have `--rollback` blocks, so `rollbackCount 1` or `rollbackCount 3` both work cleanly.
