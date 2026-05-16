# Hallazgos preliminares (resultados reales de las queries)

Estos números se obtuvieron ejecutando las queries del proyecto contra el dataset expandido (`data_expanded/`). Sirven como teaser para el caso de estudio y como sanity check del pipeline en BigQuery.

## Métricas globales (status = Entregado y Enviado)

- Revenue total: **$1,473,497.20**
- Órdenes válidas: **3,045**
- Clientes compradores únicos: **636 de 700**
- AOV global: **$483.84**
- Ventana de análisis: julio 2021 → abril 2026

## Salud operativa

| Métrica | Valor |
|---------|-------|
| Tasa de entrega | 63.5% |
| Tasa de cancelación | 5.1% |
| Tasa de devolución | 2.6% |
| En proceso / pendiente | 16.2% |

Cancelado + devuelto es 7.7% — dentro del rango aceptable, pero vale la pena analizar por país y categoría para identificar si hay patrones localizados.

## Top 3 países (por revenue)

| País | Órdenes | Revenue | AOV |
|------|---------|---------|-----|
| Ecuador | 387 | $195,579 | $505 |
| Perú | 353 | $183,410 | $520 |
| Bolivia | 344 | $173,122 | $503 |

Insight: **Ecuador lidera en revenue** pero Perú tiene el AOV más alto de este grupo. Ambos países son candidatos a recibir más inversión en catálogo premium.

## Bottom 3 países

| País | Órdenes | Revenue | AOV |
|------|---------|---------|-----|
| Colombia | 224 | $95,861 | $428 |
| Costa Rica | 228 | $115,579 | $507 |
| Uruguay | 246 | $118,538 | $482 |

Insight: **Colombia tiene el revenue más bajo** pese a ser uno de los mercados más grandes de la región. Posible oportunidad de expansión de base de clientes o revisión de la estrategia comercial local. Costa Rica, aunque pequeño en órdenes, tiene un AOV alto ($507), lo que sugiere un perfil de cliente de mayor poder adquisitivo.

## AOV por país (ranking completo)

| País | AOV |
|------|-----|
| Argentina | **$563** |
| Perú | $520 |
| Ecuador | $505 |
| Costa Rica | $507 |
| Bolivia | $503 |
| Uruguay | $482 |
| México | $468 |
| Chile | $442 |
| Colombia | $428 |
| Brasil | $426 |

Insight: **Argentina tiene el AOV más alto** ($563) a pesar de no liderar en volumen de órdenes. Hipótesis: mix de clientes con mayor proporción de Mayoristas/Corporativos o preferencia por categorías de ticket alto (Tecnología).

## Revenue por categoría

| Categoría | Revenue | Unidades |
|-----------|---------|----------|
| Tecnología | $1,091,259 | 6,037 |
| Hogar | $316,993 | 5,172 |
| Moda | $183,381 | 5,109 |
| Belleza | $113,696 | 4,546 |
| Deportes | $101,840 | 4,456 |
| Juguetería | $94,753 | 3,591 |
| Alimentos | $37,354 | 5,123 |
| Papelería | $19,492 | 2,951 |

Insight: **Tecnología concentra el 74% del revenue** pero solo el ~16% de las unidades — es una categoría de ticket muy alto. Alimentos vende muchas unidades con revenue bajo: categoría de frecuencia, no de margen.

## Segmentación RFM (el insight estrella)

| Segmento | Clientes | Revenue | % Revenue |
|----------|----------|---------|-----------|
| **Champions** | 132 | $831,442 | **56.4%** |
| Loyal | 109 | $295,228 | 20.0% |
| At Risk | 64 | $160,325 | 10.9% |
| New/Promising | 73 | $47,787 | 3.2% |
| About to Sleep | 24 | $37,772 | 2.6% |
| Needs Attention | 68 | $35,026 | 2.4% |
| Lost | 146 | $34,819 | 2.4% |
| Hibernating | 20 | $31,099 | 2.1% |

Insight principal: **132 clientes (20.8% de la base activa) generan el 56.4% del revenue**. La concentración supera ampliamente la regla 80/20 — los Champions + Loyal (241 clientes, 37.9%) acumulan el 76.4% del revenue.

Insight secundario: **At Risk + Hibernating + Lost = 230 clientes** que han generado ~$226K en revenue histórico y hoy tienen baja actividad. Esa es la oportunidad de retención más clara del negocio.

## Salud del funnel de clientes

- **Churn rate (180+ días sin comprar)**: **25.3%** (161 de 636 compradores activos)
- **Clientes registrados que nunca compraron**: **64 de 700 (9.1%)** — problema de activación que vale la pena investigar
- **Time-to-second-purchase**: mediana de **74 días** (media: 132 días). La mediana es más útil aquí porque los outliers de clientes que tardaron años en volver sesgan la media. A los 74 días es cuando se debe enviar la campaña de re-engagement.
- **Clientes con 2+ compras**: **389 de 636** (61.2%) — base recurrente saludable

## Tendencia anual (revenue, órdenes válidas)

| Año | Revenue | Órdenes válidas |
|-----|---------|-----------------|
| 2021 | $1,248 | 4 |
| 2022 | $13,046 | 34 |
| 2023 | $71,700 | 132 |
| 2024 | $205,382 | 401 |
| 2025 | $607,340 | 1,244 |
| 2026 (parcial) | $574,782 | 1,230 |

El negocio muestra crecimiento sostenido año a año. 2026 ya casi iguala a 2025 con solo 4 meses de datos, lo que sugiere aceleración.

## 3 recomendaciones de producto candidatas

Priorizadas con criterio ICE (Impact × Confidence × Ease, escala 1-10):

| Recomendación | I | C | E | ICE | Justificación |
|---------------|---|---|---|-----|----------------|
| **1. Programa VIP para Champions** | 9 | 9 | 6 | 486 | 132 clientes generan 56% del revenue. Retener a este grupo es la palanca de mayor ROI. |
| **2. Campaña de reactivación At Risk** | 8 | 7 | 8 | 448 | 64 clientes con LTV alto y actividad decayendo. Email/llamada del Asesor Comercial = costo bajo, impacto potencial alto. |
| **3. Activación de primeros 74 días** | 7 | 7 | 7 | 343 | Reducir churn antes del 2do pedido. Un cupón o contacto proactivo en semana 8 puede doblar la tasa de recompra. |

## Sanity checks que vale la pena revisar

- 64 clientes registrados sin ninguna orden: ¿son pruebas del sistema o clientes reales que no activaron?
- Argentina lidera en AOV ($563) con pocas órdenes: cruzar con tipo de cliente para validar hipótesis.
- Tecnología concentra el 74% del revenue: ¿el catálogo es demasiado estrecho? Riesgo de dependencia de una sola categoría.
- 2026 ya casi iguala 2025 en solo 4 meses: verificar en BigQuery que las fechas de 2026 son reales y no errores de ingesta.
