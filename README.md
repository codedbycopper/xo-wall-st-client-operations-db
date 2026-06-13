
## Project Overview

A PostgreSQL relational database prototype designed to manage client leads, consultations, service orders, payments, tasks, and insurance application tracking for a service-based consulting business.

The project translates a Notion-based operating workflow into a structured relational backend — the foundation for scaling a virtual financial services practice with clarity, structure, and operational calm.

---

## Business Problem

A growing consulting practice outgrows flexible tools quickly. This database models the backend infrastructure needed to move from a Notion-based workflow into a formal, scalable client management system — one that supports reporting, financial tracking, pipeline visibility, and operational accountability.

The business offers:
- Virtual tax preparation (individual and business)
- Insurance review and application support
- Business formation (LLC, S-Corp election)
- Virtual notary services
- Financial strategy consulting

The database reflects those services without simplifying the complexity underneath them.

---

## Tools Used

| Tool | Purpose |
|------|---------|
| PostgreSQL 15+ | Core database engine |
| pgAdmin or DBeaver | Local development and query execution |
| dbdiagram.io / drawSQL | ERD design |
| GitHub | Version control and portfolio hosting |

---

## Database Architecture

### Tables

| Table | Description |
|-------|-------------|
| `clients` | Primary client records with contact preferences and state |
| `leads` | Prospective clients not yet converted, with source tracking |
| `lead_sources` | Channel reference table: LinkedIn, referral, newsletter, etc. |
| `services` | Service catalog with categories and base pricing |
| `consultations` | Scheduled and completed calls, linked to clients or leads |
| `service_orders` | Active and completed service engagements per client |
| `payments` | Invoice tracking: amount due, amount paid, payment status |
| `tasks` | Operational task management with priority and status flags |
| `insurance_applications` | Full application lifecycle tracking: carrier, policy type, status |

### Views

| View | Description |
|------|-------------|
| `client_pipeline_summary` | Snapshot of every client: orders, revenue, open tasks, consultations |
| `lead_source_performance` | Conversion rate by channel — which sources are producing paying clients |
| `monthly_revenue_report` | Paid revenue grouped by month |

---

## Schema Design Decisions

**ENUM types** are used throughout (lead status, payment status, task priority, insurance application status) to enforce consistency at the database level — not just at the application layer.

**Foreign keys with deliberate cascade rules:**
- Deleting a client cascades to their orders, tasks, and consultations
- Deleting a lead source sets the reference to NULL on leads, preserving lead history
- Services cannot be deleted if orders reference them (RESTRICT), protecting financial records

**Indexes** are placed on every field used in common business queries: `email`, `state`, `status` fields across leads, orders, payments, tasks, and insurance applications — reflecting real operational usage patterns, not theoretical ones.

---

## Sample Queries

The `queries.sql` file contains twelve production-ready business queries:

1. Open Tasks Priority Dashboard
2. Unpaid & Partial Invoice Collections View
3. Monthly Revenue Report (via view)
4. Revenue by Service Category
5. Full Client Pipeline Summary (via view)
6. Lead Source Conversion Performance (via view)
7. Active Leads Needing Follow-Up
8. Upcoming Consultations (next 14 days)
9. Insurance Application Pipeline Tracker
10. Full Client Profile Detail
11. Founders Without Protection Coverage
12. Blocked Tasks — What's Stalled

---

## How to Run This Project

```sql
-- Step 1: Create the database
CREATE DATABASE xo_wall_st_client_db;

-- Step 2: Connect and run schema
\c xo_wall_st_client_db
\i schema.sql

-- Step 3: Load sample data
\i seed_data.sql

-- Step 4: Run queries
\i queries.sql
```

Or execute each file directly in pgAdmin's Query Tool.

---

## Project Files

```
xo-wall-st-client-db/
│
├── README.md           — This file
├── schema.sql          — All tables, ENUMs, indexes, and views
├── seed_data.sql       — Realistic sample data (8 clients, 4 leads, 11 orders)
├── queries.sql         — 12 business reporting and operational queries
└── erd.png             — Entity Relationship Diagram (generate from dbdiagram.io)
```

---

## ERD Generation

To generate the ERD:

1. Go to [dbdiagram.io](https://dbdiagram.io)
2. Import or manually enter the table names and relationships from `schema.sql`
3. Export as `erd.png`
4. Add to the repository root

Key relationships to diagram:
- `clients` → `service_orders` → `payments`
- `clients` → `tasks`
- `clients` → `consultations`
- `clients` → `insurance_applications`
- `leads` → `lead_sources`
- `leads` → `clients` (converted_client_id)
- `service_orders` → `services`

---

## What This Project Demonstrates

- Relational database design with normalized schema
- Primary keys, foreign keys, and referential integrity
- ENUM types for constrained categorical data
- Index strategy based on real query patterns
- Cascading rules designed around data retention requirements
- Reporting views that support executive-level visibility
- SQL queries spanning JOIN, CASE, COALESCE, DATE functions, aggregations, and subqueries
- Translation of a business workflow into structured backend logic

---

## Resume Description

**PostgreSQL Client Operations Database**
Designed and built a relational PostgreSQL database prototype for a virtual consulting business, including normalized tables for client records, lead tracking, service orders, payments, task management, and insurance application pipeline monitoring. Implemented ENUM types, primary and foreign keys, cascade rules, indexes, and three reporting views. Wrote twelve production-ready SQL queries for daily operations and financial reporting.

---
