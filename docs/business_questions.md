# answering the questions

Cada pregunta está anclada a una de las 4 apuestas estratégicas de TiendaLatam `business_mission_and_strategy`.

**Misión:** *"Que cualquier latinoamericano pueda comprar productos de calidad al mejor precio del mercado, sin depender de lo que ofrece el comercio local."*

**Estrategia en una línea:** Ganar en precio → retener digitalmente → expandir donde el diferencial de precio duele más → diversificar catálogo para no depender de Tecnología.

---

## Bloque 0 — Contexto del negocio (sql/exploratory.sql)

> Antes de responder cualquier pregunta estratégica, necesitas entender qué tan grande es el negocio, qué tan sana es la operación y qué datos tienes disponibles. Este bloque es la base factual de todo lo que sigue.

**E1. ¿Qué volumen maneja el negocio y en qué ventana de tiempo?**
Respuesta esperada: GMV, revenue (órdenes Enviado + Entregado), # órdenes válidas, # clientes únicos, AOV global, ventana de fechas.
*Por qué importa:* establece el punto de partida. Sin esta foto de referencia, no puedes medir si la estrategia está funcionando.

| Métrica | Valor | % |
|---|---|---|
| Total órdenes | 4,000 | -- |
| Órdenes válidas | 3,045 | 76.12% |
| Clientes únicos | 700 | --- |
| Clientes con órdenes | 636 | 90.86% |
| GMV | $1,958,767.55 | --- |
| Revenue | $1,473,497.20 | 75.22% |
| AOV | $489.69 | - |
| Primera orden | 2021-07-01 | - |
| Última orden | 2026-04-29 | - |

**E2. ¿Qué tan saludable es la operación según los estados de pedido?**
Foco: % entregado, % cancelado, % devuelto. Alerta si cancelado + devuelto > 10%.
*Por qué importa:* un modelo digital que promete la mejor relación calidad-precio se rompe si la operación falla. La tasa de entrega es el primer indicador de que la promesa se cumple o no.

| Status | Órdenes | % Share |
|---|---:|---:|
| Entregado | 2,542 | 63.5% |
| Enviado | 503 | 12.6% |
| Procesando | 350 | 8.8% |
| Pendiente | 296 | 7.4% |
| Cancelado | 203 | 5.1% |
| Devuelto | 106 | 2.6% |

**E2b. ¿Cuánto del GMV se convierte en revenue real, y por qué se pierde el resto?** no ex relevante en este momento?
Foco: desglosar el gap GMV ($1,958,767) → revenue ($1,473,497) — un 24.78% que se escapa. ¿Qué parte son cancelaciones, devoluciones, y órdenes aún en proceso? ¿Es este porcentaje esperado para retail digital en LATAM?
*Por qué importa:* si la promesa de precio atrae al cliente pero la operación falla en casi 1 de cada 4 órdenes, el moat se erosiona. Este número es la brecha entre lo que el negocio podría ser y lo que realmente captura.
*Nota:* con los datos actuales se puede descomponer por status. Para benchmarking competitivo se necesitan datos externos — ver sección de Gaps al final.

**E3. ¿Cómo se distribuyen los clientes por tipo?**
Foco: proporción Minorista / Mayorista / Corporativo / VIP por mercado. Identificar sobre-indexaciones.
*Por qué importa:* la misión apunta al consumidor latinoamericano individual — Minorista es el segmento más alineado. Entender el mix actual revela si la base de clientes responde al posicionamiento o si hay ruido.
*Comportamieto por país:* La distribucion de tipo de cliente es muy similar en los 10 paises.

| Tipo de Cliente | Clientes | Órdenes | Revenue | % Revenue |
|---|---:|---:|---:|---:|
| Minorista | 392 | 1,908 | $935,941.30 | 63.52% |
| Mayorista | 118 | 527 | $235,985.70 | 16.02% |
| Corporativo | 74 | 354 | $179,496.10 | 12.18% |
| VIP | 52 | 256 | $122,074.10 | 8.28% |

**E4. ¿Cuáles son los productos top y a qué categoría pertenecen?**
Foco: ¿hay un producto que arrastra solo el revenue? ¿qué % del catálogo genera el 80% de las ventas?
*Por qué importa:* spoiler — la Laptop Ultraliviana representa el 33.2% del revenue total. Eso es una dependencia crítica, no una fortaleza.

--- 4. Top 10 productos más vendidos

| Producto | Categoría | Unidades vendidas | Revenue | % del revenue total |
|---|---|---:|---:|---:|
| Aceite de Oliva 500 ml | Alimentos | 673 | $5,888.75 | 0.40% |
| Banda Elástica Resistencia | Deportes | 645 | $4,192.50 | 0.28% |
| Set Cuidado Facial | Belleza | 640 | $20,480.00 | 1.39% |
| Licuadora 6 Velocidades | Hogar | 619 | $40,173.10 | 2.73% |
| Chaqueta Impermeable | Moda | 614 | $42,673.00 | 2.90% |
| Gorra Bordada | Moda | 606 | $6,969.00 | 0.47% |
| Cargador USB-C Rápido | Tecnología | 605 | $13,007.50 | 0.88% |
| Casco Bicicleta Urbano | Deportes | 603 | $24,723.00 | 1.68% |
| Muñeca Articulada | Juguetería | 602 | $13,183.80 | 0.89% |
| Aspiradora Compacta | Hogar | 599 | $71,281.00 | 4.84% |

-- 8. Top 20 productos con mas Renevue (20/50)

| # | Producto | Categoría | Precio lista | Órdenes | Unidades | Revenue | % Revenue | % Acumulado |
|---|---|---|---:|---:|---:|---:|---:|---:|
| 2 | Laptop Ultraliviana 14 | Tecnología | $799.00 | 264 | 814 | $650,386.00 | 33.20% | 33.20% |
| 1 | Smartphone Andino X1 | Tecnología | $349.90 | 248 | 730 | $255,427.00 | 13.04% | 46.24% |
| 15 | Aspiradora Compacta | Hogar | $119.00 | 251 | 747 | $88,893.00 | 4.54% | 50.78% |
| 11 | Set de Ollas Antiadherentes | Hogar | $89.90 | 240 | 726 | $65,267.40 | 3.33% | 54.11% |
| 18 | Chaqueta Impermeable | Moda | $69.50 | 247 | 761 | $52,889.50 | 2.70% | 56.81% |
| 9 | Licuadora 6 Velocidades | Hogar | $64.90 | 258 | 784 | $50,881.60 | 2.60% | 59.41% |
| 6 | Teclado Mecánico Compacto | Tecnología | $72.00 | 229 | 670 | $48,240.00 | 2.46% | 61.87% |
| 10 | Cafetera Programable | Hogar | $52.75 | 250 | 774 | $40,828.50 | 2.08% | 63.96% |
| 3 | Audífonos Bluetooth Pro | Tecnología | $59.90 | 232 | 680 | $40,732.00 | 2.08% | 66.04% |
| 19 | Zapatillas Urbanas | Moda | $58.90 | 233 | 683 | $40,228.70 | 2.05% | 68.09% |
| 27 | Perfume Floral 100 ml | Belleza | $48.90 | 241 | 752 | $36,772.80 | 1.88% | 69.97% |
| 4 | Parlante Portátil Caribe | Tecnología | $44.50 | 254 | 765 | $34,042.50 | 1.74% | 71.71% |
| 13 | Juego de Sábanas Queen | Hogar | $45.00 | 255 | 752 | $33,840.00 | 1.73% | 73.44% |
| 41 | Casco Bicicleta Urbano | Deportes | $41.00 | 266 | 785 | $32,185.00 | 1.64% | 75.08% |
| 17 | Jeans Slim Fit | Moda | $39.90 | 247 | 729 | $29,087.10 | 1.48% | 76.56% |
| 8 | Power Bank 20000 mAh | Tecnología | $39.90 | 245 | 728 | $29,047.20 | 1.48% | 78.05% |
| 20 | Mochila Ejecutiva | Moda | $42.00 | 232 | 683 | $28,686.00 | 1.46% | 79.51% |
| 28 | Afeitadora Eléctrica | Belleza | $36.50 | 260 | 762 | $27,813.00 | 1.42% | 80.93% |
| 26 | Set Cuidado Facial | Belleza | $32.00 | 261 | 806 | $25,792.00 | 1.32% | 82.25% |
| 45 | Carro a Control Remoto | Juguetería | $37.90 | 220 | 678 | $25,696.20 | 1.31% | 83.56% |

-- 9. Revenue por categoría

| Categoría | Órdenes | Unidades | Revenue | % Revenue |
|---|---:|---:|---:|---:|
| Tecnología | 1,240 | 4,514 | $806,784.00 | 54.75% |
| Hogar | 1,118 | 3,946 | $244,044.75 | 16.56% |
| Moda | 1,107 | 3,985 | $144,726.75 | 9.82% |
| Belleza | 979 | 3,439 | $86,214.10 | 5.85% |
| Deportes | 1,012 | 3,390 | $77,837.70 | 5.28% |
| Juguetería | 823 | 2,699 | $70,852.10 | 4.81% |
| Alimentos | 1,062 | 3,916 | $28,496.85 | 1.93% |
| Papelería | 716 | 2,209 | $14,540.95 | 0.99% |

Tecnología sola genera más revenue que las otras 7 categorías juntas (54.75% vs 45.25%). Vale cruzar esto con el hallazgo anterior: la Laptop y el Smartphone explican la mayor parte de ese 54% — lo que significa que la categoría entera descansa sobre 2 SKUs.


**E5. ¿Qué productos no han vendido o tienen stock muerto?**
Foco: SKUs con stock > 0 y cero ventas. Candidatos a descatalogación o relanzamiento.
*Por qué importa:* en un modelo digital el costo de catálogo es más bajo, pero el costo de confusión para el usuario no lo es. Un catálogo limpio refuerza la promesa de precio.

| # | Producto | Categoría | Precio lista | Stock | Órdenes | Unidades | Revenue | % Revenue |
|---|---|---|---:|---:|---:|---:|---:|---:|
| 34 | Galletas Integrales | Alimentos | $3.60 | 450 | 224 | 755 | $2,718.00 | 0.14% |
| 47 | Cuaderno Profesional | Papelería | $3.90 | 700 | 257 | 751 | $2,928.90 | 0.15% |
| 30 | Chocolate Amargo 70% | Alimentos | $4.20 | 600 | 227 | 731 | $3,070.20 | 0.16% |
| 48 | Set de Marcadores | Papelería | $5.80 | 520 | 272 | 760 | $4,408.00 | 0.23% |
| 50 | Resma Papel Carta | Papelería | $6.75 | 400 | 235 | 667 | $4,502.25 | 0.23% |

Algo interesante: ninguno de estos productos tiene cero ventas — todos tienen entre 224 y 272 órdenes, que es volumen comparable al resto del catálogo. El problema no es que no se vendan, sino que su precio unitario es tan bajo ($3.60–$6.75) que aunque se vendan bien en unidades, su contribución al revenue es marginal. Son categorías de frecuencia (Alimentos, Papelería), no de margen.

**E6. ¿Quién es realmente el cliente de TiendaLatam? (ICP)**
Foco: perfil del cliente más frecuente — tipo de cliente (Minorista, Mayorista, Corporativo, VIP), país, AOV, frecuencia de compra, categorías preferidas. ¿El cliente que más compra es el que la misión describe?
*Por qué importa:* la misión habla de "cualquier latinoamericano". Si el 63% del revenue viene de Minoristas pero el LTV de Corporativos es 5x mayor, hay una decisión estratégica pendiente: ¿a quién estamos construyendo realmente? Responder esto con datos es más valioso que cualquier persona de marketing.

| Tipo | Clientes | Órdenes válidas | Revenue | AOV | Órdenes / cliente |
|---|---|---|---|---|---|
| Minorista | 392 (56%) | 1,908 (63%) | $935,941 (63.5%) | $491 | 4.87 |
| Mayorista | 118 (17%) | 527 (17%) | $235,986 (16%) | $448 | 4.47 |
| Corporativo | 74 (11%) | 354 (12%) | $179,496 (12.2%) | $507 | 4.78 |
| VIP | 52 (7%) | 256 (8%) | $122,074 (8.3%) | $477 | 4.92 |

El dato más sorprendente: la frecuencia de compra promedio es casi idéntica en los cuatro tipos (entre 4.5 y 4.9 órdenes por cliente). El Minorista domina el negocio no porque compre más seguido que el resto, sino porque hay cuatro veces más Minoristas que cualquier otro tipo.

Con el 63.5% del revenue y la mayor base absoluta, el Minorista es el cliente que sostiene la operación. Pero dentro de este segmento conviven tres perfiles muy distintos.

Tres perfiles internos

| Perfil | Clientes | % del tipo | Revenue (seg.) | LTV promedio | Órdenes prom. |
|---|---|---|---|---|---|
| Power buyer (10+ órdenes) | 71 | 18.1% | ~$539,000 | $7,592 | 17 |
| Regular (2–9 órdenes) | 165 | 42.1% | ~$312,000 | $1,888 | 4–5 |
| One-time (1 orden) | 156 | 39.8% | ~$85,000 | ~$545 | 1 |

El poder buyer es 71 personas — el 18% del segmento — pero generan aproximadamente el 57% del revenue Minorista. Con 17 órdenes promedio cada uno, su LTV es cuatro veces el del cliente regular y catorce veces el del one-time.

Analisis detallado `icp_analysis`

---

## Apuesta 1 — El motor central: precio competitivo (sql/exploratory.sql + sql/more_insights.sql)

> **La pregunta estratégica detrás:** ¿Tenemos realmente liderazgo de precio en las categorías que más pesan, y cómo lo extendemos a las que queremos crecer?

**A1-Q1. ¿Cuál es la curva ABC del catálogo?**
SQL: `sql/more_insights.sql` Q11
Foco: qué % de productos (categoría A) generan el 80% del revenue. ¿Cuántos SKUs son prescindibles?
*Decisión que habilita:* curación del catálogo digital. En Tecnología se defiende el liderazgo; en el resto se evalúa si el precio es competitivo antes de invertir en marketing.

**A1-Q2. ¿Cuáles son los productos en riesgo de quiebre de stock?**
SQL: `sql/more_insights.sql` Q13
Foco: productos con alta rotación y stock bajo. Días de inventario disponible.
*Decisión que habilita:* si un producto líder tiene quiebre de stock, la promesa de precio se rompe — el cliente va al comercio local. Esto es una alerta operativa directa a la misión.

**A1-Q3. ¿Qué productos se compran juntos?**
SQL: `sql/more_insights.sql` Q14
Foco: pares de productos con mayor co-purchase rate. Base para bundles y cross-sell.
*Decisión que habilita:* aumentar el AOV sin cambiar el catálogo. Un bundle bien diseñado refuerza la percepción de valor-precio.

**A1-Q4. ¿Nuestro precio es realmente competitivo frente al comercio local? (gap de datos)**
Foco: comparar el precio de lista de los productos top (Laptop, Smartphone, Aspiradora) contra el precio promedio del comercio local en cada mercado.
*Decisión que habilita:* validar si la Apuesta 1 tiene fundamento real o es solo una promesa declarativa. Si el diferencial de precio no existe o no es percibido, toda la estrategia está construida sobre arena.
*Nota — gap de datos:* este análisis NO es resoluble con el dataset actual. Requiere scraping o fuentes externas de pricing competitivo (Mercado Libre, Linio, Falabella). Documentarlo como brecha es en sí mismo un ejercicio PM valioso — demuestra que sabes lo que no sabes.

---

## Apuesta 2 — Retención digital (sql/retention_rfm.sql)

> **La pregunta estratégica detrás:** Sin tiendas físicas, toda la retención ocurre en canales digitales. ¿Estamos tapando la fuga o dejando escapar revenue que ya adquirimos?

**A2-Q4. ¿Cuál es la curva de retención por cohorte mensual?**
SQL: `sql/retention_rfm.sql` Q6
Foco: % de clientes de cada cohorte que vuelven a comprar en el mes 1, 3, 6 y 12.
*Decisión que habilita:* si la retención mejora en cohortes recientes, hay señal de PMF. Si degrada, el problema de churn es estructural y precede a cualquier inversión en adquisición.

**A2-Q5. ¿Cómo se segmentan los 636 clientes compradores con RFM?**
SQL: `sql/retention_rfm.sql` Q7
Foco: etiquetar a cada cliente en Champions, Loyal, At Risk, New/Promising, About to Sleep, Needs Attention, Hibernating, Lost.
*Decisión que habilita:* sin segmentación RFM, cualquier campaña de retención es spray-and-pray. Con ella, cada segmento recibe un tratamiento distinto y medible.

**A2-Q6. ¿Qué % del revenue viene de cada segmento RFM?**
SQL: `sql/retention_rfm.sql` Q8
Foco: concentración de valor. Champions + Loyal vs el resto.
*Decisión que habilita:* priorizar dónde actuar. Los Champions (132 clientes, 56.4% del revenue) son el activo más frágil del negocio — perder 10 de ellos duele más que perder 100 clientes nuevos.

**A2-Q7. ¿Cuál es la tasa de churn actual y cómo varía por segmento?**
SQL: `sql/retention_rfm.sql` Q10
Foco: % de clientes sin compra en los últimos 180 días, desglosado por tipo de cliente y segmento RFM.
*Decisión que habilita:* cuantificar el revenue en riesgo. At Risk + Hibernating + Lost representan revenue histórico que puede reactivarse con bajo costo relativo.

**A2-Q8. ¿Cuántos días tarda un cliente en hacer su 2da compra?**
SQL: `sql/more_insights.sql` Q15
Foco: mediana y distribución del time-to-second-purchase. ¿Cuál es el momento óptimo para una campaña de reengagement?
*Decisión que habilita:* diseñar el flujo de activación digital post-primera compra. La mediana de 74 días define cuándo activar el primer touchpoint automático — antes de que el cliente enfríe.

**A2-Q9b. ¿Las órdenes en estado "Pendiente" y "Procesando" representan un cuello de botella con impacto en retención?**
Foco: volumen de órdenes en estados intermedios (296 Pendiente + 350 Procesando = 16.2% del total). ¿Hay clientes con múltiples órdenes atascadas? ¿Se correlaciona con menor frecuencia de recompra?
*Decisión que habilita:* sin tiendas físicas, la experiencia post-compra es el único punto de contacto operativo con el cliente. Si una orden queda atascada y nadie la resuelve, ese cliente no vuelve. Este análisis conecta directamente la salud operativa con la tasa de retención.
*Nota — gap de datos:* el dataset no tiene timestamps de cambio de estado, así que no podemos medir cuánto tiempo lleva una orden en "Pendiente". Lo que sí podemos hacer es cruzar clientes con órdenes en estos estados contra su historial de recompra.

**A2-Q9. ¿Cuál es el LTV promedio por tipo de cliente?**
SQL: `sql/retention_rfm.sql` Q9
Foco: LTV acumulado de Minorista vs Mayorista vs Corporativo vs VIP.
*Decisión que habilita:* validar si el mix de adquisición está alineado con la misión. Si el LTV de Minoristas es bajo en comparación con Corporativos, hay una tensión con el posicionamiento hacia el consumidor individual.

**A2-Q9c. ¿Vale la pena la apuesta por clientes VIP y Corporativos, o están desviando foco de la misión?**
Foco: comparar LTV, frecuencia de compra, AOV y churn rate de VIP/Corporativo (136 clientes, 20.46% del revenue) vs Minorista (392 clientes, 63.52% del revenue). ¿El costo de adquirir y retener un cliente Corporativo se justifica frente al volumen de Minoristas?
*Decisión que habilita:* la misión apunta al "cualquier latinoamericano" — consumidor individual, no empresa. Si el LTV de Corporativos es muy superior pero hay pocos, hay una tensión estratégica: ¿estamos sirviendo a quien dijimos que serviríamos? Esta pregunta no tiene una respuesta correcta, pero un PM debe poder articularla con datos.

**A2-Q10. ¿Qué % del revenue viene de clientes nuevos vs recurrentes?**
SQL: `sql/growth_metrics.sql` Q3
Foco: evolución mensual de la proporción nuevos/recurrentes. ¿El negocio está madurando o todavía depende de adquisición?
*Decisión que habilita:* un negocio sano en la etapa de TiendaLatam debería ver la curva de recurrentes crecer en términos absolutos. Si no, hay un problema de retención que ningún gasto en adquisición puede resolver.

---

## Apuesta 3 — Expansión geográfica (sql/growth_metrics.sql)

> **La pregunta estratégica detrás:** Colombia, Brasil y México son grandes y están underperforming. ¿El problema es de demanda, de precio o de operación?

**A3-Q11. ¿Cómo ha evolucionado el revenue mes a mes por país? ¿Estamos creciendo?**
SQL: `sql/growth_metrics.sql` Q1
Foco: MoM growth % global y por mercado. Identifica meses con caída fuerte y picos estacionales.
*Decisión que habilita:* distinguir mercados en aceleración (candidatos a más inversión) de mercados estancados (requieren diagnóstico antes de escalar).

**A3-Q11b. ¿Todos los mercados se lanzaron al mismo tiempo, o hay diferencias de madurez que distorsionan la comparación?**
Foco: fecha de primera orden por país. Si Colombia lanzó 12 meses después que Ecuador, comparar su revenue absoluto es injusto y lleva a decisiones equivocadas.
*Decisión que habilita:* construir una comparación justa entre mercados — la base para priorizar en la Apuesta 3. Un mercado "underperforming" puede ser simplemente más joven.
*SQL sugerido:* `SELECT country, MIN(o.registration_date) AS first_order FROM orders o JOIN clients c ON o.client_id = c.client_id JOIN countries co ON c.country_id = co.country_id GROUP BY country ORDER BY first_order`

**A3-Q12. ¿Qué país tiene la mejor y peor performance, y cuál es el diagnóstico?**
SQL: `sql/growth_metrics.sql` Q4
Foco: cruzar revenue con AOV, % cancelación y % devolución por país. Un país puede vender mucho con mala calidad operativa.
*Decisión que habilita:* priorizar la Apuesta 3. Si Colombia, Brasil o México tienen alta cancelación, el problema no es awareness — es que la operación no está lista para escalar ahí.

**A3-Q12b. ¿Los patrones de cancelación y devolución varían por país Y por categoría?**
Foco: matriz país × categoría para tasa de cancelación y devolución. ¿Hay categorías específicas que generan más problemas en ciertos mercados?
*Decisión que habilita:* distinguir entre un problema operativo (afecta todas las categorías en un país) y un problema de producto o expectativa (afecta categorías específicas). Son dos diagnósticos distintos y requieren soluciones distintas.

**A3-Q13b. ¿La moneda y la volatilidad cambiaria afectan la percepción de precio en cada mercado? (gap de datos)**
Foco: si los precios están fijados en USD, países con alta inflación o devaluación reciente (Argentina, Colombia) perciben el precio de forma muy distinta mes a mes. ¿Hay correlación entre meses de alta volatilidad cambiaria y caída de órdenes?
*Decisión que habilita:* la promesa de "mejor precio del mercado" es relativa a la moneda local. Si el tipo de cambio deteriora el poder adquisitivo, TiendaLatam puede volverse más cara que el comercio local sin haberlo elegido.
*Nota — gap de datos:* requiere cruzar con datos externos de tipo de cambio (banco central o APIs como Open Exchange Rates).

**A3-Q13. ¿El AOV difiere entre mercados y cómo evoluciona?**
SQL: `sql/growth_metrics.sql` Q2
Foco: AOV por país y por tipo de cliente. Hipótesis: AOV bajo en mercados grandes indica tickets pequeños o mix de categorías diferente.
*Decisión que habilita:* afinar el argumento de precio. Si en Colombia el AOV es bajo ($428 vs $563 en Argentina), ¿es porque el cliente compra menos o porque no encuentra los productos premium que busca?

---

## Apuesta 4 — Diversificación de catálogo (sql/growth_metrics.sql + sql/more_insights.sql)

> **La pregunta estratégica detrás:** Tecnología genera el 74% del revenue con un solo SKU que vale el 33%. ¿Cómo crecemos Hogar, Moda y Deportes sin perder el liderazgo de precio que es el motor?

**A4-Q14. ¿Qué categorías de producto crecen y cuáles se estancan?**
SQL: `sql/growth_metrics.sql` Q5
Foco: MoM de revenue y unidades por categoría. Identifica categorías con volumen de unidades pero revenue bajo — señal de que hay demanda pero falta ticket.
*Decisión que habilita:* decidir en qué categorías invertir en precio y marketing. Hogar y Moda ya tienen volumen de unidades — el gap es de precio percibido, no de demanda.

**A4-Q15. ¿Cómo es el performance del equipo de ventas por tienda?**
SQL: `sql/more_insights.sql` Q12
Foco: revenue por empleado, órdenes gestionadas, AOV por vendedor.
*Decisión que habilita:* aunque TiendaLatam es un modelo digital, las 10 tiendas físicas existen. Entender qué vendedores tienen mejor performance por categoría puede informar qué categorías tienen mayor potencial de crecimiento en cada mercado.

---

## Plantilla para el caso de estudio

| Pregunta | Apuesta estratégica | Hallazgo principal | Implicación | Recomendación |
|----------|--------------------|--------------------|-------------|----------------|
| E2b | Motor (precio) | | | |
| A1-Q1 | Precio | | | |
| A2-Q4 | Retención | | | |
| A2-Q7 | Retención | | | |
| A2-Q9c | Misión / ICP | | | |
| A3-Q11b | Expansión | | | |
| A3-Q12 | Expansión | | | |
| A4-Q14 | Catálogo | | | |

De esta tabla saldrán los 3-5 insights estrella del dashboard y las 3 recomendaciones de producto priorizadas con ICE.

---

## Gaps de datos identificados

Estas preguntas son estratégicamente relevantes pero no son respondibles con el dataset actual. Documentarlas es parte del trabajo PM — demuestra criterio sobre lo que sabes y lo que no sabes.

| Pregunta | Dato faltante | Fuente sugerida |
|----------|--------------|-----------------|
| ¿Nuestro precio es realmente competitivo? (A1-Q4) | Precios de competidores por SKU | Scraping Mercado Libre / Falabella / Linio |
| ¿La volatilidad cambiaria afecta ventas por país? (A3-Q13b) | Tipo de cambio mensual por país | Open Exchange Rates API, banco central |
| ¿Cuánto tiempo lleva una orden en estado "Pendiente"? | Timestamps por cambio de estado | Sistema de gestión de pedidos (OMS) |
| ¿Por qué cancela o devuelve el cliente? | Razón de cancelación / devolución | Campo libre en formulario post-cancelación |
| ¿Cuál es el CAC por mercado? | Presupuesto de marketing por país | ERP / herramienta de ads |

---

## North Star Metric y frameworks PM

**North Star Metric recomendada:** Revenue mensual de clientes recurrentes (Enviado + Entregado).

Por qué: refleja simultáneamente la Apuesta 1 (el precio retiene), la Apuesta 2 (la retención digital funciona) y el estado de salud real del negocio. Crecer adquisición sin que esta métrica suba significa que se está llenando un balde con el fondo roto.

**Candidatas alternativas según audiencia:**
- Para el equipo de operaciones: tasa de entrega exitosa por país (Apuesta 3)
- Para el equipo de catálogo: % del revenue proveniente de categorías no-Tecnología (Apuesta 4)
- Para el equipo de CRM: % de clientes At Risk reactivados en los últimos 90 días (Apuesta 2)

**Frameworks aplicados:**
- **AARRR:** Activation (64 sin primera compra + E6 ICP), Retention (cohortes, RFM, A2-Q9b ops), Revenue (LTV por segmento, A2-Q9c misión). Acquisition y Referral no tienen datos disponibles.
- **ICE Scoring:** úsalo para priorizar las 3 recomendaciones finales. Referencia en `docs/findings_preliminary.md`.
- **JTBD:** Champions "contratan" TiendaLatam para abastecerse con garantía de precio. At Risk posiblemente encontraron una alternativa más barata o más conveniente — esa hipótesis debe guiar el reengagement. Minoristas contratan "resolver una necesidad puntual sin pagar más de lo justo".

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Las preguntas que se buscan responder

Cada pregunta está anclada a una de las 4 apuestas estratégicas de TiendaLatam `business_mission_and_strategy`.

**Misión:** *"Que cualquier latinoamericano pueda comprar productos de calidad al mejor precio del mercado, sin depender de lo que ofrece el comercio local."*

**Estrategia en una línea:** Ganar en precio → retener digitalmente → expandir donde el diferencial de precio duele más → diversificar catálogo para no depender de Tecnología.

---

## Bloque 0 — Contexto del negocio (sql/exploratory.sql)

> Antes de responder cualquier pregunta estratégica, necesitas entender qué tan grande es el negocio, qué tan sana es la operación y qué datos tienes disponibles. Este bloque es la base factual de todo lo que sigue.

**E1. ¿Qué volumen maneja el negocio y en qué ventana de tiempo?**
Respuesta esperada: GMV, revenue (órdenes Enviado + Entregado), # órdenes válidas, # clientes únicos, AOV global, ventana de fechas.
*Por qué importa:* establece el punto de partida. Sin esta foto de referencia, no puedes medir si la estrategia está funcionando.

**E2. ¿Qué tan saludable es la operación según los estados de pedido?**
Foco: % entregado, % cancelado, % devuelto. Alerta si cancelado + devuelto > 10%.
*Por qué importa:* un modelo digital que promete la mejor relación calidad-precio se rompe si la operación falla. La tasa de entrega es el primer indicador de que la promesa se cumple o no.

**E2b. ¿Cuánto del GMV se convierte en revenue real, y por qué se pierde el resto?**
Foco: desglosar el gap GMV ($1,958,767) → revenue ($1,473,497) — un 24.78% que se escapa. ¿Qué parte son cancelaciones, devoluciones, y órdenes aún en proceso? ¿Es este porcentaje esperado para retail digital en LATAM?
*Por qué importa:* si la promesa de precio atrae al cliente pero la operación falla en casi 1 de cada 4 órdenes, el moat se erosiona. Este número es la brecha entre lo que el negocio podría ser y lo que realmente captura.
*Nota:* con los datos actuales se puede descomponer por status. Para benchmarking competitivo se necesitan datos externos — ver sección de Gaps al final.

**E3. ¿Cómo se distribuyen los clientes por tipo y país?**
Foco: proporción Minorista / Mayorista / Corporativo / VIP por mercado. Identificar sobre-indexaciones.
*Por qué importa:* la misión apunta al consumidor latinoamericano individual — Minorista es el segmento más alineado. Entender el mix actual revela si la base de clientes responde al posicionamiento o si hay ruido.

**E4. ¿Cuáles son los productos top y a qué categoría pertenecen?**
Foco: ¿hay un producto que arrastra solo el revenue? ¿qué % del catálogo genera el 80% de las ventas?
*Por qué importa:* spoiler — la Laptop Ultraliviana representa el 33.2% del revenue total. Eso es una dependencia crítica, no una fortaleza.

**E5. ¿Qué productos no han vendido o tienen stock muerto?**
Foco: SKUs con stock > 0 y cero ventas. Candidatos a descatalogación o relanzamiento.
*Por qué importa:* en un modelo digital el costo de catálogo es más bajo, pero el costo de confusión para el usuario no lo es. Un catálogo limpio refuerza la promesa de precio.

**E6. ¿Quién es realmente el cliente de TiendaLatam? (ICP)**
Foco: perfil del cliente más frecuente — tipo de cliente (Minorista, Mayorista, Corporativo, VIP), país, AOV, frecuencia de compra, categorías preferidas. ¿El cliente que más compra es el que la misión describe?
*Por qué importa:* la misión habla de "cualquier latinoamericano". Si el 63% del revenue viene de Minoristas pero el LTV de Corporativos es 5x mayor, hay una decisión estratégica pendiente: ¿a quién estamos construyendo realmente? Responder esto con datos es más valioso que cualquier persona de marketing.

---

## Apuesta 1 — El motor central: precio competitivo (sql/exploratory.sql + sql/more_insights.sql)

> **La pregunta estratégica detrás:** ¿Tenemos realmente liderazgo de precio en las categorías que más pesan, y cómo lo extendemos a las que queremos crecer?

**A1-Q1. ¿Cuál es la curva ABC del catálogo?**
SQL: `sql/more_insights.sql` Q11
Foco: qué % de productos (categoría A) generan el 80% del revenue. ¿Cuántos SKUs son prescindibles?
*Decisión que habilita:* curación del catálogo digital. En Tecnología se defiende el liderazgo; en el resto se evalúa si el precio es competitivo antes de invertir en marketing.

**A1-Q2. ¿Cuáles son los productos en riesgo de quiebre de stock?**
SQL: `sql/more_insights.sql` Q13
Foco: productos con alta rotación y stock bajo. Días de inventario disponible.
*Decisión que habilita:* si un producto líder tiene quiebre de stock, la promesa de precio se rompe — el cliente va al comercio local. Esto es una alerta operativa directa a la misión.

**A1-Q3. ¿Qué productos se compran juntos?**
SQL: `sql/more_insights.sql` Q14
Foco: pares de productos con mayor co-purchase rate. Base para bundles y cross-sell.
*Decisión que habilita:* aumentar el AOV sin cambiar el catálogo. Un bundle bien diseñado refuerza la percepción de valor-precio.

**A1-Q4. ¿Nuestro precio es realmente competitivo frente al comercio local? (gap de datos)**
Foco: comparar el precio de lista de los productos top (Laptop, Smartphone, Aspiradora) contra el precio promedio del comercio local en cada mercado.
*Decisión que habilita:* validar si la Apuesta 1 tiene fundamento real o es solo una promesa declarativa. Si el diferencial de precio no existe o no es percibido, toda la estrategia está construida sobre arena.
*Nota — gap de datos:* este análisis NO es resoluble con el dataset actual. Requiere scraping o fuentes externas de pricing competitivo (Mercado Libre, Linio, Falabella). Documentarlo como brecha es en sí mismo un ejercicio PM valioso — demuestra que sabes lo que no sabes.

---

## Apuesta 2 — Retención digital (sql/retention_rfm.sql)

> **La pregunta estratégica detrás:** Sin tiendas físicas, toda la retención ocurre en canales digitales. ¿Estamos tapando la fuga o dejando escapar revenue que ya adquirimos?

**A2-Q4. ¿Cuál es la curva de retención por cohorte mensual?**
SQL: `sql/retention_rfm.sql` Q6
Foco: % de clientes de cada cohorte que vuelven a comprar en el mes 1, 3, 6 y 12.
*Decisión que habilita:* si la retención mejora en cohortes recientes, hay señal de PMF. Si degrada, el problema de churn es estructural y precede a cualquier inversión en adquisición.

**A2-Q5. ¿Cómo se segmentan los 636 clientes compradores con RFM?**
SQL: `sql/retention_rfm.sql` Q7
Foco: etiquetar a cada cliente en Champions, Loyal, At Risk, New/Promising, About to Sleep, Needs Attention, Hibernating, Lost.
*Decisión que habilita:* sin segmentación RFM, cualquier campaña de retención es spray-and-pray. Con ella, cada segmento recibe un tratamiento distinto y medible.

**A2-Q6. ¿Qué % del revenue viene de cada segmento RFM?**
SQL: `sql/retention_rfm.sql` Q8
Foco: concentración de valor. Champions + Loyal vs el resto.
*Decisión que habilita:* priorizar dónde actuar. Los Champions (132 clientes, 56.4% del revenue) son el activo más frágil del negocio — perder 10 de ellos duele más que perder 100 clientes nuevos.

**A2-Q7. ¿Cuál es la tasa de churn actual y cómo varía por segmento?**
SQL: `sql/retention_rfm.sql` Q10
Foco: % de clientes sin compra en los últimos 180 días, desglosado por tipo de cliente y segmento RFM.
*Decisión que habilita:* cuantificar el revenue en riesgo. At Risk + Hibernating + Lost representan revenue histórico que puede reactivarse con bajo costo relativo.

**A2-Q8. ¿Cuántos días tarda un cliente en hacer su 2da compra?**
SQL: `sql/more_insights.sql` Q15
Foco: mediana y distribución del time-to-second-purchase. ¿Cuál es el momento óptimo para una campaña de reengagement?
*Decisión que habilita:* diseñar el flujo de activación digital post-primera compra. La mediana de 74 días define cuándo activar el primer touchpoint automático — antes de que el cliente enfríe.

**A2-Q9b. ¿Las órdenes en estado "Pendiente" y "Procesando" representan un cuello de botella con impacto en retención?**
Foco: volumen de órdenes en estados intermedios (296 Pendiente + 350 Procesando = 16.2% del total). ¿Hay clientes con múltiples órdenes atascadas? ¿Se correlaciona con menor frecuencia de recompra?
*Decisión que habilita:* sin tiendas físicas, la experiencia post-compra es el único punto de contacto operativo con el cliente. Si una orden queda atascada y nadie la resuelve, ese cliente no vuelve. Este análisis conecta directamente la salud operativa con la tasa de retención.
*Nota — gap de datos:* el dataset no tiene timestamps de cambio de estado, así que no podemos medir cuánto tiempo lleva una orden en "Pendiente". Lo que sí podemos hacer es cruzar clientes con órdenes en estos estados contra su historial de recompra.

**A2-Q9. ¿Cuál es el LTV promedio por tipo de cliente?**
SQL: `sql/retention_rfm.sql` Q9
Foco: LTV acumulado de Minorista vs Mayorista vs Corporativo vs VIP.
*Decisión que habilita:* validar si el mix de adquisición está alineado con la misión. Si el LTV de Minoristas es bajo en comparación con Corporativos, hay una tensión con el posicionamiento hacia el consumidor individual.

**A2-Q9c. ¿Vale la pena la apuesta por clientes VIP y Corporativos, o están desviando foco de la misión?**
Foco: comparar LTV, frecuencia de compra, AOV y churn rate de VIP/Corporativo (136 clientes, 20.46% del revenue) vs Minorista (392 clientes, 63.52% del revenue). ¿El costo de adquirir y retener un cliente Corporativo se justifica frente al volumen de Minoristas?
*Decisión que habilita:* la misión apunta al "cualquier latinoamericano" — consumidor individual, no empresa. Si el LTV de Corporativos es muy superior pero hay pocos, hay una tensión estratégica: ¿estamos sirviendo a quien dijimos que serviríamos? Esta pregunta no tiene una respuesta correcta, pero un PM debe poder articularla con datos.

**A2-Q10. ¿Qué % del revenue viene de clientes nuevos vs recurrentes?**
SQL: `sql/growth_metrics.sql` Q3
Foco: evolución mensual de la proporción nuevos/recurrentes. ¿El negocio está madurando o todavía depende de adquisición?
*Decisión que habilita:* un negocio sano en la etapa de TiendaLatam debería ver la curva de recurrentes crecer en términos absolutos. Si no, hay un problema de retención que ningún gasto en adquisición puede resolver.

---

## Apuesta 3 — Expansión geográfica (sql/growth_metrics.sql)

> **La pregunta estratégica detrás:** Colombia, Brasil y México son grandes y están underperforming. ¿El problema es de demanda, de precio o de operación?

**A3-Q11. ¿Cómo ha evolucionado el revenue mes a mes por país? ¿Estamos creciendo?**
SQL: `sql/growth_metrics.sql` Q1
Foco: MoM growth % global y por mercado. Identifica meses con caída fuerte y picos estacionales.
*Decisión que habilita:* distinguir mercados en aceleración (candidatos a más inversión) de mercados estancados (requieren diagnóstico antes de escalar).

**A3-Q11b. ¿Todos los mercados se lanzaron al mismo tiempo, o hay diferencias de madurez que distorsionan la comparación?**
Foco: fecha de primera orden por país. Si Colombia lanzó 12 meses después que Ecuador, comparar su revenue absoluto es injusto y lleva a decisiones equivocadas.
*Decisión que habilita:* construir una comparación justa entre mercados — la base para priorizar en la Apuesta 3. Un mercado "underperforming" puede ser simplemente más joven.
*SQL sugerido:* `SELECT country, MIN(o.registration_date) AS first_order FROM orders o JOIN clients c ON o.client_id = c.client_id JOIN countries co ON c.country_id = co.country_id GROUP BY country ORDER BY first_order`

**A3-Q12. ¿Qué país tiene la mejor y peor performance, y cuál es el diagnóstico?**
SQL: `sql/growth_metrics.sql` Q4
Foco: cruzar revenue con AOV, % cancelación y % devolución por país. Un país puede vender mucho con mala calidad operativa.
*Decisión que habilita:* priorizar la Apuesta 3. Si Colombia, Brasil o México tienen alta cancelación, el problema no es awareness — es que la operación no está lista para escalar ahí.

**A3-Q12b. ¿Los patrones de cancelación y devolución varían por país Y por categoría?**
Foco: matriz país × categoría para tasa de cancelación y devolución. ¿Hay categorías específicas que generan más problemas en ciertos mercados?
*Decisión que habilita:* distinguir entre un problema operativo (afecta todas las categorías en un país) y un problema de producto o expectativa (afecta categorías específicas). Son dos diagnósticos distintos y requieren soluciones distintas.

**A3-Q13b. ¿La moneda y la volatilidad cambiaria afectan la percepción de precio en cada mercado? (gap de datos)**
Foco: si los precios están fijados en USD, países con alta inflación o devaluación reciente (Argentina, Colombia) perciben el precio de forma muy distinta mes a mes. ¿Hay correlación entre meses de alta volatilidad cambiaria y caída de órdenes?
*Decisión que habilita:* la promesa de "mejor precio del mercado" es relativa a la moneda local. Si el tipo de cambio deteriora el poder adquisitivo, TiendaLatam puede volverse más cara que el comercio local sin haberlo elegido.
*Nota — gap de datos:* requiere cruzar con datos externos de tipo de cambio (banco central o APIs como Open Exchange Rates).

**A3-Q13. ¿El AOV difiere entre mercados y cómo evoluciona?**
SQL: `sql/growth_metrics.sql` Q2
Foco: AOV por país y por tipo de cliente. Hipótesis: AOV bajo en mercados grandes indica tickets pequeños o mix de categorías diferente.
*Decisión que habilita:* afinar el argumento de precio. Si en Colombia el AOV es bajo ($428 vs $563 en Argentina), ¿es porque el cliente compra menos o porque no encuentra los productos premium que busca?

---

## Apuesta 4 — Diversificación de catálogo (sql/growth_metrics.sql + sql/more_insights.sql)

> **La pregunta estratégica detrás:** Tecnología genera el 74% del revenue con un solo SKU que vale el 33%. ¿Cómo crecemos Hogar, Moda y Deportes sin perder el liderazgo de precio que es el motor?

**A4-Q14. ¿Qué categorías de producto crecen y cuáles se estancan?**
SQL: `sql/growth_metrics.sql` Q5
Foco: MoM de revenue y unidades por categoría. Identifica categorías con volumen de unidades pero revenue bajo — señal de que hay demanda pero falta ticket.
*Decisión que habilita:* decidir en qué categorías invertir en precio y marketing. Hogar y Moda ya tienen volumen de unidades — el gap es de precio percibido, no de demanda.

**A4-Q15. ¿Cómo es el performance del equipo de ventas por tienda?**
SQL: `sql/more_insights.sql` Q12
Foco: revenue por empleado, órdenes gestionadas, AOV por vendedor.
*Decisión que habilita:* aunque TiendaLatam es un modelo digital, las 10 tiendas físicas existen. Entender qué vendedores tienen mejor performance por categoría puede informar qué categorías tienen mayor potencial de crecimiento en cada mercado.

---

## Plantilla para el caso de estudio

| Pregunta | Apuesta estratégica | Hallazgo principal | Implicación | Recomendación |
|----------|--------------------|--------------------|-------------|----------------|
| E2b | Motor (precio) | | | |
| A1-Q1 | Precio | | | |
| A2-Q4 | Retención | | | |
| A2-Q7 | Retención | | | |
| A2-Q9c | Misión / ICP | | | |
| A3-Q11b | Expansión | | | |
| A3-Q12 | Expansión | | | |
| A4-Q14 | Catálogo | | | |

De esta tabla saldrán los 3-5 insights estrella del dashboard y las 3 recomendaciones de producto priorizadas con ICE.

---

## Gaps de datos identificados

Estas preguntas son estratégicamente relevantes pero no son respondibles con el dataset actual. Documentarlas es parte del trabajo PM — demuestra criterio sobre lo que sabes y lo que no sabes.

| Pregunta | Dato faltante | Fuente sugerida |
|----------|--------------|-----------------|
| ¿Nuestro precio es realmente competitivo? (A1-Q4) | Precios de competidores por SKU | Scraping Mercado Libre / Falabella / Linio |
| ¿La volatilidad cambiaria afecta ventas por país? (A3-Q13b) | Tipo de cambio mensual por país | Open Exchange Rates API, banco central |
| ¿Cuánto tiempo lleva una orden en estado "Pendiente"? | Timestamps por cambio de estado | Sistema de gestión de pedidos (OMS) |
| ¿Por qué cancela o devuelve el cliente? | Razón de cancelación / devolución | Campo libre en formulario post-cancelación |
| ¿Cuál es el CAC por mercado? | Presupuesto de marketing por país | ERP / herramienta de ads |

---

## North Star Metric y frameworks PM

**North Star Metric recomendada:** Revenue mensual de clientes recurrentes (Enviado + Entregado).

Por qué: refleja simultáneamente la Apuesta 1 (el precio retiene), la Apuesta 2 (la retención digital funciona) y el estado de salud real del negocio. Crecer adquisición sin que esta métrica suba significa que se está llenando un balde con el fondo roto.

**Candidatas alternativas según audiencia:**
- Para el equipo de operaciones: tasa de entrega exitosa por país (Apuesta 3)
- Para el equipo de catálogo: % del revenue proveniente de categorías no-Tecnología (Apuesta 4)
- Para el equipo de CRM: % de clientes At Risk reactivados en los últimos 90 días (Apuesta 2)

**Frameworks aplicados:**
- **AARRR:** Activation (64 sin primera compra + E6 ICP), Retention (cohortes, RFM, A2-Q9b ops), Revenue (LTV por segmento, A2-Q9c misión). Acquisition y Referral no tienen datos disponibles.
- **ICE Scoring:** úsalo para priorizar las 3 recomendaciones finales. Referencia en `docs/findings_preliminary.md`.
- **JTBD:** Champions "contratan" TiendaLatam para abastecerse con garantía de precio. At Risk posiblemente encontraron una alternativa más barata o más conveniente — esa hipótesis debe guiar el reengagement. Minoristas contratan "resolver una necesidad puntual sin pagar más de lo justo".
