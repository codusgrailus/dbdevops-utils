# Flyway Cleanup

To wipe out everything Flyway applied, run these in the MariaDB CLI:

```sql
-- 1. Drop the data and schema created by migrations
DROP DATABASE IF EXISTS allservices02_central;
DROP DATABASE IF EXISTS values_check;

-- 2. Wipe Flyway's history table so it thinks nothing was ever applied
USE y1;
DROP TABLE IF EXISTS flyway_schema_history;
```

That's a clean slate — Flyway will treat it as a fresh install on the next run.
