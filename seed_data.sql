-- ============================================================
-- XO WALL ST Client Operations Database
-- seed_data.sql
-- ============================================================
-- Realistic sample data reflecting the XO WALL ST client
-- profile: women founders, professionals, and entrepreneurs
-- in Florida, Georgia, and the Treasure Coast.
-- ============================================================

-- ============================================================
-- LEAD SOURCES
-- ============================================================
INSERT INTO lead_sources (source_name, channel, notes) VALUES
('LinkedIn Organic',         'Social Media',   'Profile views and inbound DMs from LinkedIn content'),
('Soft Power Brief',         'Newsletter',     'Quiet Power Brief subscribers who convert to inquiries'),
('Instagram',                'Social Media',   'Editorial content referrals'),
('Referral — Existing Client','Referral',      'Word of mouth from satisfied clients'),
('Referral — Professional',  'Referral',       'Attorney, CPA, or advisor referrals'),
('$33 Three-Question Offer',  'Direct Offer',  'Entry-level consultation that converts to full service'),
('Google Search',            'Organic Search', 'Treasure Coast / South Florida local search'),
('Community Event',          'In-Person',      'Networking events, workshops, pop-ups');

-- ============================================================
-- SERVICES
-- ============================================================
INSERT INTO services (service_name, category, description, base_price) VALUES
('Virtual Tax Preparation — Individual',
 'tax_prep',
 'Full virtual tax prep for individual filers, W2 and/or self-employed income.',
 350.00),

('Virtual Tax Preparation — Business',
 'tax_prep',
 'Business entity tax preparation: S-Corp, LLC, sole proprietor.',
 550.00),

('Insurance Review — No Call',
 'insurance',
 'Asynchronous insurance review. Client submits current coverage; XO WALL ST returns a written analysis with recommendations.',
 97.00),

('Life Insurance Application',
 'insurance',
 'Full-service life insurance application support, carrier selection, and policy placement.',
 0.00),  -- commission-based, no direct fee

('Business Formation — LLC',
 'business_formation',
 'Florida or Georgia LLC formation, operating agreement, EIN registration.',
 299.00),

('Business Formation — S-Corp Election',
 'business_formation',
 'S-Corporation election filing (IRS Form 2553) with advisory on timing and eligibility.',
 199.00),

('Virtual Notary',
 'notary',
 'Remote online notarization via Florida-compliant platform.',
 35.00),

('$33 Three-Question Offer',
 'consultation',
 'Three written business, tax, or financial questions answered in depth. Entry-level offer.',
 33.00),

('Founder Financial Review',
 'financial_review',
 'Comprehensive review of business structure, insurance gaps, tax exposure, and operational systems for founders.',
 497.00);

-- ============================================================
-- CLIENTS
-- ============================================================
INSERT INTO clients
(first_name, last_name, business_name, email, phone, state, preferred_contact_method, notes)
VALUES
('Ava',      'Brooks',    'Brooks Beauty Studio',          'ava.brooks@example.com',      '4045550188', 'GA', 'email',
 'Esthetician, solo operator. Interested in LLC formation and tax prep.'),

('Naomi',    'Carter',    'Carter Consulting Co.',         'naomi.carter@example.com',    '7865550144', 'FL', 'whatsapp',
 'Management consultant transitioning out of corporate. Needs S-Corp election and insurance review.'),

('Simone',   'Reed',      NULL,                            'simone.reed@example.com',     '6785550199', 'GA', 'phone',
 'W2 professional, freelance income on the side. First-time client, came through $33 offer.'),

('Jordan',   'Mitchell',  'Mitch & Co. Creative',         'jordan.m@example.com',        '7725550210', 'FL', 'email',
 'Brand designer, Treasure Coast. Established LLC but needs tax catch-up and life insurance.'),

('Camille',  'Thomas',    'Thomas Wellness Group',         'camille.t@example.com',       '9545550177', 'FL', 'email',
 'Health coach pivoting to group practice model. Needs full founder review.'),

('Renee',    'Washington','Washington Law Support',        'renee.w@example.com',         '4045550301', 'GA', 'text',
 'Paralegal running independent legal support practice. Wants virtual notary and LLC.'),

('Alexis',   'Pham',      'AP Media Group',                'alexis.pham@example.com',     '3055550422', 'FL', 'whatsapp',
 'Digital media founder. Growing team. Needs business tax prep and liability review.'),

('Dana',     'Okafor',    NULL,                            'dana.okafor@example.com',     '7725550555', 'FL', 'email',
 'Corporate marketing director. Exploring exit to consulting. No business entity yet.');

-- ============================================================
-- LEADS (not yet converted to full clients)
-- ============================================================
INSERT INTO leads
(first_name, last_name, business_name, email, phone, state, source_id, status, service_interest, initial_notes)
VALUES
('Tiffany',  'Evans',  'Evans Events Co.',    'tiffany.e@example.com', '4045550900', 'GA',
 (SELECT source_id FROM lead_sources WHERE source_name = 'LinkedIn Organic'),
 'qualified',
 'LLC formation, tax prep',
 'Event planner. Has been operating as sole prop for 3 years. Ready to formalize.'),

('Maya',     'Johnson', NULL,                 'maya.j@example.com',    '7725550811', 'FL',
 (SELECT source_id FROM lead_sources WHERE source_name = '$33 Three-Question Offer'),
 'contacted',
 'Insurance review',
 'Purchased $33 offer. Questions focused on life insurance for business owner.'),

('Priya',    'Nair',   'Nair Skin Studio',    'priya.n@example.com',   '9545550732', 'FL',
 (SELECT source_id FROM lead_sources WHERE source_name = 'Referral — Existing Client'),
 'new',
 'Founder financial review',
 'Referred by Camille Thomas. Esthetician, expanding to second location.'),

('Serena',   'Banks',  'Banks Media',         'serena.b@example.com',  '4045550620', 'GA',
 (SELECT source_id FROM lead_sources WHERE source_name = 'Soft Power Brief'),
 'new',
 'S-Corp election',
 'Newsletter subscriber for 4 months. Replied to last issue asking about S-Corp timing.');

-- ============================================================
-- CONSULTATIONS
-- ============================================================
INSERT INTO consultations
(client_id, scheduled_at, duration_minutes, status, consultation_type, platform, notes, follow_up_needed)
VALUES
((SELECT client_id FROM clients WHERE email = 'naomi.carter@example.com'),
 NOW() - INTERVAL '10 days', 30, 'completed', 'discovery', 'Zoom',
 'Discussed S-Corp election timeline and insurance gaps. Client ready to move forward.', TRUE),

((SELECT client_id FROM clients WHERE email = 'camille.t@example.com'),
 NOW() - INTERVAL '3 days', 45, 'completed', 'founder_review', 'Zoom',
 'Full founder review session. Identified three uninsured risks and outdated LLC operating agreement.', TRUE),

((SELECT client_id FROM clients WHERE email = 'jordan.m@example.com'),
 NOW() + INTERVAL '4 days', 30, 'scheduled', 'discovery', 'Zoom',
 'First call. Agenda: current tax situation and life insurance conversation.', FALSE),

((SELECT client_id FROM clients WHERE email = 'dana.okafor@example.com'),
 NOW() + INTERVAL '8 days', 30, 'scheduled', 'discovery', 'Zoom',
 'Corporate-to-consulting transition. No entity yet. Needs structure before leaving W2.', FALSE);

-- ============================================================
-- SERVICE ORDERS
-- ============================================================
INSERT INTO service_orders (client_id, service_id, status, tax_year, notes) VALUES
-- Ava Brooks: LLC + Individual Tax Prep
((SELECT client_id FROM clients WHERE email = 'ava.brooks@example.com'),
 (SELECT service_id FROM services WHERE service_name = 'Business Formation — LLC'),
 'completed', NULL,
 'Georgia LLC. Articles filed. EIN obtained.'),

((SELECT client_id FROM clients WHERE email = 'ava.brooks@example.com'),
 (SELECT service_id FROM services WHERE service_name = 'Virtual Tax Preparation — Individual'),
 'completed', 2024,
 'Filed with self-employment income from studio.'),

-- Naomi Carter: S-Corp Election + Insurance Review
((SELECT client_id FROM clients WHERE email = 'naomi.carter@example.com'),
 (SELECT service_id FROM services WHERE service_name = 'Business Formation — S-Corp Election'),
 'in_progress', NULL,
 '2553 filing in process. Eligibility confirmed.'),

((SELECT client_id FROM clients WHERE email = 'naomi.carter@example.com'),
 (SELECT service_id FROM services WHERE service_name = 'Insurance Review — No Call'),
 'completed', NULL,
 'Review delivered. Identified term life gap and no disability coverage.'),

-- Simone Reed: Three-Question Offer
((SELECT client_id FROM clients WHERE email = 'simone.reed@example.com'),
 (SELECT service_id FROM services WHERE service_name = '$33 Three-Question Offer'),
 'completed', NULL,
 'Questions: quarterly estimated taxes, deductions for home office, retirement accounts for self-employed.'),

-- Jordan Mitchell: Tax Prep + Life Insurance
((SELECT client_id FROM clients WHERE email = 'jordan.m@example.com'),
 (SELECT service_id FROM services WHERE service_name = 'Virtual Tax Preparation — Business'),
 'in_progress', 2024,
 'Gathering documents. First-time business return.'),

((SELECT client_id FROM clients WHERE email = 'jordan.m@example.com'),
 (SELECT service_id FROM services WHERE service_name = 'Life Insurance Application'),
 'pending', NULL,
 'Consultation scheduled. Carrier selection TBD.'),

-- Camille Thomas: Founder Financial Review
((SELECT client_id FROM clients WHERE email = 'camille.t@example.com'),
 (SELECT service_id FROM services WHERE service_name = 'Founder Financial Review'),
 'completed', NULL,
 'Full review delivered. Three action items identified: liability insurance, updated OA, business tax prep.'),

-- Renee Washington: Notary + LLC
((SELECT client_id FROM clients WHERE email = 'renee.w@example.com'),
 (SELECT service_id FROM services WHERE service_name = 'Virtual Notary'),
 'completed', NULL,
 'Notarized independent contractor agreement.'),

((SELECT client_id FROM clients WHERE email = 'renee.w@example.com'),
 (SELECT service_id FROM services WHERE service_name = 'Business Formation — LLC'),
 'in_progress', NULL,
 'Georgia LLC formation started. Waiting on client to confirm registered agent preference.'),

-- Alexis Pham: Business Tax Prep
((SELECT client_id FROM clients WHERE email = 'alexis.pham@example.com'),
 (SELECT service_id FROM services WHERE service_name = 'Virtual Tax Preparation — Business'),
 'in_progress', 2024,
 'Multi-member LLC. Gathering K-1 documentation.');

-- ============================================================
-- PAYMENTS
-- ============================================================
INSERT INTO payments
(order_id, amount_due, amount_paid, payment_status, payment_date, payment_method, invoice_number)
VALUES
-- Ava Brooks — LLC (paid)
(1, 299.00, 299.00, 'paid', CURRENT_DATE - 45, 'Stripe', 'XO-2025-001'),
-- Ava Brooks — Tax Prep (paid)
(2, 350.00, 350.00, 'paid', CURRENT_DATE - 30, 'Stripe', 'XO-2025-002'),
-- Naomi Carter — S-Corp Election (partial)
(3, 199.00, 100.00, 'partial', CURRENT_DATE - 5, 'Zelle', 'XO-2025-003'),
-- Naomi Carter — Insurance Review (paid)
(4, 97.00, 97.00, 'paid', CURRENT_DATE - 12, 'Stripe', 'XO-2025-004'),
-- Simone Reed — $33 Offer (paid)
(5, 33.00, 33.00, 'paid', CURRENT_DATE - 20, 'Stripe', 'XO-2025-005'),
-- Jordan Mitchell — Business Tax (unpaid)
(6, 550.00, 0.00, 'unpaid', NULL, NULL, 'XO-2025-006'),
-- Jordan Mitchell — Life Insurance (commission, no invoice)
(7, 0.00, 0.00, 'paid', NULL, NULL, 'XO-2025-007'),
-- Camille Thomas — Founder Review (paid)
(8, 497.00, 497.00, 'paid', CURRENT_DATE - 7, 'Stripe', 'XO-2025-008'),
-- Renee Washington — Notary (paid)
(9, 35.00, 35.00, 'paid', CURRENT_DATE - 14, 'CashApp', 'XO-2025-009'),
-- Renee Washington — LLC (partial)
(10, 299.00, 150.00, 'partial', CURRENT_DATE - 3, 'Zelle', 'XO-2025-010'),
-- Alexis Pham — Business Tax (unpaid)
(11, 550.00, 0.00, 'unpaid', NULL, NULL, 'XO-2025-011');

-- ============================================================
-- TASKS
-- ============================================================
INSERT INTO tasks
(client_id, order_id, task_title, description, due_date, task_status, priority, assigned_to)
VALUES
-- Naomi Carter S-Corp Election
((SELECT client_id FROM clients WHERE email = 'naomi.carter@example.com'), 3,
 'Complete IRS Form 2553',
 'Finalize S-Corp election form. Confirm tax year and shareholder signatures.',
 CURRENT_DATE + 5, 'in_progress', 'high', 'M. West'),

((SELECT client_id FROM clients WHERE email = 'naomi.carter@example.com'), 3,
 'Collect outstanding balance — Naomi Carter',
 'Follow up on remaining $99 balance for S-Corp election service.',
 CURRENT_DATE + 7, 'open', 'normal', 'M. West'),

-- Jordan Mitchell Tax Prep
((SELECT client_id FROM clients WHERE email = 'jordan.m@example.com'), 6,
 'Request 2024 business documents from Jordan',
 'Need: bank statements, revenue summary, any 1099s received, home office details.',
 CURRENT_DATE + 3, 'open', 'high', 'M. West'),

-- Renee Washington LLC
((SELECT client_id FROM clients WHERE email = 'renee.w@example.com'), 10,
 'Confirm registered agent preference — Renee',
 'Client needs to select: self as agent, or third-party service.',
 CURRENT_DATE + 2, 'open', 'normal', 'M. West'),

((SELECT client_id FROM clients WHERE email = 'renee.w@example.com'), 10,
 'File Georgia Articles of Organization',
 'File LLC formation with Georgia SOS once RA confirmed and balance received.',
 CURRENT_DATE + 10, 'blocked', 'high', 'M. West'),

-- Alexis Pham Tax
((SELECT client_id FROM clients WHERE email = 'alexis.pham@example.com'), 11,
 'Collect K-1 docs from Alexis Pham',
 'Multi-member LLC — need K-1 statements from all members for 2024 return.',
 CURRENT_DATE + 4, 'open', 'high', 'M. West'),

-- Camille Thomas — post-review follow-up
((SELECT client_id FROM clients WHERE email = 'camille.t@example.com'), 8,
 'Send Camille post-review action summary',
 'Email recap of three priority items from founder review: liability insurance, OA update, business tax prep.',
 CURRENT_DATE + 1, 'open', 'urgent', 'M. West'),

-- Dana Okafor — pre-consultation prep
((SELECT client_id FROM clients WHERE email = 'dana.okafor@example.com'), NULL,
 'Prep Dana Okafor intake notes',
 'Review her background. Prepare structure conversation: LLC vs. sole prop, timeline, consulting rate strategy.',
 CURRENT_DATE + 7, 'open', 'normal', 'M. West');

-- ============================================================
-- INSURANCE APPLICATIONS
-- ============================================================
INSERT INTO insurance_applications
(client_id, order_id, carrier_name, policy_type, coverage_amount,
 premium_estimate, application_status, submitted_at, notes)
VALUES
-- Naomi Carter (identified in insurance review — now moving to application)
((SELECT client_id FROM clients WHERE email = 'naomi.carter@example.com'),
 4,
 'Protective Life', 'Term Life — 20 Year', 500000.00, 42.00,
 'info_gathered', NULL,
 'Non-smoker, healthy profile. Competitive quote received. Client reviewing.'),

-- Jordan Mitchell (pending consultation)
((SELECT client_id FROM clients WHERE email = 'jordan.m@example.com'),
 7,
 NULL, 'Term Life', 250000.00, NULL,
 'not_started', NULL,
 'Carrier not yet selected. Consultation scheduled to gather health info and coverage goals.');
