-- =====================================================================
-- Revenue mensual con crecimiento Month-over-Month — Colombia
-- =====================================================================
-- Filtra el análisis a un solo país (Colombia) usando el JOIN con
-- countries y un WHERE explícito.
--
-- Para cambiar de país: reemplaza 'Colombia' en el WHERE por el nombre
-- exacto que aparece en la tabla countries (ej: 'Argentina', 'México',
-- 'Perú', 'Uruguay', 'Chile', 'Brasil', 'Ecuador', 'Bolivia',
-- 'Costa Rica').
-- =====================================================================

WITH monthly AS (
  SELECT
    DATE_TRUNC(o.registration_date, MONTH) AS month,
    SUM(o.total_amount)                    AS revenue,
    COUNT(*)                               AS orders,
    COUNT(DISTINCT o.client_id)            AS active_clients
  FROM `tiendalatam-casestudy.tiendalatam.orders` o
  JOIN `tiendalatam-casestudy.tiendalatam.clients` c
    ON o.client_id = c.client_id
  JOIN `tiendalatam-casestudy.tiendalatam.countries` co
    ON c.country_id = co.country_id
  WHERE o.order_status_id IN (3, 4)
    AND co.name = 'Colombia'
  GROUP BY month
)
SELECT
  month,
  ROUND(revenue, 2) AS revenue,
  orders,
  active_clients,
  ROUND(revenue - LAG(revenue) OVER (ORDER BY month), 2) AS revenue_delta,
  ROUND(
    SAFE_DIVIDE(
      revenue - LAG(revenue) OVER (ORDER BY month),
      LAG(revenue) OVER (ORDER BY month)
    ) * 100,
    2
  ) AS mom_growth_pct
FROM monthly
ORDER BY month;
