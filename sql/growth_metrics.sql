-- =====================================================================
-- Growth Metrics - BigQuery dialect
-- =====================================================================

-- Q1. Revenue mensual con crecimiento Month-over-Month
WITH monthly AS (
  SELECT
    DATE_TRUNC(registration_date, MONTH) AS month,
    SUM(total_amount) AS revenue,
    COUNT(*) AS orders,
    COUNT(DISTINCT client_id) AS active_clients
  FROM `tiendalatam-casestudy.tiendalatam.orders`
  WHERE order_status_id IN (3, 4)
  GROUP BY 1
)
SELECT
  month,
  ROUND(revenue, 2) AS revenue,
  orders,
  active_clients,
  ROUND(revenue - LAG(revenue) OVER (ORDER BY month), 2) AS revenue_delta,
  ROUND(
    SAFE_DIVIDE(revenue - LAG(revenue) OVER (ORDER BY month),
                LAG(revenue) OVER (ORDER BY month)) * 100,
    2
  ) AS mom_growth_pct
FROM monthly
ORDER BY month;


-- Q2. AOV trimestral por tipo de cliente
SELECT
  DATE_TRUNC(o.registration_date, QUARTER) AS quarter,
  ct.name AS client_type,
  COUNT(*) AS orders,
  ROUND(AVG(o.total_amount), 2) AS aov,
  ROUND(SUM(o.total_amount), 2) AS revenue
FROM `tiendalatam-casestudy.tiendalatam.orders` o
JOIN `tiendalatam-casestudy.tiendalatam.clients` c       ON o.client_id = c.client_id
JOIN `tiendalatam-casestudy.tiendalatam.client_types` ct ON c.client_type_id = ct.client_type_id
WHERE o.order_status_id IN (3, 4)
GROUP BY 1, 2
ORDER BY 1, 2;


-- Q3. Clientes nuevos vs recurrentes por mes
WITH first_orders AS (
  SELECT
    client_id,
    MIN(registration_date) AS first_order_date
  FROM `tiendalatam-casestudy.tiendalatam.orders`
  GROUP BY client_id
),
orders_classified AS (
  SELECT
    DATE_TRUNC(o.registration_date, MONTH) AS month,
    o.client_id,
    CASE
      WHEN DATE_TRUNC(o.registration_date, MONTH) = DATE_TRUNC(fo.first_order_date, MONTH)
        THEN 'Nuevo'
      ELSE 'Recurrente'
    END AS client_segment,
    o.total_amount
  FROM `tiendalatam-casestudy.tiendalatam.orders` o
  JOIN first_orders fo ON o.client_id = fo.client_id
  WHERE o.order_status_id IN (3, 4)
)
SELECT
  month,
  client_segment,
  COUNT(DISTINCT client_id) AS clients,
  COUNT(*) AS orders,
  ROUND(SUM(total_amount), 2) AS revenue
FROM orders_classified
GROUP BY month, client_segment
ORDER BY month, client_segment;


-- Q4. Performance por país (calidad operativa)
-- total_orders cuenta todas las órdenes (base para los % operativos); revenue solo status 3-4
SELECT
  co.name AS country,
  COUNT(o.order_id) AS total_orders,
  ROUND(SUM(CASE WHEN o.order_status_id IN (3, 4) THEN o.total_amount ELSE 0 END), 2) AS revenue,
  ROUND(AVG(CASE WHEN o.order_status_id IN (3, 4) THEN o.total_amount END), 2) AS aov,
  ROUND(100 * COUNTIF(o.order_status_id = 5) / COUNT(*), 2) AS pct_cancelled,
  ROUND(100 * COUNTIF(o.order_status_id = 6) / COUNT(*), 2) AS pct_returned,
  ROUND(100 * COUNTIF(o.order_status_id = 4) / COUNT(*), 2) AS pct_delivered
FROM `tiendalatam-casestudy.tiendalatam.orders` o
JOIN `tiendalatam-casestudy.tiendalatam.clients` c    ON o.client_id = c.client_id
JOIN `tiendalatam-casestudy.tiendalatam.countries` co ON c.country_id = co.country_id
GROUP BY co.name
ORDER BY revenue DESC;


-- Q5. Performance por categoría
SELECT
  ca.name AS category,
  COUNT(DISTINCT od.order_id) AS orders,
  SUM(od.quantity) AS units_sold,
  ROUND(SUM(od.quantity * od.unit_price), 2) AS revenue,
  ROUND(AVG(od.unit_price), 2) AS avg_unit_price,
  ROUND(100 * SUM(od.quantity * od.unit_price) / SUM(SUM(od.quantity * od.unit_price)) OVER (), 2) AS pct_of_total_revenue
FROM `tiendalatam-casestudy.tiendalatam.order_details` od
JOIN `tiendalatam-casestudy.tiendalatam.products` p    ON od.product_id = p.product_id
JOIN `tiendalatam-casestudy.tiendalatam.categories` ca ON p.category_id = ca.category_id
JOIN `tiendalatam-casestudy.tiendalatam.orders` o      ON od.order_id = o.order_id
WHERE o.order_status_id IN (3, 4)
GROUP BY ca.name
ORDER BY revenue DESC;
