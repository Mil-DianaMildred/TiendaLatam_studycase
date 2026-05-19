# Benchmark Regional de Cumplimiento de Órdenes
## TiendaLatam vs. Estándares E-commerce LATAM

---

## 1. Contexto y objetivo

TiendaLatam es una empresa de retail que migró de tiendas presenciales a un modelo 100% digital en 10 países de Latinoamérica (Argentina, Bolivia, Brasil, Chile, Colombia, Costa Rica, Ecuador, México, Perú y Uruguay). Sus antiguas tiendas se reconvirtieron en centros de distribución logística —uno por país— y para el 2026 el C-level está formalizando este pivote estratégico. El dataset analizado cubre 4.000 órdenes entre julio 2021 y abril 2026 (~833 órdenes/año, ~70/mes en promedio histórico).

El objetivo de este análisis es contrastar la distribución actual de estados de orden de TiendaLatam contra benchmarks regionales publicados por *eCommerce Institute*, *AMVO*, *CACE*, *Deloitte*, *DHL Supply Chain*, *Merchant Risk Council* y *BlackSip*, para determinar qué métricas son competitivas y cuáles representan oportunidades estructurales.

## 2. Distribución actual de estados — TiendaLatam

| Estado | Órdenes | % |
|---|---:|---:|
| Entregado | 2.542 | 63,5% |
| Enviado | 503 | 12,6% |
| Procesando | 350 | 8,8% |
| Pendiente | 296 | 7,4% |
| Cancelado | 203 | 5,1% |
| Devuelto | 106 | 2,6% |
| **Total** | **4.000** | **100%** |

## 3. Benchmarks regionales relevantes

### 3.1 Última milla y tasa de entrega

La logística de última milla en LATAM es estructuralmente más compleja que en otras regiones por la heterogeneidad de infraestructura, la dispersión geográfica y la fragmentación de operadores locales. Los referentes regionales arrojan estos puntos de comparación:

- La **Tasa de Entrega al Primer Intento (FADR)** entre los operadores logísticos líderes en LATAM se sitúa en **93%+**, con los top performers alcanzando 97% (Zeo Route Planner, 2026).
- Mercado Libre, a través de Mercado Envíos, ha logrado entregas de 24–48 horas en ciudades capitales gracias a más de **90 centros logísticos** propios y una red de 8 hubs de distribución.
- En Argentina, **70% de las entregas e-commerce se realizan a domicilio** (CACE, 1er semestre 2024), un porcentaje que crece año contra año.
- El reporte de *Americas Market Intelligence* y *The Logistics World* documenta que en LATAM las entregas en menos de 48 horas son ya un estándar competitivo, pero solo accesible para operadores con red propia.

Para un snapshot histórico de órdenes acumuladas en un operador maduro (5+ años de operación), la proporción saludable esperada de órdenes en estado "Entregado" se ubica entre **80–85%**, con el resto distribuido entre cancelaciones (~6–8%), devoluciones (~3–5%) y órdenes en flujo activo (~3–5% combinando pendiente/procesando/enviado).

### 3.2 Tasa de cancelación

El benchmark regional de cancelación está fuertemente influenciado por la efectividad de los métodos de pago locales y la prevención de fraude:

- Según el *Global eCommerce Payments and Fraud Report* del **Merchant Risk Council**, LATAM presenta la **tasa de aprobación de pagos más baja a nivel global: 57%** (BlackSip), contra 80%+ en mercados desarrollados.
- **4,1% de los ingresos anuales del e-commerce en LATAM se pierden por fraude** — el porcentaje más alto entre las cuatro regiones del mundo monitoreadas.
- **3,9% de los pedidos aceptados resultan fraudulentos** y **5,9% son rechazados por sospecha de fraude** (la cifra más alta a nivel global).
- El abandono de carrito promedio global ronda el **70–80%**, con LATAM en el rango alto debido a costos de envío inesperados, fricción en checkout y desconfianza en métodos de pago.

Combinando estos factores, una tasa de cancelación sana para un e-commerce LATAM se ubica entre **6–10%** de las órdenes que sí lograron formalizarse (sin contar abandono de carrito previo al check-out).

### 3.3 Tasa de devolución

La logística inversa es uno de los benchmarks donde LATAM se aleja más del promedio global de eficiencia:

- *Deloitte* estima que la **tasa promedio de devolución en e-commerce LATAM es del 20%**, escalando al 40% en eventos de alta demanda.
- La **AMVO** reporta que el **26% de los compradores digitales mexicanos** ha realizado una devolución en el último año.
- Para comparación, las tiendas físicas tienen tasas de devolución del 8–10%; el e-commerce duplica ese número por la imposibilidad de probar/ver el producto.
- DHL Supply Chain advierte que **hasta el 30% del costo del producto** puede asociarse a la devolución cuando se gestiona mal la logística inversa.

### 3.4 Pendientes y procesando — cuellos de botella regionales

LATAM tiene cuellos de botella estructurales en la fase previa al despacho:

- **Aduanas, infraestructura vial y fragmentación de operadores** son los principales generadores de tiempo muerto entre la generación de la orden y el envío efectivo (Beetrack, Grupo Ei).
- En operaciones multi-país sin centro de fulfillment local en cada mercado, los tiempos de procesamiento típicamente se duplican.
- Las órdenes en estados intermedios (validación de pago, verificación antifraude, picking & packing) deberían representar **menos del 5% combinado** en una operación saludable y madura. Cuando superan el 10% acumulado, hay un cuello de botella operativo.

## 4. Análisis comparativo por estado

### 4.1 Entregado — 63,5%

Para una operación con casi 5 años de antigüedad, el porcentaje de órdenes en estado "Entregado" debería ubicarse entre 80–85%. **El 63,5% de TiendaLatam es estructuralmente bajo**: representa una brecha de aproximadamente 17 puntos porcentuales frente al benchmark de un operador maduro. Esto se debe a que más de un tercio del inventario de órdenes permanece atascado en estados intermedios (Pendiente + Procesando + Enviado = 28,8%), lo cual no es coherente con un horizonte temporal de casi 5 años — sugiere que los flujos de transición de estado no se están cerrando.

**Categoría: Malo**

### 4.2 Enviado — 12,6%

Un 12,6% del total histórico de órdenes "en tránsito" es elevado. Aún en un escenario de fuerte aceleración reciente, este número implica que ~500 órdenes están en manos del operador logístico sin confirmación de entrega. Para una operación con un punto de distribución por país (modelo descentralizado favorable), este porcentaje debería estar bajo 5%. Refleja, o bien una FADR muy por debajo del 93% regional, o un problema de actualización de estados en el sistema (visibilidad/tracking).

**Categoría: Malo**

### 4.3 Procesando — 8,8%

El 8,8% en estado "Procesando" supera ampliamente el benchmark saludable (<3%). Es coherente con los cuellos de botella regionales documentados (validación de pago, picking, coordinación con operadores logísticos terceros), pero **TiendaLatam tiene la ventaja de operar un centro propio por país**, lo cual debería mitigar este indicador. El número actual sugiere falta de automatización en la fase de validación post-checkout.

**Categoría: Malo**

### 4.4 Pendiente — 7,4%

Las órdenes en estado "Pendiente" representan típicamente fallas en el primer paso del flujo: validación de pago, verificación antifraude o stock no confirmado. El 7,4% es alto frente al benchmark saludable de <2%, pero **debe leerse en contexto regional**: con una tasa de aprobación de pagos del 57% en LATAM y una tasa de rechazo por fraude del 5,9%, es esperable un volumen relativamente alto de órdenes que se quedan en este limbo. Aún así, 7,4% es excesivo y sugiere que no hay un proceso automatizado para resolver estas órdenes (timeout, retry, cancelación automática).

**Categoría: Malo**

### 4.5 Cancelado — 5,1%

Este es el indicador donde TiendaLatam se ubica **mejor frente al benchmark regional**. El rango saludable de cancelación en LATAM es 6–10%, y TiendaLatam está por debajo del piso. Hay dos lecturas posibles:

1. **Lectura positiva**: el filtrado de fraude y la calidad del checkout son superiores al promedio regional.
2. **Lectura cautelosa**: dado que el 7,4% está en "Pendiente" y posiblemente no se está convirtiendo en cancelación formal por falta de proceso automático, el 5,1% podría estar artificialmente bajo. El verdadero "no fulfillment" total (Pendiente + Cancelado) es 12,5%.

**Categoría: Promedio** — bueno en aislado, pero condicionado por el alto Pendiente.

### 4.6 Devuelto — 2,6%

Este es el indicador donde TiendaLatam se ubica **dramáticamente por debajo del benchmark regional** (Deloitte: 20% promedio, AMVO: 26% de compradores digitales). Lecturas posibles:

1. **Lectura positiva**: precisión de cumplimiento muy alta, calidad de producto y descripciones de catálogo superiores al promedio, lo cual es coherente con el AOV alto del segmento Minorista y VIP.
2. **Lectura cautelosa**: el dataset puede no estar capturando todas las devoluciones (logística inversa subreportada), o las políticas de devolución son tan restrictivas que muchas no llegan a registrarse como devolución formal sino como reclamo no resuelto.

Dada la coherencia con el alto AOV y la baja cancelación, la interpretación más plausible es positiva, aunque amerita una auditoría de logística inversa para validar.

**Categoría: Bueno**

## 5. Mejores prácticas para operaciones multi-país en LATAM con volumen similar

Los referentes regionales (Mercado Libre, Magalu, Amazon LATAM, Falabella) y firmas consultoras (DHL, Deloitte, AMI) convergen en seis prácticas clave para operaciones multi-país con volumen comparable al de TiendaLatam:

1. **Fulfillment descentralizado con centros propios por país** — TiendaLatam ya lo aplica, pero los indicadores sugieren que la operación interna de esos centros no está estandarizada.
2. **Pasarela de pagos local con métodos preferidos por mercado** (Mercado Pago, PIX en Brasil, OXXO en México, PSE en Colombia, transferencia en efectivo en Argentina) para subir la tasa de aprobación del 57% regional al 80%+.
3. **Antifraude automatizado con orquestación de reglas + ML** — los líderes regionales destinan inversión específica a este punto; reduce el limbo de órdenes "Pendientes" y baja la tasa de cancelación legítima.
4. **SLA de procesamiento <24h post-pago confirmado** con timeout automático para órdenes sin progreso (auto-cancelación a 72h en Pendiente, escalamiento a Customer Service).
5. **Trazabilidad end-to-end con notificaciones proactivas al cliente** — reduce contracargos y devoluciones por "no recibí mi pedido" (un patrón documentado de fraude de devolución en LATAM, la región más afectada por este tipo de estafa).
6. **Política de devolución clara y cuantificada** — el 89% de los consumidores afirma que la experiencia de devolución impacta su decisión de recompra (Shopify). En LATAM, donde la devolución cuesta hasta 30% del precio del producto, es clave dimensionarla en el costo operativo.

## 6. Tabla comparativa — TiendaLatam vs. Benchmark LATAM

| Estado | TiendaLatam | Benchmark LATAM | Fuente | Brecha | Categoría |
|---|---:|---:|---|---|:---:|
| Entregado | 63,5% | 80–85% | Operador maduro 5+ años (AMI, DHL) | -17 a -22 pp | **Malo** |
| Enviado | 12,6% | ≤5% | FADR LATAM 93%+ (Zeo) | +7,6 pp | **Malo** |
| Procesando | 8,8% | ≤3% | Centros propios benchmark (ML) | +5,8 pp | **Malo** |
| Pendiente | 7,4% | ≤2% | Validación + antifraude (MRC) | +5,4 pp | **Malo** |
| Cancelado | 5,1% | 6–10% | Aprobación pagos 57% LATAM (BlackSip) | -0,9 a -4,9 pp | **Promedio** |
| Devuelto | 2,6% | 20% | Deloitte LATAM / AMVO 26% | -17,4 pp | **Bueno** |

## 7. Síntesis ejecutiva

TiendaLatam tiene **un problema estructural en el flujo de cumplimiento**, no en la calidad del producto ni en la prevención de fraude. La operación captura bien el front del funnel (cancelación baja, devolución muy baja) pero **falla en mover las órdenes a través de los estados intermedios hacia "Entregado"**. El 28,8% combinado de órdenes en Pendiente + Procesando + Enviado es la métrica más reveladora: para una operación de casi 5 años, ese inventario debería estar resuelto.

Las tres acciones de mayor impacto serían:
1. **Automatizar el cierre de órdenes en "Pendiente"** (timeout + retry de pago + auto-cancelación) — bajaría el indicador del 7,4% al rango benchmark de <2%, liberando análisis y customer service.
2. **Auditar el flujo "Procesando → Enviado"** en los 10 centros de distribución — el 8,8% en Procesando sugiere que el SLA de picking & packing varía entre países y necesita estandarización.
3. **Implementar tracking proactivo de última milla** con confirmación automática de entrega — convertiría el 12,6% en Enviado a Entregado de forma más rápida y reduciría disputas.

El indicador de **Devuelto (2,6%)** es la fortaleza más diferenciada de TiendaLatam frente a la región y debe defenderse: validar que no haya devoluciones no registradas, y usar este dato como argumento competitivo en marketing (calidad de cumplimiento muy por encima del promedio LATAM).

---

### Fuentes consultadas
- **eCommerce Institute** y reportes regionales sobre logística e-commerce LATAM
- **CACE** (Cámara Argentina de Comercio Electrónico), 1er semestre 2024
- **AMVO** (Asociación Mexicana de Venta Online), Estudio de Venta Online 2024
- **Merchant Risk Council** — Global eCommerce Payments and Fraud Report 2024
- **Deloitte** — estimaciones de logística inversa en LATAM
- **DHL Supply Chain** — Camila Furlan, Directora E-commerce LATAM, 2025
- **Americas Market Intelligence** — reportes de última milla LATAM
- **BlackSip** — BlackStats Reporte Industria E-commerce LATAM 2024/2025
- **Statista / Baymard Institute** — tasas de abandono de carrito global
- **Zeo Route Planner** — benchmarks FADR 2026
