# My Notes


Este es mi primer análisis sobre `03_exploratory`, son notas semiestructuradas de mi primera aproximación a la data, su propósito es cuestionar y entender la información que hay y no hay disponible, y me ayuda a comenzar a estructurar mentalmente el sistema de TiendaLatam.

---

## 1. Volumen y Rango Temporal

| Métrica | Valor |
|---|---|
| Total órdenes | 4,000 |
| Clientes únicos | 700 |
| Primera orden | 2021-07-01 |
| Última orden | 2026-04-29 |
| GMV | $1,958,767.55 |
| Revenue | $1,473,497.20 |
| AOV | $489.69 |

1. ¿Cuáles son las razones detrás de la diferencia del GMV y el revenue? ¿De qué porcentaje estamos hablando? ¿Es este porcentaje normal para esta industria y tipo de negocio? ¿Cómo están el GMV y el revenue en comparación a la competencia? ¿Cuáles son las mejores fuentes de esta información?
2. ¿En qué moneda está el dinero? ¿Todas las sucursales manejan la misma moneda? ¿Tiene esto alguna afectación en el revenue?
3. ¿Todas las sucursales se lanzaron al mismo tiempo?
4. ¿Cuál es el average order value de la competencia? ¿Cómo está posicionado TiendaLatam en comparación a la competencia? Hacer benchmark.
5. ¿Cuál es la distribución de las órdenes en el tiempo? ¿Por sucursal? ¿Por país?
6. ¿Qué más data tengo de esos usuarios? ¿Cuál es el ICP?

---

## 2. Distribución de Estados de Pedido

| Status | Órdenes | % Share |
|---|---:|---:|
| Entregado | 2,542 | 63.5% |
| Enviado | 503 | 12.6% |
| Procesando | 350 | 8.8% |
| Pendiente | 296 | 7.4% |
| Cancelado | 203 | 5.1% |
| Devuelto | 106 | 2.6% |

1. El 63% de los pedidos está en "Entregado", parece muy poco considerando que la operación lleva desde 2021. ¿Por qué?
2. Parece que un 12.6% de las órdenes hoy están en camino hacia el cliente; pareciera que la operación se ha acelerado o que está en un pico en estos días.
3. **Status "Procesando":** ¿Cómo es la operación de distribución de órdenes? Necesito entender esto a alto nivel.
4. **Status "Pendiente":** ¿Qué significa que una orden esté pendiente? ¿Cómo es el flujo? ¿Qué tipos de problemas y escenarios suceden aquí? ¿Cómo se afecta el customer service? ¿Qué data existe al respecto? ¿Qué impacto tiene esto en la retención?
5. **Status "Cancelado":** 5.1% de las órdenes han sido canceladas. ¿Es esto "normal" en esta industria? ¿Qué data tenemos al respecto? ¿Hay patrones en las razones?
6. **Status "Devuelto":** 2.6%. ¿Es esto normal? ¿Hay patrones?
7. En la operación, ¿qué parte del flujo está impactando más negativamente el negocio? ¿Y cuál tiene el mayor impacto positivo como North Star Metric? ¿Hay algún cuello de botella?

---

## 3. Revenue por País (solo entregadas)

| País | Órdenes | Revenue | AOV |
|---|---:|---:|---:|
| Ecuador | 387 | $195,579.45 | $505.37 |
| Perú | 353 | $183,409.85 | $519.57 |
| Bolivia | 344 | $173,121.75 | $503.26 |
| Chile | 389 | $171,887.75 | $441.87 |
| Argentina | 254 | $143,076.10 | $563.29 |
| Brasil | 328 | $139,890.15 | $426.49 |
| México | 292 | $136,553.60 | $467.65 |
| Uruguay | 246 | $118,538.30 | $481.86 |
| Costa Rica | 228 | $115,579.35 | $506.93 |
| Colombia | 224 | $95,860.90 | $427.95 |

1. ¿Cuál es la ventana de tiempo del revenue de cada país? ¿O fueron todos lanzados al mismo tiempo?
2. El AOV es muy similar entre países.
3. ¿Cuáles son las diferencias fundamentales entre el performance de un país y el otro? ¿Hay diferencias en la operación, en el marketing, en la experiencia del usuario? ¿Qué características pueden influir en estas diferencias?
4. ¿Qué se está haciendo diferente en Ecuador, Perú y Bolivia? Revisar competidores, posicionamiento en el mercado, antigüedad, qué data existe al respecto.

---

## 4. Top 10 Productos Más Vendidos

| Producto | Categoría | Unidades Vendidas | Revenue |
|---|---|---:|---:|
| Aceite de Oliva 500 ml | Alimentos | 673 | $5,888.75 |
| Banda Elástica Resistencia | Deportes | 645 | $4,192.50 |
| Set Cuidado Facial | Belleza | 640 | $20,480.00 |
| Licuadora 6 Velocidades | Hogar | 619 | $40,173.10 |
| Chaqueta Impermeable | Moda | 614 | $42,673.00 |
| Gorra Bordada | Moda | 606 | $6,969.00 |
| Cargador USB-C Rápido | Tecnología | 605 | $13,007.50 |
| Casco Bicicleta Urbano | Deportes | 603 | $24,723.00 |
| Muñeca Articulada | Juguetería | 602 | $13,183.80 |
| Aspiradora Compacta | Hogar | 599 | $71,281.00 |

1. El volumen de unidades vendidas es muy similar entre el top 10.
2. ¿Cuánto representa el top 10 del revenue total? ¿Qué volumen de productos representa el 80% del revenue?
3. ¿De cuántos productos es el total del catálogo? ¿Cuál es la estrategia de la empresa en términos de catálogo? ¿Buscan diversificación o centralización? ¿Qué movimiento sería más conveniente?
4. ¿Cómo es la distribución de productos por país/sucursal? ¿Hay varias sucursales por país?

---

## 6. Productos sin Ventas

No hay productos sin ventas.

---

## 7. Revenue por Tipo de Cliente (Global)

| Tipo de Cliente | Clientes | Órdenes | Revenue | % Revenue |
|---|---:|---:|---:|---:|
| Minorista | 392 | 1,908 | $935,941.30 | 63.52% |
| Mayorista | 118 | 527 | $235,985.70 | 16.02% |
| Corporativo | 74 | 354 | $179,496.10 | 12.18% |
| VIP | 52 | 256 | $122,074.10 | 8.28% |

1. ¿Cuál es la estrategia a nivel de negocio para apuntarle a clientes VIP y Corporativos cuando sus revenues no son muy altos? ¿La inversión para adquirir estos usuarios la justifica? ¿Cuál es el ICP que estamos persiguiendo y por qué?

---

## 8. Distribución de Ventas por Producto

| ID | Producto | Categoría | Precio Lista | Órdenes | Unidades | Revenue | % Revenue | % Acumulado |
|---|---|---|---:|---:|---:|---:|---:|---:|
| 2 | Laptop Ultraliviana 14 | Tecnología | $799.00 | 264 | 814 | $650,386.00 | 33.2% | 33.2% |
| 1 | Smartphone Andino X1 | Tecnología | $349.90 | 248 | 730 | $255,427.00 | 13.0% | 46.2% |
| 15 | Aspiradora Compacta | Hogar | $119.00 | 251 | 747 | $88,893.00 | 4.5% | 50.8% |
| 11 | Set de Ollas Antiadherentes | Hogar | $89.90 | 240 | 726 | $65,267.40 | 3.3% | 54.1% |
| 18 | Chaqueta Impermeable | Moda | $69.50 | 247 | 761 | $52,889.50 | 2.7% | 56.8% |
| 9 | Licuadora 6 Velocidades | Hogar | $64.90 | 258 | 784 | $50,881.60 | 2.6% | 59.4% |
| 6 | Teclado Mecánico Compacto | Tecnología | $72.00 | 229 | 670 | $48,240.00 | 2.5% | 61.9% |
| 10 | Cafetera Programable | Hogar | $52.75 | 250 | 774 | $40,828.50 | 2.1% | 64.0% |
| 3 | Audífonos Bluetooth Pro | Tecnología | $59.90 | 232 | 680 | $40,732.00 | 2.1% | 66.0% |
| 19 | Zapatillas Urbanas | Moda | $58.90 | 233 | 683 | $40,228.70 | 2.1% | 68.1% |
| 27 | Perfume Floral 100 ml | Belleza | $48.90 | 241 | 752 | $36,772.80 | 1.9% | 70.0% |
| 4 | Parlante Portátil Caribe | Tecnología | $44.50 | 254 | 765 | $34,042.50 | 1.7% | 71.7% |
| 13 | Juego de Sábanas Queen | Hogar | $45.00 | 255 | 752 | $33,840.00 | 1.7% | 73.4% |
| 41 | Casco Bicicleta Urbano | Deportes | $41.00 | 266 | 785 | $32,185.00 | 1.6% | 75.1% |
| 17 | Jeans Slim Fit | Moda | $39.90 | 247 | 729 | $29,087.10 | 1.5% | 76.6% |
| 8 | Power Bank 20000 mAh | Tecnología | $39.90 | 245 | 728 | $29,047.20 | 1.5% | 78.0% |
| 20 | Mochila Ejecutiva | Moda | $42.00 | 232 | 683 | $28,686.00 | 1.5% | 79.5% |
| 28 | Afeitadora Eléctrica | Belleza | $36.50 | 260 | 762 | $27,813.00 | 1.4% | 80.9% |
| 26 | Set Cuidado Facial | Belleza | $32.00 | 261 | 806 | $25,792.00 | 1.3% | 82.2% |
| 45 | Carro a Control Remoto | Juguetería | $37.90 | 220 | 678 | $25,696.20 | 1.3% | 83.6% |
| 38 | Mancuernas 5 kg Par | Deportes | $34.90 | 227 | 685 | $23,906.50 | 1.2% | 84.8% |
| 42 | Bloques de Construcción | Juguetería | $29.90 | 248 | 701 | $20,959.90 | 1.1% | 85.8% |
| 14 | Lámpara LED de Escritorio | Hogar | $28.90 | 243 | 674 | $19,478.60 | 1.0% | 86.8% |
| 7 | Cargador USB-C Rápido | Tecnología | $21.50 | 264 | 846 | $18,189.00 | 0.9% | 87.8% |
| 12 | Organizador Modular | Hogar | $24.90 | 246 | 715 | $17,803.50 | 0.9% | 88.7% |
| 46 | Juego de Mesa Estrategia | Juguetería | $26.50 | 240 | 670 | $17,755.00 | 0.9% | 89.6% |
| 36 | Balón de Fútbol Pro | Deportes | $24.90 | 244 | 710 | $17,679.00 | 0.9% | 90.5% |
| 44 | Muñeca Articulada | Juguetería | $21.90 | 267 | 763 | $16,709.70 | 0.9% | 91.3% |
| 37 | Mat de Yoga Antideslizante | Deportes | $22.50 | 249 | 725 | $16,312.50 | 0.8% | 92.2% |
| 5 | Mouse Inalámbrico Ergo | Tecnología | $18.90 | 256 | 804 | $15,195.60 | 0.8% | 93.0% |
| 22 | Cinturón Cuero Sintético | Moda | $18.75 | 258 | 769 | $14,418.80 | 0.7% | 93.7% |
| 43 | Rompecabezas 1000 Piezas | Juguetería | $17.50 | 257 | 779 | $13,632.50 | 0.7% | 94.4% |
| 25 | Protector Solar FPS 50 | Belleza | $14.90 | 245 | 752 | $11,204.80 | 0.6% | 95.0% |
| 16 | Camiseta Básica Algodón | Moda | $12.90 | 218 | 718 | $9,262.20 | 0.5% | 95.4% |
| 21 | Gorra Bordada | Moda | $11.50 | 246 | 766 | $8,809.00 | 0.4% | 95.9% |
| 49 | Agenda Ejecutiva | Papelería | $9.90 | 259 | 773 | $7,652.70 | 0.4% | 96.3% |
| 35 | Bebida Isotónica Pack | Alimentos | $10.50 | 229 | 699 | $7,339.50 | 0.4% | 96.6% |
| 31 | Aceite de Oliva 500 ml | Alimentos | $8.75 | 249 | 823 | $7,201.30 | 0.4% | 97.0% |
| 29 | Café Molido Premium | Alimentos | $9.80 | 237 | 714 | $6,997.20 | 0.4% | 97.4% |
| 23 | Crema Hidratante Aloe | Belleza | $8.90 | 235 | 756 | $6,728.40 | 0.3% | 97.7% |
| 39 | Botella Deportiva 750 ml | Deportes | $8.90 | 230 | 698 | $6,212.20 | 0.3% | 98.0% |
| 40 | Banda Elástica Resistencia | Deportes | $6.50 | 271 | 853 | $5,544.50 | 0.3% | 98.3% |
| 24 | Shampoo Nutritivo | Belleza | $7.50 | 253 | 718 | $5,385.00 | 0.3% | 98.6% |
| 33 | Mix de Frutos Secos | Alimentos | $7.40 | 228 | 721 | $5,335.40 | 0.3% | 98.9% |
| 32 | Quinua Orgánica 1 kg | Alimentos | $6.90 | 232 | 680 | $4,692.00 | 0.2% | 99.1% |
| 50 | Resma Papel Carta | Papelería | $6.75 | 235 | 667 | $4,502.30 | 0.2% | 99.3% |
| 48 | Set de Marcadores | Papelería | $5.80 | 272 | 760 | $4,408.00 | 0.2% | 99.6% |
| 30 | Chocolate Amargo 70% | Alimentos | $4.20 | 227 | 731 | $3,070.20 | 0.2% | 99.7% |
| 47 | Cuaderno Profesional | Papelería | $3.90 | 257 | 751 | $2,928.90 | 0.1% | 99.9% |
| 34 | Galletas Integrales | Alimentos | $3.60 | 224 | 755 | $2,718.00 | 0.1% | 100.0% |

1. ¿Cómo se podría optimizar el catálogo en base al consumo y al revenue? ¿Cómo se quiere posicionar la empresa?

NOTAS MIAS: CAMBIOS SOLICITADOS 
- El dashboard Resumen Ejecutivo actualmente solo muestra Revenue, Órdenes, 
AOV y Clientes activos. Necesito agregar 3 métricas de salud del negocio:
1. Churn rate (clientes sin compra en últimos 180 días)
2. Tasa de cancelación + devolución combinada (status_id 5 y 6)
3. % del revenue que viene de clientes Champions (RFM)

