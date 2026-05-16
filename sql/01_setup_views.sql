-- =====================================================================
-- Setup de vistas analíticas para Looker Studio
-- Ejecutar UNA VEZ después de cargar los 11 CSVs en BigQuery.
-- Reemplaza `tiendalatam-portfolio.tiendalatam` con tu propio project.dataset
-- =====================================================================

-- Vista 1: Órdenes enriquecidas (joins resueltos)
-- Es la fuente principal de los dashboards. Filtra solo órdenes válidas.
CREATE OR REPLACE VIEW `tiendalatam-portfolio.tiendalatam.v_orders_enriched` AS
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
  pos.name AS employee_position
FROM `tiendalatam-portfolio.tiendalatam.orders` o
JOIN `tiendalatam-portfolio.tiendalatam.order_statuses` os ON o.order_status_id = os.order_status_id
JOIN `tiendalatam-portfolio.tiendalatam.clients` c         ON o.client_id = c.client_id
JOIN `tiendalatam-portfolio.tiendalatam.client_types` ct   ON c.client_type_id = ct.client_type_id
JOIN `tiendalatam-portfolio.tiendalatam.countries` co      ON c.country_id = co.country_id
JOIN `tiendalatam-portfolio.tiendalatam.locations` l       ON o.location_id = l.location_id
JOIN `tiendalatam-portfolio.tiendalatam.employees` e       ON o.employee_id = e.employee_id
JOIN `tiendalatam-portfolio.tiendalatam.positions` pos     ON e.employee_position = pos.position_id;


-- Vista 2: Líneas de pedido con info de producto
CREATE OR REPLACE VIEW `tiendalatam-portfolio.tiendalatam.v_order_lines` AS
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
FROM `tiendalatam-portfolio.tiendalatam.order_details` od
JOIN `tiendalatam-portfolio.tiendalatam.products` p    ON od.product_id = p.product_id
JOIN `tiendalatam-portfolio.tiendalatam.categories` ca ON p.category_id = ca.category_id
JOIN `tiendalatam-portfolio.tiendalatam.orders` o      ON od.order_id = o.order_id;


-- Vista 3: Segmentación RFM por cliente (lista para visualizar)
CREATE OR REPLACE VIEW `tiendalatam-portfolio.tiendalatam.v_rfm_segments` AS
WITH last_date AS (
  SELECT MAX(registration_date) AS snapshot
  FROM `tiendalatam-portfolio.tiendalatam.orders`
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
  FROM `tiendalatam-portfolio.tiendalatam.clients` c
  JOIN `tiendalatam-portfolio.tiendalatam.orders` o
    ON c.client_id = o.client_id AND o.order_status_id IN (3, 4)
  JOIN `tiendalatam-portfolio.tiendalatam.client_types` ct ON c.client_type_id = ct.client_type_id
  JOIN `tiendalatam-portfolio.tiendalatam.countries` co    ON c.country_id = co.country_id
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
CREATE OR REPLACE VIEW `tiendalatam-portfolio.tiendalatam.v_cohort_retention` AS
WITH first_orders AS (
  SELECT
    client_id,
    DATE_TRUNC(MIN(registration_date), MONTH) AS cohort_month
  FROM `tiendalatam-portfolio.tiendalatam.orders`
  WHERE order_status_id IN (3, 4)
  GROUP BY client_id
),
orders_with_cohort AS (
  SELECT
    o.client_id,
    fo.cohort_month,
    DATE_DIFF(DATE_TRUNC(o.registration_date, MONTH), fo.cohort_month, MONTH) AS months_since_first
  FROM `tiendalatam-portfolio.tiendalatam.orders` o
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
CREATE OR REPLACE VIEW `tiendalatam-portfolio.tiendalatam.v_monthly_metrics` AS
WITH first_orders AS (
  SELECT client_id, MIN(registration_date) AS first_order_date
  FROM `tiendalatam-portfolio.tiendalatam.orders`
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
FROM `tiendalatam-portfolio.tiendalatam.orders` o
JOIN first_orders fo ON o.client_id = fo.client_id
WHERE o.order_status_id IN (3, 4)
GROUP BY 1
ORDER BY 1;
