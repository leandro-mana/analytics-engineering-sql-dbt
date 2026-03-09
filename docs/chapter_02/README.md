# Chapter 2: Data Modeling for Analytics

> Data modeling fundamentals: from conceptual design through normalization to dimensional modeling patterns, modular dbt models, and the medallion architecture.

## Key Concepts

### Data Modeling Phases

| Phase | Focus | Output |
|-------|-------|--------|
| **Conceptual** | Identify entities, attributes, relationships; gather requirements from stakeholders | Entity-Relationship Diagram (ERD) |
| **Logical** | Normalize data to eliminate redundancy; translate ERD to relational model (DBMS-independent) | Normalized relational schema |
| **Physical** | Define storage structures, data types, indexes, constraints for a specific DBMS | DDL statements (CREATE TABLE) |

### Normalization

| Normal Form | Rule | Effect |
|-------------|------|--------|
| **1NF** | Eliminate repeating groups; atomic values only | Separate entities into distinct tables |
| **2NF** | Every non-key column depends solely on the primary key | Remove partial dependencies |
| **3NF** | Eliminate transitive dependencies (non-key → non-key) | Extract lookup tables |

OLTP databases typically use 3NF — optimized for write operations, low latency, current-state data.

### OLTP vs OLAP

| Aspect | OLTP | OLAP |
|--------|------|------|
| **Optimized for** | Write operations | Read operations |
| **Data** | Current state only | Current + historical |
| **Sources** | Single application | Multiple OLTP systems |
| **Schema** | Normalized (3NF) | Denormalized (star/snowflake) |

### Dimensional Modeling

#### Star Schema
- **Fact tables**: Store measurable events (orders, transactions) with foreign keys + numeric measures
- **Dimension tables**: Describe business entities (customers, products, time) with descriptive attributes
- Simple, intuitive, fewer JOINs, integrates well with BI tools (Tableau, Power BI, Looker)

#### Snowflake Schema
- Normalized dimensions (e.g., `dimLocation` → `dimCity` → `dimState` → `dimCountry`)
- Reduces redundancy at the cost of more complex queries (more JOINs)
- Better for evolving data structures and frequent changes

#### Data Vault 2.0
Three components designed for large volumes and changing requirements:

| Component | Purpose |
|-----------|---------|
| **Hubs** | Business entities — store unique business keys |
| **Links** | Relationships between hubs (many-to-many) |
| **Satellites** | Descriptive attributes with time-varying data (historical records) |

### Modular Data Models with dbt

The antidote to monolithic SQL files — break the pipeline into reusable, testable layers:

| Layer | Purpose | Materialization | Naming |
|-------|---------|-----------------|--------|
| **Staging** | 1:1 with source; rename, cast, light transforms only | View | `stg_source_entity` |
| **Intermediate** | Combine staging models; business logic not exposed to end users | View / Ephemeral | `int_description` |
| **Marts** | Final business entities for dashboards and applications | Table | `dim_entity`, `fct_event` |

**Key dbt functions:**
- `{{ source('schema', 'table') }}` — reference raw data (used only in staging)
- `{{ ref('model_name') }}` — reference another model (builds the DAG automatically)

### Testing Data Models

| Type | Description | Location |
|------|-------------|----------|
| **Generic tests** | Reusable: `unique`, `not_null`, `accepted_values`, `relationships` | YAML files |
| **Singular tests** | Custom SQL returning failing rows | `tests/` directory |

### Medallion Architecture

A data lakehouse pattern with three tiers of ascending data quality:

| Layer | Purpose | Contents |
|-------|---------|----------|
| **Bronze** | Landing zone | Raw data mirroring source systems + metadata (load date, process ID) |
| **Silver** | Refined | Cleansed, merged, conformed data; can follow star schema, 3NF, or data vault |
| **Gold** | Business-ready | Aggregated data for BI, reporting, ML |

The medallion architecture complements (not replaces) dimensional modeling — it guides **how data flows** through layers, while star schema / data vault guide **how data is structured** within each layer.

## Summary

Data modeling is the foundation of analytics engineering. Start with conceptual design (ERDs), normalize for OLTP (3NF), then denormalize for analytics (star/snowflake schema or data vault). Modern dbt projects use modular layers (staging → intermediate → marts) that bring software engineering principles to data transformation. The medallion architecture provides an additional organizational pattern for data lakehouses.

---

*Based on Chapter 2 of "Analytics Engineering with SQL and dbt" by Rui Machado & Hélder Russa (O'Reilly, 2023)*
