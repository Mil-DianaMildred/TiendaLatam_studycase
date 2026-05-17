# Roadmap
falta descripcion del roadmap, aclarar que el mi framewotk y el caso de uso
---
## Setup y exploración (Foundation)

**Objetivo:** montar BigQuery, cargar los datos, hacer la primera exploración y contextualización.

Tareas:
- ✅ Crear cuenta de Google Cloud (gratis, sin tarjeta) y proyecto `tiendalatam-casestudy`. Seguir `docs/setup_bigquery.md` paso a paso.
- ✅ Activar BigQuery sandbox y crear el dataset `tiendalatam`.
- ✅ Cargar los CSVs de `data_expanded/` con autodetección de esquema.
- ✅ Generar con AI un plan de EDA y ejecutarlo. `sql/03_exploratory.sql` — 6 queries que dan el panorama general: volumen, fechas, distribución de status y productos top.
- ✅ Crear con AI un `product-growth-metrics-ref` para mapear el universo ideal de métricas según el tipo de producto y evaluar el potencial de la data existente.
- ✅ Documenta las consideraciones de negocio sobre cómo se calculan las métricas. Por ejemplo, algunas empresas calculan el revenue solo con órdenes en status `entregado`, otras incluyen también `enviado`. Asegúrate de tener claridad en cada métrica y documenta los matices relevantes para que sean tenidos en cuenta durante el procesamiento con AI. `CLAUDE`
- ✅ Generar con AI `findings_preliminary`: analiza los hallazgos, documenta las observaciones iniciales y las preguntas que surgen `my_notes`.
- Hacer discovery sobre los puntos que consideres mas relevantes para el objetivo al que quieres llegar, un par de sessiones con alguien que conozca en profundidad mejorara la calidad de tus insights

> **Tip:** Tómate el tiempo para este paso. Sentirse perdido aquí es normal — es mucha información para un cerebro humano, pero no para la AI. Apóyate en ella para resolver dudas, generar queries rápidos o pedir datos ya procesados. Todo va cobrando sentido a medida que pasas más tiempo con la data y construyes contexto.

---

## Data Strategy - Definiciones 
Framework: Product Strategy Stack

Con base a la data que se tiene
que quiere hacer el negocion, compamy vision
cual es tu rol en la compania
hay algun objetivo en specifico?


---

## Día 2 — Métricas de Growth

**Objetivo:** responder las preguntas de crecimiento del negocio.

Tareas:
- Ejecutar `sql/04_growth_metrics.sql`: MoM revenue growth, ticket promedio, nuevos clientes vs recurrentes, performance por país y por canal.
- Calcular la North Star Metric candidata. Mi recomendación para retail digital: "ingresos generados por clientes recurrentes en los últimos 90 días". Justifica por qué la elegiste.
- Identificar los 3 países con mejor performance y los 3 con peor, y formular hipótesis del porqué.

Entregable: archivo `docs/business_questions.md` actualizado con respuestas a las preguntas Q1-Q5 y una primera versión de tu North Star Metric.

Tiempo estimado: 3-4 horas.

Tip PM: no te quedes en "Argentina vendió X". Avanza a "Argentina creció X% pero su ticket promedio bajó Y%, lo cual sugiere que estamos vendiendo más unidades pero más baratas — vale la pena revisar el mix de categorías". En un modelo online, también pregunta: ¿hay diferencias en el canal de adquisición o en el comportamiento de compra digital entre países?

---

## Día 3 — Retención, cohortes y RFM

**Objetivo:** este es el corazón del proyecto y lo que más impresiona en una entrevista de PM.

Tareas:
- Ejecutar `sql/05_retention_rfm.sql`: análisis de cohortes mensuales (porcentaje de clientes que vuelven a comprar en mes 1, 3, 6, 12), segmentación RFM (Recency, Frequency, Monetary) y churn rate por segmento.
- Construir el perfil de los 8 segmentos RFM: Champions, Loyal, At Risk, New/Promising, About to Sleep, Needs Attention, Hibernating, Lost. Calcular cuántos hay, cuánto facturan y qué porcentaje del revenue total representan. (Referencia: Champions son 132 clientes que concentran el 56.4% del revenue.)
- Calcular LTV promedio por tipo de cliente (Minorista, Mayorista, Corporativo, VIP).

Entregable: tabla de cohortes lista para visualizar, segmentación RFM con cada cliente etiquetado, y 3 recomendaciones de producto basadas en los hallazgos.

Tiempo estimado: 4-5 horas.

Tip PM: termina este día con una respuesta concreta a "si fueras PM de TiendaLatam, ¿qué propondrías como próximo experimento de retención en un canal 100% digital?". Esa respuesta es oro en una entrevista.

---

## Día 4 — Dashboard en Looker Studio

**Objetivo:** materializar los hallazgos en un dashboard ejecutivo publicado en la nube.

Tareas:
- Abrir Looker Studio (lookerstudio.google.com) con la misma cuenta de Google.
- Conectar como fuentes de datos las 5 vistas que creamos en BigQuery: `v_orders_enriched`, `v_order_lines`, `v_rfm_segments`, `v_cohort_retention`, `v_monthly_metrics`.
- Construir 4 páginas siguiendo `docs/dashboard_design.md`:
  1. **Resumen Ejecutivo** — KPIs principales (Revenue, Órdenes, AOV, Clientes Activos), tendencia mensual y mapa de revenue por país.
  2. **Growth** — MoM growth, nuevos vs recurrentes, retención mes-1.
  3. **Producto** — Top categorías, treemap por producto, ABC analysis, alertas de stock.
  4. **Clientes (RFM)** — Distribución de segmentos, heatmap de cohortes, lista de clientes en riesgo.
- Añadir filtros globales: país, rango de fechas, tipo de cliente.
- Aplicar la paleta de colores definida en `docs/dashboard_design.md`.
- Crear al menos 2 campos calculados (% Cancelación, Es Champion) para mostrar dominio de la herramienta.

Entregable: dashboard publicado con link público + 4 capturas para el sitio web.

Tiempo estimado: 4-5 horas.

Tip PM: pon títulos con conclusión, no descriptivos. En vez de "Revenue por mes", escribe "Abril 2026 fue el mejor mes con $220K — crecimiento sostenido desde 2021".

---

## Día 5 — Storytelling y publicación

**Objetivo:** convertir el proyecto en una pieza de portafolio digna de un PM senior.

Tareas:
- Escribir el caso de estudio para tu sitio web siguiendo esta estructura:
  - **Contexto** — ¿qué es TiendaLatam y por qué importa el problema?
  - **Tu rol** — Te posicionas como PM hipotético del negocio.
  - **Preguntas que respondiste** — Las 15 preguntas con un teaser de cada respuesta.
  - **Hallazgos clave** — 3-5 insights con visual de soporte.
  - **Recomendaciones de producto** — 3 features o experimentos propuestos con priorización (RICE o ICE).
  - **Qué haría diferente con más tiempo** — Mostrar criterio.
- Publicar el dashboard de Looker Studio con "Cualquier persona con el enlace puede ver" + copiar link.
- Embebir el iframe en tu sitio web (botón Compartir → Insertar informe).
- Crear repo de GitHub público con el código SQL y el README.
- Publicar el caso de estudio en tu website con el dashboard incrustado.

Entregable: caso de estudio publicado + repo de GitHub + dashboard accesible.

Tiempo estimado: 4-5 horas.

Tip PM: el storytelling pesa más que la técnica. Un análisis perfecto sin narrativa pasa desapercibido; un análisis bueno con narrativa clara abre puertas. Cuando escribas, piensa en un reclutador que dedica 90 segundos a tu portafolio.

---

## Cómo este proyecto fortalece tu perfil PM

Lo que demuestra cada parte:

| Skill PM | Dónde lo demuestras |
|----------|---------------------|
| Data fluency | Queries SQL no triviales (cohortes, RFM, ventanas) |
| Definición de métricas | North Star Metric justificada + KPI hierarchy |
| Pensamiento de negocio | Hallazgos accionables, no descripciones |
| Segmentación de usuarios | RFM + caracterización de personas |
| Priorización | Frameworks RICE/ICE en las recomendaciones |
| Storytelling | Caso de estudio en website |
| Stakeholder communication | Dashboard ejecutivo con jerarquía clara |

## Extensiones opcionales (si te sobra tiempo)

- Crear un PRD ficticio para 1 de las 3 recomendaciones de producto.
- Diseñar un experimento A/B para validar una hipótesis de retención.
- Hacer un análisis competitivo de TiendaLatam vs tiendas locales de cada país y vs players regionales (Mercado Libre, Falabella, Linio) — el diferenciador clave es precio.
- Construir un funnel ficticio (visitas → carrito → checkout → entregado) e identificar el cuello de botella.
- Forecast simple de revenue con función LAG/LEAD o regresión lineal en Power BI.


??? Ejecutar `sql/01_setup_views.sql` para crear las 5 vistas analíticas.

![alt text](image.png)

