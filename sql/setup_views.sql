-- =====================================================================
-- Setup de vistas analíticas para Looker Studio
-- Ejecutar en BigQuery antes de conectar Looker Studio.
-- Las vistas son las únicas fuentes que conecta el dashboard —
-- nunca conectar tablas crudas directamente.
-- =====================================================================


-- Vista 1: Órdenes enriquecidas (joins resueltos)
-- Fuente principal del dashboard. Incluye todos los estados.
-- Aplicar filtro order_status_id IN (3, 4) en Looker Studio para revenue;
-- sin filtro para métricas operativas (% cancelación, % pendiente, etc.)
CREATE OR REPLACE VIEW `tiendalatam-casestudy.tiendalatam.v_orders_enriched` AS
SELECT
  o.order_id,
  o.client_id,
  o.location_id,
  o.employee_id,
  o.registration_date,
  o.total_amount,
  o.order_status_id,
  os.name                                   AS order_status,
  CONCAT(c.name, ' ', c.last_name)          AS client_full_name,
  ct.name                                   AS client_type,
  co.name                                   AS country,
  c.city,
  l.name                                    AS store_name,
  CONCAT(e.name, ' ', e.last_name)          AS employee_full_name,
  pos.name                                  AS employee_position,
  CASE WHEN o.order_status_id IN (3, 4) THEN 1 ELSE 0 END AS is_valid_revenue,
  CASE WHEN o.order_status_id = 4        THEN 1 ELSE 0 END AS is_delivered,
  CASE WHEN o.order_status_id = 5        THEN 1 ELSE 0 END AS is_cancelled,
  CASE WHEN o.order_status_id = 6        THEN 1 ELSE 0 END AS is_returned,
  CASE WHEN o.order_status_id IN (1, 2)  THEN 1 ELSE 0 END AS is_in_progress
FROM `tiendalatam-casestudy.tiendalatam.orders` o
JOIN `tiendalatam-casestudy.tiendalatam.order_statuses` os ON o.order_status_id = os.order_status_id
JOIN `tiendalatam-casestudy.tiendalatam.clients` c         ON o.client_id = c.client_id
JOIN `tiendalatam-casestudy.tiendalatam.client_types` ct   ON c.client_type_id = ct.client_type_id
JOIN `tiendalatam-casestudy.tiendalatam.countries` co      ON c.country_id = co.country_id
JOIN `tiendalatam-casestudy.tiendalatam.locations` l       ON o.location_id = l.location_id
JOIN `tiendalatam-casestudy.tiendalatam.employees` e       ON o.employee_id = e.employee_id
JOIN `tiendalatam-casestudy.tiendalatam.positions` pos     ON e.employee_position = pos.position_id;


-- Vista 2: Líneas de pedido con info de producto, país y tipo de cliente
-- Usada en la página de Catálogo. Incluye country y client_type para
-- que los filtros globales del dashboard funcionen sobre esta fuente.
CREATE OR REPLACE VIEW `tiendalatam-casestudy.tiendalatam.v_order_lines` AS
SELECT
  od.detail_id,
  od.order_id,
  od.product_id,
  od.quantity,
  od.unit_price,
  od.quantity * od.unit_price AS line_total,
  p.product_name,
  p.price                     AS list_price,
  ca.name                     AS category,
  p.stock,
  o.registration_date,
  o.order_status_id,
  o.client_id,
  co.name                     AS country,
  ct.name                     AS client_type
FROM `tiendalatam-casestudy.tiendalatam.order_details` od
JOIN `tiendalatam-casestudy.tiendalatam.products` p        ON od.product_id = p.product_id
JOIN `tiendalatam-casestudy.tiendalatam.categories` ca     ON p.category_id = ca.category_id
JOIN `tiendalatam-casestudy.tiendalatam.orders` o          ON od.order_id = o.order_id
JOIN `tiendalatam-casestudy.tiendalatam.clients` c         ON o.client_id = c.client_id
JOIN `tiendalatam-casestudy.tiendalatam.countries` co      ON c.country_id = co.country_id
JOIN `tiendalatam-casestudy.tiendalatam.client_types` ct   ON c.client_type_id = ct.client_type_id;


-- Vista 3: Segmentación RFM por cliente
-- Usada en la página de Retención. Permite donut de segmentos,
-- barras de revenue por segmento y tabla de At Risk accionable.
CREATE OR REPLACE VIEW `tiendalatam-casestudy.tiendalatam.v_rfm_segments` AS
WITH last_date AS (
  SELECT MAX(registration_date) AS snapshot
  FROM `tiendalatam-casestudy.tiendalatam.orders`
),
client_rfm AS (
  SELECT
    c.client_id,
    CONCAT(c.name, ' ', c.last_name) AS client_name,
    ct.name                          AS client_type,
    co.name                          AS country,
    DATE_DIFF(ld.snapshot, MAX(o.registration_date), DAY) AS recency_days,
    COUNT(o.order_id)                AS frequency,
    ROUND(SUM(o.total_amount), 2)    AS monetary
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


-- Vista 4: Retención por cohorte mensual (matriz lista para heatmap)
-- Usada en la página de Retención. Formato largo compatible con
-- el heatmap de Looker Studio (cada fila = una cohorte × mes).
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
  COUNT(DISTINCT o.client_id)                                         AS active_clients,
  ROUND(100 * COUNT(DISTINCT o.client_id) / cs.cohort_clients, 2)    AS retention_pct
FROM orders_with_cohort o
JOIN cohort_size cs ON o.cohort_month = cs.cohort_month
GROUP BY o.cohort_month, cs.cohort_clients, o.months_since_first
ORDER BY o.cohort_month, o.months_since_first;


-- Vista 5: Métricas mensuales pre-agregadas
-- Usada en la página de Crecimiento para la línea de revenue,
-- barras apiladas nuevo vs recurrente y scorecards de MoM.
CREATE OR REPLACE VIEW `tiendalatam-casestudy.tiendalatam.v_monthly_metrics` AS
WITH first_orders AS (
  SELECT client_id, MIN(registration_date) AS first_order_date
  FROM `tiendalatam-casestudy.tiendalatam.orders`
  WHERE order_status_id IN (3, 4)
  GROUP BY client_id
)
SELECT
  DATE_TRUNC(o.registration_date, MONTH)                                              AS month,
  COUNT(*)                                                                             AS orders,
  COUNT(DISTINCT o.client_id)                                                          AS active_clients,
  COUNTIF(DATE_TRUNC(o.registration_date, MONTH)
          = DATE_TRUNC(fo.first_order_date, MONTH))                                   AS new_client_orders,
  COUNT(*) - COUNTIF(DATE_TRUNC(o.registration_date, MONTH)
                     = DATE_TRUNC(fo.first_order_date, MONTH))                        AS recurring_client_orders,
  ROUND(SUM(o.total_amount), 2)                                                        AS revenue,
  ROUND(SUM(CASE WHEN DATE_TRUNC(o.registration_date, MONTH)
                      = DATE_TRUNC(fo.first_order_date, MONTH)
                 THEN o.total_amount ELSE 0 END), 2)                                  AS new_client_revenue,
  ROUND(SUM(CASE WHEN DATE_TRUNC(o.registration_date, MONTH)
                     != DATE_TRUNC(fo.first_order_date, MONTH)
                 THEN o.total_amount ELSE 0 END), 2)                                  AS recurring_client_revenue,
  ROUND(AVG(o.total_amount), 2)                                                        AS aov
FROM `tiendalatam-casestudy.tiendalatam.orders` o
JOIN first_orders fo ON o.client_id = fo.client_id
WHERE o.order_status_id IN (3, 4)
GROUP BY 1
ORDER BY 1;


-- Vista 6: Métricas de salud ejecutiva (una sola fila para scorecards)
-- Usada en la página de Resumen Ejecutivo.
CREATE OR REPLACE VIEW `tiendalatam-casestudy.tiendalatam.v_executive_health` AS
WITH
last_date AS (
  SELECT MAX(registration_date) AS snapshot
  FROM `tiendalatam-casestudy.tiendalatam.orders`
),
totals AS (
  SELECT
    COUNT(*)                                                                  AS total_orders_all,
    COUNTIF(order_status_id IN (3, 4))                                       AS total_valid_orders,
    ROUND(SUM(CASE WHEN order_status_id IN (3, 4) THEN total_amount END), 2) AS total_revenue,
    ROUND(AVG(CASE WHEN order_status_id IN (3, 4) THEN total_amount END), 2) AS global_aov,
    COUNT(DISTINCT CASE WHEN order_status_id IN (3, 4) THEN client_id END)   AS active_clients,
    COUNTIF(order_status_id = 4)                                             AS delivered_count,
    COUNTIF(order_status_id = 5)                                             AS cancelled_count,
    COUNTIF(order_status_id = 6)                                             AS returned_count,
    COUNTIF(order_status_id IN (1, 2))                                       AS in_progress_count
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
    ROUND(SUM(CASE WHEN segment = 'Champions' THEN monetary ELSE 0 END), 2) AS champ_revenue,
    ROUND(SUM(monetary), 2)                                                  AS total_rfm_revenue
  FROM `tiendalatam-casestudy.tiendalatam.v_rfm_segments`
)
SELECT
  t.total_valid_orders                                                                    AS total_orders,
  t.total_revenue,
  t.global_aov,
  t.active_clients,
  ROUND(100 * t.delivered_count   / t.total_orders_all, 2)                               AS pct_delivered,
  ROUND(100 * t.cancelled_count   / t.total_orders_all, 2)                               AS pct_cancelled,
  ROUND(100 * t.returned_count    / t.total_orders_all, 2)                               AS pct_returned,
  ROUND(100 * t.in_progress_count / t.total_orders_all, 2)                               AS pct_in_progress,
  ROUND(100 * (t.cancelled_count + t.returned_count) / t.total_orders_all, 2)            AS pct_problem_orders,
  ROUND(100 * ch.churned_count / ch.total_clients, 2)                                    AS churn_rate_180d,
  ROUND(100 * cc.champ_revenue / cc.total_rfm_revenue, 2)                                AS champions_revenue_pct
FROM totals t
CROSS JOIN churn_calc ch
CROSS JOIN champions_calc cc;


-- Vista 7: Clasificación ABC del catálogo
-- Usada en la página de Catálogo & Precio.
-- Calcula el % acumulado de revenue por producto y asigna clase A/B/C.
-- No es reproducible en Looker Studio (requiere window function acumulativa).
CREATE OR REPLACE VIEW `tiendalatam-casestudy.tiendalatam.v_abc_classification` AS
WITH product_revenue AS (
  SELECT
    p.product_id,
    p.product_name,
    ca.name                                      AS category,
    p.price                                      AS list_price,
    p.stock,
    COUNT(DISTINCT od.order_id)                  AS orders,
    SUM(od.quantity)                             AS units_sold,
    ROUND(SUM(od.quantity * od.unit_price), 2)   AS revenue
  FROM `tiendalatam-casestudy.tiendalatam.products` p
  JOIN `tiendalatam-casestudy.tiendalatam.categories` ca ON p.category_id = ca.category_id
  LEFT JOIN `tiendalatam-casestudy.tiendalatam.order_details` od ON p.product_id = od.product_id
  LEFT JOIN `tiendalatam-casestudy.tiendalatam.orders` o
         ON od.order_id = o.order_id AND o.order_status_id IN (3, 4)
  GROUP BY p.product_id, p.product_name, ca.name, p.price, p.stock
),
with_cumulative AS (
  SELECT *,
    ROUND(100 * revenue / SUM(revenue) OVER (), 2) AS pct_revenue,
    ROUND(
      SUM(revenue) OVER (ORDER BY revenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
      / SUM(revenue) OVER () * 100,
    2) AS cumulative_pct
  FROM product_revenue
)
SELECT *,
  CASE
    WHEN cumulative_pct <= 80 THEN 'A'
    WHEN cumulative_pct <= 95 THEN 'B'
    ELSE 'C'
  END AS abc_class
FROM with_cumulative
ORDER BY revenue DESC;


-- Vista 8: Alertas de stock
-- Usada en la página de Catálogo & Precio.
-- Calcula ventas de los últimos 90 días y días de inventario disponibles.
-- No es reproducible en Looker Studio (requiere fecha relativa dinámica).
CREATE OR REPLACE VIEW `tiendalatam-casestudy.tiendalatam.v_stock_alerts` AS
WITH sales_90d AS (
  SELECT
    od.product_id,
    SUM(od.quantity) AS units_sold_last_90d
  FROM `tiendalatam-casestudy.tiendalatam.order_details` od
  JOIN `tiendalatam-casestudy.tiendalatam.orders` o ON od.order_id = o.order_id
  WHERE o.order_status_id IN (3, 4)
    AND o.registration_date >= DATE_SUB(
      (SELECT MAX(registration_date) FROM `tiendalatam-casestudy.tiendalatam.orders`),
      INTERVAL 90 DAY)
  GROUP BY od.product_id
)
SELECT
  p.product_id,
  p.product_name,
  ca.name                                           AS category,
  p.price                                           AS list_price,
  p.stock,
  COALESCE(s.units_sold_last_90d, 0)                AS units_sold_last_90d,
  CASE
    WHEN COALESCE(s.units_sold_last_90d, 0) = 0 THEN NULL
    ELSE ROUND(p.stock / (s.units_sold_last_90d / 90.0), 1)
  END                                               AS days_of_inventory,
  CASE
    WHEN COALESCE(s.units_sold_last_90d, 0) = 0            THEN 'Sin movimiento'
    WHEN p.stock / (s.units_sold_last_90d / 90.0) < 90     THEN 'Riesgo de quiebre'
    ELSE 'Stock OK'
  END                                               AS stock_alert
FROM `tiendalatam-casestudy.tiendalatam.products` p
JOIN `tiendalatam-casestudy.tiendalatam.categories` ca ON p.category_id = ca.category_id
LEFT JOIN sales_90d s ON p.product_id = s.product_id
ORDER BY days_of_inventory ASC NULLS LAST;


-- Vista 9: Performance por país
-- Usada en las páginas de Resumen Ejecutivo y Operación & Expansión.
-- Consolida revenue, AOV, salud operativa y madurez de mercado por país.
-- No es reproducible en Looker Studio (requiere MIN(date) + DATE_DIFF).
CREATE OR REPLACE VIEW `tiendalatam-casestudy.tiendalatam.v_country_performance` AS
SELECT
  co.name                                                                AS country,
  MIN(o.registration_date)                                               AS first_order_date,
  DATE_DIFF(CURRENT_DATE(), MIN(o.registration_date), MONTH)             AS months_active,
  COUNT(DISTINCT CASE WHEN o.order_status_id IN (3, 4)
                      THEN o.client_id END)                              AS total_buyers,
  COUNT(o.order_id)                                                      AS total_orders,
  COUNTIF(o.order_status_id IN (3, 4))                                   AS valid_orders,
  ROUND(SUM(CASE WHEN o.order_status_id IN (3, 4)
                 THEN o.total_amount ELSE 0 END), 2)                     AS revenue,
  ROUND(AVG(CASE WHEN o.order_status_id IN (3, 4)
                 THEN o.total_amount END), 2)                            AS aov,
  ROUND(100 * COUNTIF(o.order_status_id = 4) / COUNT(o.order_id), 2)    AS pct_delivered,
  ROUND(100 * COUNTIF(o.order_status_id = 5) / COUNT(o.order_id), 2)    AS pct_cancelled,
  ROUND(100 * COUNTIF(o.order_status_id = 6) / COUNT(o.order_id), 2)    AS pct_returned,
  ROUND(
    SUM(CASE WHEN o.order_status_id IN (3, 4) THEN o.total_amount ELSE 0 END)
    / NULLIF(DATE_DIFF(CURRENT_DATE(), MIN(o.registration_date), MONTH), 0),
  2)                                                                     AS revenue_per_month_active
FROM `tiendalatam-casestudy.tiendalatam.orders` o
JOIN `tiendalatam-casestudy.tiendalatam.clients` c   ON o.client_id = c.client_id
JOIN `tiendalatam-casestudy.tiendalatam.countries` co ON c.country_id = co.country_id
GROUP BY co.name
ORDER BY revenue DESC;


-- =====================================================================
-- QUERIES DE VALIDACIÓN
-- Ejecutar después de CREATE OR REPLACE VIEW para confirmar
-- que los datos son consistentes con los análisis.
-- =====================================================================

-- V1: v_orders_enriched — debe devolver 4,000 filas
SELECT COUNT(*) AS total_rows FROM `tiendalatam-casestudy.tiendalatam.v_orders_enriched`;
-- Esperado: 4000

-- V2: v_executive_health — 1 fila; valores de referencia validados
SELECT
  total_orders,          -- referencia: 3045
  total_revenue,         -- referencia: 1473497.20
  global_aov,            -- referencia: 489.69
  pct_delivered,         -- referencia: 63.5%
  pct_cancelled,         -- referencia: 5.1%
  pct_returned,          -- referencia: 2.6%
  pct_in_progress,       -- referencia: 16.2% (Pendiente + Procesando)
  churn_rate_180d,       -- referencia: ~23%
  champions_revenue_pct  -- referencia: 56.4%
FROM `tiendalatam-casestudy.tiendalatam.v_executive_health`;

-- V3: v_abc_classification — 50 filas (un registro por producto)
SELECT abc_class, COUNT(*) AS products, ROUND(SUM(revenue), 2) AS revenue
FROM `tiendalatam-casestudy.tiendalatam.v_abc_classification`
GROUP BY abc_class ORDER BY abc_class;
-- Esperado: A = ~17 productos con ~80% del revenue

-- V4: v_stock_alerts — 50 filas; Laptop debe estar en 'Riesgo de quiebre'
SELECT product_name, stock, days_of_inventory, stock_alert
FROM `tiendalatam-casestudy.tiendalatam.v_stock_alerts`
WHERE product_name LIKE '%Laptop%' OR stock_alert = 'Riesgo de quiebre'
ORDER BY days_of_inventory ASC
LIMIT 10;

-- V5: v_country_performance — 10 filas; Ecuador debe tener el mayor revenue
SELECT country, revenue, aov, pct_cancelled, revenue_per_month_active
FROM `tiendalatam-casestudy.tiendalatam.v_country_performance`
ORDER BY revenue DESC;
-- Esperado: Ecuador ~$195K, Colombia ~$95K (menor revenue/mes activo)

-- V6: v_rfm_segments — Champions debe tener ~56% del revenue
SELECT segment, COUNT(*) AS clients, ROUND(SUM(monetary), 2) AS revenue,
  ROUND(100 * SUM(monetary) / SUM(SUM(monetary)) OVER (), 2) AS pct_revenue
FROM `tiendalatam-casestudy.tiendalatam.v_rfm_segments`
GROUP BY segment ORDER BY revenue DESC;
