# Las preguntas de negocio a responder

intro pending

---

## Bloque 1 — Exploración (`sql/03_exploratory.sql`)

**E1. ¿Qué volumen maneja el negocio y en qué ventana de tiempo?**

Métricas a responder: GMV total, revenue total, diferencia GMV vs revenue (% y valor absoluto), # órdenes totales, # órdenes válidas, # clientes únicos, AOV global, ventana de fechas.

Preguntas adicionales de negocio:
- ¿La diferencia entre GMV y revenue ($485K, 24.8%) es normal para retail LATAM? ¿Qué porcentaje corresponde a cancelaciones vs devoluciones vs órdenes en tránsito?
- ¿En qué moneda están expresados los montos? ¿Todos los puntos de distribución operan en la misma moneda base? ¿Hay algún efecto cambiario que deba documentarse?
- ¿Todos los puntos de distribución se lanzaron simultáneamente o en fechas distintas? Esto afecta directamente la comparación de revenue entre países.

Respuesta:

| Métrica | Valor |
|---|---|
| Total órdenes | 4,000 |
| Órdenes válidas (entregadas) | 3,045 |
| Clientes únicos registrados | 700 |
| Clientes con al menos 1 compra | 636 |
| Primera orden | 2021-07-01 |
| Última orden | 2026-04-29 |
| GMV | $1,958,767.55 |
| Revenue | $1,473,497.20 |
| AOV global | $489.69 |
| Sucursales | 10 |

---

**E2. ¿Qué tan saludable es la operación según los estados de pedido?**

Foco: % entregado, % cancelado, % devuelto. Si cancelado + devuelto > 10% hay una alerta operativa.

Preguntas adicionales de negocio:
- El 63.5% de entrega parece bajo para una operación de 5 años. ¿Está explicado por órdenes recientes aún en tránsito (12.6% en Enviado + 8.8% en Procesando)?
- ¿Qué significa operacionalmente que una orden esté en "Pendiente" (7.4%)? ¿Hay un SLA definido antes de que se escale a cancelación? ¿Qué impacto tiene en el customer service y en la retención?
- El 5.1% de cancelaciones: ¿hay patrones por país, categoría, tipo de cliente o rango de precio? Una cancelación en Tecnología tiene un impacto económico muy diferente a una en Alimentos.
- El 2.6% de devoluciones: ¿la razón de devolución está capturada en algún campo? ¿Hay categorías con devolución sistémica?

Respuesta:

| Status | Órdenes | % Share |
|---|---:|---:|
| Entregado | 2,542 | 63.5% |
| Enviado | 503 | 12.6% |
| Procesando | 350 | 8.8% |
| Pendiente | 296 | 7.4% |
| Cancelado | 203 | 5.1% |
| Devuelto | 106 | 2.6% |

Cancelado + devuelto = **7.7%** — dentro del rango aceptable, pero vale segmentar por país y categoría.

---

**E3. ¿Cuáles son los 5 países con mayor revenue y cuál es el gap entre ellos?**

Foco: ranking completo, diferencia entre el #1 y el #5, identificar mercados sub-representados con potencial.

Preguntas adicionales de negocio:
- ¿Cuáles son las diferencias fundamentales entre el performance de Ecuador vs Colombia (el tope y el fondo)? ¿Hay diferencias en la operación local, el catálogo disponible, la estrategia comercial o el perfil de cliente?
- Argentina tiene el AOV más alto ($563) pero no lidera en órdenes. ¿Su mix de clientes tiene mayor proporción de Mayoristas/Corporativos, o compran más productos de Tecnología de ticket alto?
- Colombia es uno de los mercados retail más grandes de LATAM y aparece último en revenue. ¿Es un problema de penetración (pocos clientes) o de valor por cliente (bajo AOV)?

Respuesta:

| País | Órdenes | Revenue | AOV |
|---|---:|---:|---:|
| Ecuador | 387 | $195,579 | $505 |
| Perú | 353 | $183,410 | $520 |
| Bolivia | 344 | $173,122 | $503 |
| Chile | 389 | $171,888 | $442 |
| Argentina | 254 | $143,076 | $563 |
| Brasil | 328 | $139,890 | $426 |
| México | 292 | $136,554 | $468 |
| Uruguay | 246 | $118,538 | $482 |
| Costa Rica | 228 | $115,579 | $507 |
| Colombia | 224 | $95,861 | $428 |

---

**E4. ¿Cuáles son los productos top y a qué categoría pertenecen?**

Foco: concentración de revenue en pocos productos, categorías que arrastran el total, ratio unidades vs revenue.

Preguntas adicionales de negocio:
- La Laptop Ultraliviana 14 (producto #2) representa el 33.2% del revenue total ella sola. ¿Qué riesgo operativo implica esta concentración? ¿Qué pasa con el negocio si hay un problema de stock o de proveedor en ese SKU?
- Los 2 productos de Tecnología más vendidos (Laptop + Smartphone) acumulan el 46.2% del revenue. ¿Es esto una fortaleza (especialización) o una vulnerabilidad (dependencia)?
- ¿Cuántos productos se necesitan para llegar al 80% del revenue? → Respuesta directa de la curva ABC en Q11.
- El volumen de unidades vendidas es muy similar entre los top 10 (~600-850 unidades cada uno). ¿Qué determina la diferencia de revenue entonces? Principalmente el precio unitario.

---

**E5. ¿Cómo se distribuyen los clientes por tipo y país?**

Foco: países sobre-indexados en mayoristas vs minoristas, oportunidad de upsell de segmento.

Preguntas adicionales de negocio:
- ¿La estrategia actual apunta a crecer en Minoristas (61.7% de la base) o en Corporativos/VIP (20%)? El ICP no está explícito en la data y vale la pena formular una hipótesis.
- VIP son solo 60 clientes (8.6% de la base) pero ¿qué % del revenue generan? Si es menor al esperado, hay un problema de captura de valor o de definición del segmento.
- ¿Hay países donde el % de Mayoristas es significativamente mayor? Eso indicaría diferencias en el modelo de go-to-market local.

Respuesta:

| Tipo de Cliente | Clientes | Órdenes | Revenue | % Revenue |
|---|---:|---:|---:|---:|
| Minorista | 392 | 1,908 | $935,941 | 63.52% |
| Mayorista | 118 | 527 | $235,986 | 16.02% |
| Corporativo | 74 | 354 | $179,496 | 12.18% |
| VIP | 52 | 256 | $122,074 | 8.28% |

---

**E6. ¿Qué productos no han vendido nunca?**

Resultado: **no hay productos sin ventas** en el catálogo actual. Todos los 50 SKUs tienen al menos una unidad vendida. Esto significa que el problema no es catálogo muerto sino catálogo de bajo rendimiento relativo (ver curva ABC en Q11).

---

## Bloque 2 — Revenue y Growth (`sql/04_growth_metrics.sql`)

**Q1. ¿Cómo ha evolucionado el revenue mes a mes? ¿Estamos creciendo?**

Métrica: MoM growth %. Identifica meses con caída fuerte y meses pico.

Preguntas adicionales de negocio:
- 2026 ya casi iguala todo el revenue de 2025 con solo 4 meses de datos. ¿Es esto aceleración real o hay fechas incorrectas en la ingesta? Validar en BigQuery que los registros de 2026 tienen timestamps coherentes.
- ¿Hay estacionalidad visible? ¿Q4 (Nov-Dic) muestra picos asociados a temporada de fin de año en LATAM?
- ¿Qué meses tuvieron caídas y qué los explica? ¿Hay correlación con eventos macroeconómicos en la región (inflación en AR, BR)?

Respuesta:

| Año | Revenue | Órdenes válidas |
|---|---|---|
| 2021 | $1,248 | 4 |
| 2022 | $13,046 | 34 |
| 2023 | $71,700 | 132 |
| 2024 | $205,382 | 401 |
| 2025 | $607,340 | 1,244 |
| 2026 (parcial) | $574,782 | 1,230 |

---

**Q2. ¿El AOV difiere entre tipos de cliente y cómo evoluciona en el tiempo?**

Hipótesis a validar: Corporativos y VIP deberían tener AOV significativamente mayor que Minoristas. Si no es así, hay un problema de captura de valor o los segmentos no están bien definidos.

Preguntas adicionales de negocio:
- ¿El AOV de Mayoristas justifica la inversión en ese segmento? ¿Compran más unidades por orden (volumen) o productos de mayor precio?
- ¿El AOV de los 10 países tiene varianza real o es ruido estadístico? Con 224 órdenes (Colombia) vs 389 (Chile), ¿son comparables?

---

**Q3. ¿Qué % del revenue viene de clientes nuevos vs recurrentes?**

Pregunta clave de Growth PM. Un negocio sano tiene cada vez más revenue de recurrentes en términos absolutos. La tendencia importa más que el snapshot puntual.

Preguntas adicionales de negocio:
- ¿En qué mes o año el revenue de recurrentes superó al de nuevos por primera vez? Ese punto es el de inflexión hacia un modelo sostenible.
- ¿Hay países donde el revenue de recurrentes es desproporcionadamente bajo? Ese sería el mercado con peor retención y mayor urgencia de intervención.

---

**Q4. ¿Qué país tiene la mejor y peor performance operativa y de revenue?**

Cruza revenue con % de cancelaciones/devoluciones. Un país puede vender mucho pero tener mala calidad operativa que erosione el margen y la satisfacción del cliente.

Preguntas adicionales de negocio:
- ¿Ecuador lidera en revenue pero tiene también mayor tasa de cancelación? Si es así, el revenue neto real podría estar más cerca de Perú.
- ¿Hay algún país donde las devoluciones sean sistemáticamente más altas? Eso podría señalar un problema logístico local, un mix de productos diferente o expectativas de cliente no alineadas.

---

**Q5. ¿Qué categorías de producto crecen y cuáles se estancan?**

Decisión de producto: dónde invertir en el catálogo digital, dónde reducir SKUs, dónde hay oportunidad de expansión de catálogo.

Dato clave a evaluar: Tecnología concentra el 74% del revenue con ~16% de las unidades. Alimentos tiene alto volumen de unidades con revenue mínimo. ¿Cuál es el rol estratégico de cada categoría?

| Categoría | Revenue | % Revenue | Unidades |
|---|---|---|---|
| Tecnología | $1,091,259 | 74.1% | 6,037 |
| Hogar | $316,993 | 21.5% | 5,172 |
| Moda | $183,381 | 12.4% | 5,109 |
| Belleza | $113,696 | 7.7% | 4,546 |
| Deportes | $101,840 | 6.9% | 4,456 |
| Juguetería | $94,753 | 6.4% | 3,591 |
| Alimentos | $37,354 | 2.5% | 5,123 |
| Papelería | $19,492 | 1.3% | 2,951 |

---

## Bloque 3 — Retención (`sql/05_retention_rfm.sql`)

**Q6. ¿Cuál es la curva de retención por cohorte mensual?**

La pregunta más importante del bloque. Identifica si la retención mejora con el tiempo (señal de product-market fit) o degrada (señal de que el crecimiento es artificial).

Preguntas adicionales de negocio:
- ¿La retención en el mes 1 (primer recompra) está mejorando en las cohortes más recientes? Una mejora sostenida indica que el producto se está volviendo más sticky.
- ¿Hay cohortes específicas con retención excepcionalmente alta o baja? Identificarlas puede revelar qué condiciones (época del año, campaña, país) favorecen la retención.
- ¿A partir de qué mes la curva de retención se estabiliza? Ese es el núcleo leal del negocio.

---

**Q7. ¿Cómo se segmentan los clientes con RFM?**

Etiquetar a cada uno de los 636 clientes compradores en un segmento accionable.

Respuesta:

| Segmento | Clientes | Revenue | % Revenue |
|---|---|---|---|
| **Champions** | 132 | $831,442 | **56.4%** |
| Loyal | 109 | $295,228 | 20.0% |
| At Risk | 64 | $160,325 | 10.9% |
| New/Promising | 73 | $47,787 | 3.2% |
| About to Sleep | 24 | $37,772 | 2.6% |
| Needs Attention | 68 | $35,026 | 2.4% |
| Lost | 146 | $34,819 | 2.4% |
| Hibernating | 20 | $31,099 | 2.1% |

---

**Q8. ¿Qué % del revenue viene de cada segmento RFM?**

Insight principal: **132 Champions (20.8% de la base activa) generan el 56.4% del revenue**. Champions + Loyal (241 clientes, 37.9%) acumulan el 76.4% del revenue — superando la regla 80/20 clásica.

Insight secundario: At Risk + Hibernating + Lost = 230 clientes que han generado ~$226K en revenue histórico y hoy tienen baja actividad. Esa es la oportunidad de retención más clara del negocio.

Preguntas adicionales de negocio:
- ¿Qué tipo de cliente (Minorista, Mayorista, Corporativo, VIP) concentra más Champions? Si la mayoría son Minoristas, hay una oportunidad de upsell a segmentos de mayor LTV.
- ¿Los 64 clientes "At Risk" han comprado en los últimos 90-120 días? Si es así, aún son recuperables con una campaña de retención a corto plazo.

---

**Q9. ¿Cuál es el LTV promedio por tipo de cliente?**

Hipótesis: Mayoristas y Corporativos tienen 3-5x el LTV de Minoristas. Si la diferencia es menor, hay un problema de captura de valor en los segmentos premium.

Preguntas adicionales de negocio:
- ¿Qué tipo de cliente tiene mayor LTV *y* mejor retención? Ese es el segmento estratégico a proteger y expandir.
- ¿Hay clientes Minoristas con LTV comparables a Corporativos? Identificarlos podría revelar candidatos a upsell o a un programa de fidelización diferenciado.

---

**Q10. ¿Cuál es la tasa de churn actual y dónde se concentra?**

Definición: % de clientes sin compra en los últimos 180 días.

Respuesta actual: **25.3%** (161 de 636 compradores activos sin compra en 180 días).

Métricas relacionadas de salud del funnel:
- Clientes registrados que nunca compraron: **64 de 700 (9.1%)** — problema de activación
- Time-to-second-purchase: mediana **74 días** (media: 132 días)
- Clientes con 2+ compras: **389 de 636 (61.2%)**

> **Nota para el dashboard:** El Resumen Ejecutivo debe incluir estas 3 métricas de salud además de los KPIs básicos:
> 1. **Churn rate** (clientes sin compra en últimos 180 días) → actualmente 25.3%
> 2. **Tasa de cancelación + devolución combinada** (status_id 5 y 6) → actualmente 7.7%
> 3. **% de revenue de Champions** (RFM) → actualmente 56.4%

Preguntas adicionales de negocio:
- ¿El churn de 25.3% está concentrado en algún tipo de cliente, categoría de compra o país en particular?
- La mediana de 74 días al 2do pedido indica que el punto de intervención óptimo para campañas de re-engagement es la semana 8-10. ¿Hay actualmente alguna campaña o touchpoint automatizado en ese momento?
- Los 64 clientes que nunca compraron: ¿son cuentas de prueba del sistema, empleados o clientes reales que nunca activaron? Segmentarlos tiene implicaciones muy diferentes.

---

## Bloque 4 — Producto y Operación (`sql/06_pm_insights.sql`)

**Q11. ¿Cuál es la curva ABC del catálogo? (Pareto)**

Preguntas adicionales de negocio:
- ¿Cuántos productos (de 50) se necesitan para cubrir el 80% del revenue? Si son 5 o menos, el catálogo tiene una concentración peligrosa.
- Los 2 productos de Tecnología top (Laptop + Smartphone) ya representan el 46.2% del revenue. ¿Qué sucede con el negocio si hay un desabastecimiento global de ese componente o el proveedor sube precios?
- ¿Los productos de categoría C (Papelería, Alimentos de bajo precio) tienen algún rol estratégico en frecuencia de compra que justifique mantenerlos aunque su revenue sea marginal?

Respuesta parcial (distribución ABC preliminar):

| Clase | Productos | Revenue acumulado |
|---|---|---|
| A (80% del revenue) | ~18 SKUs | $1,571,014 |
| B (siguiente 15%) | ~14 SKUs | ~$294,000 |
| C (último 5%) | ~18 SKUs | ~$93,000 |

---

**Q12. ¿Cómo es el performance individual del equipo de ventas?**

Foco: identificar top performers para escalar sus prácticas e identificar quién necesita apoyo.

Preguntas adicionales de negocio:
- ¿El revenue por empleado está correlacionado con el punto de distribución donde operan (efecto de mercado local) o hay varianza significativa dentro del mismo país?
- ¿Los empleados con mayor revenue tienen también mayor tasa de devolución? Un vendedor que "empuja" ventas puede generar más devoluciones.
- ¿20 empleados para 10 países (2 por tienda en promedio) es suficiente capacidad operativa para el volumen actual de órdenes?

---

**Q13. ¿Qué productos están en riesgo de quiebre de stock?**

Alerta operativa: productos con alta velocidad de venta y stock bajo.

Preguntas adicionales de negocio:
- Para la Laptop Ultraliviana (33.2% del revenue), ¿cuántos días de inventario quedan al ritmo de venta actual? Un quiebre de stock en ese producto solo podría costar cientos de miles en revenue perdido.
- ¿Hay productos de baja rotación con stock alto que estén inmovilizando capital? Esos son candidatos a liquidación o promoción.
- ¿Hay diferencias en el stock disponible por país/tienda, o el inventario está centralizado?

---

**Q14. ¿Qué productos se compran juntos? (Market basket analysis)**

Insumo para: bundles, recomendaciones cross-sell, diseño de la sección "también compraron", y layout de tienda física.

Preguntas adicionales de negocio:
- ¿Las combinaciones de productos más frecuentes cruzan categorías (ej: Tecnología + Accesorios) o se quedan dentro de la misma categoría?
- Si Laptop + Cargador USB-C aparecen juntos frecuentemente, ¿hay una oportunidad de bundle con descuento que aumente el AOV sin reducir el margen en el producto ancla?
- ¿Las combinaciones varían por país o tipo de cliente? Un Mayorista puede tener patrones de compra muy diferentes a un Minorista.

---

**Q15. ¿Cuántos días tarda un cliente en hacer su 2da compra?**

Una de las métricas de onboarding más subestimadas. Define cuándo enviar campañas de re-engagement y qué tan agresivo debe ser el nurturing post-primera compra.

Respuesta: mediana **74 días** (media: 132 días). La mediana es la métrica relevante porque los outliers de clientes que tardaron años en volver sesgan la media.

Preguntas adicionales de negocio:
- ¿El TT2P (time to second purchase) varía por categoría de la primera compra? Un cliente que compra Alimentos en su primera orden probablemente regrese más rápido que uno que compra una Laptop.
- ¿El TT2P varía por tipo de cliente? Un Mayorista puede tener ciclos de recompra más predecibles.
- ¿Hay un punto de corte natural en la distribución (ej: bimodal) que indique dos poblaciones distintas de clientes: los que regresan rápido vs los que tardan mucho?

---

## Plantilla para el caso de estudio

Para cada pregunta, documentar:

| Pregunta | Hallazgo principal | Implicación para el negocio | Recomendación |
|---|---|---|---|
| Q1 | (revenue MoM) | (qué significa) | (qué harías) |
| Q6 | (curva retención) | (señal de PMF) | (experimento propuesto) |
| Q7-Q8 | Champions = 56.4% | Concentración de riesgo | Programa VIP |
| Q10 | Churn 25.3% | Ventana corta: 74 días | Campaña semana 8 |
| Q11 | 2 SKUs = 46.2% | Riesgo de dependencia | Diversificar catálogo A |
| ... | ... | ... | ... |

---

## Las 3 recomendaciones priorizadas (ICE)

| Recomendación | I | C | E | ICE | Justificación |
|---|---|---|---|---|---|
| **1. Programa de retención Champions** | 9 | 9 | 6 | 486 | 132 clientes generan 56% del revenue. Perder 10 Champions = pérdida de ~$63K. |
| **2. Campaña de reactivación At Risk (semana 8)** | 8 | 7 | 8 | 448 | 64 clientes At Risk con LTV alto y actividad decayendo. Email/llamada en día 56-74 = costo bajo, impacto potencial alto. |
| **3. Diversificación de riesgo en catálogo A** | 7 | 6 | 5 | 210 | 2 SKUs concentran el 46.2% del revenue. Incorporar 3-5 productos de Tecnología complementarios reduce el riesgo de dependencia sin canibalizar. |

---

## Frameworks PM que aplica este proyecto

- **North Star Metric candidata:** Revenue de clientes recurrentes en los últimos 90 días. Capta crecimiento sostenible, no solo adquisición.
- **AARRR:** Activation (1ra compra — 9.1% nunca activaron), Retention (cohortes + RFM), Revenue (LTV por segmento). Referral y Acquisition requieren datos externos.
- **RICE / ICE:** aplicado en las 3 recomendaciones arriba.
- **JTBD:** los Champions "contratan" TiendaLatam para abastecimiento recurrente; los At Risk lo contratan para compras puntuales — necesidades diferentes, estrategias de retención diferentes.