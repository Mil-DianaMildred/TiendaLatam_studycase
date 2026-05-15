-- =====================================================================
-- Segmentación RFM por cliente
-- =====================================================================
-- Asigna a cada cliente un score 1-4 en Recency, Frequency y Monetary,
-- y lo clasifica en un segmento accionable (Champions, At Risk, etc.).
--
-- Cómo usarla:
--   - Pegala completa en BigQuery Studio y ejecuta.
--   - Cambia `tiendalatam-casestudy.tiendalatam` si tu proyecto/dataset
--     tienen otro nombre.
--
-- Filtro de calidad: solo cuento órdenes con status 3 (Enviado) o 4
-- (Entregado) para que el revenue sea el realmente realizado.
-- =====================================================================

WITH
-- 1. Fecha de referencia ("hoy"): la última fecha del dataset.
last_date AS (
  SELECT MAX(registration_date) AS snapshot
  FROM `tiendalatam-casestudy.tiendalatam.orders`
),

-- 2. Métricas crudas RFM por cliente.
client_rfm AS (
  SELECT
    c.client_id,
    CONCAT(c.name, ' ', c.last_name)                       AS client_name,
    ct.name                                                AS client_type,
    co.name                                                AS country,
    DATE_DIFF(ld.snapshot, MAX(o.registration_date), DAY)  AS recency_days,
    COUNT(o.order_id)                                      AS frequency,
    ROUND(SUM(o.total_amount), 2)                          AS monetary
  FROM `tiendalatam-casestudy.tiendalatam.clients` c
  JOIN `tiendalatam-casestudy.tiendalatam.orders` o
    ON c.client_id = o.client_id
   AND o.order_status_id IN (3, 4)
  JOIN `tiendalatam-casestudy.tiendalatam.client_types` ct
    ON c.client_type_id = ct.client_type_id
  JOIN `tiendalatam-casestudy.tiendalatam.countries` co
    ON c.country_id = co.country_id
  CROSS JOIN last_date ld
  GROUP BY c.client_id, c.name, c.last_name, ct.name, co.name, ld.snapshot
),

-- 3. Scoring 1 (peor) a 4 (mejor) por cuartiles.
--    Recency: menos días sin comprar = mejor → DESC en el ORDER BY.
--    Frequency / Monetary: más es mejor → ASC.
scored AS (
  SELECT
    *,
    NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
    NTILE(4) OVER (ORDER BY frequency)         AS f_score,
    NTILE(4) OVER (ORDER BY monetary)          AS m_score
  FROM client_rfm
)

-- 4. Etiquetado final con segmentos accionables.
SELECT
  client_id,
  client_name,
  client_type,
  country,
  recency_days,
  frequency,
  monetary,
  r_score,
  f_score,
  m_score,
  CASE
    WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Champions'
    WHEN r_score >= 3 AND f_score >= 2                  THEN 'Loyal'
    WHEN r_score >= 3 AND f_score = 1                   THEN 'New / Promising'
    WHEN r_score = 2  AND f_score >= 2                  THEN 'Needs Attention'
    WHEN r_score = 2  AND f_score = 1                   THEN 'About to Sleep'
    WHEN r_score = 1  AND f_score >= 3                  THEN 'At Risk'
    WHEN r_score = 1  AND f_score = 2                   THEN 'Hibernating'
    WHEN r_score = 1  AND f_score = 1                   THEN 'Lost'
    ELSE 'Others'
  END AS segment
FROM scored
ORDER BY monetary DESC;

-- =====================================================================
-- Cómo leer el resultado
-- Cada fila es un cliente. Las columnas que importan para tu storytelling:
-- 
-- recency_days: cuántos días desde su última compra. Menos es mejor.
-- frequency: cuántas órdenes hizo en total. Más es mejor.
-- monetary: cuánto ha gastado acumulado. Más es mejor.
-- r/f/m_score: cuartil 1 (peor) a 4 (mejor).
-- segment: el nombre accionable. Estos son los que vas a usar en el dashboard.
-- 
-- Qué hacer con cada segmento (el insight PM)
-- 
-- Champions: tus mejores clientes. Pídeles referidos, prográmales beneficios VIP.
-- Loyal: compran seguido pero no son los más grandes. Estrategia de upselling.
-- New / Promising: recientes, pocas compras. Foco de onboarding/segunda compra.
-- Needs Attention: estuvieron activos pero empiezan a alejarse. Email/llamada.
-- At Risk: clientes valiosos que ya no compran. La oportunidad de retención más rentable.
-- Hibernating / About to Sleep: en zona gris. Campañas masivas baratas.
-- Lost: posiblemente perdidos. Bajo prioridad excepto si te sobra ancho de banda.
-- =====================================================================
