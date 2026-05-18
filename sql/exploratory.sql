-- =====================================================================
-- Exploración inicial (EDA) - BigQuery dialect
-- =====================================================================

-- 1. Volumen y rango temporal
SELECT
  COUNT(*)                              AS total_orders,
  COUNT(DISTINCT client_id)             AS unique_clients,
  MIN(registration_date)                AS first_order,
  MAX(registration_date)                AS last_order,
  ROUND(SUM(total_amount), 2)                                                         AS gmv,
  ROUND(SUM(CASE WHEN order_status_id IN (3, 4) THEN total_amount ELSE 0 END), 2)   AS revenue,
  ROUND(AVG(total_amount), 2)                                                         AS avg_order_value
FROM `tiendalatam-casestudy.tiendalatam.orders`;


-- 2. Distribución de estados de pedido
SELECT
  os.name AS status,
  COUNT(*) AS orders,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_share
FROM `tiendalatam-casestudy.tiendalatam.orders` o
JOIN `tiendalatam-casestudy.tiendalatam.order_statuses` os
  ON o.order_status_id = os.order_status_id
GROUP BY os.name
ORDER BY orders DESC;


-- 3. Revenue por país (solo entregadas)
SELECT
  co.name AS country,
  COUNT(o.order_id) AS orders,
  ROUND(SUM(o.total_amount), 2) AS revenue,
  ROUND(AVG(o.total_amount), 2) AS aov
FROM `tiendalatam-casestudy.tiendalatam.orders` o
JOIN `tiendalatam-casestudy.tiendalatam.clients` c   ON o.client_id = c.client_id
JOIN `tiendalatam-casestudy.tiendalatam.countries` co ON c.country_id = co.country_id
WHERE o.order_status_id IN (3, 4)
GROUP BY co.name
ORDER BY revenue DESC;


-- 4. Top 10 productos más vendidos
SELECT
  p.product_name,
  ca.name AS category,
  SUM(od.quantity) AS units_sold,
  ROUND(SUM(od.quantity * od.unit_price), 2) AS revenue,
  ROUND(
    SUM(od.quantity * od.unit_price) * 100.0
    / SUM(SUM(od.quantity * od.unit_price)) OVER (),
    2
  ) AS pct_of_revenue
FROM `tiendalatam-casestudy.tiendalatam.order_details` od
JOIN `tiendalatam-casestudy.tiendalatam.products` p    ON od.product_id = p.product_id
JOIN `tiendalatam-casestudy.tiendalatam.categories` ca ON p.category_id = ca.category_id
JOIN `tiendalatam-casestudy.tiendalatam.orders` o      ON od.order_id = o.order_id
WHERE o.order_status_id IN (3, 4)
GROUP BY p.product_name, ca.name
ORDER BY units_sold DESC
LIMIT 10;


-- 5. Distribución de clientes por tipo y país
SELECT
  co.name AS country,
  ct.name AS client_type,
  COUNT(*) AS clients
FROM `tiendalatam-casestudy.tiendalatam.clients` c
JOIN `tiendalatam-casestudy.tiendalatam.countries` co    ON c.country_id = co.country_id
JOIN `tiendalatam-casestudy.tiendalatam.client_types` ct ON c.client_type_id = ct.client_type_id
GROUP BY co.name, ct.name
ORDER BY co.name, clients DESC;


-- 6. Productos sin ventas
SELECT
  p.product_id,
  p.product_name,
  ca.name AS category,
  p.price,
  p.stock
FROM `tiendalatam-casestudy.tiendalatam.products` p
JOIN `tiendalatam-casestudy.tiendalatam.categories` ca ON p.category_id = ca.category_id
LEFT JOIN `tiendalatam-casestudy.tiendalatam.order_details` od ON p.product_id = od.product_id
WHERE od.detail_id IS NULL
ORDER BY p.stock DESC;

-- 7. Renevue por tipo de cliente (Global)
SELECT
  ct.name AS client_type,
  COUNT(DISTINCT o.client_id) AS clients,
  COUNT(o.order_id) AS orders,
  ROUND(SUM(o.total_amount), 2) AS revenue,
  ROUND(100 * SUM(o.total_amount) / SUM(SUM(o.total_amount)) OVER (), 2) AS pct_revenue
FROM `tiendalatam-casestudy.tiendalatam.orders` o
JOIN `tiendalatam-casestudy.tiendalatam.clients` c       ON o.client_id = c.client_id
JOIN `tiendalatam-casestudy.tiendalatam.client_types` ct ON c.client_type_id = ct.client_type_id
WHERE o.order_status_id IN (3, 4)
GROUP BY ct.name

-- 8. Distribucion de ventas por producto (Top 20/50)
SELECT
  p.product_id,
  p.product_name,
  ca.name                                    AS category,
  p.price                                    AS list_price,
  COUNT(DISTINCT od.order_id)                AS orders,
  SUM(od.quantity)                           AS units_sold,
  ROUND(SUM(od.quantity * od.unit_price), 2) AS revenue,
  ROUND(100 * SUM(od.quantity * od.unit_price) 
        / SUM(SUM(od.quantity * od.unit_price)) OVER (), 2) AS pct_revenue,
  ROUND(SUM(SUM(od.quantity * od.unit_price)) OVER (
        ORDER BY SUM(od.quantity * od.unit_price) DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
        / SUM(SUM(od.quantity * od.unit_price)) OVER () * 100, 2) AS cumulative_pct
FROM `tiendalatam-casestudy.tiendalatam.products` p
JOIN `tiendalatam-casestudy.tiendalatam.categories` ca     ON p.category_id = ca.category_id
LEFT JOIN `tiendalatam-casestudy.tiendalatam.order_details` od ON p.product_id = od.product_id
LEFT JOIN `tiendalatam-casestudy.tiendalatam.orders` o         ON od.order_id = o.order_id
                                                               AND o.order_status_id IN (3, 4)
GROUP BY p.product_id, p.product_name, ca.name, p.price
ORDER BY revenue DESC NULLS LAST
LIMIT 20;

-- 9. Revenue por categoría
SELECT
  ca.name                                    AS category,
  COUNT(DISTINCT od.order_id)                AS orders,
  SUM(od.quantity)                           AS units_sold,
  ROUND(SUM(od.quantity * od.unit_price), 2) AS revenue,
  ROUND(100 * SUM(od.quantity * od.unit_price)
        / SUM(SUM(od.quantity * od.unit_price)) OVER (), 2) AS pct_revenue
FROM `tiendalatam-casestudy.tiendalatam.order_details` od
JOIN `tiendalatam-casestudy.tiendalatam.products` p        ON od.product_id = p.product_id
JOIN `tiendalatam-casestudy.tiendalatam.categories` ca     ON p.category_id = ca.category_id
JOIN `tiendalatam-casestudy.tiendalatam.orders` o          ON od.order_id = o.order_id
WHERE o.order_status_id IN (3, 4)
GROUP BY ca.name
ORDER BY revenue DESC;



