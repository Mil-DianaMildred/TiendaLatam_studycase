# Business Questions

TiendaLatam nació como retail presencial y ha completado su transición a un modelo 100% digital, convirtiendo sus tiendas en centros de distribución. Para el 2026, el C-level está formalizando este pivote con la misión y estrategia descritas en `business_mission_and_strategy`. Las preguntas de este documento están diseñadas para medir si los datos respaldan —o cuestionan— cada una de las 4 apuestas estratégicas.

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

**E2b. ¿Cuánto del GMV se convierte en revenue real, y por qué se pierde el resto? Como es el performance de tiendalatam en comparacion a la industria** 
Foco: desglosar el gap GMV ($1,958,767) → revenue ($1,473,497) — un 24.78% que se escapa. 
*Por qué importa:* si la promesa de precio atrae al cliente pero la operación falla en casi 1 de cada 4 órdenes, el moat se erosiona. Este número es la brecha entre lo que el negocio podría ser y lo que realmente captura.

| Status | Órdenes | % Share |
|---|---:|---:|
| Entregado | 2,542 | 63.5% |
| Enviado | 503 | 12.6% |
| Procesando | 350 | 8.8% |
| Pendiente | 296 | 7.4% |
| Cancelado | 203 | 5.1% |
| Devuelto | 106 | 2.6% |

-- benckmark tiendalatam `benckmark_tiendalatam_latam`

| Estado      | TiendaLatam | Benchmark LATAM | Fuente                               | Brecha              | Categoría |
|------------|-------------|-----------------|--------------------------------------|---------------------|-----------|
| Entregado  | 63,5%       | 80–85%          | Operador maduro 5+ años (AMI, DHL)  | -17 a -22 pp        | Malo      |
| Enviado    | 12,6%       | ≤5%             | FADR LATAM 93%+ (Zeo)               | +7,6 pp             | Malo      |
| Procesando | 8,8%        | ≤3%             | Centros propios benchmark (ML)      | +5,8 pp             | Malo      |
| Pendiente  | 7,4%        | ≤2%             | Validación + antifraude (MRC)       | +5,4 pp             | Malo      |
| Cancelado  | 5,1%        | 6–10%           | Aprobación pagos 57% LATAM (BlackSip)| -0,9 a -4,9 pp     | Promedio  |
| Devuelto   | 2,6%        | 20%             | Deloitte LATAM / AMVO 26%           | -17,4 pp            | Bueno     |

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

Ya la resolvi arriba

**A1-Q2. ¿Cuáles son los productos en riesgo de quiebre de stock?**
SQL: `sql/more_insights.sql` Q13
Foco: productos con alta rotación y stock bajo. Días de inventario disponible.
*Decisión que habilita:* si un producto líder tiene quiebre de stock, la promesa de precio se rompe — el cliente va al comercio local. Esto es una alerta operativa directa a la misión.

| product_id | product_name | category | stock | units_sold_last_90d | days_of_inventory | alert |
|---|---|---|---:|---:|---:|---|
| 4 | Parlante Portátil Caribe | Tecnología | 180 | 260 | 62.3 | Riesgo de quiebre |
| 43 | Rompecabezas 1000 Piezas | Juguetería | 170 | 212 | 72.2 | Riesgo de quiebre |
| 37 | Mat de Yoga Antideslizante | Deportes | 145 | 207 | 63.0 | Riesgo de quiebre |
| 13 | Juego de Sábanas Queen | Hogar | 115 | 207 | 50.0 | Riesgo de quiebre |
| 10 | Cafetera Programable | Hogar | 90 | 206 | 39.3 | Riesgo de quiebre |
| 9 | Licuadora 6 Velocidades | Hogar | 120 | 201 | 53.7 | Riesgo de quiebre |
| 41 | Casco Bicicleta Urbano | Deportes | 80 | 199 | 36.2 | Riesgo de quiebre |
| 26 | Set Cuidado Facial | Belleza | 110 | 199 | 49.7 | Riesgo de quiebre |
| 18 | Chaqueta Impermeable | Moda | 85 | 199 | 38.4 | Riesgo de quiebre |
| 28 | Afeitadora Eléctrica | Belleza | 95 | 197 | 43.4 | Riesgo de quiebre |
| 42 | Bloques de Construcción | Juguetería | 130 | 193 | 60.6 | Riesgo de quiebre |
| 1 | Smartphone Andino X1 | Tecnología | 130 | 187 | 62.6 | Riesgo de quiebre |
| 2 | Laptop Ultraliviana 14 | Tecnología | 64 | 187 | 30.8 | Riesgo de quiebre |
| 38 | Mancuernas 5 kg Par | Deportes | 100 | 186 | 48.4 | Riesgo de quiebre |
| 27 | Perfume Floral 100 ml | Belleza | 75 | 180 | 37.5 | Riesgo de quiebre |
| 45 | Carro a Control Remoto | Juguetería | 95 | 180 | 47.5 | Riesgo de quiebre |
| 8 | Power Bank 20000 mAh | Tecnología | 150 | 179 | 75.4 | Riesgo de quiebre |
| 20 | Mochila Ejecutiva | Moda | 140 | 178 | 70.8 | Riesgo de quiebre |
| 19 | Zapatillas Urbanas | Moda | 170 | 177 | 86.4 | Riesgo de quiebre |
| 11 | Set de Ollas Antiadherentes | Hogar | 70 | 177 | 35.6 | Riesgo de quiebre |
| 15 | Aspiradora Compacta | Hogar | 55 | 174 | 28.4 | Riesgo de quiebre |
| 36 | Balón de Fútbol Pro | Deportes | 160 | 166 | 86.7 | Riesgo de quiebre |
| 46 | Juego de Mesa Estrategia | Juguetería | 140 | 162 | 77.8 | Riesgo de quiebre |
| 6 | Teclado Mecánico Compacto | Tecnología | 95 | 160 | 53.4 | Riesgo de quiebre |
| 44 | Muñeca Articulada | Juguetería | 115 | 158 | 65.5 | Riesgo de quiebre |

**A1-Q3. ¿Qué productos se compran juntos?**
SQL: `sql/more_insights.sql` Q14
Foco: pares de productos con mayor co-purchase rate. Base para bundles y cross-sell.
*Decisión que habilita:* aumentar el AOV sin cambiar el catálogo. Un bundle bien diseñado refuerza la percepción de valor-precio.

| product_a | product_b | orders_with_both |
|---|---|---:|
| Parlante Portátil Caribe | Shampoo Nutritivo | 30 |
| Cinturón Cuero Sintético | Shampoo Nutritivo | 29 |
| Aceite de Oliva 500 ml | Rompecabezas 1000 Piezas | 28 |
| Parlante Portátil Caribe | Banda Elástica Resistencia | 27 |
| Cafetera Programable | Bloques de Construcción | 25 |
| Cinturón Cuero Sintético | Banda Elástica Resistencia | 25 |
| Casco Bicicleta Urbano | Juego de Mesa Estrategia | 24 |
| Aspiradora Compacta | Juego de Mesa Estrategia | 24 |
| Camiseta Básica Algodón | Banda Elástica Resistencia | 24 |
| Galletas Integrales | Bebida Isotónica Pack | 23 |
| Balón de Fútbol Pro | Set de Marcadores | 23 |
| Laptop Ultraliviana 14 | Bloques de Construcción | 23 |
| Audífonos Bluetooth Pro | Cargador USB-C Rápido | 23 |
| Cargador USB-C Rápido | Protector Solar FPS 50 | 23 |
| Protector Solar FPS 50 | Set de Marcadores | 23 |

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

-- Retención mensual de cohorte (12 meses)

| cohort_month | num_clients | mes_0 | mes_1 | mes_2 | mes_3 | mes_4 | mes_5 | mes_6 | mes_7 | mes_8 | mes_9 | mes_10 | mes_11 | mes_12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 2021-07 | 1 | 1 | 0.0 | 0.0 | 0.0 | 100.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 100.0 |
| 2021-11 | 1 | 1 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2022-03 | 2 | 2 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 50.0 | 50.0 | 0.0 | 50.0 | 0.0 | 0.0 |
| 2022-05 | 1 | 1 | 100.0 | 0.0 | 0.0 | 0.0 | 0.0 | 100.0 | 0.0 | 0.0 | 100.0 | 0.0 | 0.0 | 0.0 |
| 2022-06 | 1 | 1 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2022-07 | 2 | 2 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 50.0 | 50.0 |
| 2022-08 | 3 | 3 | 33.3 | 0.0 | 0.0 | 33.3 | 0.0 | 0.0 | 33.3 | 33.3 | 33.3 | 0.0 | 33.3 | 0.0 |
| 2022-09 | 4 | 4 | 25.0 | 0.0 | 25.0 | 0.0 | 0.0 | 0.0 | 0.0 | 25.0 | 0.0 | 0.0 | 25.0 | 0.0 |
| 2022-10 | 3 | 3 | 33.3 | 0.0 | 0.0 | 0.0 | 33.3 | 0.0 | 0.0 | 0.0 | 100.0 | 0.0 | 0.0 | 0.0 |
| 2022-11 | 3 | 3 | 0.0 | 0.0 | 0.0 | 33.3 | 0.0 | 0.0 | 0.0 | 0.0 | 33.3 | 0.0 | 0.0 | 33.3 |
| 2022-12 | 3 | 3 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 33.3 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2023-01 | 3 | 3 | 0.0 | 0.0 | 0.0 | 0.0 | 33.3 | 33.3 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2023-02 | 4 | 4 | 0.0 | 0.0 | 25.0 | 25.0 | 25.0 | 0.0 | 25.0 | 25.0 | 50.0 | 25.0 | 0.0 | 50.0 |
| 2023-03 | 1 | 1 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2023-04 | 7 | 7 | 14.3 | 0.0 | 0.0 | 14.3 | 0.0 | 0.0 | 14.3 | 14.3 | 0.0 | 0.0 | 14.3 | 14.3 |
| 2023-05 | 2 | 2 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2023-06 | 1 | 1 | 0.0 | 0.0 | 0.0 | 0.0 | 100.0 | 0.0 | 0.0 | 0.0 | 0.0 | 100.0 | 0.0 | 0.0 |
| 2023-08 | 6 | 6 | 0.0 | 33.3 | 16.7 | 50.0 | 0.0 | 33.3 | 0.0 | 33.3 | 16.7 | 0.0 | 16.7 | 33.3 |
| 2023-09 | 8 | 8 | 12.5 | 12.5 | 12.5 | 0.0 | 25.0 | 0.0 | 37.5 | 0.0 | 12.5 | 25.0 | 12.5 | 0.0 |
| 2023-10 | 4 | 4 | 50.0 | 25.0 | 25.0 | 25.0 | 50.0 | 0.0 | 25.0 | 25.0 | 0.0 | 0.0 | 50.0 | 0.0 |
| 2023-11 | 11 | 11 | 27.3 | 9.1 | 9.1 | 18.2 | 18.2 | 9.1 | 9.1 | 0.0 | 18.2 | 0.0 | 18.2 | 45.5 |
| 2023-12 | 8 | 8 | 12.5 | 0.0 | 12.5 | 0.0 | 37.5 | 25.0 | 37.5 | 25.0 | 37.5 | 12.5 | 25.0 | 25.0 |
| 2024-01 | 10 | 10 | 0.0 | 0.0 | 10.0 | 0.0 | 0.0 | 10.0 | 0.0 | 0.0 | 30.0 | 30.0 | 20.0 | 30.0 |
| 2024-02 | 7 | 7 | 0.0 | 0.0 | 0.0 | 0.0 | 28.6 | 14.3 | 14.3 | 14.3 | 57.1 | 28.6 | 42.9 | 0.0 |
| 2024-03 | 10 | 10 | 0.0 | 0.0 | 10.0 | 10.0 | 0.0 | 10.0 | 0.0 | 10.0 | 30.0 | 0.0 | 10.0 | 10.0 |
| 2024-04 | 4 | 4 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 25.0 | 0.0 | 0.0 | 0.0 | 25.0 | 0.0 |
| 2024-05 | 6 | 6 | 0.0 | 16.7 | 16.7 | 33.3 | 33.3 | 50.0 | 33.3 | 16.7 | 0.0 | 0.0 | 16.7 | 33.3 |
| 2024-06 | 7 | 7 | 14.3 | 0.0 | 0.0 | 0.0 | 0.0 | 14.3 | 28.6 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2024-07 | 15 | 15 | 13.3 | 13.3 | 0.0 | 13.3 | 20.0 | 0.0 | 0.0 | 20.0 | 0.0 | 20.0 | 6.7 | 13.3 |
| 2024-08 | 13 | 13 | 15.4 | 7.7 | 7.7 | 23.1 | 7.7 | 7.7 | 15.4 | 7.7 | 23.1 | 7.7 | 7.7 | 7.7 |
| 2024-09 | 10 | 10 | 20.0 | 10.0 | 40.0 | 10.0 | 30.0 | 40.0 | 10.0 | 30.0 | 20.0 | 30.0 | 20.0 | 40.0 |
| 2024-10 | 13 | 13 | 30.8 | 23.1 | 7.7 | 7.7 | 15.4 | 30.8 | 15.4 | 7.7 | 7.7 | 23.1 | 15.4 | 7.7 |
| 2024-11 | 18 | 18 | 11.1 | 16.7 | 0.0 | 22.2 | 5.6 | 11.1 | 0.0 | 16.7 | 5.6 | 5.6 | 16.7 | 33.3 |
| 2024-12 | 14 | 14 | 0.0 | 21.4 | 7.1 | 14.3 | 21.4 | 7.1 | 14.3 | 21.4 | 21.4 | 28.6 | 35.7 | 21.4 |
| 2025-01 | 13 | 13 | 0.0 | 7.7 | 15.4 | 23.1 | 30.8 | 23.1 | 15.4 | 23.1 | 0.0 | 23.1 | 7.7 | 30.8 |
| 2025-02 | 13 | 13 | 23.1 | 38.5 | 7.7 | 23.1 | 15.4 | 30.8 | 15.4 | 30.8 | 30.8 | 38.5 | 30.8 | 23.1 |
| 2025-03 | 19 | 19 | 10.5 | 15.8 | 15.8 | 21.1 | 10.5 | 26.3 | 15.8 | 26.3 | 31.6 | 15.8 | 15.8 | 26.3 |
| 2025-04 | 21 | 21 | 14.3 | 14.3 | 14.3 | 23.8 | 4.8 | 28.6 | 33.3 | 38.1 | 14.3 | 33.3 | 42.9 | 28.6 |
| 2025-05 | 24 | 24 | 12.5 | 20.8 | 12.5 | 16.7 | 25.0 | 41.7 | 41.7 | 50.0 | 29.2 | 29.2 | 37.5 | 0.0 |
| 2025-06 | 22 | 22 | 0.0 | 13.6 | 9.1 | 13.6 | 31.8 | 22.7 | 22.7 | 0.0 | 27.3 | 18.2 | 0.0 | 0.0 |
| 2025-07 | 19 | 19 | 15.8 | 10.5 | 10.5 | 42.1 | 26.3 | 31.6 | 21.1 | 26.3 | 21.1 | 0.0 | 0.0 | 0.0 |
| 2025-08 | 22 | 22 | 22.7 | 31.8 | 40.9 | 40.9 | 40.9 | 31.8 | 27.3 | 27.3 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2025-09 | 18 | 18 | 16.7 | 22.2 | 22.2 | 22.2 | 27.8 | 27.8 | 22.2 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2025-10 | 25 | 25 | 32.0 | 28.0 | 36.0 | 28.0 | 40.0 | 36.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2025-11 | 40 | 40 | 25.0 | 20.0 | 22.5 | 20.0 | 22.5 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2025-12 | 33 | 33 | 21.2 | 24.2 | 24.2 | 27.3 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2026-01 | 37 | 37 | 35.1 | 37.8 | 32.4 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2026-02 | 43 | 43 | 23.3 | 37.2 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2026-03 | 35 | 35 | 40.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2026-04 | 46 | 46 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |

-- Retención mensual de cohorte (trimestral)

| cohort_month | num_clients | q0 | q1 | q2 | q3 | q4 |
|---|---|---|---|---|---|---|
| 2021-07 | 1 | 1 | 0.0 | 100.0 | 0.0 | 100.0 |
| 2021-11 | 1 | 1 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2022-03 | 2 | 2 | 0.0 | 0.0 | 50.0 | 50.0 |
| 2022-05 | 1 | 1 | 100.0 | 100.0 | 100.0 | 0.0 |
| 2022-06 | 1 | 1 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2022-07 | 2 | 2 | 0.0 | 0.0 | 0.0 | 100.0 |
| 2022-08 | 3 | 3 | 33.3 | 33.3 | 66.7 | 33.3 |
| 2022-09 | 4 | 4 | 50.0 | 0.0 | 25.0 | 25.0 |
| 2022-10 | 3 | 3 | 33.3 | 33.3 | 100.0 | 0.0 |
| 2022-11 | 3 | 3 | 0.0 | 33.3 | 33.3 | 33.3 |
| 2022-12 | 3 | 3 | 0.0 | 33.3 | 0.0 | 0.0 |
| 2023-01 | 3 | 3 | 0.0 | 33.3 | 0.0 | 0.0 |
| 2023-02 | 4 | 4 | 25.0 | 50.0 | 75.0 | 50.0 |
| 2023-03 | 1 | 1 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2023-04 | 7 | 7 | 14.3 | 14.3 | 28.6 | 28.6 |
| 2023-05 | 2 | 2 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2023-06 | 1 | 1 | 0.0 | 100.0 | 0.0 | 100.0 |
| 2023-08 | 6 | 6 | 50.0 | 66.7 | 33.3 | 50.0 |
| 2023-09 | 8 | 8 | 37.5 | 25.0 | 50.0 | 37.5 |
| 2023-10 | 4 | 4 | 75.0 | 50.0 | 50.0 | 50.0 |
| 2023-11 | 11 | 11 | 45.5 | 27.3 | 27.3 | 45.5 |
| 2023-12 | 8 | 8 | 25.0 | 50.0 | 50.0 | 62.5 |
| 2024-01 | 10 | 10 | 10.0 | 10.0 | 30.0 | 60.0 |
| 2024-02 | 7 | 7 | 0.0 | 42.9 | 57.1 | 71.4 |
| 2024-03 | 10 | 10 | 10.0 | 20.0 | 40.0 | 20.0 |
| 2024-04 | 4 | 4 | 0.0 | 0.0 | 25.0 | 25.0 |
| 2024-05 | 6 | 6 | 16.7 | 66.7 | 33.3 | 33.3 |
| 2024-06 | 7 | 7 | 14.3 | 14.3 | 28.6 | 0.0 |
| 2024-07 | 15 | 15 | 20.0 | 26.7 | 20.0 | 20.0 |
| 2024-08 | 13 | 13 | 23.1 | 38.5 | 38.5 | 23.1 |
| 2024-09 | 10 | 10 | 50.0 | 50.0 | 50.0 | 60.0 |
| 2024-10 | 13 | 13 | 38.5 | 38.5 | 23.1 | 38.5 |
| 2024-11 | 18 | 18 | 22.2 | 22.2 | 22.2 | 38.9 |
| 2024-12 | 14 | 14 | 28.6 | 35.7 | 35.7 | 50.0 |
| 2025-01 | 13 | 13 | 15.4 | 38.5 | 38.5 | 38.5 |
| 2025-02 | 13 | 13 | 53.8 | 46.2 | 61.5 | 53.8 |
| 2025-03 | 19 | 19 | 36.8 | 36.8 | 36.8 | 42.1 |
| 2025-04 | 21 | 21 | 33.3 | 42.9 | 52.4 | 61.9 |
| 2025-05 | 24 | 24 | 37.5 | 58.3 | 58.3 | 50.0 |
| 2025-06 | 22 | 22 | 18.2 | 40.9 | 31.8 | 18.2 |
| 2025-07 | 19 | 19 | 26.3 | 52.6 | 36.8 | 0.0 |
| 2025-08 | 22 | 22 | 50.0 | 59.1 | 40.9 | 0.0 |
| 2025-09 | 18 | 18 | 38.9 | 38.9 | 22.2 | 0.0 |
| 2025-10 | 25 | 25 | 48.0 | 56.0 | 0.0 | 0.0 |
| 2025-11 | 40 | 40 | 40.0 | 30.0 | 0.0 | 0.0 |
| 2025-12 | 33 | 33 | 30.3 | 27.3 | 0.0 | 0.0 |
| 2026-01 | 37 | 37 | 45.9 | 0.0 | 0.0 | 0.0 |
| 2026-02 | 43 | 43 | 41.9 | 0.0 | 0.0 | 0.0 |
| 2026-03 | 35 | 35 | 40.0 | 0.0 | 0.0 | 0.0 |
| 2026-04 | 46 | 46 | 0.0 | 0.0 | 0.0 | 0.0 |

**A2-Q6. ¿Qué % del revenue viene de cada segmento RFM?**
SQL: `sql/retention_rfm.sql` Q8
Foco: concentración de valor. Champions + Loyal vs el resto.
*Decisión que habilita:* priorizar dónde actuar. Los Champions (132 clientes, 56.4% del revenue) son el activo más frágil del negocio — perder 10 de ellos duele más que perder 100 clientes nuevos.

| Segmento | Clientes | Revenue | % Revenue |
|----------|----------|---------|-----------|
| **Champions** | 132 | $831,442 | **56.4%** |
| Loyal | 109 | $295,228 | 20.0% |
| At Risk | 64 | $160,325 | 10.9% |
| New/Promising | 73 | $47,787 | 3.2% |
| About to Sleep | 24 | $37,772 | 2.6% |
| Needs Attention | 68 | $35,026 | 2.4% |
| Lost | 146 | $34,819 | 2.4% |
| Hibernating | 20 | $31,099 | 2.1% |

**A2-Q7. ¿Cuál es la tasa de churn actual y cómo varía por segmento?**
SQL: `sql/retention_rfm.sql` Q10
Foco: % de clientes sin compra en los últimos 180 días, desglosado por tipo de cliente y segmento RFM.
*Decisión que habilita:* cuantificar el revenue en riesgo. At Risk + Hibernating + Lost representan revenue histórico que puede reactivarse con bajo costo relativo.

| total_clients | never_purchased | active_last_90d | at_risk_90_180d | churned_180d_plus | churn_rate_pct |
|---|---|---|---|---|---|
| 700 | 64 | 346 | 129 | 161 | 23.0 |

-- Churn por tipo de cliente

| client_type | total_clients | churned_clients | churn_pct |
|---|---|---|---|
| Minorista | 392 | 103 | 26.3 |
| Mayorista | 118 | 29 | 24.6 |
| VIP | 52 | 12 | 23.1 |
| Corporativo | 74 | 17 | 23.0 |

-- Churn por segmento RFM REVISAR PARECE QUE HAY UN PROBLEMA EN EL CALCULO DE RFM 

| segment | total_clients | churned_clients | churn_pct |
|---|---:|---:|---:|
| Lost | 2 | 2 | 100.0 |
| Hibernating | 25 | 25 | 100.0 |
| About to Sleep | 132 | 132 | 100.0 |
| Needs Attention | 68 | 1 | 1.5 |
| At Risk | 91 | 1 | 1.1 |
| Promising | 223 | 0 | 0.0 |
| Champions | 31 | 0 | 0.0 |
| Loyal | 64 | 0 | 0.0 |

**A2-Q8. ¿Cuántos días tarda un cliente en hacer su 2da compra?**
SQL: `sql/more_insights.sql` Q15
Foco: mediana y distribución del time-to-second-purchase. ¿Cuál es el momento óptimo para una campaña de reengagement?
*Decisión que habilita:* diseñar el flujo de activación digital post-primera compra. La mediana de 74 días define cuándo activar el primer touchpoint automático — antes de que el cliente enfríe.

| clients_with_2nd_purchase | avg_days_between | min_days | max_days | median_days |
|---:|---:|---:|---:|---:|
| 389 | 132.4 | 0 | 1229 | 74 |

-- Time-to-second-purchase by user type

| client_type | clients_with_2nd_purchase | avg_days | min_days | max_days | median_days |
|---|---:|---:|---:|---:|---:|
| Corporativo | 45 | 111.8 | 3 | 363 | 60 |
| Minorista | 236 | 127.7 | 0 | 1152 | 71 |
| Mayorista | 72 | 150.5 | 0 | 1229 | 89 |
| VIP | 36 | 153.1 | 1 | 859 | 52 |

-- Time-to-second-purchase by RFM REVISAR PARECE QUE HAY UN PROBLEMA EN EL CALCULO DE RFM


**A2-Q9b. ¿Las órdenes en estado "Pendiente" y "Procesando" representan un cuello de botella con impacto en retención?**
Foco: volumen de órdenes en estados intermedios (296 Pendiente + 350 Procesando = 16.2% del total). ¿Hay clientes con múltiples órdenes atascadas? ¿Se correlaciona con menor frecuencia de recompra?
*Decisión que habilita:* sin tiendas físicas, la experiencia post-compra es el único punto de contacto operativo con el cliente. Si una orden queda atascada y nadie la resuelve, ese cliente no vuelve. Este análisis conecta directamente la salud operativa con la tasa de retención.
*Nota — gap de datos:* el dataset no tiene timestamps de cambio de estado, así que no podemos medir cuánto tiempo lleva una orden en "Pendiente". Lo que sí podemos hacer es cruzar clientes con órdenes en estos estados contra su historial de recompra.

Data de benchmakr en la pregutna E2b

**A2-Q9. ¿Cuál es el LTV promedio por tipo de cliente?**
SQL: `sql/retention_rfm.sql` Q9
Foco: LTV acumulado de Minorista vs Mayorista vs Corporativo vs VIP.
*Decisión que habilita:* validar si el mix de adquisición está alineado con la misión. Si el LTV de Minoristas es bajo en comparación con Corporativos, hay una tensión con el posicionamiento hacia el consumidor individual.

| client_type | clients | avg_ltv | avg_orders_per_client | segment_revenue |
|-------------|--------:|--------:|----------------------:|----------------:|
| Corporativo | 80 | $2,425.62 | 4.78 | $179,496.10 |
| Minorista | 432 | $2,387.61 | 4.87 | $935,941.30 |
| VIP | 60 | $2,347.58 | 4.92 | $122,074.10 |
| Mayorista | 128 | $1,999.88 | 4.47 | $235,985.70 |

Lo que llama la atención inmediatamente: El spread entre el LTV más alto (Corporativo $2,425) y el más bajo (Mayorista $1,999) es de apenas 17%. Para un negocio con 4 tipos de cliente tan distintos, eso es casi plano — y eso es una señal de alerta, no de salud.

El problema con cada segmento:

Corporativo ($2,425 LTV) — lidera, pero apenas. Un cliente corporativo debería tener 5-8x el LTV de un minorista en retail. Que sea solo 1.6% mayor sugiere que no se está capturando el valor diferencial de este segmento. Probable causa: sin pricing especial, sin volumen mínimo, sin contrato.

Minorista ($2,387 LTV) — prácticamente empata con Corporativo con 432 clientes. Esto significa que el negocio está siendo sostenido estructuralmente por su base más masiva y menos rentable en términos unitarios. Es señal de que no hay diferenciación real de propuesta de valor por segmento.

VIP ($2,347 LTV) — es el más contraintuitivo. El segmento "premium" tiene el tercer LTV más bajo. Si VIP existe como categoría, debería tener el LTV más alto con diferencia. Que no sea así sugiere que el criterio de asignación VIP no está correlacionado con valor real, o que no hay beneficios exclusivos que incentiven mayor gasto.

Mayorista ($1,999 LTV) — el único que se diferencia hacia abajo, pero con solo 4.47 órdenes promedio cuando debería ser el segmento de mayor frecuencia de compra. Un mayorista que compra 4 veces en 5 años no está siendo mayorista en la práctica.

**A2-Q9c. ¿Vale la pena la apuesta por clientes VIP y Corporativos, o están desviando foco de la misión?**
Foco: comparar LTV, frecuencia de compra, AOV y churn rate de VIP/Corporativo (136 clientes, 20.46% del revenue) vs Minorista (392 clientes, 63.52% del revenue). ¿El costo de adquirir y retener un cliente Corporativo se justifica frente al volumen de Minoristas?
*Decisión que habilita:* la misión apunta al "cualquier latinoamericano" — consumidor individual, no empresa. Si el LTV de Corporativos es muy superior pero hay pocos, hay una tensión estratégica: ¿estamos sirviendo a quien dijimos que serviríamos? Esta pregunta no tiene una respuesta correcta, pero un PM debe poder articularla con datos.

**A2-Q10. ¿Qué % del revenue viene de clientes nuevos vs recurrentes?**
SQL: `sql/growth_metrics.sql` Q3
Foco: evolución mensual de la proporción nuevos/recurrentes. ¿El negocio está madurando o todavía depende de adquisición?
*Decisión que habilita:* un negocio sano en la etapa de TiendaLatam debería ver la curva de recurrentes crecer en términos absolutos. Si no, hay un problema de retención que ningún gasto en adquisición puede resolver.

| month | client_segment | clients | orders | revenue | pct_revenue |
|-------|---------------|--------:|-------:|--------:|------------:|
| 2025-05 | Nuevo | 8 | 8 | $1,590.00 | 13.5% |
| 2025-05 | Recurrente | 21 | 22 | $10,230.70 | 86.5% |
| 2025-06 | Nuevo | 20 | 22 | $9,913.80 | 24.5% |
| 2025-06 | Recurrente | 42 | 54 | $30,630.50 | 75.5% |
| 2025-07 | Nuevo | 17 | 18 | $7,339.50 | 18.0% |
| 2025-07 | Recurrente | 52 | 58 | $33,393.70 | 82.0% |
| 2025-08 | Nuevo | 15 | 18 | $8,441.75 | 20.6% |
| 2025-08 | Recurrente | 64 | 79 | $32,477.75 | 79.4% |
| 2025-09 | Nuevo | 17 | 19 | $12,339.40 | 30.7% |
| 2025-09 | Recurrente | 53 | 60 | $27,799.10 | 69.3% |
| 2025-10 | Nuevo | 22 | 26 | $10,537.90 | 20.7% |
| 2025-10 | Recurrente | 65 | 84 | $40,299.60 | 79.3% |
| 2025-11 | Nuevo | 34 | 38 | $19,735.25 | 16.4% |
| 2025-11 | Recurrente | 127 | 217 | $100,829.40 | 83.6% |
| 2025-12 | Nuevo | 31 | 38 | $22,414.60 | 16.3% |
| 2025-12 | Recurrente | 137 | 228 | $114,940.70 | 83.7% |
| 2026-01 | Nuevo | 32 | 41 | $17,254.85 | 15.5% |
| 2026-01 | Recurrente | 117 | 183 | $93,890.10 | 84.5% |
| 2026-02 | Nuevo | 39 | 43 | $20,726.95 | 19.3% |
| 2026-02 | Recurrente | 117 | 191 | $86,677.70 | 80.7% |
| 2026-03 | Nuevo | 31 | 44 | $15,374.60 | 11.3% |
| 2026-03 | Recurrente | 147 | 269 | $120,399.05 | 88.7% |
| 2026-04 | Nuevo | 39 | 149 | $77,139.80 | 35.0% |
| 2026-04 | Recurrente | 156 | 310 | $143,318.70 | 65.0% |

---

## Apuesta 3 — Expansión geográfica (sql/growth_metrics.sql)

> **La pregunta estratégica detrás:** Colombia, Brasil y México son grandes y están underperforming. ¿El problema es de demanda, de precio o de operación?

**A3-Q11. ¿Cómo ha evolucionado el revenue mes a mes por país? ¿Estamos creciendo?**
SQL: `sql/growth_metrics.sql` Q1
Foco: MoM growth % global y por mercado. Identifica meses con caída fuerte y picos estacionales.
*Decisión que habilita:* distinguir mercados en aceleración (candidatos a más inversión) de mercados estancados (requieren diagnóstico antes de escalar).

Ya la resolvi arriba

**A3-Q11b. ¿Todos los mercados se lanzaron al mismo tiempo, o hay diferencias de madurez que distorsionan la comparación?**
Foco: fecha de primera orden por país. Si Colombia lanzó 12 meses después que Ecuador, comparar su revenue absoluto es injusto y lleva a decisiones equivocadas.
*Decisión que habilita:* construir una comparación justa entre mercados — la base para priorizar en la Apuesta 3. Un mercado "underperforming" puede ser simplemente más joven.

| country | first_order_date | months_active | total_buyers | total_orders | total_revenue |
|---------|-----------------|-------------:|-------------:|-------------:|--------------:|
| Ecuador | 2021-07-01 | 58 | 68 | 387 | $195,579.45 |
| Costa Rica | 2021-11-06 | 54 | 46 | 228 | $115,579.35 |
| Perú | 2022-03-04 | 50 | 74 | 353 | $183,409.85 |
| Bolivia | 2022-03-07 | 50 | 70 | 344 | $173,121.75 |
| Colombia | 2022-07-12 | 46 | 51 | 224 | $95,860.90 |
| México | 2022-07-21 | 46 | 78 | 292 | $136,553.60 |
| Uruguay | 2022-08-02 | 45 | 60 | 246 | $118,538.30 |
| Chile | 2022-08-26 | 45 | 65 | 389 | $171,887.75 |
| Brasil | 2022-10-12 | 43 | 63 | 328 | $139,890.15 |
| Argentina | 2022-11-13 | 42 | 61 | 254 | $143,076.10 |

**A3-Q12. ¿Qué país tiene la mejor y peor performance, y cuál es el diagnóstico?**
SQL: `sql/growth_metrics.sql` Q4
Foco: cruzar revenue con AOV, % cancelación y % devolución por país. Un país puede vender mucho con mala calidad operativa.
*Decisión que habilita:* priorizar la Apuesta 3. Si Colombia, Brasil o México tienen alta cancelación, el problema no es awareness — es que la operación no está lista para escalar ahí.

| country | total_orders | revenue | aov | pct_cancelled | pct_returned | pct_delivered |
|---------|-------------:|--------:|----:|--------------:|-------------:|--------------:|
| Ecuador | 506 | $195,579.45 | $505.37 | 3.75% | 3.36% | 66.60% |
| Perú | 462 | $183,409.85 | $519.57 | 4.76% | 2.60% | 63.20% |
| Bolivia | 445 | $173,121.75 | $503.26 | 4.72% | 1.57% | 61.80% |
| Chile | 505 | $171,887.75 | $441.87 | 4.95% | 2.77% | 64.55% |
| Argentina | 334 | $143,076.10 | $563.29 | 5.39% | 2.10% | 62.87% |
| Brasil | 427 | $139,890.15 | $426.49 | 5.15% | 2.58% | 64.17% |
| México | 384 | $136,553.60 | $467.65 | 5.47% | 2.86% | 63.80% |
| Uruguay | 332 | $118,538.30 | $481.86 | 5.72% | 3.01% | 61.45% |
| Costa Rica | 306 | $115,579.35 | $506.93 | 5.23% | 2.94% | 61.76% |
| Colombia | 299 | $95,860.90 | $427.95 | 6.69% | 2.68% | 63.55% |

**A3-Q12b. ¿Los patrones de cancelación y devolución varían por país Y por categoría?**
Foco: matriz país × categoría para tasa de cancelación y devolución. ¿Hay categorías específicas que generan más problemas en ciertos mercados?
*Decisión que habilita:* distinguir entre un problema operativo (afecta todas las categorías en un país) y un problema de producto o expectativa (afecta categorías específicas). Son dos diagnósticos distintos y requieren soluciones distintas.
*Nota — gap de datos:* la data actual no contiene detalles sobre los motivos de cancelación y devolución, valdria la pena incluirlos para un analisis mas profundo. 

**A3-Q13. ¿El AOV difiere entre mercados y cómo evoluciona?**
SQL: `sql/growth_metrics.sql` Q2
Foco: AOV por país y por tipo de cliente. Hipótesis: AOV bajo en mercados grandes indica tickets pequeños o mix de categorías diferente.
*Decisión que habilita:* afinar el argumento de precio. Si en Colombia el AOV es bajo ($428 vs $563 en Argentina), ¿es porque el cliente compra menos o porque no encuentra los productos premium que busca?

| quarter | aov_minorista | aov_mayorista | aov_vip | aov_corporativo |
|---|---|---|---|---|
| 2021-07-01 | 219.8 | | | |
| 2021-10-01 | 342.57 | | | |
| 2022-01-01 | 150.0 | | | |
| 2022-04-01 | 390.88 | | | |
| 2022-07-01 | 612.44 | 201.1 | 320.95 | |
| 2022-10-01 | 356.55 | 437.1 | 147.88 | |
| 2023-01-01 | 1182.4 | 439.63 | | |
| 2023-04-01 | 863.39 | 195.79 | 204.1 | 184.6 |
| 2023-07-01 | 324.3 | 210.2 | 277.04 | 229.88 |
| 2023-10-01 | 550.11 | 829.12 | 277.52 | 280.55 |
| 2024-01-01 | 406.48 | 568.52 | 2316.2 | 974.69 |
| 2024-04-01 | 441.65 | 432.43 | 121.7 | 111.85 |
| 2024-07-01 | 527.74 | 556.5 | 468.56 | 544.78 |
| 2024-10-01 | 522.95 | 345.66 | 616.68 | 615.56 |
| 2025-01-01 | 490.94 | 403.15 | 517.23 | 923.07 |
| 2025-04-01 | 474.76 | 601.77 | 243.51 | 376.92 |
| 2025-07-01 | 485.02 | 608.12 | 312.79 | 429.83 |
| 2025-10-01 | 501.96 | 394.74 | 505.76 | 534.02 |
| 2026-01-01 | 473.76 | 441.16 | 428.72 | 426.26 |
| 2026-04-01 | 480.0 | 392.16 | 788.07 | 469.93 |

Mirando los últimos 4 trimestres (Q3 2024 – Q2 2026), los cuatro segmentos convergen en un rango muy similar:

Cuatro tipos de cliente con propuestas de valor distintas, comprimidos en el mismo rango de ticket promedio. Esto indica ausencia de diferenciación real por segmento — no hay pricing por volumen, no hay incentivos que empujen el AOV de los segmentos premium hacia arriba.

#Insight1Minorista está maduro y estable — no hay palanca obvia para subir su AOV sin cambiar el catálogo o bundles2Mayorista tiene el AOV más bajo — revisar si los clientes de este tipo realmente compran en volumen3VIP no se comporta como premium en AOV — el criterio de clasificación o los beneficios del segmento necesitan revisión4Corporativo tiene el mayor potencial de crecimiento de AOV con mínima inversión (contratos, pricing especial)5La convergencia de AOV entre segmentos desde 2024 es la señal más crítica: no hay diferenciación real de propuesta de valor
---

## Apuesta 4 — Diversificación de catálogo (sql/growth_metrics.sql + sql/more_insights.sql)

> **La pregunta estratégica detrás:** Tecnología genera el 74% del revenue con un solo SKU que vale el 33%. ¿Cómo crecemos Hogar, Moda y Deportes sin perder el liderazgo de precio que es el motor?

**A4-Q14. ¿Qué categorías de producto crecen y cuáles se estancan?**
SQL: `sql/growth_metrics.sql` Q5
Foco: MoM de revenue y unidades por categoría. Identifica categorías con volumen de unidades pero revenue bajo — señal de que hay demanda pero falta ticket.
*Decisión que habilita:* decidir en qué categorías invertir en precio y marketing. Hogar y Moda ya tienen volumen de unidades — el gap es de precio percibido, no de demanda.

| category | orders | units_sold | revenue | avg_unit_price | pct_of_total_revenue |
|---|---|---|---|---|---|
| Tecnología | 1,240 | 4,514 | $806,784.00 | $179.40 | 54.75% |
| Hogar | 1,118 | 3,946 | $244,044.75 | $60.64 | 16.56% |
| Moda | 1,107 | 3,985 | $144,726.75 | $36.63 | 9.82% |
| Belleza | 979 | 3,439 | $86,214.10 | $24.91 | 5.85% |
| Deportes | 1,012 | 3,390 | $77,837.70 | $23.03 | 5.28% |
| Juguetería | 823 | 2,699 | $70,852.10 | $26.22 | 4.81% |
| Alimentos | 1,062 | 3,916 | $28,496.85 | $7.37 | 1.93% |
| Papelería | 716 | 2,209 | $14,540.95 | $6.55 | 0.99% |


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
