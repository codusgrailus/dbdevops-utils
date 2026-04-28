# Liquibase Rollback Demo — YAML Auto-Implicit

Same scenario as `rollback-sql-explicit` but using **YAML with Liquibase built-in change types**.

## Key difference from SQL format

| | `rollback-sql-explicit` | `rollback-yaml-auto-implicit` |
|---|---|---|
| Format | Liquibase formatted SQL | YAML with built-in types |
| Rollback for createTable | Must write `--rollback DROP TABLE` | **Auto-generated** by Liquibase |
| Rollback for addColumn | Must write `--rollback DROP COLUMN` | **Auto-generated** by Liquibase |
| Rollback for modifyDataType | Must write `--rollback` | Still needs explicit `rollback:` block |

## Changesets

| ID | Change | Rollback |
|---|---|---|
| `rollback-yaml-demo-1` | `createTable discount_codes` | Auto: `dropTable` |
| `rollback-yaml-demo-2` | `addColumn discount_code_id` + FK | Auto: `dropColumn` + drop FK |
| `rollback-yaml-demo-3` | **BAD**: `modifyDataType` removes NOT NULL/default | Explicit `rollback:` block required |

## Pipeline steps

### Step 1 — Apply
```bash
liquibase \
  --url="jdbc:mysql://<host>:3306/" \
  --username=<user> \
  --password=<pass> \
  --changeLogFile=liquibase/rollback-yaml-auto-implicit/changelog.yml \
  update
```

### Step 2 — Rollback last 1 changeset
```bash
liquibase \
  --url="jdbc:mysql://<host>:3306/" \
  --username=<user> \
  --password=<pass> \
  --changeLogFile=liquibase/rollback-yaml-auto-implicit/changelog.yml \
  rollbackCount 1
```
