# Diseño del Dashboard — TiendaLatam

Dashboard ejecutivo en Looker Studio (5 páginas) alineado con las 4 apuestas estratégicas de TiendaLatam. Cada página responde una pregunta estratégica clara y lleva a una decisión.

**Prerequisito:** haber ejecutado `sql/setup_views.sql` en BigQuery. Las 9 vistas son las únicas fuentes que conecta el dashboard.

---

## 1. Fuentes de datos a conectar

En Looker Studio → **Crear → Fuente de datos → BigQuery → tiendalatam-casestudy → tiendalatam → selecciona la vista**.

| Vista | Páginas que la usan | Para qué |
|-------|----------------------|----------|
| `v_orders_enriched` | Todas | KPIs operativos, mapa de país, filtros globales |
| `v_monthly_metrics` | Resumen, Crecimiento | Línea de revenue, nuevo vs recurrente, MoM |
| `v_executive_health` | Resumen Ejecutivo | Scorecards de una sola fila (churn, champions %, etc.) |
| `v_country_performance` | Resumen, Operación | Revenue/mes activo, madurez por país, diagnóstico Colombia |
| `v_rfm_segments` | Retención | Segmentos RFM, At Risk accionable, donut de clientes |
| `v_cohort_retention` | Retención | Heatmap de cohortes |
| `v_abc_classification` | Catálogo | Clasificación A/B/C, revenue acumulado por SKU |
| `v_stock_alerts` | Catálogo | Scatter stock vs ventas, lista de alertas |
| `v_order_lines` | Catálogo | Treemap categoría → producto |

---

## 2. Paleta de colores

Aplicar desde Tema y diseño → Personalizar. Define la paleta en la primera página y guarda como tema predeterminado.

| Elemento | Hex | Uso |
|---|---|---|
| Fondo | `#F5F1EA` | Fondo de todas las páginas |
| Acento principal | `#1F3A5F` | Headers, scorecards positivos |
| Acento secundario | `#F2A65A` | Elementos de alerta media |
| Éxito / positivo | `#4CAF7A` | Flechas de crecimiento, "Stock OK" |
| Alerta / negativo | `#D9534F` | Flechas de caída, "Riesgo de quiebre" |
| Texto principal | `#2D2D2D` | Títulos y etiquetas |

---

## 3. Campos calculados en Looker Studio

Crear en la fuente indicada. En Looker Studio: editar fuente de datos → **Agregar un campo**.

**En `v_orders_enriched`:**

```
Revenue (campo calculado)
= SUM(CASE WHEN is_valid_revenue = 1 THEN total_amount ELSE 0 END)

% Entregado
= SUM(is_delivered) / COUNT(order_id)

% Cancelado
= SUM(is_cancelled) / COUNT(order_id)

% Devuelto
= SUM(is_returned) / COUNT(order_id)

% En proceso (Pendiente + Procesando)
= SUM(is_in_progress) / COUNT(order_id)
```

**En `v_monthly_metrics`:**

```
% Revenue Recurrente
= recurring_client_revenue / revenue
```

**En `v_rfm_segments`:**

```
Es Champion
= CASE WHEN segment = "Champions" THEN 1 ELSE 0 END

Es At Risk o Hibernating
= CASE WHEN segment IN ("At Risk", "Hibernating") THEN 1 ELSE 0 END
```

---

## 4. Estructura de las 5 páginas

### Página 1 — Resumen Ejecutivo

**Audiencia:** C-level. **Pregunta:** ¿Vamos bien o mal en 10 segundos?

```
┌──────────────────────────────────────────────────────────────────┐
│ TiendaLatam · Resumen Ejecutivo     [Año] [País] [Tipo cliente] │
├────────────┬────────────┬────────────┬────────────┬─────────────┤
│  Revenue   │   AOV      │  Clientes  │  Churn     │  Champions  │
│  total     │  global    │  activos   │  180d      │  % revenue  │
│ (vs mes    │ (vs mes    │ (vs mes    │            │             │
│  anterior) │  anterior) │  anterior) │            │             │
├────────────┴────────────┴────────────┴────────────┴─────────────┤
│ Revenue mensual — línea histórica 2021–2026                      │
│ Fuente: v_monthly_metrics · dimensión: month · métrica: revenue  │
├───────────────────────────┬──────────────────────────────────────┤
│ Revenue por país          │ Estado de órdenes — donut            │
│ Mapa geográfico LATAM     │ Fuente: v_orders_enriched            │
│ Fuente: v_country_performance│ dimensión: order_status          │
│ métrica: revenue          │ alerta visual: Pendiente en naranja  │
└───────────────────────────┴──────────────────────────────────────┘
```

**Configuración:**
- Scorecards (fila superior): fuente `v_executive_health`. Activar "Comparación con período anterior" en Revenue, AOV y Clientes activos.
- Revenue mensual: fuente `v_monthly_metrics`, dimensión `month`, métrica `revenue`. Línea simple, sin desagregar.
- Mapa: fuente `v_country_performance`, dimensión `country` (tipo Geo → País), métrica `revenue`. Color de gradiente del acento principal.
- Donut de estados: fuente `v_orders_enriched`, dimensión `order_status`, métrica `COUNT(order_id)`. Colores: Entregado = verde, Enviado = azul, Pendiente/Procesando = naranja, Cancelado/Devuelto = rojo.

---

### Página 2 — Operación & Expansión

**Audiencia:** VP Operaciones, C-level. **Pregunta:** ¿Dónde está el cuello de botella operativo y qué mercados están underperformando?

```
┌────────────────────────────────────────────────────────────────┐
│ Operación & Expansión          [País] [Año]                    │
├────────────┬────────────┬────────────┬──────────────────────── │
│ % Entregado│ % Pendiente│ % Procesando│ % Cancelado           │
│  63.5%     │   7.4%     │   8.8%      │   5.1%                │
│ (benchmark │ (benchmark │ (benchmark  │ (benchmark            │
│  80–85%)   │  ≤2%)      │  ≤3%)       │  6–10%)               │
├────────────┴────────────┴────────────┴────────────────────────┤
│ Performance por país — tabla con color condicional             │
│ columnas: país | meses activo | revenue | revenue/mes | AOV   │
│           | % entregado | % cancelado | % devuelto            │
│ Fuente: v_country_performance · ordenar por revenue desc      │
│ Color condicional: % cancelado > 6% = rojo · < 4% = verde    │
├─────────────────────────────┬──────────────────────────────── │
│ Revenue/mes activo vs       │ Revenue mensual por país        │
│ % cancelación — scatter     │ barras apiladas por país        │
│ Cada punto = 1 país         │ Fuente: v_orders_enriched       │
│ Fuente: v_country_performance│ dimensión: month + country     │
│ X: pct_cancelled            │ métrica: total_amount (status   │
│ Y: revenue_per_month_active │ IN (3,4))                       │
└─────────────────────────────┴──────────────────────────────────┘
```

**Configuración:**
- Scorecards de métricas operativas: fuente `v_executive_health`. Los campos `pct_delivered`, `pct_in_progress`, `pct_cancelled`, `pct_returned` ya están calculados. Agrega texto debajo de cada scorecard con el benchmark (se hace con un cuadro de texto estático en Looker Studio).
- Tabla de países: fuente `v_country_performance`. Activa "Barra de datos" en la columna `revenue` y "Escala de color" en `pct_cancelled`. Agrega una columna calculada `revenue_per_month_active / 1000` para mostrar en miles.
- Scatter: fuente `v_country_performance`, X = `pct_cancelled`, Y = `revenue_per_month_active`, dimensión de etiqueta = `country`. Colombia debería aparecer en el cuadrante de bajo revenue + alta cancelación.

---

### Página 3 — Catálogo & Precio

**Audiencia:** Category Manager, PM de producto. **Pregunta:** ¿Dónde está la concentración de riesgo y dónde está la oportunidad de precio?

```
┌────────────────────────────────────────────────────────────────┐
│ Catálogo & Precio              [Categoría] [Año]               │
├───────────────────────┬────────────────────────────────────────┤
│ Treemap               │ Revenue por categoría — barras         │
│ categoría → producto  │ Fuente: v_order_lines (status 3-4)    │
│ Fuente: v_order_lines │ dimensión: category                   │
│ (status IN (3,4))     │ métrica: SUM(line_total)              │
│ dim: category, product_name │                                  │
│ métrica: SUM(line_total)    │                                  │
├───────────────────────┴────────────────────────────────────────┤
│ Clasificación ABC — tabla con color condicional                │
│ columnas: producto | categoría | revenue | % revenue          │
│           | % acumulado | clase ABC | precio lista | stock    │
│ Fuente: v_abc_classification                                   │
│ Color: clase A = verde · B = amarillo · C = gris              │
├─────────────────────────────┬──────────────────────────────── │
│ Stock vs ventas 90d         │ Alertas de stock — tabla        │
│ scatter                     │ filtrada a stock_alert =        │
│ X: stock                    │ 'Riesgo de quiebre'             │
│ Y: units_sold_last_90d      │ columnas: producto | stock |    │
│ color: stock_alert          │ días inventario | alerta        │
│ Fuente: v_stock_alerts      │ Fuente: v_stock_alerts          │
│ etiqueta: product_name      │ orden: days_of_inventory asc    │
└─────────────────────────────┴──────────────────────────────────┘
```

**Configuración:**
- Treemap: fuente `v_order_lines` con filtro `order_status_id IN (3, 4)`. Dimensión de nivel 1 = `category`, nivel 2 = `product_name`. Métrica = `SUM(line_total)`. Activar etiquetas con porcentaje.
- Tabla ABC: fuente `v_abc_classification`. Color condicional: `abc_class = "A"` → fondo verde, `"B"` → amarillo, `"C"` → gris. Resaltar las dos primeras filas (Laptop + Smartphone) con un cuadro de texto de nota.
- Scatter de stock: fuente `v_stock_alerts`. Punto rojo si `stock_alert = "Riesgo de quiebre"`, verde si `"Stock OK"`. Añade una línea de referencia horizontal en `units_sold_last_90d = 150` para visualizar el umbral de alta rotación.
- Tabla de alertas: fuente `v_stock_alerts` con filtro `stock_alert = "Riesgo de quiebre"`. Ordenada por `days_of_inventory` ascendente. La Laptop Ultraliviana (30.8 días) debe aparecer primera.

---

### Página 4 — Retención & RFM

**Audiencia:** PM de retención, CRM. **Pregunta:** ¿A quién retener, a quién reactivar y cuándo actuar?

```
┌────────────────────────────────────────────────────────────────┐
│ Retención & RFM                [Tipo cliente] [País]           │
├──────────────┬──────────────┬─────────────────────────────────┤
│ Churn 180d   │ Champions    │ Mediana días 2da compra         │
│ 23%          │ 56.4% rev    │ 74 días                         │
│              │              │ → intervención día 50           │
├──────────────┴──────────────┴─────────────────────────────────┤
│ Revenue por segmento RFM — barras horizontales                │
│ Fuente: v_rfm_segments                                        │
│ dimensión: segment · métrica: SUM(monetary)                   │
│ Color: Champions = acento principal, At Risk = alerta         │
├─────────────────────────────┬──────────────────────────────── │
│ Heatmap de cohortes         │ Tabla At Risk — accionable      │
│ Fuente: v_cohort_retention  │ Fuente: v_rfm_segments          │
│ filas: cohort_month         │ filtro: segment IN              │
│ columnas: months_since_first│ ('At Risk', 'Hibernating')      │
│ valor: retention_pct        │ columnas: client_name |         │
│ escala de color: 0%=rojo    │ country | monetary |            │
│ 50%=amarillo · 100%=verde   │ recency_days                    │
│                             │ orden: monetary desc            │
└─────────────────────────────┴──────────────────────────────────┘
```

**Configuración:**
- Scorecards: `churn_rate_180d` y `champions_revenue_pct` desde `v_executive_health`. El scorecard de "74 días" es un cuadro de texto estático — no está en ninguna vista (viene del análisis de `more_insights.sql` Q15).
- Barras de segmentos: fuente `v_rfm_segments`, dimensión `segment`, métrica `SUM(monetary)`. Activa "Mostrar porcentaje" para ver cada barra como % del total.
- Heatmap de cohortes: fuente `v_cohort_retention`. En Looker Studio, una "Tabla pivote" funciona mejor que una tabla normal: filas = `cohort_month`, columnas = `months_since_first`, valor = `retention_pct` con color condicional. Limita las columnas a 0–12 para evitar cohortes vacías.
- Tabla At Risk: fuente `v_rfm_segments` con filtro `segment IN ("At Risk", "Hibernating")`. Esta tabla debe ser accionable — quien vea el dashboard debería poder exportarla para una campaña de reactivación.

---

### Página 5 — Crecimiento

**Audiencia:** VP Growth, CEO. **Pregunta:** ¿El negocio está madurando o depende de adquisición constante?

```
┌────────────────────────────────────────────────────────────────┐
│ Crecimiento                    [Año] [País] [Tipo cliente]    │
├──────────────┬──────────────┬──────────────────────────────── │
│ Revenue mes  │ MoM growth   │ % Revenue recurrentes           │
│ actual       │ vs mes ant.  │ último mes                      │
├──────────────┴──────────────┴──────────────────────────────── │
│ Revenue mensual nuevo vs recurrente — barras apiladas          │
│ Fuente: v_monthly_metrics                                      │
│ dimensión: month · métricas: new_client_revenue (color claro) │
│             + recurring_client_revenue (color oscuro)         │
├─────────────────────────────┬──────────────────────────────── │
│ AOV trimestral por tipo     │ Top 10 mejores meses            │
│ de cliente — líneas         │ Fuente: v_monthly_metrics       │
│ Fuente: v_orders_enriched   │ dimensión: month                │
│ dimensión: quarter (fecha   │ métrica: revenue                │
│ truncada), series: client_type │ tabla ordenada desc         │
│ métrica: AVG(total_amount)  │                                 │
│ filtro: status IN (3,4)     │                                 │
└─────────────────────────────┴──────────────────────────────────┘
```

**Configuración:**
- Scorecard de revenue mensual: fuente `v_monthly_metrics` con filtro a último mes disponible, o usa "comparación con período anterior" automática.
- Barras apiladas: fuente `v_monthly_metrics`. Crea dos series: `new_client_revenue` (color terracota claro) y `recurring_client_revenue` (color azul profundo). El objetivo visual: ver cómo la barra azul crece en el tiempo.
- AOV por tipo: fuente `v_orders_enriched` con filtro `is_valid_revenue = 1`. Dimensión de tiempo = `DATE_TRUNC(registration_date, QUARTER)`, series = `client_type`, métrica = `AVG(total_amount)`. El gráfico debería mostrar convergencia entre segmentos — la señal crítica del análisis.
- Tabla top 10: fuente `v_monthly_metrics`, ordenada por `revenue` descendente, limitada a 10 filas.

---

## 5. Filtros globales

Crea estos controles en cada página. Para replicarlos: copiar el control → pegar en otras páginas.

| Control | Tipo | Fuente | Campo | Aplica a |
|---|---|---|---|---|
| Rango de fechas | Date range control | `v_orders_enriched` | `registration_date` | Todas las páginas |
| País | Drop-down list | `v_orders_enriched` | `country` | Todas las páginas |
| Tipo de cliente | Drop-down list | `v_orders_enriched` | `client_type` | Páginas 1, 4, 5 |
| Categoría | Drop-down list | `v_order_lines` | `category` | Página 3 |

Nota: el filtro de país en la página de Operación filtra tanto `v_orders_enriched` como `v_country_performance`. Asegúrate de que ambas fuentes estén en el mismo control de filtro.

---

## 6. Títulos con conclusión (no descriptivos)

Looker Studio permite editar el título de cada visual. Reemplaza los títulos por defecto por títulos con la conclusión del hallazgo:

| Visual | Título genérico (malo) | Título con conclusión (bueno) |
|---|---|---|
| Línea de revenue | Revenue mensual | Crecimiento ininterrumpido — 2026 en camino a duplicar 2025 |
| Donut de estados | Estados de órdenes | Solo el 63.5% de órdenes llega a Entregado — benchmark: 80–85% |
| Tabla de países | Performance por país | Colombia underperforma: $2,084/mes vs $3,372 de Ecuador |
| Heatmap cohortes | Retención por cohorte | Cohortes 2025 retienen 33–54% en Q1 — PMF emergente |
| Tabla At Risk | At Risk | 64 clientes con $160K en revenue histórico — rescatables |
| ABC catálogo | Catálogo ABC | 2 SKUs = 46.2% del revenue — riesgo sistémico |

---

## 7. Publicar y compartir

1. Botón **Compartir** → **Administrar acceso** → cambiar a **"Cualquier persona con el enlace puede ver"**.
2. Copia el link y pruébalo en una ventana incógnito.
3. Para embeber: **Compartir → Insertar informe** → copia el iframe. Ancho = 100% del contenedor.

---

## 8. Trucos de Looker Studio

- **Tabla pivote para cohortes**: en lugar de una tabla normal, usa Insertar → Tabla pivote. Filas = `cohort_month`, columnas = `months_since_first`, valor = `retention_pct`. Agrega escala de color al valor.
- **Páginas ocultas**: crea páginas de appendix con análisis detallado accesibles solo con link directo.
- **Anotaciones en gráficos de línea**: usa "Agregar referencia" para marcar el punto de inflexión 2024 en la línea de revenue.
- **Mezcla de datos**: si necesitas cruzar `v_rfm_segments` con `v_orders_enriched` en una misma visual, usa el blending de Looker Studio en lugar de crear otra vista en BigQuery.
- **Bookmarks por país**: crea páginas filtradas por Colombia, Ecuador y Argentina para presentaciones ejecutivas rápidas.

---

## 9. Checklist antes de publicar

- [ ] Las 9 vistas están creadas en BigQuery (ejecutar `sql/setup_views.sql`).
- [ ] Las 5 fuentes de datos están conectadas en Looker Studio.
- [ ] Los campos calculados (`is_valid_revenue`, `% Entregado`, etc.) están creados en cada fuente.
- [ ] Los 5 títulos de página tienen la conclusión del hallazgo, no solo un descriptor.
- [ ] Los filtros globales (fecha, país, tipo cliente) funcionan en todas las visualizaciones de su página.
- [ ] La tabla At Risk es exportable (verificar que tiene botón de descarga).
- [ ] El heatmap de cohortes muestra datos desde 2023 (cohortes anteriores son demasiado pequeñas).
- [ ] El scatter de stock tiene el punto de la Laptop Ultraliviana visible y etiquetado.
- [ ] La paleta de colores es consistente en las 5 páginas.
- [ ] El link público funciona en ventana incógnito.
- [ ] El dashboard se ve bien en monitor 1080p y en pantalla de laptop (13").
