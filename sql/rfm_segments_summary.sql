-- =====================================================================
-- Resumen ejecutivo de segmentos RFM
-- =====================================================================
-- Produce la tabla agregada por segmento con: # clientes, revenue total
-- y % del revenue total. Es la versión "ejecutiva" del análisis RFM —
-- la que va en el dashboard y en el caso de estudio.
--
-- Resultado esperado (orden por revenue desc):
--   Champions, Needs Attention, At Risk, New/Promising, Loyal,
--   Hibernating, About to Sleep, Lost.
--
-- Cómo usarla:
--   - Pegala completa en BigQuery Studio y ejecuta.
--   - Cambia `tiendalatam-casestudy.tiendalatam` si tu proyecto/dataset
--     tienen otro nombre.
-- =====================================================================

WITH
-- 1. Fecha de referencia ("hoy" = última orden registrada).
last_date AS (
  SELECT MAX(registration_date) AS snapshot
  FROM `tiendalatam-casestudy.tiendalatam.orders`
),

-- 2. RFM crudo por cliente (solo órdenes válidas: Enviado o Entregado).
client_rfm AS (
  SELECT
    c.client_id,
    DATE_DIFF(ld.snapshot, MAX(o.registration_date), DAY) AS recency_days,
    COUNT(o.order_id) AS frequency,
    SUM(o.total_amount) AS monetary
  FROM `tiendalatam-casestudy.tiendalatam.clients` c
  JOIN `tiendalatam-casestudy.tiendalatam.orders` o
    ON c.client_id = o.client_id
   AND o.order_status_id IN (3, 4)
  CROSS JOIN last_date ld
  GROUP BY c.client_id, ld.snapshot
),

-- 3. Scoring por cuartiles (1 peor, 4 mejor).
scored AS (
  SELECT
    *,
    NTILE(4) OVER (ORDER BY recency_days DESC) AS r,
    NTILE(4) OVER (ORDER BY frequency)         AS f,
    NTILE(4) OVER (ORDER BY monetary)          AS m
  FROM client_rfm
),

-- 4. Etiquetado de segmentos.
labelled AS (
  SELECT
    *,
    CASE
      WHEN r >= 3 AND f >= 3 AND m >= 3 THEN 'Champions'
      WHEN r >= 3 AND f >= 2             THEN 'Loyal'
      WHEN r >= 3 AND f = 1              THEN 'New / Promising'
      WHEN r = 2  AND f >= 2             THEN 'Needs Attention'
      WHEN r = 2  AND f = 1              THEN 'About to Sleep'
      WHEN r = 1  AND f >= 3             THEN 'At Risk'
      WHEN r = 1  AND f = 2              THEN 'Hibernating'
      WHEN r = 1  AND f = 1              THEN 'Lost'
      ELSE 'Others'
    END AS segment
  FROM scored
)

-- 5. Resumen agregado por segmento (la tabla que ves en el dashboard).
SELECT
  segment                                                                    AS Segmento,
  COUNT(*)                                                                   AS Clientes,
  ROUND(SUM(monetary), 0)                                                    AS Revenue,
  ROUND(100 * SUM(monetary) / SUM(SUM(monetary)) OVER (), 1)                 AS pct_Revenue
FROM labelled
GROUP BY segment
ORDER BY Revenue DESC;
