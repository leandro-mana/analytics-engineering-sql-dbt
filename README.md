# Analytics Engineering with SQL and dbt

[![Python 3.12+](https://img.shields.io/badge/python-3.12%2B-blue.svg)](https://www.python.org/downloads/)
[![dbt 1.9+](https://img.shields.io/badge/dbt-1.9%2B-FF694B.svg)](https://www.getdbt.com/)
[![PostgreSQL 16](https://img.shields.io/badge/postgresql-16-336791.svg)](https://www.postgresql.org/)
[![Code Style: sqlfluff](https://img.shields.io/badge/code%20style-sqlfluff-4B8BBE.svg)](https://sqlfluff.com/)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Chapters](https://img.shields.io/badge/chapters-6-orange.svg)](docs/)
[![Models](https://img.shields.io/badge/models-15-brightgreen.svg)](models/)

Study notes and hands-on dbt project based on *Analytics Engineering with SQL and dbt* by Rui Machado & Hélder Russa (O'Reilly, 2023).

This repository is an **opinionated, runnable dbt project** — not a rewrite of the book. Theory lives in the chapter READMEs; the real value is in the working models, tests, and data pipeline you can run locally.

## Requirements

- [Python 3.12+](https://www.python.org/downloads/)
- [Poetry](https://python-poetry.org/docs/#installation)
- [Docker](https://docs.docker.com/get-docker/)

## Quick Start

```bash
make install          # Install Python dependencies (dbt-core, dbt-postgres)
make up               # Start PostgreSQL via Docker
make dbt-seed         # Load sample data (Jaffle Shop + Omnichannel)
make dbt-run          # Run all models (staging → intermediate → marts)
make dbt-test         # Run all tests (generic + singular)
make dbt-docs         # Generate and serve dbt documentation
```

Or run the full pipeline in one command:

```bash
make dbt-build        # seed + run + test
```

## Chapters Overview

| # | Chapter | Type | Status |
|---|---------|------|--------|
| 1 | [Analytics Engineering](docs/chapter_01/README.md) | Theory | Done |
| 2 | [Data Modeling for Analytics](docs/chapter_02/README.md) | Theory | Done |
| 3 | [SQL for Analytics](docs/chapter_03/README.md) | Theory | Done |
| 4 | [Data Transformation with dbt](docs/chapter_04/README.md) | Hands-on | Done |
| 5 | [dbt Advanced Topics](docs/chapter_05/README.md) | Hands-on | Done |
| 6 | [End-to-End Use Case](docs/chapter_06/README.md) | Hands-on | Done |

## Project Structure

```
├── models/
│   ├── staging/                    # 1:1 with sources, light transforms
│   │   ├── jaffle_shop/           # Ch4: customers, orders
│   │   ├── stripe/                # Ch4: payments
│   │   └── omnichannel/           # Ch6: channels, products, purchases, visits
│   ├── intermediate/              # Ch4: payment aggregations
│   └── marts/
│       ├── core/                  # Ch4: dim_customers, fct_orders
│       └── omnichannel/           # Ch6: star schema (3 dims + 2 facts)
├── seeds/                         # CSV sample data for all chapters
├── macros/                        # Ch5: reusable Jinja macros
├── snapshots/                     # Ch5: SCD type 2 order tracking
├── analyses/                      # Ad hoc analytical queries
├── tests/                         # Singular dbt tests
├── docs/                          # Chapter READMEs + book PDF (gitignored)
├── dbt_project.yml                # dbt configuration
├── packages.yml                   # dbt packages (dbt_utils)
├── profiles.yml                   # Database connection (local PostgreSQL)
├── docker-compose.yml             # PostgreSQL 16
├── Makefile                       # Automation commands
└── pyproject.toml                 # Poetry dependencies
```

## Key Concepts by Chapter

| Concept | Chapter | Models |
|---------|---------|--------|
| Staging / Intermediate / Marts layers | 4 | `stg_*`, `int_*`, `dim_*`, `fct_*` |
| Sources and `{{ ref() }}` | 4 | All models |
| Generic + singular tests | 4, 6 | YAML configs + `tests/` |
| Seeds (CSV → tables) | 4, 6 | `seeds/*.csv` |
| Documentation (YAML + doc blocks) | 4 | `_core_docs.md` |
| Snapshots (SCD type 2) | 5 | `snap_orders.sql` |
| Jinja macros | 5 | `macros/` |
| dbt packages (`dbt_utils`) | 5, 6 | Surrogate keys in omnichannel dims |
| Star schema (dims + facts) | 6 | `models/marts/omnichannel/` |
| Surrogate keys | 6 | `dim_omni_*` |
| Naming conventions (sk_, nk_, mtr_, dsc_) | 6 | Omnichannel models |

## Related Repositories

| Repository | Topic |
|------------|-------|
| [data-algorithms-with-pyspark](https://github.com/leandro-mana/data-algorithms-with-pyspark) | Data algorithms with PySpark |
| [learning-python](https://github.com/leandro-mana/learning-python) | Python fundamentals to advanced |
| [postgres-notes](https://github.com/leandro-mana/postgres-notes) | PostgreSQL notes |
| [mysql-notes](https://github.com/leandro-mana/mysql-notes) | MySQL notes |

## Book Reference

Place the book PDF in `docs/` (gitignored):

```bash
cp ~/path/to/"Analytics Engineering with SQL and dbt (2023).pdf" docs/
```

## License

MIT
