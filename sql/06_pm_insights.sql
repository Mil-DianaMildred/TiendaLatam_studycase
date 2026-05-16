-- =====================================================================
-- PM Insights - BigQuery dialect
-- =====================================================================

-- Q11. Análisis ABC del catálogo (Pareto)
WITH product_revenue AS (
  SELECT
    p.product_id,
    p.product_name,
    ca.name AS category,
    COALESCE(SUM(od.quantity * od.unit_price), 0) AS revenue
  FROM `tiendalatam-portfolio.tiendalatam.products` p
  JOIN `tiendalatam-portfolio.tiendalatam.categories` ca ON p.category_id = ca.category_id
  LEFT JOIN `tiendalatam-portfolio.tiendalatam.order_details` od ON p.product_id = od.product_id
  LEFT JOIN `tiendalatam-portfolio.tiendalatam.orders` o ON od.order_id = o.order_id AND o.order_status_id IN (3, 4)
  GROUP BY p.product_id, p.product_name, ca.name
),
ranked AS (
  SELECT
    product_id, product_name, category, revenue,
    SUM(revenue) OVER (ORDER BY revenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue,
    SUM(revenue) OVER () AS total_revenue
  FROM product_revenue
)
SELECT
  product_id,
  product_name,
  category,
  revenue,
  ROUND(100 * SAFE_DIVIDE(cumulative_revenue, total_revenue), 2) AS cumulative_pct,
  CASE
    WHEN SAFE_DIVIDE(cumulative_revenue, total_revenue) <= 0.80 THEN 'A'
    WHEN SAFE_DIVIDE(cumulative_revenue, total_revenue) <= 0.95 THEN 'B'
    ELSE 'C'
  END AS abc_class
FROM ranked
ORDER BY revenue DESC;


-- Q12. Performance por empleado y tienda
SELECT
  l.name AS store,
  co.name AS country,
  CONCAT(e.name, ' ', e.last_name) AS employee,
  pos.name AS position,
  COUNT(o.order_id) AS orders_handled,
  ROUND(SUM(o.total_amount), 2) AS revenue_generated,
  ROUND(AVG(o.total_amount), 2) AS aov
FROM `tiendalatam-portfolio.tiendalatam.employees` e
JOIN `tiendalatam-portfolio.tiendalatam.locations` l    ON e.location_id = l.location_id
JOIN `tiendalatam-portfolio.tiendalatam.countries` co   ON l.country_id = co.country_id
JOIN `tiendalatam-portfolio.tiendalatam.positions` pos  ON e.employee_position = pos.position_id
LEFT JOIN `tiendalatam-portfolio.tiendalatam.orders` o
  ON e.employee_id = o.employee_id AND o.order_status_id IN (3, 4)
GROUP BY l.name, co.name, e.name, e.last_name, pos.name
ORDER BY revenue_generated DESC NULLS LAST;


-- Q13. Productos con riesgo de quiebre de stock
WITH max_date AS (
  SELECT MAX(registration_date) AS snapshot
  FROM `tiendalatam-portfolio.tiendalatam.orders`
),
product_demand AS (
  SELECT
    p.product_id,
    p.product_name,
    p.stock,
    p.price,
    ca.name AS category,
    COALESCE(SUM(od.quantity), 0) AS units_sold_total,
    COALESCE(SUM(
      CASE WHEN o.registration_date >= DATE_SUB((SELECT snapshot FROM max_date), INTERVAL 90 DAY)
           THEN od.quantity ELSE 0 END
    ), 0) AS units_sold_last_90d
  FROM `tiendalatam-portfolio.tiendalatam.products` p
  JOIN `tiendalatam-portfolio.tiendalatam.categories` ca ON p.category_id = ca.category_id
  LEFT JOIN `tiendalatam-portfolio.tiendalatam.order_details` od ON p.product_id = od.product_id
  LEFT JOIN `tiendalatam-portfolio.tiendalatam.orders` o ON od.order_id = o.order_id AND o.order_status_id IN (3, 4)
  GROUP BY p.product_id, p.product_name, p.stock, p.price, ca.name
)
SELECT
  product_id,
  product_name,
  category,
  stock,
  units_sold_last_90d,
  CASE
    WHEN units_sold_last_90d = 0 THEN NULL
    ELSE ROUND(SAFE_DIVIDE(stock, units_sold_last_90d / 90.0), 1)
  END AS days_of_inventory,
  CASE
    WHEN units_sold_last_90d > 0 AND stock < units_sold_last_90d THEN 'Riesgo de quiebre'
    WHEN units_sold_last_90d = 0 AND stock > 50 THEN 'Stock muerto'
    ELSE 'OK'
  END AS alert
FROM product_demand
ORDER BY
  CASE WHEN units_sold_last_90d > 0 AND stock < units_sold_last_90d THEN 0 ELSE 1 END,
  units_sold_last_90d DESC;


-- Q14. Market basket: combinaciones de productos frecuentes
WITH product_pairs AS (
  SELECT
    od1.product_id AS product_a,
    od2.product_id AS product_b,
    COUNT(*) AS pair_count
  FROM `tiendalatam-portfolio.tiendalatam.order_details` od1
  JOIN `tiendalatam-portfolio.tiendalatam.order_details` od2
    ON od1.order_id = od2.order_id
   AND od1.product_id < od2.product_id
  GROUP BY od1.product_id, od2.product_id
  HAVING COUNT(*) >= 2
)
SELECT
  p1.product_name AS product_a,
  p2.product_name AS product_b,
  pp.pair_count AS orders_with_both
FROM product_pairs pp
JOIN `tiendalatam-portfolio.tiendalatam.products` p1 ON pp.product_a = p1.product_id
JOIN `tiendalatam-portfolio.tiendalatam.products` p2 ON pp.product_b = p2.product_id
ORDER BY pp.pair_count DESC
LIMIT 15;


-- Q15. Time-to-second-purchase
WITH ordered_purchases AS (
  SELECT
    client_id,
    registration_date,
    ROW_NUMBER() OVER (PARTITION BY client_id ORDER BY registration_date) AS purchase_n
  FROM `tiendalatam-portfolio.tiendalatam.orders`
  WHERE order_status_id IN (3, 4)
),
first_second AS (
  SELECT
    f.client_id,
    f.registration_date AS first_purchase,
    s.registration_date AS second_purchase,
    DATE_DIFF(s.registration_date, f.registration_date, DAY) AS days_between
  FROM ordered_purchases f
  JOIN ordered_purchases s ON f.client_id = s.client_id
  WHERE f.purchase_n = 1 AND s.purchase_n = 2
)
SELECT
  COUNT(*) AS clients_with_2nd_purchase,
  ROUND(AVG(days_between), 1) AS avg_days_between,
  MIN(days_between) AS min_days,
  MAX(days_between) AS max_days,
  APPROX_QUANTILES(days_between, 100)[OFFSET(50)] AS median_days
FROM first_second;
