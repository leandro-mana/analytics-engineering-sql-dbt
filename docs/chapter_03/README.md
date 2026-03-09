# Chapter 3: SQL for Analytics

> SQL fundamentals for analytics engineering — from DDL/DML through views, CTEs, and window functions to distributed data processing.

## Key Concepts

### Why SQL Endures

SQL has remained the dominant language for data work because of:
- **Readability** — declarative syntax: specify *what* you want, not *how*
- **Engine evolution** — from traditional RDBMS to distributed engines (Spark, Presto, DuckDB)
- **Strong data typing** — consistent types enforced throughout the pipeline
- **Modularity** — CTEs make SQL testable and composable
- **Window functions** — complex analytics without collapsing rows

### DDL (Data Definition Language)

| Command | Purpose |
|---------|---------|
| `CREATE` | New objects (tables, views, indexes) |
| `ALTER` | Modify structure (add/modify/drop columns) |
| `DROP` | Permanently delete objects |
| `TRUNCATE` | Remove all data, keep structure |

**Constraints:** `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK`, `NOT NULL`

### DML (Data Manipulation Language)

| Command | Purpose |
|---------|---------|
| `SELECT` | Query data (WHERE, GROUP BY, HAVING, ORDER BY, JOINs) |
| `INSERT` | Add new rows |
| `UPDATE` | Modify existing rows |
| `DELETE` | Remove rows (consider soft deletes for audit trails) |

**JOIN types:** `INNER`, `LEFT`, `RIGHT`, `FULL`, `CROSS`

### Views

Virtual tables defined by a query — simplify complex queries, provide security layers, and maintain backward compatibility when schemas change.

### Common Table Expressions (CTEs)

Temporary named result sets that break complex queries into readable, reusable blocks:

```sql
WITH step_one AS (
    SELECT ... FROM ...
),

step_two AS (
    SELECT ... FROM step_one
)

SELECT ... FROM step_two
```

**Advantages over subqueries:** readability, reusability (reference the same CTE multiple times), modularity, maintainability. CTEs are fundamental to how dbt models are structured.

### Window Functions

Perform calculations across a set of rows related to the current row — without collapsing rows like `GROUP BY`:

```sql
SELECT
    column,
    window_function() OVER (
        PARTITION BY column
        ORDER BY column
    )
FROM table;
```

| Type | Functions | Use Case |
|------|-----------|----------|
| **Aggregate** | `SUM()`, `AVG()`, `COUNT()`, `MAX()`, `MIN()` | Running totals, moving averages |
| **Ranking** | `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `NTILE()` | Top-N, percentiles, deduplication |
| **Analytics** | `LAG()`, `LEAD()`, `FIRST_VALUE()`, `LAST_VALUE()` | Period-over-period comparisons |

### Distributed Data Processing

The chapter also covers SQL interfaces for distributed/modern engines:

| Tool | Description |
|------|-------------|
| **DuckDB** | In-process OLAP database (like SQLite for analytics); column-oriented, parallelized |
| **Polars** | High-performance DataFrame library (Rust); lazy evaluation, Apache Arrow backend |
| **FugueSQL** | Unified SQL interface across pandas, Spark, Dask, and DuckDB |

## Hands-On SQL Practice

For comprehensive SQL practice with working examples, see these companion repositories:

- **[postgres-notes](https://github.com/leandro-mana/postgres-notes)** — PostgreSQL fundamentals, advanced queries, administration
- **[mysql-notes](https://github.com/leandro-mana/mysql-notes)** — MySQL fundamentals and practice

This repository focuses on **dbt as the SQL transformation layer** — see Chapters 4-6 for hands-on dbt models.

## Summary

SQL remains the backbone of analytics engineering. Its declarative nature, strong typing, CTEs, and window functions make it ideal for data transformation. Modern engines (DuckDB, Polars) prove SQL's adaptability, while dbt leverages SQL's strengths to bring software engineering practices to data pipelines. The real power is in combining SQL fundamentals with dbt's modularity — which is exactly what Chapters 4-6 build.

---

*Based on Chapter 3 of "Analytics Engineering with SQL and dbt" by Rui Machado & Hélder Russa (O'Reilly, 2023)*
