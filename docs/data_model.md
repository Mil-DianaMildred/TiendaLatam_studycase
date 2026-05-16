# Diccionario de datos — TiendaLatam

## Modelo entidad-relación (resumen)

```
countries ──< clients ──< orders >── locations >── countries
                            │           │
                            │           └── employees ── positions
                            │
                          order_details ── products ── categories
                            │
                          order_statuses

clients ── client_types
```

## Tablas

### countries
| Columna | Tipo | Notas |
|---------|------|-------|
| country_id | INT (PK) | |
| code | VARCHAR(2) | ISO Alpha-2 |
| name | VARCHAR(50) | Nombre del país |
| continent | VARCHAR(30) | Todos: América |

10 países LATAM: AR, BO, BR, CL, CO, CR, EC, MX, PE, UY.

### categories
| Columna | Tipo | Notas |
|---------|------|-------|
| category_id | INT (PK) | |
| name | VARCHAR(50) | |
| description | TEXT | |

Categorías: Tecnología, Hogar, Moda, Belleza, Alimentos, Deportes, Juguetería, Papelería.

### client_types
| Columna | Tipo | Notas |
|---------|------|-------|
| client_type_id | INT (PK) | |
| name | VARCHAR(30) | Minorista, Mayorista, Corporativo, VIP |

Distribución actual: Minorista 432 (61.7%), Mayorista 128 (18.3%), Corporativo 80 (11.4%), VIP 60 (8.6%).

### order_statuses
6 estados: Pendiente, Procesando, Enviado, Entregado, Cancelado, Devuelto.

Para análisis de revenue se usan típicamente los estados 3 (Enviado) y 4 (Entregado).

### positions
Cargos: Gerente de tienda, Vendedor, Cajero, Coordinador logístico, Asesor comercial.

### locations
10 tiendas físicas, una por país LATAM (10 ciudades).

### employees
20 empleados distribuidos en las 10 tiendas. `employee_position` → positions.

### products
50 productos en 8 categorías. Rango de precios: $3.60 – $799.00. Campos clave: `price`, `stock`, `status` (activo/inactivo).

### clients
700 clientes. Campos importantes para análisis: `registration_date` (cuándo se registró), `client_type_id` (segmento), `country_id`, `status` (activo/inactivo). 636 tienen al menos una orden válida; 64 nunca compraron.

### orders
4,000 pedidos entre julio 2021 y abril 2026. Campos clave:
- `registration_date`: fecha del pedido (sirve como timestamp principal del análisis).
- `total_amount`: monto total del pedido. **Nota**: para mayor rigor se podría recalcular sumando `order_details`, pero este campo está pre-agregado.
- `order_status_id`: filtrar por (3, 4) para revenue realizado — da 3,045 órdenes válidas.

### order_details
12,279 líneas. Granularidad: una fila por producto en una orden. `quantity * unit_price` da el subtotal de línea.

## Decisiones de modelado

**¿Por qué `total_amount` está duplicado en orders y derivable de order_details?**
Es una optimización común para reportes (denormalización ligera). En análisis serios conviene validar que coincida con `SUM(quantity * unit_price)` de la orden. Hay una query de validación sugerida abajo.

**¿Por qué status booleano en varias tablas?**
Permite soft-deletes: marcar como inactivo sin perder histórico. Importante filtrar en consultas que cuentan "activos".

## Query de validación de integridad

```sql
-- BigQuery dialect — verifica que total_amount coincida con la suma de order_details.
SELECT
  o.order_id,
  o.total_amount AS stored_total,
  ROUND(SUM(od.quantity * od.unit_price), 2) AS computed_total,
  ROUND(o.total_amount - SUM(od.quantity * od.unit_price), 2) AS difference
FROM `tiendalatam-casestudy.tiendalatam.orders` o
JOIN `tiendalatam-casestudy.tiendalatam.order_details` od ON o.order_id = od.order_id
GROUP BY o.order_id, o.total_amount
HAVING ABS(o.total_amount - SUM(od.quantity * od.unit_price)) > 0.01;
```

Si esta query devuelve filas, hay inconsistencias que vale la pena documentar en el caso de estudio (calidad de datos es un tema clásico que PMs deben saber manejar).
