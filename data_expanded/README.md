# Dataset ampliado — TiendaLatam v2

Dataset sintético con la misma estructura del original pero con volumen más rico para análisis de Growth & Retención.

## Lo que cambió

| Tabla | Antes | Ahora |
|-------|-------|-------|
| clients | 149 | **700** |
| orders | 299 | **4,000** |
| order_details | 846 | **12,279** |
| (catálogos) | sin cambio | sin cambio |

Las 8 tablas catálogo (countries, categories, products, employees, locations, client_types, order_statuses, positions) son **idénticas** al dataset original. Las incluyo en esta carpeta para que tengas un set completo y self-contained al subir.

## Estadísticas del nuevo dataset

- **Rango temporal**: julio 2021 → abril 2026 (casi 5 años)
- **Revenue total**: $1,958,767.55
- **AOV**: $489.69
- **Crecimiento por año**: 2021: 4 órdenes → 2022: 34 → 2023: 132 → 2024: 401 → 2025: 1,244 → 2026 (parcial, 4m): 1,230
- **Distribución de status**: 63.5% Entregado, 12.6% Enviado, 8.8% Procesando, 7.4% Pendiente, 5.1% Cancelado, 2.6% Devuelto
- **Clientes por tipo**: 61.7% Minorista, 18.3% Mayorista, 11.4% Corporativo, 8.6% VIP
- **Distribución de órdenes por cliente**: power-law realista. Mediana 2, máximo 38. El 5% más activo concentra muchas órdenes (Champions futuros del RFM).

## Integridad referencial validada

Todas estas invariantes están garantizadas:
- Todo `order.client_id` existe en clients.
- Todo `order_details.order_id` existe en orders.
- Todo `order_details.product_id` existe en products.
- Todo `order.location_id` existe en locations.
- Todo `order.employee_id` existe en employees.
- Cada empleado solo aparece en órdenes de su punto de distribución asignado.
- `total_amount` de cada orden = suma exacta de sus detalles (sin redondeo perdido).
- Ninguna orden tiene fecha anterior al registro de su cliente.
- Todas las fechas están dentro de 2021-01-01 a 2026-04-30.

## Cómo reemplazar las tablas en BigQuery sin duplicar

Tienes dos opciones; elige según tu comodidad.

### Opción A — Sobrescribir desde la UI (lo más simple)

Por cada una de las 3 tablas que cambian (`clients`, `orders`, `order_details`):

1. En BigQuery, click en los tres puntos al lado de la tabla → **Crear tabla**.
2. **Origen**: Subir archivo. Selecciona el nuevo CSV.
3. **Nombre de tabla**: pon el mismo nombre que la tabla existente (`clients`, `orders` o `order_details`).
4. En **Opciones avanzadas → Preferencias de escritura**, selecciona **"Sobrescribir tabla"** (en inglés "Write if empty" no — usa "Overwrite table" o "WRITE_TRUNCATE").
5. **Esquema**: Detección automática (los tipos serán los mismos del original).
6. Click **Crear tabla**.

Esto **borra y reescribe** la tabla en una sola operación, sin riesgo de duplicados ni datos truncados a mitad.

Las 8 tablas catálogo no las toques — son idénticas al original.

### Opción B — Borrar y recrear (más control)

1. Click en los tres puntos junto a cada tabla a reemplazar → **Eliminar tabla**.
2. Confirma.
3. Crea de nuevo con el flujo normal de "Crear tabla → Subir archivo → Autodetect".

Más pasos pero te da certeza absoluta del estado.

## Después de reemplazar

1. Re-ejecuta `sql/01_setup_views.sql` para que las vistas analíticas se actualicen contra los nuevos datos (las vistas NO se autorrefrescan al cambiar tablas base).
2. Refresca la fuente de datos en Looker Studio (Recurso → Administrar fuentes → Editar conexión → Aceptar). Esto detecta los nuevos volúmenes.

## Notas sobre los datos sintéticos

Estos datos están generados con `random.seed(42)`, así que si re-corres el script de generación obtienes exactamente los mismos números. Es importante para que tus hallazgos sean reproducibles.

Las distribuciones (status, tipo de cliente, geografía) se calibraron para que matcheen aproximadamente las del dataset original, así que el "espíritu" del negocio se mantiene. La diferencia clave es que ahora tienes suficiente masa para hacer cohortes mensuales con 30+ clientes por cohort y segmentación RFM con segmentos de 50-150 personas — el tipo de tamaño donde los hallazgos son estadísticamente defendibles.
