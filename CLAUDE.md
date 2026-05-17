# TiendaLatam — Convenciones del proyecto

## Definición de Revenue

**Revenue = SUM(total_amount) WHERE order_status_id IN (3, 4)**

- Status 3 = **Enviado**
- Status 4 = **Entregado**

Nunca incluir órdenes en estado Pendiente, En proceso, Cancelado o Devuelto en cálculos de revenue.

```sql
-- CORRECTO
WHERE order_status_id IN (3, 4)

-- INCORRECTO — incluye canceladas, devueltas, pendientes
-- (sin filtro de status)

-- INCORRECTO — falta "Enviado"
WHERE order_status_id = 4
```

**GMV** (Gross Merchandise Value) = SUM(total_amount) sin filtro de status → total bruto de todas las órdenes. Usar solo cuando se quiere comparar el volumen total contra el revenue real.

**Excepción:** queries de calidad operativa (pct_cancelled, pct_returned, etc.) deben contar `total_orders` sobre todas las órdenes, pero la columna `revenue` sigue aplicando el filtro IN (3, 4) — usar `SUM(CASE WHEN order_status_id IN (3, 4) THEN total_amount ELSE 0 END)`.

**Churn:** cliente sin ninguna orden válida (status_id IN (3,4)) en los últimos 180 días.

**Moneda** Todos los valores que representan dinero estan expresados en US Dollars.
