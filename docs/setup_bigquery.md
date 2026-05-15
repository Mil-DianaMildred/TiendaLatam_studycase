# Setup de BigQuery + Looker Studio

Guía paso a paso para montar el proyecto desde cero. Sin tarjeta de crédito, sin instalaciones locales. Tiempo total estimado: 30-45 minutos la primera vez.

## Lo que vas a tener al final

Una base de datos en la nube con tus 11 tablas, queries SQL listas para ejecutar en el navegador, y un dashboard en Looker Studio compartible con un link público para tu website.

## Pre-requisitos

Solo una cuenta de Google (la misma que usas para Gmail funciona). No necesitas tarjeta de crédito para BigQuery sandbox.

---

## Paso 1 — Crear proyecto en Google Cloud (5 min)

1. Abre [console.cloud.google.com](https://console.cloud.google.com).
2. Acepta los términos.
3. Arriba a la izquierda, hay un selector de proyecto. Click → **Nuevo proyecto**.
4. Nombre: `tiendalatam-casestudy`. Deja la organización en blanco. Click **Crear**.
5. Espera 30 segundos y selecciona el proyecto recién creado en el selector.

## Paso 2 — Activar BigQuery Sandbox (2 min)

1. En el buscador superior, escribe "BigQuery" y entra.
2. La primera vez verás un banner que dice "BigQuery sandbox activado". Esto significa modo gratis: 10 GB de almacenamiento y 1 TB de consultas por mes, sin tarjeta. Más que suficiente para este proyecto (los CSVs pesan <500KB en total).
3. Importante: las **tablas en sandbox expiran a 60 días**. Para un portafolio activo recomiendo, después de cargar todo, activar la "Prueba gratuita" de Google Cloud (90 días, $300 USD de crédito, no se cobra automáticamente al expirar — pero sí pide tarjeta). Si no quieres dar tarjeta, simplemente recreas las tablas cuando expiren (10 minutos de trabajo).

## Paso 3 — Crear dataset (2 min)

Un "dataset" en BigQuery es como un schema: agrupa tus tablas.

1. En el panel izquierdo (Explorador), click en los tres puntos junto a tu proyecto → **Crear conjunto de datos**.
2. ID del conjunto de datos: `tiendalatam`.
3. Ubicación de los datos: `US (multi-region)` está bien, o `southamerica-east1` si quieres mantenerlo en LATAM.
4. Click **Crear conjunto de datos**.

## Paso 4 — Cargar los 11 CSVs (15 min)

Tienes que repetir este proceso 11 veces. Es tedioso pero solo lo haces una vez.

Por cada archivo CSV (`countries.csv`, `categories.csv`, `client_types.csv`, `order_statuses.csv`, `positions.csv`, `locations.csv`, `employees.csv`, `products.csv`, `clients.csv`, `orders.csv`, `order_details.csv`):

1. Click en los tres puntos junto al dataset `tiendalatam` → **Crear tabla**.
2. **Origen**: Subir archivo.
3. **Seleccionar archivo**: elige el CSV correspondiente.
4. **Formato de archivo**: CSV.
5. **Nombre de tabla**: usa el nombre del archivo sin la extensión (ej: `orders`).
6. **Esquema**: marca la casilla "Detección automática". Esto es lo que te ahorra escribir DDL.
7. **Opciones avanzadas → Filas para saltar en el encabezado**: `1`.
8. Click **Crear tabla**.

Tip: empieza por las tablas catálogo (las pequeñas: `countries`, `categories`, etc.) y deja `orders` y `order_details` para el final. Si algo falla con la autodetección, suele ser solo en estas dos.

## Paso 5 — Validar la carga (2 min)

Abre una ventana de consulta (botón azul "+ Redactar nueva consulta") y pega:

```sql
SELECT
  table_id AS table_name,
  row_count
FROM `tiendalatam.__TABLES__`
ORDER BY table_id;
```

Esperado: las 11 tablas con los row counts. Si alguna tiene 0, vuelve a cargarla.

Numeros que deberías ver:

| Tabla | Filas |
|-------|-------|
| categories | 8 |
| client_types | 4 |
| clients | 149 |
| countries | 10 |
| employees | 19 |
| locations | 9 |
| order_details | 846 |
| order_statuses | 6 |
| orders | 299 |
| positions | 5 |
| products | 49 |

## Paso 6 — Ejecutar la primera query

Copia el contenido de `sql/03_exploratory_bq.sql`, pégalo en la consola de BigQuery y ejecuta cada query con cmd+enter / ctrl+enter. Los resultados aparecen en la parte inferior.

Tip de productividad: BigQuery te dice cuántos GB va a procesar antes de ejecutar. Para este dataset todo es <100 KB, ni te acerca al límite gratis del mes.

## Paso 7 — Crear vistas reutilizables (opcional pero recomendado)

Para que Looker Studio consuma datos pre-procesados, crea vistas (views) para tus análisis principales. Una vista en BigQuery se crea con `CREATE OR REPLACE VIEW`:

```sql
CREATE OR REPLACE VIEW `tiendalatam.v_orders_enriched` AS
SELECT
  o.order_id,
  o.client_id,
  o.location_id,
  o.employee_id,
  o.registration_date,
  o.total_amount,
  os.name AS order_status,
  c.name AS client_name,
  c.last_name AS client_last_name,
  ct.name AS client_type,
  co.name AS country,
  l.name AS store_name
FROM `tiendalatam.orders` o
JOIN `tiendalatam.order_statuses` os ON o.order_status_id = os.order_status_id
JOIN `tiendalatam.clients` c ON o.client_id = c.client_id
JOIN `tiendalatam.client_types` ct ON c.client_type_id = ct.client_type_id
JOIN `tiendalatam.countries` co ON c.country_id = co.country_id
JOIN `tiendalatam.locations` l ON o.location_id = l.location_id
WHERE o.order_status_id IN (3,4);
```

Crear esta vista te ahorra los joins en cada visual del dashboard.

## Paso 8 — Conectar Looker Studio (5 min)

1. Abre [lookerstudio.google.com](https://lookerstudio.google.com) con la misma cuenta.
2. Click **Crear → Fuente de datos**.
3. Selecciona el conector **BigQuery**.
4. Autoriza el acceso. Selecciona tu proyecto `tiendalatam-portfolio` → dataset `tiendalatam` → tabla o vista que quieras conectar.
5. Click **Conectar** (arriba a la derecha).
6. Revisa los tipos detectados (asegúrate que las fechas estén como tipo Fecha, no como texto).
7. Click **Crear informe**.

Repite el paso para cada tabla/vista que necesites en el dashboard. Una práctica común: crea un "informe" en Looker Studio con varias fuentes de datos, y úsalas para distintos visuales.

## Paso 9 — Compartir el dashboard

Cuando tengas tu dashboard listo:

1. Botón **Compartir** arriba a la derecha.
2. Pestaña **Administrar accesos** → cambia a **"Cualquier persona con el enlace puede ver"**.
3. Copia el link → ese link va a tu website y CV.

Para incrustar en tu website: botón **Compartir → Insertar informe**. Te da un iframe HTML que puedes pegar directamente.

---

## Comandos útiles para mantener el proyecto

**Ver costo acumulado del mes:**
En BigQuery → "Capacidad" → "Sandbox". Mientras esté en sandbox, el costo es $0.

**Re-cargar una tabla:**
Botón **Crear tabla** sobre el dataset, mismo nombre, opción **Sobrescribir tabla** en preferencias de escritura.

**Eliminar tabla:**
Tres puntos junto a la tabla → Eliminar.

---

## Troubleshooting

**"Schema autodetect failed"** al cargar `orders.csv`: las notas en español pueden contener comas que confunden al parser. Solución: en opciones avanzadas, marca "Permitir filas mal definidas: 5" o convierte el CSV a usar comillas dobles en el campo notes.

**Las fechas se cargaron como STRING:** ve a la tabla → pestaña Esquema → edita el campo registration_date a tipo DATE. Si no permite, recarga la tabla con autodetect = falso y schema manual.

**Looker Studio dice "Sin acceso al proyecto":** vuelve a la consola GCP → IAM → asegura que tu cuenta tenga rol "BigQuery Data Viewer" + "BigQuery Job User".

**Las consultas tardan mucho:** revisa que estés filtrando por fecha cuando sea posible. BigQuery cobra por bytes escaneados, así que la práctica de PM es escribir queries selectivas.
