# Las 15 preguntas que responde este proyecto

Cada pregunta está vinculada al archivo SQL donde se resuelve y al panel del dashboard donde se visualiza. Cuando termines el análisis, vuelve aquí y agrega tus respuestas con números reales — eso es lo que vas a contar en el caso de estudio.

## Bloque 1 — Exploración (sql/03_exploratory.sql)

**E1. ¿Qué volumen maneja el negocio y en qué ventana de tiempo?**
Respuesta esperada: revenue total, # órdenes, # clientes únicos, AOV global, ventana de fechas.

**E2. ¿Qué tan saludable es la operación según los estados de pedido?**
Foco: % entregado, % cancelado, % devuelto. Si cancelado + devuelto > 10% hay una alerta operativa.

**E3. ¿Cuáles son los 5 países con mayor revenue?**
Foco: ranking, gap entre #1 y #5, oportunidad de expansión.

**E4. ¿Cuáles son los productos top y a qué categoría pertenecen?**
Foco: ¿hay concentración en pocas categorías? ¿algún producto único arrastra el resto?

**E5. ¿Cómo se distribuyen los clientes por tipo y país?**
Foco: identificar países sobre-indexados en mayoristas vs minoristas — sirve para estrategia comercial.

**E6. ¿Qué productos no han vendido nunca?**
Foco: catálogo muerto, candidatos a descatalogación o relanzamiento con bundling.

---

## Bloque 2 — Growth (sql/04_growth_metrics.sql)

**Q1. ¿Cómo ha evolucionado el revenue mes a mes? ¿Estamos creciendo?**
Métrica: MoM growth %. Identifica meses con caída fuerte y meses pico (Q4 / temporada de fin de año).

**Q2. ¿El AOV difiere entre tipos de cliente y cómo evoluciona?**
Hipótesis a validar: corporativos y VIP deberían tener AOV mucho mayor que minoristas.

**Q3. ¿Qué % del revenue viene de clientes nuevos vs recurrentes?**
Pregunta clave de Growth PM. Un negocio sano tiene cada vez más revenue de recurrentes en términos absolutos.

**Q4. ¿Qué país tiene la mejor y peor performance, y por qué?**
Cruza revenue con % de cancelaciones/devoluciones. Un país puede vender mucho pero tener mala calidad operativa.

**Q5. ¿Qué categorías de producto crecen y cuáles estancan?**
Decisión: dónde invertir en el catálogo digital, dónde reducir SKUs.

---

## Bloque 3 — Retención (sql/05_retention_rfm.sql)

**Q6. ¿Cuál es la curva de retención por cohort mensual?**
La pregunta más importante del bloque. Identifica si la retención mejora con el tiempo (señal de PMF) o degrada.

**Q7. ¿Cómo se segmentan los clientes con RFM?**
Etiquetar a cada uno de los 636 clientes compradores en un segmento accionable (Champions, At Risk, etc.).

**Q8. ¿Qué % del revenue viene de cada segmento RFM?**
Casi siempre 20% de clientes (Champions + Loyal) generan 70-80% del revenue. Cuantifícalo.

**Q9. ¿Cuál es el LTV promedio por tipo de cliente?**
Hipótesis: Mayoristas y Corporativos tienen 5-10x el LTV de Minoristas. Si no es así, hay un problema de captura de valor.

**Q10. ¿Cuál es la tasa de churn actual?**
Definición sencilla: % de clientes sin compra en los últimos 180 días.

---

## Bloque 4 — PM Insights (sql/06_pm_insights.sql)

**Q11. ¿Cuál es la curva ABC del catálogo? (Pareto)**
¿Qué % de productos generan el 80% del revenue? Decisión: focus de marketing, simplificación del catálogo.

**Q12. ¿Cómo es el performance individual del equipo de ventas?**
Identifica top performers (¿hacer mentoring/escalar prácticas?) y bottom (¿necesitan apoyo?).

**Q13. ¿Qué productos están en riesgo de quiebre de stock?**
Alerta operativa. Demuestra que un PM piensa en supply chain, no solo en features.

**Q14. ¿Qué productos se compran juntos? (Market basket analysis)**
Insumo para bundles, recomendaciones cross-sell y diseño de la sección "compraron también".

**Q15. ¿Cuántos días tarda un cliente en hacer su 2da compra?**
Una de las métricas de onboarding más subestimadas. Permite definir cuándo enviar campañas de re-engagement.

---

## Plantilla para tu caso de estudio

Para cada pregunta, anota en una tabla:

| Pregunta | Hallazgo principal | Implicación para el negocio | Recomendación |
|----------|---------------------|------------------------------|----------------|
| Q1 | (tu número aquí) | (qué significa) | (qué harías) |
| ... | ... | ... | ... |

De esta tabla saldrán los 3-5 insights estrella del dashboard y las 3 recomendaciones de producto del caso de estudio.

## Frameworks PM que aplica este proyecto

- **North Star Metric**: candidatas — Revenue de recurrentes (90d), # de clientes activos mensuales, AOV de Champions.
- **AARRR (Pirate Metrics)**: aunque no hay datos de "Acquisition" puros, sí se puede analizar Activation (1ra compra), Retention (cohortes), Revenue (LTV), Referral (no disponible aquí).
- **RICE / ICE Scoring**: úsalo en las recomendaciones finales del caso de estudio para priorizar.
- **JTBD (Jobs to be Done)**: el análisis RFM permite hipotetizar qué "job" contrata cada segmento — los Mayoristas contratan "abastecer mi tienda", los Minoristas "resolver una necesidad puntual".
