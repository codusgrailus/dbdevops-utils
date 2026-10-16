# Flyway Simple — Apply & Rollback

This directory is self-contained. It includes both the versioned migration scripts (`V*`) and undo scripts (`U*`).

Compatible with **MySQL 8.0** and **MariaDB**.

---

## Migrations

| Version | Script | Description |
|---------|--------|-------------|
| V1 | `V1__create_database.sql` | Create database `allservices02_central` |
| V2 | `V2__create_user_info_table.sql` | Create `user_info` table |
| V3 | `V3__add_phone_numbers.sql` | Add phone number columns to `user_info` |
| V4 | `V4__insert_seed_data.sql` | Insert seed users |
| V5 | `V5__fault_injection.sql` | Fault injection — fails only if `rollback_trigger` table exists in `y1` |

## Undo Scripts

| Version | Script | Description |
|---------|--------|-------------|
| U5 | `U5__fault_injection.sql` | Delete `faultuser` from `user_info` (if inserted) |
| U4 | `U4__insert_seed_data.sql` | Delete seeded rows |
| U3 | `U3__add_phone_numbers.sql` | Drop phone number columns |
| U2 | `U2__create_user_info_table.sql` | Drop `user_info` table |
| U1 | `U1__create_database.sql` | Drop database `allservices02_central` |

---

## Fault Injection (V5)

V5 is a controlled fault. It fails migration only if a `rollback_trigger` table exists in `y1` (the Flyway-connected schema).

**To enable the fault (V5 will fail on next migrate):**

```sql
CREATE TABLE y1.rollback_trigger (id INT);
```

**To disable the fault (V5 will pass silently):**

```sql
DROP TABLE IF EXISTS y1.rollback_trigger;
```

**To force V5 to re-run (if it was already recorded as applied):**

```sql
DELETE FROM y1.flyway_schema_history WHERE version = '5';
```

---

## How to test fault injection + rollback (full sequence)

### Step 1 — Full cleanup

```sql
DROP DATABASE IF EXISTS allservices02_central;
USE y1;
DROP TABLE IF EXISTS flyway_schema_history;
DROP TABLE IF EXISTS rollback_trigger;
```

### Step 2 — Run 1: establish baseline (fault OFF)

Ensure `rollback_trigger` does not exist, then run the Harness pipeline.

V1 → V2 → V3 → V4 → V5 all apply successfully. Schema is at V5.

Verify:
```sql
SELECT version, description, success FROM y1.flyway_schema_history;
```

### Step 3 — Enable the fault

```sql
CREATE TABLE y1.rollback_trigger (id INT);
```

### Step 4 — Reset V5 in history so Flyway re-runs it

```sql
DELETE FROM y1.flyway_schema_history WHERE version = '5';
```

### Step 5 — Run 2: trigger fault + rollback

Run the Harness pipeline again.

Expected sequence:
- V5 fails (bad INSERT fires because `rollback_trigger` exists)
- Repair removes the failed V5 entry from history
- Rollback runs `flyway undo -target=3` → executes U4 (deletes seed data)
- Schema lands at V3

Verify rollback worked:
```sql
SELECT * FROM allservices02_central.user_info;
-- expected: empty table (seed data deleted by U4)
```

---

## Apply (migrate)

```bash
flyway migrate \
  -url=jdbc:mysql://<host>:3306/<schema> \
  -user=<user> \
  -password=<password> \
  -locations=filesystem:flyway/simple-rollback
```

## Rollback (undo — requires Flyway Teams/Enterprise)

Undo one version at a time (runs the `U*` script for the current version):

```bash
flyway undo \
  -url=jdbc:mysql://<host>:3306/<schema> \
  -user=<user> \
  -password=<password> \
  -locations=filesystem:flyway/simple-rollback
```

Repeat the `undo` command to roll back additional versions.

### Undo to a specific target version

```bash
flyway undo \
  -url=jdbc:mysql://<host>:3306/<schema> \
  -user=<user> \
  -password=<password> \
  -locations=filesystem:flyway/simple-rollback \
  -target=2
```

This rolls back V4 and V3, leaving the schema at V2.

---

## Check current state

```bash
flyway info \
  -url=jdbc:mysql://<host>:3306/<schema> \
  -user=<user> \
  -password=<password> \
  -locations=filesystem:flyway/simple-rollback
```
