# Chapter 1: Analytics Engineering

> The evolution of data management from traditional SQL-based systems to modern tools like dbt, and how the analytics engineer role bridges data engineering and analytics.

## Key Concepts

### The Data Analytics Lifecycle

A six-stage cyclical framework that guides analytics engineering work:

| Stage | Description |
|-------|-------------|
| **1. Problem Definition** | Understand the business problem, identify objectives, assess data availability |
| **2. Data Modeling** | Model data using the technique that best fits requirements (star schema, data vault, etc.) |
| **3. Data Ingestion & Transformation** | Ingest and prepare data from source systems (schema-on-write vs schema-on-read) |
| **4. Data Storage & Structuring** | Choose file formats (Parquet, Delta Lake, Iceberg), partitioning, and storage (S3, Redshift, BigQuery) |
| **5. Data Visualization & Analysis** | Build dashboards and explore data for decision support |
| **6. Data Quality, Testing & Documentation** | Implement quality controls, document transformations, ensure proper testing |

### The Analytics Engineer Role

The analytics engineer acts as a **bridge** between data platform engineers (infrastructure) and data analysts (consumption).

**Core mandate:** Create well-tested, up-to-date, and documented datasets that the rest of the organization can use to answer their own questions.

**Key responsibilities:**
- Design and implement data storage and retrieval systems
- Create and maintain data transformation pipelines (ELT)
- Ensure data accuracy, completeness, consistency, and accessibility
- Optimize performance of storage systems and data pipelines
- Apply software engineering best practices (version control, CI/CD, testing)
- Collaborate with data scientists and analysts on requirements

### ETL vs ELT

| Aspect | ETL | ELT |
|--------|-----|-----|
| **Order** | Extract → Transform → Load | Extract → Load → Transform |
| **Where** | Transformation before loading | Transformation in the data warehouse |
| **Flexibility** | Less flexible, harder to scale | More flexible, leverages warehouse compute |
| **Cost** | Lower storage (only transformed data) | Higher storage (raw + transformed data) |
| **Modern fit** | Legacy approach | Cloud-native approach (dbt operates here) |

### Enabling Analytics in a Data Mesh

- **Data Mesh**: A framework where domain teams own their data services instead of relying on a central data team
- **Data Products**: Applications that provide access to data-driven insights, supporting decision-making or automating processes
- **dbt as enabler**: Provides data modeling, testing, documentation, lineage tracking, and governance capabilities to support data mesh architectures

### The dbt Revolution

dbt is an open-source command-line tool that simplifies data transformation and modeling:

- Analytics engineers write **SQL SELECT statements** — dbt handles the rest
- Integrates with orchestrators (Airflow, Dagster, Prefect) for scheduling
- Brings **software engineering practices** to analytics: version control, testing, documentation, CI/CD
- Open source, deployable on-premises or in the cloud

## Historical Context

| Era | Milestone |
|-----|-----------|
| 1980s-1990s | Data warehousing begins (Bill Inmon, Ralph Kimball) |
| Early 2000s | Big Data era — Google File System, Apache Hadoop |
| 2012 | Amazon Redshift — OLAP meets cloud |
| Cloud era | BigQuery, Snowflake streamline administration |
| Modern stack | dbt, Airflow, Looker transform workflows; "analytics engineer" emerges |

## Summary

Analytics engineering is a discipline focused on transforming raw data into reliable, well-tested, documented datasets. The field has evolved from monolithic stored procedures and ETL tools to modern ELT pipelines powered by dbt. The analytics engineer role combines technical skills (SQL, Python, data modeling) with business understanding and software engineering practices.

---

*Based on Chapter 1 of "Analytics Engineering with SQL and dbt" by Rui Machado & Hélder Russa (O'Reilly, 2023)*
