# Arquitectura del proyecto

Este documento explica cómo está organizado el proyecto técnicamente: qué herramienta hace qué, por qué la elegimos y cómo fluye la información de los CSVs hasta el dashboard publicado en tu website. Está pensado para que tú lo entiendas profundamente (sirve como práctica de pensamiento de arquitectura PM)

## Vista panorámica (en una frase)

Los CSVs originales se cargan en BigQuery (data warehouse en la nube), donde el análisis se hace con SQL; los resultados se conectan a Looker Studio (BI), que genera un dashboard interactivo accesible por un link público que se embebe en tu website.

## Diagrama de la arquitectura

```
┌─────────────────┐
│  11 archivos    │
│  CSV originales │   (Data del projecto)
│  (data/)        │
└────────┬────────┘
         │
         │  carga manual una sola vez vía UI de BigQuery
         │  (drag & drop, autodetect schema)
         ▼
┌──────────────────────────────────────────────────┐
│           Google BigQuery (Sandbox)              │
│  ─────────────────────────────────────────────  │
│  Proyecto: tiendalatam-casestudy                 │
│  Dataset:  tiendalatam                           │
│                                                  │
│  Tablas base (11):                               │
│    clients, orders, order_details, products,     │
│    employees, locations, categories,             │
│    countries, client_types, order_statuses,      │
│    positions                                     │
│                                                  │
│  Vistas analíticas (creadas con SQL):            │
│    v_orders_enriched     (orders + joins)        │
│    v_monthly_revenue     (revenue agregado)      │
│    v_rfm_segments        (clientes segmentados)  │
│    v_cohort_retention    (matriz de cohortes)    │
│                                                  │
│  Costo: $0 (sandbox sin tarjeta)                 │
└────────────────────────┬─────────────────────────┘
                         │
                         │  conector nativo BigQuery
                         │  (autenticación con tu cuenta Google)
                         ▼
┌──────────────────────────────────────────────────┐
│            Looker Studio (BI tool)               │
│  ─────────────────────────────────────────────  │
│  Informe: TiendaLatam – Growth & Retention       │
│                                                  │
│  Páginas:                                        │
│    1. Resumen Ejecutivo                          │
│    2. Growth (MoM, nuevos vs recurrentes)        │
│    3. Producto (ABC, market basket)              │
│    4. Clientes (RFM, cohortes, churn)            │
│                                                  │
│  Costo: $0 (gratuito siempre)                    │
└────────────────────────┬─────────────────────────┘
                         │
                         │  link público + iframe embed
                         ▼
┌──────────────────────────────────────────────────┐
│              Tu sitio web personal               │
│  ─────────────────────────────────────────────  │
│  Caso de estudio: TiendaLatam                    │
│    • Contexto del problema                       │
│    • Hallazgos clave (3-5 insights)              │
│    • Dashboard incrustado (live)                 │
│    • Recomendaciones de producto                 │
└──────────────────────────────────────────────────┘
```

## Las 3 capas de la arquitectura

### Capa 1 — Almacenamiento y procesamiento (BigQuery)

BigQuery es un data warehouse serverless de Google. "Serverless" significa que tú no manejas servidores ni instalaciones: subes datos, escribes SQL, Google se encarga del resto.

**Qué hace en este proyecto:**
- Guardar las 11 tablas originales.
- Ejecutar todas las consultas SQL del análisis (las del repositorio `sql/`).
- Materializar vistas analíticas (queries pre-calculadas) para que Looker Studio no las recompute en cada carga.

**Por qué BigQuery y no otra cosa:**
- Sandbox 100% gratis, sin tarjeta de crédito.
- Sintaxis SQL muy cercana a PostgreSQL.
- Conector nativo a Looker Studio: un clic.
- Es el data warehouse más usado en startups y empresas tech en LATAM — pone tu nombre cerca de ese ecosistema.

**Lo que cuesta:**
- Almacenamiento: gratis hasta 10 GB. Tu proyecto pesa <1 MB.
- Consultas: gratis hasta 1 TB procesado/mes. Cada consulta tuya procesa kilobytes.
- Limitación: las tablas en sandbox expiran a los 60 días. Solución sencilla: recargarlas (10 min) o activar la prueba gratuita de GCP (90 días + $300 USD de crédito, no cobra automáticamente al terminar).

### Capa 2 — Visualización y exploración (Looker Studio)

Looker Studio (antes Google Data Studio) es la herramienta de BI gratuita de Google. Permite arrastrar campos y construir visuales conectados a fuentes de datos.

**Qué hace en este proyecto:**
- Leer las vistas de BigQuery.
- Renderizar 4 páginas de dashboard interactivo.
- Aplicar filtros globales (país, fecha, tipo de cliente).
- Publicar el dashboard con un link público.

**Por qué Looker Studio y no Power BI / Tableau:**
- Es 100% web — no requiere instalar nada y funciona en tu Mac.
- Es gratis para uso ilimitado, sin features bloqueados.
- Genera links públicos compartibles (Power BI Free no permite esto).
- Integración nativa con BigQuery: cero configuración de conexión.

**Limitaciones honestas:**
- Algunos visuales avanzados (cohort heatmap perfecto, scatter plots con tooltips ricos) son más torpes que en Tableau.
- Cálculos complejos en Looker Studio se hacen con "campos calculados" (sintaxis tipo fórmula), no con DAX. La estrategia es: dejar los cálculos pesados en SQL (BigQuery) y que Looker Studio solo visualice.

## Overview

1. Crear cuenta Google Cloud (gratis, sin tarjeta).
2. Crear proyecto `tiendalatam-portfolio` en console.cloud.google.com.
3. Activar BigQuery sandbox.
4. Crear dataset `tiendalatam`.
5. Subir los 11 CSVs con autodetección de esquema.
6. Ejecutar las queries de `sql/01_setup_views.sql` para crear las vistas analíticas.
7. Conectar Looker Studio a las vistas creadas.
8. Construir el dashboard siguiendo `docs/dashboard_design.md`.
9. Publicar el dashboard como link público.
10. Incrustar el link en tu website.

Tiempo estimado de setup completo: 1-1.5 horas la primera vez. Después de ahí, todo es análisis.

## Diagrama corto para tu sitio web

Si quieres una versión simplificada del diagrama para tu caso de estudio:

```
CSVs ─> BigQuery ─> Looker Studio ─> Dashboard público
       (SQL)        (visuales)
```

Esa imagen de 4 cajas comunica el stack de un vistazo y demuestra que entiendes la separación entre capa de datos, capa de análisis y capa de presentación — exactamente lo que un PM tech necesita.
