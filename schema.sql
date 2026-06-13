-- ============================================================
-- XO WALL ST Client Operations Database
-- schema.sql
-- PostgreSQL 15+
-- ============================================================
-- Structure is protection. This database is the foundation
-- under the marble floor.
-- ============================================================

-- Drop tables in reverse dependency order (safe re-run)
DROP TABLE IF EXISTS insurance_applications CASCADE;
DROP TABLE IF EXISTS tasks CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS service_orders CASCADE;
DROP TABLE IF EXISTS consultations CASCADE;
DROP TABLE IF EXISTS leads CASCADE;
DROP TABLE IF EXISTS lead_sources CASCADE;
DROP TABLE IF EXISTS services CASCADE;
DROP TABLE IF EXISTS clients CASCADE;

-- ============================================================
-- ENUM TYPES
-- ============================================================

DO $$ BEGIN
    CREATE TYPE contact_method AS ENUM ('email', 'phone', 'whatsapp', 'text');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE lead_status AS ENUM ('new', 'contacted', 'qualified', 'converted', 'lost');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE consultation_status AS ENUM ('scheduled', 'completed', 'cancelled', 'no_show');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE order_status AS ENUM ('pending', 'in_progress', 'completed', 'cancelled');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE payment_status AS ENUM ('unpaid', 'partial', 'paid', 'refunded');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE task_status AS ENUM ('open', 'in_progress', 'blocked', 'complete');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE task_priority AS ENUM ('low', 'normal', 'high', 'urgent');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE insurance_app_status AS ENUM (
        'not_started', 'info_gathered', 'application_submitted',
        'underwriting', 'approved', 'declined', 'issued'
    );
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE service_category AS ENUM (
        'tax_prep', 'insurance', 'business_formation',
        'notary', 'consultation', 'financial_review'
    );
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- ============================================================
-- TABLE: lead_sources
-- ============================================================
CREATE TABLE lead_sources (
    source_id       SERIAL PRIMARY KEY,
    source_name     VARCHAR(100) NOT NULL UNIQUE,
    channel         VARCHAR(100),
    notes           TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABLE: services
-- ============================================================
CREATE TABLE services (
    service_id      SERIAL PRIMARY KEY,
    service_name    VARCHAR(150) NOT NULL UNIQUE,
    category        service_category NOT NULL,
    description     TEXT,
    base_price      NUMERIC(10, 2),
    is_active       BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABLE: clients
-- ============================================================
CREATE TABLE clients (
    client_id               SERIAL PRIMARY KEY,
    first_name              VARCHAR(100) NOT NULL,
    last_name               VARCHAR(100) NOT NULL,
    business_name           VARCHAR(200),
    email                   VARCHAR(255) UNIQUE,
    phone                   VARCHAR(20),
    state                   CHAR(2),
    preferred_contact_method contact_method DEFAULT 'email',
    is_active               BOOLEAN DEFAULT TRUE,
    notes                   TEXT,
    created_at              TIMESTAMPTZ DEFAULT NOW(),
    updated_at              TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABLE: leads
-- ============================================================
CREATE TABLE leads (
    lead_id             SERIAL PRIMARY KEY,
    first_name          VARCHAR(100) NOT NULL,
    last_name           VARCHAR(100) NOT NULL,
    business_name       VARCHAR(200),
    email               VARCHAR(255),
    phone               VARCHAR(20),
    state               CHAR(2),
    source_id           INT REFERENCES lead_sources(source_id) ON DELETE SET NULL,
    status              lead_status DEFAULT 'new',
    service_interest    VARCHAR(255),
    initial_notes       TEXT,
    converted_client_id INT REFERENCES clients(client_id) ON DELETE SET NULL,
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    updated_at          TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABLE: consultations
-- ============================================================
CREATE TABLE consultations (
    consultation_id     SERIAL PRIMARY KEY,
    client_id           INT REFERENCES clients(client_id) ON DELETE CASCADE,
    lead_id             INT REFERENCES leads(lead_id) ON DELETE SET NULL,
    scheduled_at        TIMESTAMPTZ NOT NULL,
    duration_minutes    INT DEFAULT 30,
    status              consultation_status DEFAULT 'scheduled',
    consultation_type   VARCHAR(100) DEFAULT 'discovery',
    platform            VARCHAR(100) DEFAULT 'Zoom',
    notes               TEXT,
    follow_up_needed    BOOLEAN DEFAULT FALSE,
    created_at          TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABLE: service_orders
-- ============================================================
CREATE TABLE service_orders (
    order_id        SERIAL PRIMARY KEY,
    client_id       INT NOT NULL REFERENCES clients(client_id) ON DELETE CASCADE,
    service_id      INT NOT NULL REFERENCES services(service_id) ON DELETE RESTRICT,
    status          order_status DEFAULT 'pending',
    ordered_at      TIMESTAMPTZ DEFAULT NOW(),
    completed_at    TIMESTAMPTZ,
    tax_year        INT,
    notes           TEXT
);

-- ============================================================
-- TABLE: payments
-- ============================================================
CREATE TABLE payments (
    payment_id      SERIAL PRIMARY KEY,
    order_id        INT NOT NULL REFERENCES service_orders(order_id) ON DELETE CASCADE,
    amount_due      NUMERIC(10, 2) NOT NULL,
    amount_paid     NUMERIC(10, 2) DEFAULT 0,
    payment_status  payment_status DEFAULT 'unpaid',
    payment_date    DATE,
    payment_method  VARCHAR(100),
    invoice_number  VARCHAR(50) UNIQUE,
    notes           TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABLE: tasks
-- ============================================================
CREATE TABLE tasks (
    task_id         SERIAL PRIMARY KEY,
    client_id       INT REFERENCES clients(client_id) ON DELETE CASCADE,
    order_id        INT REFERENCES service_orders(order_id) ON DELETE SET NULL,
    task_title      VARCHAR(255) NOT NULL,
    description     TEXT,
    due_date        DATE,
    task_status     task_status DEFAULT 'open',
    priority        task_priority DEFAULT 'normal',
    assigned_to     VARCHAR(100),
    completed_at    TIMESTAMPTZ,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABLE: insurance_applications
-- ============================================================
CREATE TABLE insurance_applications (
    app_id              SERIAL PRIMARY KEY,
    client_id           INT NOT NULL REFERENCES clients(client_id) ON DELETE CASCADE,
    order_id            INT REFERENCES service_orders(order_id) ON DELETE SET NULL,
    carrier_name        VARCHAR(150),
    policy_type         VARCHAR(100),
    coverage_amount     NUMERIC(12, 2),
    premium_estimate    NUMERIC(10, 2),
    application_status  insurance_app_status DEFAULT 'not_started',
    submitted_at        DATE,
    decision_at         DATE,
    policy_number       VARCHAR(100),
    notes               TEXT,
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    updated_at          TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- INDEXES — for performance on common queries
-- ============================================================
CREATE INDEX idx_clients_email       ON clients(email);
CREATE INDEX idx_clients_state       ON clients(state);
CREATE INDEX idx_leads_status        ON leads(status);
CREATE INDEX idx_leads_source        ON leads(source_id);
CREATE INDEX idx_leads_converted     ON leads(converted_client_id);
CREATE INDEX idx_orders_client       ON service_orders(client_id);
CREATE INDEX idx_orders_status       ON service_orders(status);
CREATE INDEX idx_payments_status     ON payments(payment_status);
CREATE INDEX idx_tasks_client        ON tasks(client_id);
CREATE INDEX idx_tasks_status        ON tasks(task_status);
CREATE INDEX idx_tasks_due_date      ON tasks(due_date);
CREATE INDEX idx_consultations_client ON consultations(client_id);
CREATE INDEX idx_insurance_client    ON insurance_applications(client_id);
CREATE INDEX idx_insurance_status    ON insurance_applications(application_status);

-- ============================================================
-- VIEW: client_pipeline_summary
-- A snapshot of every client's open activity across
-- orders, payments, tasks, and consultations.
-- ============================================================
CREATE OR REPLACE VIEW client_pipeline_summary AS
SELECT
    c.client_id,
    c.first_name || ' ' || c.last_name        AS client_name,
    c.business_name,
    c.state,
    COUNT(DISTINCT so.order_id)               AS total_orders,
    COUNT(DISTINCT CASE WHEN so.status = 'in_progress'
                   THEN so.order_id END)      AS active_orders,
    COALESCE(SUM(p.amount_due), 0)            AS total_invoiced,
    COALESCE(SUM(p.amount_paid), 0)           AS total_collected,
    COALESCE(SUM(p.amount_due - p.amount_paid), 0) AS outstanding_balance,
    COUNT(DISTINCT CASE WHEN t.task_status IN ('open','in_progress')
                   THEN t.task_id END)        AS open_tasks,
    COUNT(DISTINCT CASE WHEN con.status = 'scheduled'
                   THEN con.consultation_id END) AS upcoming_consultations
FROM clients c
LEFT JOIN service_orders so  ON c.client_id = so.client_id
LEFT JOIN payments p         ON so.order_id = p.order_id
LEFT JOIN tasks t            ON c.client_id = t.client_id
LEFT JOIN consultations con  ON c.client_id = con.client_id
GROUP BY c.client_id, c.first_name, c.last_name, c.business_name, c.state
ORDER BY outstanding_balance DESC;

-- ============================================================
-- VIEW: lead_source_performance
-- Which channels are producing the most converted clients.
-- ============================================================
CREATE OR REPLACE VIEW lead_source_performance AS
SELECT
    ls.source_name,
    ls.channel,
    COUNT(l.lead_id)                                    AS total_leads,
    COUNT(l.converted_client_id)                        AS converted_clients,
    ROUND(
        100.0 * COUNT(l.converted_client_id)
        / NULLIF(COUNT(l.lead_id), 0), 1
    )                                                   AS conversion_rate_pct
FROM lead_sources ls
LEFT JOIN leads l ON ls.source_id = l.source_id
GROUP BY ls.source_id, ls.source_name, ls.channel
ORDER BY converted_clients DESC;

-- ============================================================
-- VIEW: monthly_revenue_report
-- Paid revenue grouped by month.
-- ============================================================
CREATE OR REPLACE VIEW monthly_revenue_report AS
SELECT
    DATE_TRUNC('month', p.payment_date)::DATE   AS month,
    COUNT(DISTINCT p.payment_id)                AS invoices_paid,
    SUM(p.amount_paid)                          AS total_revenue
FROM payments p
WHERE p.payment_status = 'paid'
GROUP BY DATE_TRUNC('month', p.payment_date)
ORDER BY month DESC;
