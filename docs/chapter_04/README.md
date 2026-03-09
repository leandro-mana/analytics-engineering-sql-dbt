# Chapter 4: Data Transformation with dbt

> The core dbt chapter — project structure, the Jaffle Shop database, staging/intermediate/marts layers, sources, tests, seeds, documentation, and deployment.

## dbt Design Philosophy

- **Code-centric** — Data modeling via SQL scripts, not GUIs. Version controlled, reviewable, testable.
- **Modularity** — Models, macros, and tests organized into reusable components.
- **SQL SELECT statements** — Every model is a SELECT. dbt handles materialization (view, table, incremental).
- **Declarative** — Specify the desired outcome; dbt handles the implementation.
- **Testing built-in** — Data quality checks are first-class citizens, not afterthoughts.
- **Documentation as code** — Descriptions live alongside the models they document.

## The Jaffle Shop Database

The classic dbt example — a fictional e-commerce shop with three raw data sources:

| Source | Table | Description |
|--------|-------|-------------|
| `jaffle_shop` | `raw_customers` | Customer records (id, first_name, last_name) |
| `jaffle_shop` | `raw_orders` | Order records (id, user_id, order_date, status) |
| `stripe` | `raw_payments` | Payment records (id, order_id, payment_method, amount, status) |

**Relationships:** One customer → many orders → many payments.

In our project, these are loaded as **seeds** (CSV files) into PostgreSQL via `dbt seed`.

## Project Structure

```
models/
├── staging/
│   ├── jaffle_shop/
│   │   ├── _jaffle_shop_sources.yml     # Source definitions + tests
│   │   ├── _jaffle_shop_models.yml      # Model configs + tests
│   │   ├── stg_jaffle_shop__customers.sql
│   │   └── stg_jaffle_shop__orders.sql
│   └── stripe/
│       ├── _stripe_sources.yml
│       ├── _stripe_models.yml
│       └── stg_stripe__payments.sql
├── intermediate/
│   ├── _intermediate_models.yml
│   └── int_payment_type_amount_per_order.sql
└── marts/
    └── core/
        ├── _core_models.yml
        ├── _core_docs.md
        ├── dim_customers.sql
        └── fct_orders.sql
```

## The Three Layers

### Staging (`models/staging/`)
- **1:1 with source tables** — one staging model per raw table
- **Light transformations only** — rename columns, cast types, classify values
- **Materialized as views** — no storage overhead, always fresh
- **Uses `source()`** — the only layer that references raw data directly

### Intermediate (`models/intermediate/`)
- **Combines staging models** — business logic not exposed to end users
- **Materialized as views** — or ephemeral (CTEs injected into downstream models)
- **Uses `ref()`** — references staging models

### Marts (`models/marts/`)
- **Business-ready entities** — fact and dimension tables for dashboards
- **Materialized as tables** — optimized for query performance
- **Uses `ref()`** — references intermediate and staging models

## Key dbt Concepts

### Sources vs Refs
- `{{ source('schema', 'table') }}` — reference raw data. Used only in staging models.
- `{{ ref('model_name') }}` — reference another dbt model. Builds the DAG automatically.

### Tests

| Type | Description | Location |
|------|-------------|----------|
| **Generic** | Reusable: `unique`, `not_null`, `accepted_values`, `relationships` | YAML files (columns section) |
| **Singular** | Custom SQL returning rows that fail | `tests/` directory |

### Seeds
CSV files loaded as tables via `dbt seed`. For small, infrequently changing reference data.

### Documentation
- **YAML descriptions** — inline in model YAML files
- **Doc blocks** — Markdown files with `{% docs block_name %}` for rich documentation
- **Generate** — `dbt docs generate` creates a browsable documentation site

## Running This Chapter

```bash
make up              # Start PostgreSQL
make dbt-seed        # Load seed data (raw_customers, raw_orders, raw_payments)
make dbt-run         # Run all models (staging → intermediate → marts)
make dbt-test        # Run all tests (generic + singular)
make dbt-build       # All of the above in one command
make dbt-docs        # Generate and serve documentation
```

## dbt Commands Reference

| Command | Purpose |
|---------|---------|
| `dbt run` | Execute all models |
| `dbt run --select model_name` | Run a specific model |
| `dbt run --select +model_name` | Run model and all upstream dependencies |
| `dbt test` | Run all tests |
| `dbt test --select model_name` | Run tests for a specific model |
| `dbt seed` | Load CSV seed data |
| `dbt docs generate` | Generate documentation |
| `dbt compile` | Compile Jinja to pure SQL (useful for debugging) |
| `dbt debug` | Test database connection |
| `dbt clean` | Remove build artifacts |

---

*Based on Chapter 4 of "Analytics Engineering with SQL and dbt" by Rui Machado & Hélder Russa (O'Reilly, 2023)*
