# TiendaLatam — Análisis de Growth & Retención

Análisis end-to-end de una empresa tecnológica de retail 100% online con operaciones en 10 países de Latinoamérica, enfocado en identificar palancas de crecimiento, mejorar la retención de clientes y construir un dashboard ejecutivo en Looker Studio.

## El problema de negocio

TiendaLatam es una empresa tecnológica de retail que opera exclusivamente a través de canales digitales en Argentina, Bolivia, Brasil, Chile, Colombia, Costa Rica, Ecuador, México, Perú y Uruguay. No cuenta con tiendas físicas — su modelo se apoya en puntos de distribución logística por país. Su propuesta de valor es ofrecer la mejor relación calidad–precio del mercado, compitiendo directamente con tiendas locales mediante precios significativamente más competitivos. El equipo directivo necesita responder tres preguntas:

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
│   ├── 01_setup_views.sql          # Vistas analíticas para Looker Studio
│   ├── 01_schema.sql               # DDL Postgres (referencia, no usado)
│   ├── 03_exploratory.sql          # Exploración inicial
│   ├── 04_growth_metrics.sql       # KPIs de crecimiento
│   ├── 05_retention_rfm.sql        # Cohortes y segmentación RFM
│   └── 06_pm_insights.sql          # Preguntas de Product Management
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
3. Ejecutar `sql/01_setup_views.sql` para crear las vistas analíticas.
4. Ejecutar las consultas exploratorias y de análisis (`sql/03` a `sql/06`).
5. Conectar Looker Studio a las vistas y construir el dashboard siguiendo `docs/dashboard_design.md`.

## Sobre la autora

Diana Mildred — Product Manager. Este proyecto forma parte de mi portafolio profesional.
