# Chapter 5: dbt Advanced Topics

> Materializations, incremental models, snapshots, Jinja templating, macros, packages, and the semantic layer.

## Materializations

| Strategy | Storage | Query Speed | Best For |
|----------|---------|-------------|----------|
| **View** | Query only (no data on disk) | Slower (computed at runtime) | Staging layer, lightweight transforms |
| **Table** | Full data on disk | Fast | Marts layer, frequently queried models |
| **Ephemeral** | None (injected as CTE) | N/A (not queryable directly) | Lightweight intermediate logic |
| **Incremental** | Appends/merges new data | Fast | Large tables with frequent updates |
| **Materialized View** | Cached query results, auto-refreshed | Fast | Low-latency access, platform-managed refresh |

### Incremental Models

Process only new or changed data instead of rebuilding the entire table:

```sql
SELECT ...
FROM {{ source('schema', 'table') }}

{% if is_incremental() %}
    WHERE updated_at >= (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}
```

`is_incremental()` returns true when: (1) model is configured as incremental, (2) the table already exists, (3) not running `--full-refresh`.

## Snapshots (SCD Type 2)

Capture point-in-time state of mutable data. dbt adds tracking columns:

| Column | Purpose |
|--------|---------|
| `dbt_valid_from` | When this version of the record became active |
| `dbt_valid_to` | When this version was superseded (NULL = current) |
| `dbt_scd_id` | Unique key for each snapshot record |

**Strategies:** `timestamp` (monitors an `updated_at` column) or `check` (monitors specific columns for changes).

See [snap_orders.sql](../../snapshots/snap_orders.sql) for a working example.

## Dynamic SQL with Jinja

| Syntax | Purpose |
|--------|---------|
| `{{ ... }}` | Expressions — output values |
| `{% ... %}` | Statements — variables, loops, conditionals |
| `{# ... #}` | Comments |
| `{%- ... -%}` | Whitespace-trimmed statements |

### Key Patterns

**Variables and loops** — dynamically generate SQL columns:
```sql
{%- set payment_types = ['cash', 'credit'] -%}

{% for payment_type in payment_types %}
    SUM(CASE WHEN payment_type = '{{ payment_type }}' THEN amount ELSE 0 END)
        AS {{ payment_type }}_amount,
{% endfor %}
```

**Environment-aware filtering** — limit data in dev:
```sql
{% if target.name != 'prod' %}
    WHERE order_date >= CURRENT_DATE - INTERVAL '90 days'
{% endif %}
```

## Macros

Reusable Jinja functions defined in `macros/`. Two examples in this project:

- [get_column_values.sql](../../macros/get_column_values.sql) — generic macro using `run_query()` to dynamically fetch distinct column values
- [limit_data_in_dev.sql](../../macros/limit_data_in_dev.sql) — environment-aware data filtering

## dbt Packages

Third-party packages installed via `packages.yml` and `dbt deps`:

```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: ">=1.1.0"
```

**Used in this project:**
- `dbt_utils.generate_surrogate_key()` — create deterministic surrogate keys for dimension tables

## Semantic Layer

An abstraction layer defining business metrics on top of dbt models:

| Component | Description |
|-----------|-------------|
| **Entities** | Identifiable objects (join keys between semantic models) |
| **Dimensions** | Categorical/time attributes for slicing data |
| **Measures** | Quantifiable data points subject to aggregation |
| **Metrics** | Business-defined calculations on measures |

---

*Based on Chapter 5 of "Analytics Engineering with SQL and dbt" by Rui Machado & Hélder Russa (O'Reilly, 2023)*
