# TiendaLatam — Análisis de Growth & Retención

Análisis end-to-end del pivote estratégico de TiendaLatam: una empresa de retail que comenzó con tiendas presenciales y ha migrado su operación a un modelo 100% digital en 10 países de Latinoamérica. El proyecto identifica palancas de crecimiento, analiza retención de clientes y construye un dashboard ejecutivo en Looker Studio.

## El problema de negocio

TiendaLatam es una empresa de retail que nació como cadena de tiendas presenciales y ha completado su transición a un modelo 100% digital en 10 países de Latinoamérica (Argentina, Bolivia, Brasil, Chile, Colombia, Costa Rica, Ecuador, México, Perú y Uruguay). Sus tiendas se reconvirtieron en centros de distribución logística —uno por país— eliminando el costo del modelo presencial para trasladarlo al precio. Para el 2026, el equipo directivo está formalizando este pivote con una estrategia orientada a competir exclusivamente por precio online. El análisis busca responder tres preguntas clave:

1. ¿De dónde viene el crecimiento real y dónde estamos perdiendo clientes?
2. ¿Qué segmentos de clientes generan más valor a largo plazo (LTV) y cuáles están en riesgo de churn?
3. ¿Qué decisiones de producto, pricing y operación pueden tomarse con los datos actuales?

## Stack técnico

| Capa | Herramienta | Por qué |
|------|------------|---------|
| Almacenamiento + SQL | Google BigQuery (sandbox gratis) | Data warehouse serverless, sin instalación, SQL estándar |
| Visualización | Looker Studio | BI tool gratuita de Google, conector nativo a BigQuery, dashboards compartibles vía link público |

Ver `ARCHITECTURE.md` para el diagrama completo del flujo de datos.

## Estructura del repositorio

```
proyecto-tiendalatam/
├── README.md                       # Este archivo
├── ROADMAP.md                      # Plan de ejecución de 5 días
├── ARCHITECTURE.md                 # Cómo está montado el proyecto técnicamente
├── data_expanded/                  # CSVs del dataset (11 tablas, ~17k filas)
├── sql/
│   ├── setup_views.sql             # Vistas analíticas para Looker Studio
│   ├── schema.sql                  # DDL Postgres (referencia, no usado)
│   ├── exploratory.sql             # Exploración inicial
│   ├── growth_metrics.sql          # KPIs de crecimiento
│   ├── retention_rfm.sql           # Cohortes y segmentación RFM
│   └── more_insights.sql           # Preguntas de Product Management
└── docs/
    ├── setup_bigquery.md           # Guía paso a paso de setup
    ├── data_model.md               # Diccionario de datos
    ├── business_questions.md       # Las 15 preguntas que responde el proyecto
    ├── findings_preliminary.md     # Resultados ejecutados contra los datos reales
    └── dashboard_design.md         # Estructura del dashboard en Looker Studio
```

## Dataset

| Tabla | Filas | Descripción |
|-------|-------|-------------|
| clients | 700 | Clientes activos e inactivos, segmentados por tipo |
| orders | 4,000 | Pedidos entre julio 2021 y abril 2026 |
| order_details | 12,279 | Líneas de pedido con cantidad y precio unitario |
| products | 50 | Catálogo de productos en 8 categorías |
| employees | 20 | Equipo de ventas distribuido en 10 países |
| locations | 10 | Puntos de distribución logística, uno por país LATAM |
| categories | 8 | Tecnología, Hogar, Moda, Belleza, Alimentos, Deportes, Juguetería, Papelería |
| client_types | 4 | Minorista, Mayorista, Corporativo, VIP |
| order_statuses | 6 | Pendiente, Procesando, Enviado, Entregado, Cancelado, Devuelto |
| countries | 10 | Países LATAM |
| positions | 5 | Cargos del equipo |

## Hallazgos principales

Tres hallazgos validados contra los datos:

- **132 clientes Champions generan el 56.4% del revenue** total — concentración de valor más pronunciada que la regla de Pareto clásica.
- **Ecuador y Perú lideran en revenue** ($195K y $183K respectivamente), pero **Argentina tiene el AOV más alto** ($563) a pesar de tener menos órdenes.
- **Churn rate de 25.3%** y mediana de **74 días al 2do pedido** — la ventana de re-engagement es más corta de lo habitual, lo que favorece campañas de activación tempranas.

Detalles en `docs/findings_preliminary.md`.

## Cómo replicarlo

1. Crear una cuenta Google Cloud (gratis, sin tarjeta).
2. Seguir `docs/setup_bigquery.md` para crear el proyecto `tiendalatam-casestudy` y cargar los CSVs de `data_expanded/`.
3. Ejecutar `sql/setup_views.sql` para crear las vistas analíticas.
4. Ejecutar las consultas exploratorias y de análisis (`sql/exploratory.sql`, `sql/growth_metrics.sql`, `sql/retention_rfm.sql`, `sql/more_insights.sql`).
5. Conectar Looker Studio a las vistas y construir el dashboard siguiendo `docs/dashboard_design.md`.

## Sobre la autora

Diana Mildred — Product Manager. Este proyecto forma parte de mi portafolio profesional.
