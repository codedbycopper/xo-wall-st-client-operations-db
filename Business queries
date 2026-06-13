-- ============================================================
-- XO WALL ST Client Operations Database
-- queries.sql
-- ============================================================
-- Business intelligence queries for daily operations,
-- financial reporting, and client pipeline management.
-- ============================================================


-- ============================================================
-- 1. OPEN TASKS — Priority Dashboard
--    What needs attention today?
-- ============================================================
SELECT
    c.first_name || ' ' || c.last_name   AS client_name,
    c.business_name,
    t.task_title,
    t.priority,
    t.task_status,
    t.due_date,
    CASE
        WHEN t.due_date < CURRENT_DATE THEN 'OVERDUE'
        WHEN t.due_date = CURRENT_DATE THEN 'Due Today'
        ELSE 'Upcoming'
    END                                  AS urgency_flag
FROM tasks t
JOIN clients c ON t.client_id = c.client_id
WHERE t.task_status IN ('open', 'in_progress', 'blocked')
ORDER BY
    CASE t.priority
        WHEN 'urgent' THEN 1
        WHEN 'high'   THEN 2
        WHEN 'normal' THEN 3
        WHEN 'low'    THEN 4
    END,
    t.due_date;


-- ============================================================
-- 2. UNPAID & PARTIAL INVOICES — Collections View
--    Who owes money and how much?
-- ============================================================
SELECT
    c.first_name || ' ' || c.last_name   AS client_name,
    c.email,
    c.preferred_contact_method,
    s.service_name,
    p.invoice_number,
    p.amount_due,
    p.amount_paid,
    (p.amount_due - p.amount_paid)       AS balance_remaining,
    p.payment_status,
    p.created_at::DATE                   AS invoice_date
FROM payments p
JOIN service_orders so  ON p.order_id = so.order_id
JOIN clients c          ON so.client_id = c.client_id
JOIN services s         ON so.service_id = s.service_id
WHERE p.payment_status IN ('unpaid', 'partial')
  AND p.amount_due > 0
ORDER BY balance_remaining DESC;


-- ============================================================
-- 3. MONTHLY REVENUE — Using the reporting view
-- ============================================================
SELECT * FROM monthly_revenue_report;


-- ============================================================
-- 4. REVENUE BY SERVICE CATEGORY
--    Which service lines are generating the most income?
-- ============================================================
SELECT
    s.category,
    s.service_name,
    COUNT(so.order_id)                   AS orders_completed,
    SUM(p.amount_paid)                   AS revenue_collected
FROM service_orders so
JOIN services s    ON so.service_id = s.service_id
JOIN payments p    ON so.order_id = p.order_id
WHERE so.status = 'completed'
  AND p.payment_status = 'paid'
GROUP BY s.category, s.service_name
ORDER BY revenue_collected DESC;


-- ============================================================
-- 5. CLIENT PIPELINE SUMMARY — Using the reporting view
--    Full business snapshot per client.
-- ============================================================
SELECT * FROM client_pipeline_summary;


-- ============================================================
-- 6. LEAD CONVERSION — Source Performance
--    Which channels are producing paying clients?
-- ============================================================
SELECT * FROM lead_source_performance;


-- ============================================================
-- 7. ACTIVE LEADS — Needs Follow-Up
--    Leads not yet converted, sorted by status.
-- ============================================================
SELECT
    l.first_name || ' ' || l.last_name   AS lead_name,
    l.business_name,
    l.state,
    ls.source_name,
    l.status,
    l.service_interest,
    l.initial_notes,
    l.created_at::DATE                   AS lead_date,
    (CURRENT_DATE - l.created_at::DATE)  AS days_in_pipeline
FROM leads l
LEFT JOIN lead_sources ls ON l.source_id = ls.source_id
WHERE l.status NOT IN ('converted', 'lost')
ORDER BY
    CASE l.status
        WHEN 'qualified'  THEN 1
        WHEN 'contacted'  THEN 2
        WHEN 'new'        THEN 3
    END,
    l.created_at;


-- ============================================================
-- 8. UPCOMING CONSULTATIONS
--    Next 14 days of scheduled calls.
-- ============================================================
SELECT
    c.first_name || ' ' || c.last_name   AS client_name,
    c.email,
    c.preferred_contact_method,
    con.scheduled_at,
    con.duration_minutes,
    con.consultation_type,
    con.platform,
    con.notes
FROM consultations con
JOIN clients c ON con.client_id = c.client_id
WHERE con.status = 'scheduled'
  AND con.scheduled_at BETWEEN NOW() AND NOW() + INTERVAL '14 days'
ORDER BY con.scheduled_at;


-- ============================================================
-- 9. INSURANCE APPLICATION TRACKER
--    Where is every application in the pipeline?
-- ============================================================
SELECT
    c.first_name || ' ' || c.last_name   AS client_name,
    ia.carrier_name,
    ia.policy_type,
    TO_CHAR(ia.coverage_amount, 'FM$999,999,999') AS coverage_amount,
    TO_CHAR(ia.premium_estimate,'FM$999,990.00')  AS monthly_premium,
    ia.application_status,
    ia.submitted_at,
    ia.decision_at,
    ia.policy_number,
    ia.notes
FROM insurance_applications ia
JOIN clients c ON ia.client_id = c.client_id
ORDER BY
    CASE ia.application_status
        WHEN 'underwriting'         THEN 1
        WHEN 'application_submitted'THEN 2
        WHEN 'info_gathered'        THEN 3
        WHEN 'approved'             THEN 4
        WHEN 'not_started'          THEN 5
        WHEN 'issued'               THEN 6
        WHEN 'declined'             THEN 7
    END;


-- ============================================================
-- 10. CLIENT PROFILE — Full detail for one client
--     Replace the email parameter to pull any client.
-- ============================================================
SELECT
    c.client_id,
    c.first_name || ' ' || c.last_name   AS client_name,
    c.business_name,
    c.email,
    c.phone,
    c.state,
    c.preferred_contact_method,
    c.notes                              AS client_notes,
    so.order_id,
    s.service_name,
    s.category,
    so.status                            AS order_status,
    so.tax_year,
    p.invoice_number,
    p.amount_due,
    p.amount_paid,
    p.payment_status,
    p.payment_date
FROM clients c
LEFT JOIN service_orders so ON c.client_id = so.client_id
LEFT JOIN services s        ON so.service_id = s.service_id
LEFT JOIN payments p        ON so.order_id = p.order_id
WHERE c.email = 'naomi.carter@example.com'  -- change to query any client
ORDER BY so.ordered_at DESC;


-- ============================================================
-- 11. FOUNDERS WITHOUT PROTECTION
--     Clients with active service orders but no insurance app.
--     Content inspiration: "Many founders are operating without
--     protection while publicly performing success."
-- ============================================================
SELECT
    c.first_name || ' ' || c.last_name   AS client_name,
    c.business_name,
    c.state,
    COUNT(so.order_id)                   AS total_services
FROM clients c
JOIN service_orders so ON c.client_id = so.client_id
WHERE c.client_id NOT IN (
    SELECT DISTINCT client_id FROM insurance_applications
)
GROUP BY c.client_id, c.first_name, c.last_name, c.business_name, c.state
ORDER BY total_services DESC;


-- ============================================================
-- 12. BLOCKED TASKS — What's stalled?
--     Identify anything waiting on client action.
-- ============================================================
SELECT
    c.first_name || ' ' || c.last_name   AS client_name,
    t.task_title,
    t.description,
    t.due_date,
    t.priority,
    t.created_at::DATE                   AS task_created
FROM tasks t
JOIN clients c ON t.client_id = c.client_id
WHERE t.task_status = 'blocked'
ORDER BY t.due_date;
