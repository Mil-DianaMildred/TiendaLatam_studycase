# TiendaLatam — Análisis de Growth & Retención

Análisis end-to-end de una cadena retail con presencia en 10 países de Latinoamérica, enfocado en identificar palancas de crecimiento, mejorar la retención de clientes y construir un dashboard ejecutivo en Looker Studio.

## El problema de negocio

TiendaLatam opera tiendas físicas en Argentina, Bolivia, Brasil, Chile, Colombia, Costa Rica, Ecuador, México, Perú y Uruguay. El equipo directivo necesita responder tres preguntas:

1. ¿De dónde viene el crecimiento real y dónde estamos perdiendo clientes?
2. ¿Qué segmentos de clientes generan más valor a largo plazo (LTV) y cuáles están en riesgo de churn?
3. ¿Qué decisiones de producto, pricing y operación pueden tomarse con los datos actuales?

Este proyecto entrega 15 consultas SQL accionables, un modelo de cohortes y RFM, y un dashboard ejecutivo en Looker Studio que sintetiza los hallazgos.

## Stack técnico

| Capa | Herramienta | Por qué |
|------|------------|---------|
| Almacenamiento + SQL | Google BigQuery (sandbox gratis) | Data warehouse serverless, sin instalación, SQL estándar |
| Visualización | Looker Studio | BI tool gratuita de Google, conector nativo a BigQuery, dashboards compartibles vía link público |
| Presentación | Tu sitio web | Caso de estudio narrativo + dashboard incrustado vía iframe |

Costo total del proyecto: **$0**.

Ver `docs/architecture.md` para el diagrama completo del flujo de datos.

## Estructura del repositorio

```
proyecto-tiendalatam/
├── README.md                       # Este archivo
├── ROADMAP.md                      # Plan de ejecución de 5 días
├── data/                           # CSVs originales (11 tablas)
├── sql/
│   ├── 01_setup_views.sql          # Vistas analíticas para Looker Studio
│   ├── 01_schema.sql               # DDL Postgres (referencia, no usado)
│   ├── 03_exploratory.sql          # Exploración inicial
│   ├── 04_growth_metrics.sql       # KPIs de crecimiento
│   ├── 05_retention_rfm.sql        # Cohortes y segmentación RFM
│   └── 06_pm_insights.sql          # Preguntas de Product Management
└── docs/
    ├── architecture.md             # Cómo está montado el proyecto técnicamente
    ├── setup_bigquery.md           # Guía paso a paso de setup
    ├── data_model.md               # Diccionario de datos
    ├── business_questions.md       # Las 15 preguntas que responde el proyecto
    ├── findings_preliminary.md     # Resultados ejecutados contra los datos reales
    └── dashboard_design.md         # Estructura del dashboard en Looker Studio
```

## Dataset

| Tabla | Filas | Descripción |
|-------|-------|-------------|
| clients | 149 | Clientes activos e inactivos, segmentados por tipo |
| orders | 299 | Pedidos entre mayo 2022 y abril 2026 |
| order_details | 846 | Líneas de pedido con cantidad y precio unitario |
| products | 49 | Catálogo de productos en 8 categorías |
| employees | 19 | Vendedores distribuidos en 9 tiendas |
| locations | 9 | Tiendas físicas en 10 países LATAM |
| categories | 8 | Tecnología, Hogar, Moda, Belleza, Alimentos, Deportes, Juguetería, Papelería |
| client_types | 4 | Minorista, Mayorista, Corporativo, VIP |
| order_statuses | 6 | Pendiente, Procesando, Enviado, Entregado, Cancelado, Devuelto |
| countries | 10 | Países LATAM |
| positions | 5 | Cargos del equipo |

## Hallazgos principales

Tres hallazgos validados contra los datos:

- **26 clientes Champions generan el 40.2% del revenue** total.
- **Uruguay tiene el AOV más alto** ($741) — 2.4x el de México ($313).
- **44.7% churn rate (180d+)** y **mediana de 163 días al 2do pedido**, lo que sugiere oportunidad clara de campañas de re-engagement.

Detalles en `docs/findings_preliminary.md`.

## Cómo replicarlo

1. Crear una cuenta Google Cloud (gratis, sin tarjeta).
2. Seguir `docs/setup_bigquery.md` para crear el proyecto y cargar los CSVs.
3. Ejecutar `sql/01_setup_views.sql` para crear las vistas analíticas.
4. Ejecutar las consultas exploratorias y de análisis (`sql/03` a `sql/06`).
5. Conectar Looker Studio a las vistas y construir el dashboard siguiendo `docs/dashboard_design.md`.
6. Publicar el dashboard como link público y embeberlo en tu sitio web.

## Sobre la autora

Diana Mildred — Product Manager (Personal Project)
