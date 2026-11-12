# Flyway Simple Migrations

## Migrations

| Version | Description |
|---------|-------------|
| V1 | Create database `allservices02_central` |
| V2 | Create `user_info` table |
| V3 | Add phone number columns to `user_info` |
| V4 | Insert seed data into `user_info` (idempotent via `INSERT IGNORE`) |
| V5 | Create `orders` table, insert seed data, error-trigger check |

---

## Testing V5 Rollback

### 1. Happy path (no rollback)

Run without `trigger_error_table` present — V5 completes cleanly.

```sql
-- Verify orders were inserted
SELECT * FROM orders;

-- Confirm flyway recorded V5 as success
SELECT version, description, success FROM flyway_schema_history ORDER BY installed_rank;
```

### 2. Set up rollback trigger

Manually create `trigger_error_table` in the target schema **before** running the pipeline:

```sql
-- Run this on y1 or y2
CREATE TABLE y2.trigger_error_table (id INT);
```

### 3. Run the pipeline

V5 will fail at the dynamic INSERT into `this_table_does_not_exist`.

