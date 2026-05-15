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
  FROM `tiendalatam-portfolio.tiendalatam.orders`
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
FROM `tiendalatam-portfolio.tiendalatam.orders` o
JOIN `tiendalatam-portfolio.tiendalatam.clients` c       ON o.client_id = c.client_id
JOIN `tiendalatam-portfolio.tiendalatam.client_types` ct ON c.client_type_id = ct.client_type_id
WHERE o.order_status_id IN (3, 4)
GROUP BY 1, 2
ORDER BY 1, 2;


-- Q3. Clientes nuevos vs recurrentes por mes
WITH first_orders AS (
  SELECT
    client_id,
    MIN(registration_date) AS first_order_date
  FROM `tiendalatam-portfolio.tiendalatam.orders`
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
  FROM `tiendalatam-portfolio.tiendalatam.orders` o
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
SELECT
  co.name AS country,
  COUNT(o.order_id) AS total_orders,
  ROUND(SUM(o.total_amount), 2) AS revenue,
  ROUND(AVG(o.total_amount), 2) AS aov,
  ROUND(100 * COUNTIF(o.order_status_id = 5) / COUNT(*), 2) AS pct_cancelled,
  ROUND(100 * COUNTIF(o.order_status_id = 6) / COUNT(*), 2) AS pct_returned,
  ROUND(100 * COUNTIF(o.order_status_id = 4) / COUNT(*), 2) AS pct_delivered
FROM `tiendalatam-portfolio.tiendalatam.orders` o
JOIN `tiendalatam-portfolio.tiendalatam.clients` c    ON o.client_id = c.client_id
JOIN `tiendalatam-portfolio.tiendalatam.countries` co ON c.country_id = co.country_id
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
FROM `tiendalatam-portfolio.tiendalatam.order_details` od
JOIN `tiendalatam-portfolio.tiendalatam.products` p    ON od.product_id = p.product_id
JOIN `tiendalatam-portfolio.tiendalatam.categories` ca ON p.category_id = ca.category_id
JOIN `tiendalatam-portfolio.tiendalatam.orders` o      ON od.order_id = o.order_id
WHERE o.order_status_id IN (3, 4)
GROUP BY ca.name
ORDER BY revenue DESC;
