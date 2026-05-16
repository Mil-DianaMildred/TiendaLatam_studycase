-- =====================================================================
-- Revenue mensual con crecimiento Month-over-Month por país
-- =====================================================================
-- Cambios respecto a la versión global:
--   1. JOIN a clients + countries para traer el nombre del país.
--   2. GROUP BY incluye country.
--   3. LAG() particionado por country: el cálculo de MoM compara cada
--      mes contra el mes anterior del MISMO país (sin esto el cálculo
--      sería incorrecto).
--   4. ORDER BY country, month para leer la evolución país por país.
-- =====================================================================

WITH monthly AS (
  SELECT
    co.name                              AS country,
    DATE_TRUNC(o.registration_date, MONTH) AS month,
    SUM(o.total_amount)                  AS revenue,
    COUNT(*)                             AS orders,
    COUNT(DISTINCT o.client_id)          AS active_clients
  FROM `tiendalatam-casestudy.tiendalatam.orders` o
  JOIN `tiendalatam-casestudy.tiendalatam.clients` c
    ON o.client_id = c.client_id
  JOIN `tiendalatam-casestudy.tiendalatam.countries` co
    ON c.country_id = co.country_id
  WHERE o.order_status_id IN (3, 4)
  GROUP BY country, month
)
SELECT
  country,
  month,
  ROUND(revenue, 2) AS revenue,
  orders,
  active_clients,
  ROUND(
    revenue - LAG(revenue) OVER (PARTITION BY country ORDER BY month),
    2
  ) AS revenue_delta,
  ROUND(
    SAFE_DIVIDE(
      revenue - LAG(revenue) OVER (PARTITION BY country ORDER BY month),
      LAG(revenue) OVER (PARTITION BY country ORDER BY month)
    ) * 100,
    2
  ) AS mom_growth_pct
FROM monthly
ORDER BY country, month;
