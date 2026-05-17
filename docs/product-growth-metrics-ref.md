# Métricas de producto y growth — Retail LATAM

Referencia completa de métricas relevantes para un negocio retail como TiendaLatam.
La columna **Disponibilidad** indica si la métrica se puede construir con el dataset actual.

| Leyenda | Significado |
|---------|-------------|
| ✅ Disponible | Se puede calcular directamente con los datos de TiendaLatam |
| 🟡 Parcial | Calculable con supuestos o datos aproximados |
| ❌ No disponible | Requiere datos externos (costos, sesiones, encuestas, etc.) |

---

## Adquisición

| Métrica | Definición | Disponibilidad |
|---------|-----------|----------------|
| Nuevos clientes por mes | Clientes que realizan su primera compra en el período. | ✅ Disponible |
| Tasa de conversión de registro | % de clientes registrados que completan al menos una compra sobre el total registrado. | ✅ Disponible — 636 de 700 (90.9%) |
| CAC — Costo de adquisición de cliente | Inversión total en marketing y ventas dividida entre nuevos clientes en el período. | ❌ Sin datos de costos |
| CAC payback period | Meses que tarda un cliente en generar revenue suficiente para cubrir su propio CAC. | ❌ Sin datos de costos |
| Mix de canal de adquisición | Distribución de clientes nuevos por canal (orgánico, pago, referido, directo). | ❌ Sin datos de canal |
| Costo por lead (CPL) | Inversión dividida entre leads generados antes de convertirse en cliente. | ❌ Sin datos de marketing |

---

## Activación

| Métrica | Definición | Disponibilidad |
|---------|-----------|----------------|
| Tasa de activación (1a compra) | % de clientes registrados que completan al menos una orden válida. | ✅ Disponible — 9.1% nunca compraron |
| Time to second purchase (TT2P) | Días entre la primera y la segunda orden. Indicador clave de onboarding exitoso. | ✅ Disponible — mediana 74 días |
| Tasa de clientes que nunca compraron | % de registrados sin ninguna orden. Indica fuga en el funnel de activación. | ✅ Disponible — 64 de 700 (9.1%) |
| Time to first purchase (TTFP) | Días entre el registro del cliente y su primera orden completada. | 🟡 Parcial — requiere cruzar `registration_date` de `clients` vs `orders` |
| Abandono de carrito | % de sesiones con ítems agregados que no completan checkout. | ❌ Sin datos de sesión/carrito |

---

## Retención

| Métrica | Definición | Disponibilidad |
|---------|-----------|----------------|
| Retention rate por cohorte | % de clientes de una cohorte mensual que vuelven a comprar en el mes N. | ✅ Disponible — vista `v_cohort_retention` |
| Churn rate | % de clientes activos que no han comprado en los últimos X días (definición: 180d). | ✅ Disponible — 25.3% a 180 días |
| Tasa de recompra | % de clientes que han realizado 2 o más órdenes sobre el total de compradores. | ✅ Disponible — 61.2% (389 de 636) |
| Rolling retention (day 30 / 60 / 90) | % de clientes activos en el mes 0 que vuelven a comprar en el día 30, 60 o 90. | ✅ Disponible — derivable de la tabla de cohortes |
| Segmentación RFM | Clasificación en segmentos accionables según Recency, Frequency y Monetary. | ✅ Disponible — vista `v_rfm_segments` |
| Tasa de devolución | % de órdenes con status "Devuelto" sobre el total. | ✅ Disponible — 2.6% global |
| NPS — Net Promoter Score | Disposición de clientes a recomendar la tienda (escala 0–10, promotores minus detractores). | ❌ Sin datos de encuestas |
| CSAT — Customer Satisfaction Score | Satisfacción promedio reportada por clientes tras una compra o interacción. | ❌ Sin datos de encuestas |

---

## Revenue

| Métrica | Definición | Disponibilidad |
|---------|-----------|----------------|
| Revenue mensual (MRR) | Revenue total de órdenes válidas (Enviado + Entregado) en el mes. | ✅ Disponible |
| MoM growth % | Tasa de crecimiento del revenue mes a mes: `(mes actual / mes anterior) − 1`. | ✅ Disponible — `sql/04_growth_metrics.sql` Q1 |
| YoY growth % | Crecimiento del revenue comparando el mismo período del año anterior. | ✅ Disponible — derivable |
| AOV — Average Order Value | Revenue total dividido entre número de órdenes válidas en el período. | ✅ Disponible — global $483.84 |
| LTV — Lifetime Value | Revenue total acumulado por cliente durante toda su relación con la tienda. | ✅ Disponible — calculable por cliente |
| Revenue por segmento RFM | Distribución del revenue entre Champions, Loyal, At Risk, etc. | ✅ Disponible — Champions generan 56.4% |
| Revenue nuevos vs recurrentes | % del revenue mensual proveniente de primeras compras vs clientes que repiten. | ✅ Disponible — `sql/04_growth_metrics.sql` Q3 |
| Tasa de cancelación de revenue | % del revenue bruto perdido por órdenes canceladas o devueltas. | ✅ Disponible — derivable de `order_statuses` |
| Revenue por empleado / tienda | Revenue atribuido a cada vendedor o tienda física. | ✅ Disponible — `sql/06_pm_insights.sql` Q12 |
| LTV:CAC ratio | Cuántas veces el LTV supera el CAC. Meta saludable: >3x. | ❌ Sin datos de CAC |
| Gross margin | Revenue menos costo de productos vendidos (COGS), expresado en %. | ❌ Sin datos de costos |

---

## Producto y catálogo

| Métrica | Definición | Disponibilidad |
|---------|-----------|----------------|
| Análisis ABC de catálogo (Pareto) | Clasificación de productos en A (80% del revenue), B (siguiente 15%) y C (resto). | ✅ Disponible — `sql/06_pm_insights.sql` Q11 |
| Market basket / co-purchase rate | Con qué frecuencia dos productos se compran juntos. Base para bundles y cross-sell. | ✅ Disponible — `sql/06_pm_insights.sql` Q14 |
| Dead stock / productos sin ventas | Productos con stock > 0 y cero unidades vendidas. Candidatos a descatalogación. | ✅ Disponible — `sql/03_exploratory.sql` E6 |
| Días de inventario disponible | Stock actual dividido entre la tasa de venta diaria de los últimos 90 días. | ✅ Disponible — `sql/06_pm_insights.sql` Q13 |
| Revenue por categoría (% del total) | Distribución del revenue entre las 8 categorías de producto. | ✅ Disponible — Tecnología: 74% |
| Precio promedio de venta (ASP) | Precio unitario promedio real de venta (puede diferir del precio catálogo). | ✅ Disponible — campo `unit_price` en `order_details` |
| Tasa de productos activos vs descatalogados | % de SKUs con status activo sobre el total del catálogo. | ✅ Disponible — campo `status` en `products` |
| Sell-through rate | % del inventario disponible que se vendió en el período: `unidades vendidas / stock inicial`. | 🟡 Parcial — stock actual disponible, sin histórico de entradas de inventario |

---

## Operaciones

| Métrica | Definición | Disponibilidad |
|---------|-----------|----------------|
| Tasa de entrega exitosa | % de órdenes que alcanzan status "Entregado" sobre el total. | ✅ Disponible — 63.5% global |
| Tasa de cancelación | % de órdenes canceladas sobre el total. Alerta si supera el 5%. | ✅ Disponible — 5.1% global |
| Performance por tienda / país | Revenue, AOV y % cancelación desglosados por tienda o país. | ✅ Disponible — `sql/04_growth_metrics.sql` Q4 |
| Órdenes por empleado | Número de órdenes gestionadas por cada vendedor. Indicador de productividad. | ✅ Disponible — `sql/06_pm_insights.sql` Q12 |
| Order fulfillment time | Días entre la creación de la orden y el cambio a status "Entregado". | ❌ Sin timestamp por cambio de estado |
| Tasa de órdenes en estado pendiente prolongado | % de órdenes con más de X días en "Pendiente" o "Procesando". Señal de cuello de botella. | 🟡 Parcial — sin timestamp de cambio de estado |

---

## Resumen de cobertura

| Estado | Cantidad |
|--------|----------|
| ✅ Disponible con el dataset actual | 28 |
| 🟡 Parcialmente calculable | 4 |
| ❌ Requiere datos externos | 10 |
| **Total** | **42** |

---

## Brechas principales y cómo cerrarlas

| Brecha | Datos necesarios | Fuente típica |
|--------|-----------------|---------------|
| Sin métricas de costo (CAC, gross margin, LTV:CAC) | Presupuesto de marketing + COGS por producto | ERP / herramienta de ads (Google Ads, Meta) |
| Sin datos de sesión digital (abandono de carrito, embudo) | Eventos web / app por usuario | Google Analytics 4, Mixpanel, Amplitude |
| Sin feedback del cliente (NPS, CSAT) | Encuestas post-compra | Typeform, Delighted, HubSpot |
| Sin timestamps por cambio de estado | Log de transiciones de estado de orden | Sistema de gestión de pedidos (OMS) |
| Sin historial de entradas de inventario | Movimientos de stock (entradas, salidas, ajustes) | ERP / WMS |

---

*Generado como parte del proyecto TiendaLatam — portafolio de Product Management.*