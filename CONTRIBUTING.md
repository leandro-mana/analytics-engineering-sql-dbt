# Contributing

This repository follows a professional workflow inspired by the [data-algorithms-with-pyspark](https://github.com/leandro-mana/data-algorithms-with-pyspark) and [learning-python](https://github.com/leandro-mana/learning-python) repositories.

## Workflow

### 1. Setup

```bash
make install              # Install dependencies
make pre-commit-install   # Install git hooks
make up                   # Start PostgreSQL
```

### 2. Development

```bash
make dbt-debug            # Test database connection
make dbt-seed             # Load seed data
make dbt-run              # Run models
make dbt-test             # Run tests
make dbt-docs             # Generate documentation
```

### 3. Code Quality

Before committing, run all checks:

```bash
make check                # lint + dbt test
make lint                 # sqlfluff linter
make lint-fix             # sqlfluff auto-fix
```

### 4. Commit Messages

```
feat: Add omnichannel dimension models
test: Add singular tests for purchase amounts
docs: Update Chapter 5 README with macro examples
fix: Correct payment type classification in staging
```

## SQL Style

- **Keywords:** UPPERCASE (`SELECT`, `FROM`, `WHERE`, `LEFT JOIN`)
- **Identifiers:** lowercase (`customer_id`, `order_date`)
- **Indentation:** 4 spaces
- **CTEs:** One CTE per logical step, named descriptively
- **Commas:** Leading commas in SELECT lists (dbt convention)
- **Line length:** 120 characters max

## dbt Conventions

- **Staging models:** 1:1 with source, `stg_source__entity.sql`
- **Intermediate models:** `int_description.sql`
- **Marts:** `dim_entity.sql`, `fct_event.sql`
- **YAML configs:** Prefixed with `_` (e.g., `_jaffle_shop_sources.yml`)
- **Sources:** Only referenced in staging via `{{ source() }}`
- **Refs:** All other cross-model references via `{{ ref() }}`
