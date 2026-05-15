# Roadmap — 5 días

Este plan está diseñado para terminar el proyecto en una semana laboral (3-5 días intensos o ~2 horas diarias por una semana). Cada día tiene un entregable claro y un "by end of day you should have".

Pensamiento de fondo: este proyecto no es un ejercicio de SQL, es un caso de estudio de Product Management. Cada query debe responder a una pregunta de negocio, y cada visual del dashboard debe llevar a una decisión accionable.

---

## Día 1 — Setup y exploración (Foundation)

**Objetivo:** montar BigQuery, cargar los datos y hacer la primera exploración.

Tareas:
- Crear cuenta de Google Cloud (gratis, sin tarjeta) y proyecto `tiendalatam-casestudy`. Seguir `docs/setup_bigquery.md` paso a paso.
- Activar BigQuery sandbox y crear el dataset `tiendalatam`.
- Cargar los 11 CSVs con autodetección de esquema (~15 min).
- Ejecutar `sql/01_setup_views.sql` para crear las 5 vistas analíticas.
- Ejecutar `sql/03_exploratory.sql` — 6 queries que te dan el panorama: volumen, fechas, distribución de status, productos top.
- Documentar 3-5 observaciones iniciales en una nota.

Entregable: BigQuery con datos cargados, vistas funcionando, primera lista de observaciones.

Tiempo estimado: 2-3 horas.

---

## Día 2 — Métricas de Growth

**Objetivo:** responder las preguntas de crecimiento del negocio.

Tareas:
- Ejecutar `sql/04_growth_metrics.sql`: MoM revenue growth, ticket promedio, nuevos clientes vs recurrentes, performance por país y por categoría.
- Calcular la North Star Metric candidata. Mi recomendación para retail: "ingresos generados por clientes recurrentes en los últimos 90 días". Justifica por qué la elegiste.
- Identificar los 3 países con mejor performance y los 3 con peor, y formular hipótesis del porqué.

Entregable: archivo `docs/business_questions.md` actualizado con respuestas a las preguntas Q1-Q5 y una primera versión de tu North Star Metric.

Tiempo estimado: 3-4 horas.

Tip PM: no te quedes en "Argentina vendió X". Avanza a "Argentina creció X% pero su ticket promedio bajó Y%, lo cual sugiere que estamos vendiendo más unidades pero más baratas — vale la pena revisar el mix de categorías".

---

## Día 3 — Retención, cohortes y RFM

**Objetivo:** este es el corazón del proyecto y lo que más impresiona en una entrevista de PM.

Tareas:
- Ejecutar `sql/05_retention_rfm.sql`: análisis de cohortes mensuales (porcentaje de clientes que vuelven a comprar en mes 1, 3, 6, 12), segmentación RFM (Recency, Frequency, Monetary) y churn rate por segmento.
- Construir el perfil de tus 4 segmentos de clientes: Champions, Loyal, At-Risk, Lost. Calcular cuántos hay, cuánto facturan y qué porcentaje del revenue total representan.
- Calcular LTV promedio por tipo de cliente (Minorista, Mayorista, Corporativo, VIP).

Entregable: tabla de cohortes lista para visualizar, segmentación RFM con cada cliente etiquetado, y 3 recomendaciones de producto basadas en los hallazgos.

Tiempo estimado: 4-5 horas.

Tip PM: termina este día con una respuesta concreta a "si fueras PM de TiendaLatam, ¿qué propondrías como próximo experimento de retención?". Esa respuesta es oro en una entrevista.

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

Tip PM: pon títulos con conclusión, no descriptivos. En vez de "Revenue por mes", escribe "Diciembre 2025 fue el mejor mes con +94% MoM".

---

## Día 5 — Storytelling y publicación

**Objetivo:** convertir el proyecto en una pieza de portafolio digna de un PM senior.

Tareas:
- Escribir el caso de estudio para tu sitio web siguiendo esta estructura:
  - **Contexto** — ¿qué es TiendaLatam y por qué importa el problema?
  - **Tu rol** — Te posicionas como PM hipotético del negocio.
  - **Preguntas que respondiste** — Las 12 preguntas con un teaser de cada respuesta.
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


## Extensiones opcionales (si te sobra tiempo)

- Crear un PRD ficticio para 1 de las 3 recomendaciones de producto.
- Diseñar un experimento A/B para validar una hipótesis de retención.
- Hacer un análisis competitivo de TiendaLatam vs Mercado Libre / Falabella / Linio.
- Construir un funnel ficticio (visitas → carrito → checkout → entregado) e identificar el cuello de botella.
- Forecast simple de revenue con función LAG/LEAD o regresión lineal en Power BI.
