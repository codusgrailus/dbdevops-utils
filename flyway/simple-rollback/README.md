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
| V5 | `V5__fault_injection.sql` | Fault injection — fails only if `rollback_trigger` table exists |

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

V5 is a controlled fault. It fails migration only if a `rollback_trigger` table exists in `allservices02_central`. This lets you test Harness DBDevOps rollback behaviour on demand.

**To trigger a failure on next migrate:**

```sql
CREATE TABLE allservices02_central.rollback_trigger (id INT);
```

**To disable the fault (V5 will pass silently):**

```sql
DROP TABLE IF EXISTS allservices02_central.rollback_trigger;
```

The table must be created in `allservices02_central` (the database created by V1), not in the Flyway-connected schema.

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
