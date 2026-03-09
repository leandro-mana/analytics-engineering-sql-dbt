# Chapter 6: Building an End-to-End Analytics Engineering Use Case

> The capstone chapter — designing and building a complete omnichannel analytics data warehouse from operational data to business insights.

## Problem Definition

**Goal:** Enhance customer experience by providing seamless, personalized interactions across multiple channels (website, mobile app, Instagram).

**Requirements:**
- Customer profiles with contact information
- Cross-channel interaction tracking
- Order details with payment and discount analysis
- Product catalog for marketing optimization

## Data Architecture

```
Raw Seeds (CSV) → dbt seed → PostgreSQL (raw schema)
                                    ↓
                              dbt staging layer
                                    ↓
                              dbt marts layer (star schema)
                                    ↓
                              Analytical queries
```

## Star Schema Design

### Dimensions

| Table | Key Columns | Description |
|-------|-------------|-------------|
| `dim_omni_channels` | `sk_channel`, `nk_channel_id`, `dsc_channel_name` | Sales channels |
| `dim_omni_customers` | `sk_customer`, `nk_customer_id`, `dsc_name`, `dsc_country` | Customer profiles |
| `dim_omni_products` | `sk_product`, `nk_product_sku`, `dsc_product_name`, `mtr_unit_price` | Product catalog |

### Fact Tables

| Table | Measures | Description |
|-------|----------|-------------|
| `fct_purchase_history` | `mtr_quantity`, `mtr_discount`, `mtr_total_amount_gross`, `mtr_total_amount_net` | Purchase transactions |
| `fct_visit_history` | `mtr_length_of_stay_minutes` | Channel visit tracking |

### Naming Conventions

| Prefix | Type | Example |
|--------|------|---------|
| `sk_` | Surrogate key | `sk_customer` |
| `nk_` | Natural key | `nk_customer_id` |
| `mtr_` | Metric (numeric) | `mtr_total_amount_net` |
| `dsc_` | Description (text) | `dsc_product_name` |
| `dt_` | Date/time | `dt_order_date` |

## Key Design Decisions

- **Surrogate keys** via `dbt_utils.generate_surrogate_key()` — deterministic hashing of natural keys
- **COALESCE(..., '-1')** — handles unmatched dimension lookups gracefully
- **Calculated metrics** in fact tables: `mtr_total_amount_gross` (qty * price) and `mtr_total_amount_net` (qty * price * (1 - discount))
- **Visit duration** calculated via timestamp difference: `EXTRACT(EPOCH FROM (bounce - visit)) / 60.0`

## Testing Strategy

**Generic tests (YAML):**
- `unique` + `not_null` on all dimension surrogate keys
- `relationships` on fact table foreign keys → dimension surrogate keys

**Singular tests (SQL):**
- `assert_gross_amount_is_positive` — no negative purchase amounts
- `assert_visit_duration_is_positive` — no negative visit durations

## Sample Analytical Queries

After building the warehouse (`make dbt-build`), run these against the marts:

**Total sales per channel:**
```sql
SELECT dc.dsc_channel_name, ROUND(SUM(fct.mtr_total_amount_net), 2) AS total_net
FROM public_marts.fct_purchase_history fct
LEFT JOIN public_marts.dim_omni_channels dc ON fct.sk_channel = dc.sk_channel
GROUP BY dc.dsc_channel_name ORDER BY total_net DESC;
```

**Average visit duration per channel:**
```sql
SELECT dc.dsc_channel_name, ROUND(AVG(mtr_length_of_stay_minutes), 2) AS avg_minutes
FROM public_marts.fct_visit_history fct
LEFT JOIN public_marts.dim_omni_channels dc ON fct.sk_channel = dc.sk_channel
GROUP BY dc.dsc_channel_name;
```

---

*Based on Chapter 6 of "Analytics Engineering with SQL and dbt" by Rui Machado & Hélder Russa (O'Reilly, 2023)*
