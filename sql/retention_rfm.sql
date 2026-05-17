-- =====================================================================
-- Retención, Cohortes y RFM - BigQuery dialect
-- =====================================================================

-- Q6. Cohort analysis - retención mensual
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
    DATE_TRUNC(o.registration_date, MONTH) AS order_month,
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
  COUNT(DISTINCT o.client_id) AS active_clients,
  ROUND(100 * COUNT(DISTINCT o.client_id) / cs.cohort_clients, 2) AS retention_pct
FROM orders_with_cohort o
JOIN cohort_size cs ON o.cohort_month = cs.cohort_month
GROUP BY o.cohort_month, cs.cohort_clients, o.months_since_first
ORDER BY o.cohort_month, o.months_since_first;


-- Q7. Segmentación RFM (Recency, Frequency, Monetary)
WITH last_date AS (
  SELECT MAX(registration_date) AS snapshot
  FROM `tiendalatam-casestudy.tiendalatam.orders`
),
client_rfm AS (
  SELECT
    c.client_id,
    CONCAT(c.name, ' ', c.last_name) AS client_name,
    ct.name AS client_type,
    co.name AS country,
    DATE_DIFF(ld.snapshot, MAX(o.registration_date), DAY) AS recency_days,
    COUNT(o.order_id) AS frequency,
    ROUND(SUM(o.total_amount), 2) AS monetary
  FROM `tiendalatam-casestudy.tiendalatam.clients` c
  JOIN `tiendalatam-casestudy.tiendalatam.orders` o
    ON c.client_id = o.client_id AND o.order_status_id IN (3, 4)
  JOIN `tiendalatam-casestudy.tiendalatam.client_types` ct ON c.client_type_id = ct.client_type_id
  JOIN `tiendalatam-casestudy.tiendalatam.countries` co    ON c.country_id = co.country_id
  CROSS JOIN last_date ld
  GROUP BY c.client_id, c.name, c.last_name, ct.name, co.name, ld.snapshot
),
scored AS (
  SELECT
    *,
    NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
    NTILE(4) OVER (ORDER BY frequency)         AS f_score,
    NTILE(4) OVER (ORDER BY monetary)          AS m_score
  FROM client_rfm
)
SELECT
  client_id,
  client_name,
  client_type,
  country,
  recency_days,
  frequency,
  monetary,
  r_score, f_score, m_score,
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
FROM scored
ORDER BY monetary DESC;


-- Q8. Resumen ejecutivo de segmentos RFM
WITH last_date AS (
  SELECT MAX(registration_date) AS snapshot
  FROM `tiendalatam-casestudy.tiendalatam.orders`
),
client_rfm AS (
  SELECT
    c.client_id,
    DATE_DIFF(ld.snapshot, MAX(o.registration_date), DAY) AS recency_days,
    COUNT(o.order_id) AS frequency,
    SUM(o.total_amount) AS monetary
  FROM `tiendalatam-casestudy.tiendalatam.clients` c
  JOIN `tiendalatam-casestudy.tiendalatam.orders` o
    ON c.client_id = o.client_id AND o.order_status_id IN (3, 4)
  CROSS JOIN last_date ld
  GROUP BY c.client_id, ld.snapshot
),
scored AS (
  SELECT *,
    NTILE(4) OVER (ORDER BY recency_days DESC) AS r,
    NTILE(4) OVER (ORDER BY frequency)         AS f,
    NTILE(4) OVER (ORDER BY monetary)          AS m
  FROM client_rfm
),
labelled AS (
  SELECT *,
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
SELECT
  segment,
  COUNT(*) AS clients,
  ROUND(AVG(recency_days), 0) AS avg_recency_days,
  ROUND(AVG(frequency), 2) AS avg_frequency,
  ROUND(SUM(monetary), 2) AS total_revenue,
  ROUND(100 * SUM(monetary) / SUM(SUM(monetary)) OVER (), 2) AS pct_of_revenue
FROM labelled
GROUP BY segment
ORDER BY total_revenue DESC;


-- Q9. LTV por tipo de cliente
WITH client_revenue AS (
  SELECT
    client_id,
    SUM(total_amount) AS total_revenue,
    COUNT(*) AS total_orders
  FROM `tiendalatam-casestudy.tiendalatam.orders`
  WHERE order_status_id IN (3, 4)
  GROUP BY client_id
)
SELECT
  ct.name AS client_type,
  COUNT(DISTINCT c.client_id) AS clients,
  ROUND(AVG(cr.total_revenue), 2) AS avg_ltv,
  ROUND(AVG(cr.total_orders), 2) AS avg_orders_per_client,
  ROUND(SUM(cr.total_revenue), 2) AS segment_revenue
FROM `tiendalatam-casestudy.tiendalatam.clients` c
JOIN `tiendalatam-casestudy.tiendalatam.client_types` ct ON c.client_type_id = ct.client_type_id
LEFT JOIN client_revenue cr ON c.client_id = cr.client_id
GROUP BY ct.name
ORDER BY avg_ltv DESC NULLS LAST;


-- Q10. Churn rate aproximado
WITH last_date AS (
  SELECT MAX(registration_date) AS snapshot
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
)
SELECT
  COUNT(*) AS total_clients,
  COUNTIF(last_purchase IS NULL) AS never_purchased,
  COUNTIF(DATE_DIFF(ld.snapshot, last_purchase, DAY) <= 90) AS active_last_90d,
  COUNTIF(DATE_DIFF(ld.snapshot, last_purchase, DAY) BETWEEN 91 AND 180) AS at_risk_90_180d,
  COUNTIF(DATE_DIFF(ld.snapshot, last_purchase, DAY) > 180) AS churned_180d_plus,
  ROUND(100 * COUNTIF(DATE_DIFF(ld.snapshot, last_purchase, DAY) > 180) / COUNT(*), 2) AS churn_rate_pct
FROM client_activity
CROSS JOIN last_date ld;
