-- =====================================================================
-- Exploración inicial (EDA) - BigQuery dialect
-- Reemplaza `tiendalatam-portfolio.tiendalatam` con tu propio project.dataset
-- =====================================================================

-- 1. Volumen y rango temporal
SELECT
  COUNT(*)                              AS total_orders,
  COUNT(DISTINCT client_id)             AS unique_clients,
  MIN(registration_date)                AS first_order,
  MAX(registration_date)                AS last_order,
  ROUND(SUM(total_amount), 2)           AS total_revenue,
  ROUND(AVG(total_amount), 2)           AS avg_order_value
FROM `tiendalatam-portfolio.tiendalatam.orders`;


-- 2. Distribución de estados de pedido
SELECT
  os.name AS status,
  COUNT(*) AS orders,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_share
FROM `tiendalatam-portfolio.tiendalatam.orders` o
JOIN `tiendalatam-portfolio.tiendalatam.order_statuses` os
  ON o.order_status_id = os.order_status_id
GROUP BY os.name
ORDER BY orders DESC;


-- 3. Top 5 países por revenue (solo entregadas)
SELECT
  co.name AS country,
  COUNT(o.order_id) AS orders,
  ROUND(SUM(o.total_amount), 2) AS revenue,
  ROUND(AVG(o.total_amount), 2) AS aov
FROM `tiendalatam-portfolio.tiendalatam.orders` o
JOIN `tiendalatam-portfolio.tiendalatam.clients` c   ON o.client_id = c.client_id
JOIN `tiendalatam-portfolio.tiendalatam.countries` co ON c.country_id = co.country_id
WHERE o.order_status_id = 4
GROUP BY co.name
ORDER BY revenue DESC
LIMIT 5;


-- 4. Top 10 productos más vendidos
SELECT
  p.product_name,
  ca.name AS category,
  SUM(od.quantity) AS units_sold,
  ROUND(SUM(od.quantity * od.unit_price), 2) AS revenue
FROM `tiendalatam-portfolio.tiendalatam.order_details` od
JOIN `tiendalatam-portfolio.tiendalatam.products` p    ON od.product_id = p.product_id
JOIN `tiendalatam-portfolio.tiendalatam.categories` ca ON p.category_id = ca.category_id
JOIN `tiendalatam-portfolio.tiendalatam.orders` o      ON od.order_id = o.order_id
WHERE o.order_status_id = 4
GROUP BY p.product_name, ca.name
ORDER BY units_sold DESC
LIMIT 10;


-- 5. Distribución de clientes por tipo y país
SELECT
  co.name AS country,
  ct.name AS client_type,
  COUNT(*) AS clients
FROM `tiendalatam-portfolio.tiendalatam.clients` c
JOIN `tiendalatam-portfolio.tiendalatam.countries` co    ON c.country_id = co.country_id
JOIN `tiendalatam-portfolio.tiendalatam.client_types` ct ON c.client_type_id = ct.client_type_id
GROUP BY co.name, ct.name
ORDER BY co.name, clients DESC;


-- 6. Productos sin ventas
SELECT
  p.product_id,
  p.product_name,
  ca.name AS category,
  p.price,
  p.stock
FROM `tiendalatam-portfolio.tiendalatam.products` p
JOIN `tiendalatam-portfolio.tiendalatam.categories` ca ON p.category_id = ca.category_id
LEFT JOIN `tiendalatam-portfolio.tiendalatam.order_details` od ON p.product_id = od.product_id
WHERE od.detail_id IS NULL
ORDER BY p.stock DESC;
