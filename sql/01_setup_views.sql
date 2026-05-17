-- =====================================================================
-- Setup de vistas analíticas para Looker Studio
-- =====================================================================

-- Vista 1: Órdenes enriquecidas (joins resueltos)
-- Incluye todos los estados; aplicar filtros de status en Looker Studio según el visual.
CREATE OR REPLACE VIEW `tiendalatam-casestudy.tiendalatam.v_orders_enriched` AS
SELECT
  o.order_id,
  o.client_id,
  o.location_id,
  o.employee_id,
  o.registration_date,
  o.total_amount,
  o.order_status_id,
  os.name AS order_status,
  CONCAT(c.name, ' ', c.last_name) AS client_full_name,
  ct.name AS client_type,
  co.name AS country,
  c.city,
  l.name AS store_name,
  CONCAT(e.name, ' ', e.last_name) AS employee_full_name,
  pos.name AS employee_position,
  CASE WHEN o.order_status_id = 5 THEN 1 ELSE 0 END AS is_cancelled,
  CASE WHEN o.order_status_id = 6 THEN 1 ELSE 0 END AS is_returned
FROM `tiendalatam-casestudy.tiendalatam.orders` o
JOIN `tiendalatam-casestudy.tiendalatam.order_statuses` os ON o.order_status_id = os.order_status_id
JOIN `tiendalatam-casestudy.tiendalatam.clients` c         ON o.client_id = c.client_id
JOIN `tiendalatam-casestudy.tiendalatam.client_types` ct   ON c.client_type_id = ct.client_type_id
JOIN `tiendalatam-casestudy.tiendalatam.countries` co      ON c.country_id = co.country_id
JOIN `tiendalatam-casestudy.tiendalatam.locations` l       ON o.location_id = l.location_id
JOIN `tiendalatam-casestudy.tiendalatam.employees` e       ON o.employee_id = e.employee_id
JOIN `tiendalatam-casestudy.tiendalatam.positions` pos     ON e.employee_position = pos.position_id;


-- Vista 2: Líneas de pedido con info de producto
CREATE OR REPLACE VIEW `tiendalatam-casestudy.tiendalatam.v_order_lines` AS
SELECT
  od.detail_id,
  od.order_id,
  od.product_id,
  od.quantity,
  od.unit_price,
  od.quantity * od.unit_price AS line_total,
  p.product_name,
  ca.name AS category,
  p.stock,
  o.registration_date,
  o.order_status_id,
  o.client_id
FROM `tiendalatam-casestudy.tiendalatam.order_details` od
JOIN `tiendalatam-casestudy.tiendalatam.products` p    ON od.product_id = p.product_id
JOIN `tiendalatam-casestudy.tiendalatam.categories` ca ON p.category_id = ca.category_id
JOIN `tiendalatam-casestudy.tiendalatam.orders` o      ON od.order_id = o.order_id;


-- Vista 3: Segmentación RFM por cliente (lista para visualizar)
CREATE OR REPLACE VIEW `tiendalatam-casestudy.tiendalatam.v_rfm_segments` AS
WITH last_date AS (
  SELECT MAX(registration_date) AS snapshot
  FROM `tiendalatam-casestudy.tiendalatam.orders`
),
client_rfm AS (
  SELECT
    c.client_id,
    CONCAT(c.name, ' ', c.last_name) AS client_name,
    ct.name AS client_type,
    co.name AS country,
    DATE_DIFF(ld.snapshot, MAX(o.registration_date), DAY) AS recency_days,
    COUNT(o.order_id) AS frequency,
    ROUND(SUM(o.total_amount), 2) AS monetary
  FROM `tiendalatam-casestudy.tiendalatam.clients` c
  JOIN `tiendalatam-casestudy.tiendalatam.orders` o
    ON c.client_id = o.client_id AND o.order_status_id IN (3, 4)
  JOIN `tiendalatam-casestudy.tiendalatam.client_types` ct ON c.client_type_id = ct.client_type_id
  JOIN `tiendalatam-casestudy.tiendalatam.countries` co    ON c.country_id = co.country_id
  CROSS JOIN last_date ld
  GROUP BY c.client_id, c.name, c.last_name, ct.name, co.name, ld.snapshot
),
scored AS (
  SELECT *,
    NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
    NTILE(4) OVER (ORDER BY frequency)         AS f_score,
    NTILE(4) OVER (ORDER BY monetary)          AS m_score
  FROM client_rfm
)
SELECT
  *,
  CASE
    WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Champions'
    WHEN r_score >= 3 AND f_score >= 2                   THEN 'Loyal'
    WHEN r_score >= 3 AND f_score = 1                    THEN 'New / Promising'
    WHEN r_score = 2  AND f_score >= 2                   THEN 'Needs Attention'
    WHEN r_score = 2  AND f_score = 1                    THEN 'About to Sleep'
    WHEN r_score = 1  AND f_score >= 3                   THEN 'At Risk'
    WHEN r_score = 1  AND f_score = 2                    THEN 'Hibernating'
    WHEN r_score = 1  AND f_score = 1                    THEN 'Lost'
    ELSE 'Others'
  END AS segment
FROM scored;


-- Vista 4: Retención por cohort mensual (matriz lista para heatmap)
CREATE OR REPLACE VIEW `tiendalatam-casestudy.tiendalatam.v_cohort_retention` AS
WITH first_orders AS (
  SELECT
    client_id,
    DATE_TRUNC(MIN(registration_date), MONTH) AS cohort_month
  FROM `tiendalatam-casestudy.tiendalatam.orders`
  WHERE order_status_id IN (3, 4)
  GROUP BY client_id
),
orders_with_cohort AS (
  SELECT
    o.client_id,
    fo.cohort_month,
    DATE_DIFF(DATE_TRUNC(o.registration_date, MONTH), fo.cohort_month, MONTH) AS months_since_first
  FROM `tiendalatam-casestudy.tiendalatam.orders` o
  JOIN first_orders fo ON o.client_id = fo.client_id
  WHERE o.order_status_id IN (3, 4)
),
cohort_size AS (
  SELECT cohort_month, COUNT(DISTINCT client_id) AS cohort_clients
  FROM first_orders
  GROUP BY cohort_month
)
SELECT
  o.cohort_month,
  cs.cohort_clients,
  o.months_since_first,
  COUNT(DISTINCT o.client_id) AS active_clients,
  ROUND(100 * COUNT(DISTINCT o.client_id) / cs.cohort_clients, 2) AS retention_pct
FROM orders_with_cohort o
JOIN cohort_size cs ON o.cohort_month = cs.cohort_month
GROUP BY o.cohort_month, cs.cohort_clients, o.months_since_first
ORDER BY o.cohort_month, o.months_since_first;


-- Vista 5: Métricas mensuales pre-agregadas (KPI cards y line charts)
CREATE OR REPLACE VIEW `tiendalatam-casestudy.tiendalatam.v_monthly_metrics` AS
WITH first_orders AS (
  SELECT client_id, MIN(registration_date) AS first_order_date
  FROM `tiendalatam-casestudy.tiendalatam.orders`
  WHERE order_status_id IN (3, 4)
  GROUP BY client_id
)
SELECT
  DATE_TRUNC(o.registration_date, MONTH) AS month,
  COUNT(*) AS orders,
  COUNT(DISTINCT o.client_id) AS active_clients,
  COUNTIF(DATE_TRUNC(o.registration_date, MONTH) = DATE_TRUNC(fo.first_order_date, MONTH)) AS new_clients_orders,
  ROUND(SUM(o.total_amount), 2) AS revenue,
  ROUND(AVG(o.total_amount), 2) AS aov
FROM `tiendalatam-casestudy.tiendalatam.orders` o
JOIN first_orders fo ON o.client_id = fo.client_id
WHERE o.order_status_id IN (3, 4)
GROUP BY 1
ORDER BY 1;


-- Vista 6: Métricas de salud ejecutiva (una sola fila para scorecards)
CREATE OR REPLACE VIEW `tiendalatam-casestudy.tiendalatam.v_executive_health` AS
WITH
last_date AS (
  SELECT MAX(registration_date) AS snapshot
  FROM `tiendalatam-casestudy.tiendalatam.orders`
),
totals AS (
  SELECT
    COUNT(*)                                                                    AS total_orders_all,
    COUNTIF(order_status_id IN (3, 4))                                         AS total_orders,
    SUM(CASE WHEN order_status_id IN (3, 4) THEN total_amount END)             AS total_revenue,
    AVG(CASE WHEN order_status_id IN (3, 4) THEN total_amount END)             AS global_aov,
    COUNT(DISTINCT CASE WHEN order_status_id IN (3, 4) THEN client_id END)     AS active_clients,
    COUNTIF(order_status_id = 5)                                               AS cancelled_count,
    COUNTIF(order_status_id = 6)                                               AS returned_count
  FROM `tiendalatam-casestudy.tiendalatam.orders`
),
client_activity AS (
  SELECT
    c.client_id,
    MAX(o.registration_date) AS last_purchase
  FROM `tiendalatam-casestudy.tiendalatam.clients` c
  LEFT JOIN `tiendalatam-casestudy.tiendalatam.orders` o
    ON c.client_id = o.client_id AND o.order_status_id IN (3, 4)
  GROUP BY c.client_id
),
churn_calc AS (
  SELECT
    COUNT(*)                                                              AS total_clients,
    COUNTIF(DATE_DIFF(ld.snapshot, last_purchase, DAY) > 180)            AS churned_count
  FROM client_activity
  CROSS JOIN last_date ld
),
champions_calc AS (
  SELECT
    SUM(CASE WHEN segment = 'Champions' THEN monetary ELSE 0 END)  AS champ_revenue,
    SUM(monetary)                                                   AS total_rfm_revenue
  FROM `tiendalatam-casestudy.tiendalatam.v_rfm_segments`
)
SELECT
  t.total_orders,
  ROUND(t.total_revenue, 2)                                                       AS total_revenue,
  ROUND(t.global_aov, 2)                                                          AS global_aov,
  t.active_clients,
  ROUND(100 * t.cancelled_count / t.total_orders_all, 2)                          AS pct_cancelled,
  ROUND(100 * t.returned_count  / t.total_orders_all, 2)                          AS pct_returned,
  ROUND(100 * (t.cancelled_count + t.returned_count) / t.total_orders_all, 2)     AS pct_problem_orders,
  ROUND(100 * ch.churned_count  / ch.total_clients, 2)                            AS churn_rate_180d,
  ROUND(100 * cc.champ_revenue  / cc.total_rfm_revenue, 2)                        AS champions_revenue_pct
FROM totals t
CROSS JOIN churn_calc ch
CROSS JOIN champions_calc cc;


-- =====================================================================
-- QUERIES DE VALIDACIÓN (ejecutar después de CREATE OR REPLACE VIEW)
-- =====================================================================

-- V1: v_orders_enriched debe devolver 4000 filas (todos los estados)
SELECT COUNT(*) AS total_rows FROM `tiendalatam-casestudy.tiendalatam.v_orders_enriched`;
-- Esperado: 4000

-- V2: v_executive_health debe devolver 1 fila con valores de referencia
SELECT
  total_orders,
  total_revenue,
  global_aov,
  active_clients,
  pct_cancelled,
  pct_returned,
  pct_problem_orders,   -- referencia ≈ 7.7%
  churn_rate_180d,      -- referencia ≈ 25.3%
  champions_revenue_pct -- referencia ≈ 56.4%
FROM `tiendalatam-casestudy.tiendalatam.v_executive_health`;

-- V3: diagnóstico si pct_problem_orders difiere más de 2 pp
SELECT
  order_status_id,
  COUNT(*) AS orders,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM `tiendalatam-casestudy.tiendalatam.orders`
GROUP BY order_status_id
ORDER BY order_status_id;

-- V4: diagnóstico si churn_rate_180d difiere más de 2 pp
WITH last_date AS (
  SELECT MAX(registration_date) AS snapshot FROM `tiendalatam-casestudy.tiendalatam.orders`
),
client_activity AS (
  SELECT
    c.client_id,
    MAX(o.registration_date) AS last_purchase
  FROM `tiendalatam-casestudy.tiendalatam.clients` c
  LEFT JOIN `tiendalatam-casestudy.tiendalatam.orders` o
    ON c.client_id = o.client_id AND o.order_status_id IN (3, 4)
  GROUP BY c.client_id
)
SELECT
  COUNT(*)                                                             AS total_clients,
  COUNTIF(last_purchase IS NULL)                                       AS never_purchased,
  COUNTIF(DATE_DIFF(ld.snapshot, last_purchase, DAY) <= 90)           AS active_last_90d,
  COUNTIF(DATE_DIFF(ld.snapshot, last_purchase, DAY) BETWEEN 91 AND 180) AS at_risk_90_180d,
  COUNTIF(DATE_DIFF(ld.snapshot, last_purchase, DAY) > 180)           AS churned_180d_plus,
  ROUND(100 * COUNTIF(DATE_DIFF(ld.snapshot, last_purchase, DAY) > 180) / COUNT(*), 2) AS churn_rate_pct
FROM client_activity
CROSS JOIN last_date ld;

-- V5: diagnóstico si champions_revenue_pct difiere más de 2 pp
SELECT segment, COUNT(*) AS clients, ROUND(SUM(monetary), 2) AS revenue,
  ROUND(100 * SUM(monetary) / SUM(SUM(monetary)) OVER (), 2) AS pct_of_revenue
FROM `tiendalatam-casestudy.tiendalatam.v_rfm_segments`
GROUP BY segment
ORDER BY revenue DESC;
