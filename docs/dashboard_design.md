# Diseño del Dashboard en Looker Studio

Guía paso a paso para construir un dashboard ejecutivo en Looker Studio (gratis, basado en navegador) que comunique los hallazgos de Growth & Retención. Pensado para que cada página responda una pregunta clara y lleve a una decisión.

Antes de empezar, asegúrate de haber completado el setup de BigQuery (ver `docs/setup_bigquery.md`) y haber ejecutado `sql/01_setup_views.sql` para crear las vistas analíticas.

## 1. Fuentes de datos a conectar

Vamos a conectar las 5 vistas que creamos en BigQuery (no las tablas crudas — las vistas ya tienen los joins resueltos):

| Vista | Para qué la usaremos |
|-------|----------------------|
| `v_orders_enriched` | KPIs principales, mapa por país, performance por tienda |
| `v_order_lines` | Análisis de productos, categorías, ABC |
| `v_rfm_segments` | Distribución de segmentos, % revenue por segmento |
| `v_cohort_retention` | Heatmap de cohortes |
| `v_monthly_metrics` | Línea temporal de revenue, MoM growth, nuevos vs recurrentes |

Para conectar cada una: en Looker Studio → **Crear → Fuente de datos → BigQuery → tu proyecto → tiendalatam → selecciona la vista**.

## 2. Paleta de colores sugerida

Inspirada en una identidad LATAM cálida y profesional. En Looker Studio aplica desde Tema y diseño → Personalizar:

- Color de fondo: `#F5F1EA` (crema claro)
- Color de acento principal: `#1F3A5F` (azul profundo)
- Color secundario: `#F2A65A` (terracota)
- Color de éxito (positivo): `#4CAF7A`
- Color de alerta (negativo): `#D9534F`
- Texto principal: `#2D2D2D`

Tip: define la paleta en la primera página, después guarda el tema como predeterminado del informe.

## 3. Campos calculados clave en Looker Studio

Looker Studio permite crear campos calculados que actúan como medidas. La sintaxis es similar a Excel/Sheets. Crea estos campos en la fuente `v_orders_enriched`:

```
% Cancelación
= SUM(CASE WHEN order_status_id = 5 THEN 1 ELSE 0 END) / COUNT(order_id)

% Devolución
= SUM(CASE WHEN order_status_id = 6 THEN 1 ELSE 0 END) / COUNT(order_id)

Es Entregado
= CASE WHEN order_status_id = 4 THEN 1 ELSE 0 END
```

En la fuente `v_rfm_segments`:

```
Es Champion
= CASE WHEN segment = "Champions" THEN 1 ELSE 0 END
```

En la fuente `v_monthly_metrics`, para calcular MoM growth en Looker Studio se usa una función de comparación temporal:

- Métrica: SUM(revenue)
- Comparación: período anterior (mes anterior)
- Looker Studio muestra automáticamente el % de cambio.

## 4. Estructura de las 4 páginas

### Página 1 — Resumen Ejecutivo

Audiencia: C-level. Objetivo: en 10 segundos saber si vamos bien o mal.

Layout sugerido:

```
┌─────────────────────────────────────────────────────┐
│ TiendaLatam · Resumen Ejecutivo                    │
│ Filtros: [Año] [País] [Tipo de Cliente]            │
├──────────┬──────────┬──────────┬─────────────────┤
│ Revenue  │ Órdenes  │ Clientes │ AOV             │
│ Scorecard│ Scorecard│ activos  │ Scorecard       │
│          │          │ Scorecard│                 │
├──────────┴──────────┴──────────┴─────────────────┤
│ Revenue mensual (gráfico de línea)                 │
├───────────────────────┬────────────────────────────┤
│ Revenue por país      │ Top 5 categorías           │
│ (Mapa geográfico)     │ (Gráfico de barras)        │
└───────────────────────┴────────────────────────────┘
```

Configuración exacta:
- Fuente: `v_orders_enriched` (filtrada a order_status_id IN (3, 4))
- Scorecards: SUM(total_amount), COUNT_DISTINCT(order_id), COUNT_DISTINCT(client_id), AVG(total_amount)
- Mapa: usa la dimensión `country` con tipo Geo → País.
- Filtros (slicers): año (de registration_date), country, client_type.

Truco visual: en cada scorecard, activa "Comparación con período anterior" para mostrar la flecha verde/roja automáticamente.

### Página 2 — Growth

Audiencia: VP Growth / PM. Objetivo: entender la velocidad y composición del crecimiento.

Visuales:
- Scorecard con flecha: MoM growth del último mes (Revenue actual vs mes anterior).
- Gráfico de barras apiladas: revenue mensual desglosado por nuevo vs recurrente. Fuente: `v_monthly_metrics`, dimensión = month, métrica 1 = revenue de new_clients_orders, métrica 2 = revenue - new (calcular con campo).
- Gráfico combinado (línea + barras): barras de "nuevos clientes por mes" (eje izq), línea de "retención mes 1" (eje der). Fuente: `v_cohort_retention` filtrado a months_since_first = 1.
- Tabla: top 10 mejores meses históricos por revenue.
- Scorecard: tiempo promedio a segunda compra (puedes hardcodearlo o calcularlo en una vista adicional).

### Página 3 — Producto

Audiencia: Category Manager / PM de producto. Objetivo: decidir mix.

Visuales:
- Treemap: revenue por categoría → producto. Fuente: `v_order_lines`.
- Tabla con escala de color: clasificación ABC (necesitarás materializar la query Q11 como una vista adicional `v_abc_classification`).
- Scatter plot: stock (eje X) vs unidades vendidas en 90 días (eje Y). Cuadrantes implícitos: alta venta + bajo stock = estrella en riesgo.
- Tabla: top 10 combinaciones de productos (puedes materializar Q14 como vista).
- Lista con condicional: productos con alerta "Riesgo de quiebre" o "Stock muerto" en rojo/naranja.

### Página 4 — Clientes (RFM y Cohortes)

Audiencia: PM de retención / CRM. Objetivo: identificar a quién retener y a quién reactivar.

Visuales:
- Donut chart: distribución de clientes por segmento. Fuente: `v_rfm_segments`, dimensión = segment, métrica = COUNT(client_id).
- Gráfico de barras horizontal: % de revenue por segmento. Misma fuente, dimensión = segment, métrica = SUM(monetary).
- Tabla pivote (heatmap de cohortes): filas = cohort_month, columnas = months_since_first, valor = retention_pct con escala de color. Fuente: `v_cohort_retention`.
- Tabla "Clientes At Risk": fuente `v_rfm_segments` filtrada a segment IN ("At Risk", "Hibernating"), columnas client_name, country, monetary, recency_days. Ordenada por monetary desc.
- Scorecard: Churn rate 180d (calculado en una vista adicional o como campo calculado).

## 5. Filtros globales

Crea un control de filtro (slicer) en cada página o, mejor aún, en una "Sección oculta de filtros" que se replica en todas las páginas. Filtros recomendados:

- Rango de fechas (Date range control conectado a registration_date)
- País (Drop-down list)
- Tipo de cliente (Drop-down list)

## 6. Publicar y compartir

Cuando el dashboard esté listo:

1. Botón **Compartir** arriba a la derecha → **Administrar acceso**.
2. Cambia "Restringido" a **"Cualquier persona con el enlace puede ver"**.
3. Copia el link.

Para embeber en tu website:
1. Botón **Compartir → Insertar informe**.
2. Copia el código iframe HTML.
3. Pégalo en una sección de tu sitio web (Webflow, Notion embed, Squarespace block, etc.).
4. Define el ancho a 100% del contenedor para que sea responsive.

## 7. Tips de diseño que diferencian

- Usa títulos con conclusión, no descriptivos. Mal: "Revenue por mes". Bien: "Diciembre 2025 fue el mejor mes con $10,825 (+94% MoM)".
- Pon el periodo de análisis visible en el header de cada página.
- Una historia por página: si un visual no responde la pregunta de la página, sácalo.
- Crea bookmarks por país para presentaciones rápidas.
- Activa tooltips personalizados para mostrar contexto al hacer hover.
- En las tablas, usa "barras dentro de celdas" como visualización compacta de magnitud.

## 8. Trucos de Looker Studio que pocos PMs conocen

- **Páginas ocultas**: puedes crear páginas con análisis profundo que solo se ven con link directo. Útil para "appendix" del dashboard.
- **Parámetros**: permiten que el usuario cambie variables (ej: definir el umbral de "Champion"). Más avanzado.
- **Mezcla de datos**: si necesitas cruzar dos vistas, Looker Studio permite hacer "blending" (similar a un JOIN ligero). Útil para no crear más vistas en BigQuery.
- **Plantillas de comunidad**: explora la galería de Looker Studio para inspiración visual antes de empezar a diseñar.

## 9. Checklist antes de publicar

- [ ] Las 4 páginas tienen títulos con conclusión.
- [ ] Hay al menos un campo calculado en cada página.
- [ ] Los filtros globales funcionan en todas las visualizaciones.
- [ ] No hay valores en blanco/null visibles al usuario.
- [ ] La paleta de colores es consistente.
- [ ] El dashboard se ve bien en monitor 1080p Y en pantalla de laptop.
- [ ] El link público está activado y probado en una ventana incógnito.
- [ ] El iframe se ve bien embebido en tu website (prueba primero en una página de prueba).
