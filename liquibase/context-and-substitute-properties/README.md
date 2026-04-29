# Liquibase: Context and Property Substitution Example

```text
Use "base,dev" as context values for these examples without the enclosing ""
```

```text
 for schema_name use this
 key: schema_name
 value: demo_ctx_props
 
 for phone_col use this
 key: phone_col
 value: mobile
```
Demonstrates two Liquibase features:
- **Property substitution** — replace `${var}` placeholders at runtime
- **Contexts** — selectively run changesets based on environment

## Properties

Defined in `changelog.yml` with defaults:

| Property | Default | Override flag |
|---|---|---|
| `schema_name` | `demo_ctx_props` | `--changeLogParameters.schema_name=mydb` |
| `phone_col` | `phone_number` | `--changeLogParameters.phone_col=mobile` |

## Contexts

| Context | Changesets that run |
|---|---|
| `base` | Create database + `user_info` table (id, username) |
| `dev` | Add `phone_number`, `future_use01`, `future_use02` columns |

Changeset `add_future_use02` also has labels `debug_support,analytics` for finer filtering.

## Equivalent liquibase Commands

```bash
# Base only — create DB and table
liquibase --changelog-file=changelog.yml --contexts base update

# Dev only — add columns (run base first)
liquibase --changelog-file=changelog.yml --contexts dev update

# Everything
liquibase --changelog-file=changelog.yml --contexts "base,dev" update

# Override schema name
liquibase --changelog-file=changelog.yml \
  --contexts "base,dev" \
  --changeLogParameters.schema_name=my_custom_db \
  update

# Filter by label
liquibase --changelog-file=changelog.yml \
  --contexts dev \
  --labels debug_support \
  update
```
