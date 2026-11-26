# 📘 Guía de trabajo — SAFER en Casablanca

**Aplicación con torre de flujo, Landsat 8/9 y Sentinel-2**
Teledetección Aplicada a la Vegetación · 02/2026

Esta guía acompaña un script incompleto. El propósito es que usted construya los
cálculos centrales, interprete cada variable y compare una observación de torre
con dos productos satelitales.

| Elemento | Descripción |
|:--|:--|
| **Sitio** | Viñedo ChileFlux Casablanca, Chile |
| **Fecha común** | 4 de diciembre de 2023 |
| **Software** | Google Earth Engine y R con el paquete `terra` |
| **Productos** | Tabla comparativa, gráfico final, respuestas y GeoTIFF |

---

## 🎯 Resultados de aprendizaje

- Reconocer cómo el balance de energía de una torre se transforma en ETa diaria.
- Distinguir ET₀, ETfr y ETa, y explicar la relación entre ellas.
- Relacionar reflectancia, NDVI, albedo y temperatura superficial con SAFER.
- Aplicar la ecuación SAFER con Landsat 8 y 9.
- Construir e interpretar un producto híbrido con NDVI Sentinel-2 y variables Landsat.
- Comparar mediciones puntuales con estimaciones espaciales.

---

## 🗂️ Organización del trabajo

Abra `PRACTICA_CASABLANCA.Rproj` y después `02_R/01_practica_Casablanca_ET.R`.
El script está dividido en bloques. Cada línea `stop()` que comienza con
**ACTIVIDAD** marca un cálculo que debe completarse: escriba la expresión
solicitada y elimine **solo** esa línea. Ejecute el bloque otra vez antes de
avanzar.

| Etapa | Trabajo del estudiante | Resultado observable |
|:--|:--|:--|
| Torre | Cerrar el balance e integrar LE | ETa diaria y gráfico de flujos |
| Referencia | Seleccionar ET₀ y calcular ETfr | Valor diario y gráfico semanal |
| Imágenes | Explorar bandas y resoluciones | RGB, NDVI y LST |
| Landsat | Aplicar SAFER | Mapas de ETfr y ETa |
| Híbrido | Combinar NDVI Sentinel-2 con Landsat | Mapas en la grilla de 10 m |
| Comparación | Extraer el entorno de la torre | Tabla y gráfico final |

> ⚠️ **Regla de trabajo.** No ejecute el archivo completo desde el inicio.
> Termine un bloque, inspeccione los objetos y el gráfico, y recién entonces
> continúe.

---

## 📦 Inventario de datos

| Archivo | Contenido | Unidad o resolución |
|:--|:--|:--|
| `ChileFlux_Casablanca_2023-12-04_30min.csv` | Rn, H, tres placas G y u\* | W m⁻² y m s⁻¹, cada 30 min |
| `ETo_INIA_Colliguay_2023-12-01_07.csv` | ET₀ diaria y completitud | mm día⁻¹ |
| `LANDSAT89_CASABLANCA_20231204.tif` | Reflectancias, NDVI, albedo y LST | 30 m |
| `SENTINEL2_CASABLANCA_20231204.tif` | Reflectancias y NDVI | 10 m en la salida |

Los dos GeoTIFF se generan ejecutando
[`GEE/01_descargar_Casablanca_L89_S2.js`](GEE/01_descargar_Casablanca_L89_S2.js)
en el editor de código de Earth Engine. Las fuentes de los datos de estación y
de torre están en [`../DATOS/FUENTES.md`](../DATOS/FUENTES.md).

---

## ⚡ Fundamentos del balance de energía

La superficie intercambia energía con la atmósfera y el suelo. En esta práctica
ese intercambio se representa con cuatro flujos: **Rn** es la radiación neta
disponible, **G** el calor que entra o sale del suelo, **H** el calor sensible
transferido al aire y **LE** la energía asociada al cambio de fase del agua.

```
Rn = G + H + LE
LE = Rn − G − H
```

La tabla no contiene una medición directa de LE mediante analizador de gases;
por eso se calcula como **residuo**. El resultado reúne transpiración y
evaporación, y también acumula los errores de Rn, G y H.

### Conversión de LE en ETa

Un watt equivale a un joule por segundo y cada fila representa 1800 segundos.

```
Energía LE del intervalo = LE × 1800 / 1 000 000        [MJ m⁻²]
ET del intervalo         = Energía LE del intervalo / 2.45
ETa diaria de la torre   = suma de los intervalos válidos
```

Se adopta un calor latente de vaporización de 2.45 MJ kg⁻¹. Como 1 kg de agua
sobre 1 m² equivale a una lámina de 1 mm, la división produce milímetros.

### Control de calidad de la torre

El script aplica límites físicos simples, elimina intervalos diurnos con
u\* < 0.10 m s⁻¹, fija LE nocturno en cero y evita evaporación negativa. Estos
criterios forman parte del ejercicio: **no cambie los umbrales sin justificarlo**.

---

## 💧 ET₀, ETfr y ETa

ET₀ expresa la demanda atmosférica sobre una superficie de referencia bien
regada. Depende de la disponibilidad de energía y de la capacidad del aire para
transportar vapor. La actividad no recalcula la ecuación de Penman-Monteith:
selecciona la ET₀ diaria de la tabla INIA para concentrarse en la relación entre
campo y satélite.

```
ETfr = ETa / ET0
ETa  = ETfr × ET0
```

ETfr es adimensional. Un valor próximo a uno indica que la superficie
evapotranspira a una tasa próxima a la demanda de referencia. Un valor menor
puede asociarse a menor cobertura vegetal, limitación hídrica o diferencias
entre la superficie real y la de referencia.

---

## 🌈 Variables espectrales y térmicas

### Reflectancia y NDVI

```
NDVI = (NIR − RED) / (NIR + RED)
```

### Albedo Landsat

El albedo **no es una banda nativa** del archivo Landsat: el código GEE
transforma las bandas ópticas de reflectancia de superficie mediante una suma
ponderada.

```
albedo = 0.254·BLUE + 0.149·GREEN + 0.147·RED + 0.311·NIR + 0.103·SWIR1 + 0.036·SWIR2
```

Los coeficientes son una parametrización suministrada por el ejercicio. No deben
interpretarse como coeficientes universales ni como una banda oficial de Landsat.

### Temperatura superficial

El archivo usa `ST_B10` del producto Nivel 2, aplica su escala y convierte
Kelvin en grados Celsius. La LST representa el estado radiativo de la superficie
en el momento de paso del satélite; **no es la temperatura del aire**.

### Diferencia entre Landsat y Sentinel-2

Sentinel-2 ofrece mayor detalle en las bandas ópticas, pero no tiene banda
térmica capaz de proporcionar LST. Aquí Sentinel-2 aporta **solamente su NDVI**;
la LST y el albedo proceden de Landsat y se interpolan a la grilla de 10 m. El
resultado es **híbrido**: la interpolación modifica la grilla, pero no crea
detalle térmico nuevo.

---

## 🧮 Ecuación SAFER utilizada

```
ETfr = exp[A + B × LST / (albedo × NDVI)]
```

| Símbolo | Significado | Valor o unidad |
|:--:|:--|:--|
| A | Coeficiente calibrado previamente | 0.3663 |
| B | Coeficiente calibrado previamente | −0.001117 |
| LST | Temperatura superficial | grados Celsius |
| albedo | Fracción de onda corta reflejada | adimensional |
| NDVI | Contraste entre NIR y rojo | adimensional |
| ETfr | Fracción de evapotranspiración | adimensional |

Los coeficientes A y B ya fueron establecidos para el caso de estudio y no se
recalibran en la actividad. El ejercicio limita ETfr entre 0 y 1.2 y elimina
píxeles con NDVI o albedo no positivos, para evitar denominadores inválidos.

---

## 📏 Escala espacial y comparación

La torre y el satélite no observan exactamente el mismo volumen. La huella de la
torre cambia con el viento y la estabilidad atmosférica; Landsat representa
celdas de 30 m y Sentinel-2 aporta NDVI en una grilla de 10 m. Para reducir la
dependencia de un solo píxel, la comparación usa un **radio de 60 m** alrededor
de la torre.

Una diferencia entre la ETa de torre y la ETa satelital no demuestra por sí sola
que uno de los métodos sea incorrecto: también influyen la hora de observación,
el soporte espacial, la distancia a la estación de ET₀, los filtros y la
parametrización.

---

## 📝 Aplicación paso a paso

El nombre de cada actividad coincide con una línea `stop()` del script.

### Actividad 1A — Promedio de G

**Objetivo.** Representar el flujo de calor en el suelo con las tres placas disponibles.
**Fundamento.** El promedio por fila conserva la escala temporal de 30 minutos y reduce la influencia de una sola placa.

1. Localice las columnas `G1_W_m2`, `G2_W_m2` y `G3_W_m2`.
2. Calcule el promedio por fila ignorando valores `NA`.
3. Guarde el vector en `torre$G_prom_W_m2` y elimine la línea `stop()` correspondiente.

*Pista:* use `rowMeans()` sobre un subconjunto de columnas y agregue `na.rm = TRUE`.
*Antes de continuar:* ejecute `summary()` de `G_prom_W_m2` y confirme que el objeto tiene tantas posiciones como filas de `torre`.

### Actividad 1B — Cierre del balance

**Objetivo.** Obtener LE como residuo del balance de energía.
**Fundamento.** La energía disponible Rn menos G se reparte entre H y LE. El residuo hereda la incertidumbre de los tres términos.

4. Escriba la ecuación `LE = Rn − G − H` usando las columnas de `torre`.
5. Guarde el resultado en `torre$LE_W_m2`.
6. Elimine la línea `stop()` y ejecute también los filtros de turbulencia y noche.

*Pista:* las operaciones entre columnas de un `data.frame` se realizan elemento por elemento.
*Antes de continuar:* inspeccione `summary()` de `LE_W_m2` y compruebe que no quedan valores negativos después de los filtros.

### Actividad 1C — Integración diaria

**Objetivo.** Transformar un flujo de energía en una lámina diaria de agua.
**Fundamento.** La conversión exige respetar los segundos por intervalo, los joules por megajoule y el calor latente de vaporización.

7. Multiplique LE por 1800 y divida por 1 000 000.
8. Divida la energía de cada intervalo por 2.45.
9. Sume los milímetros válidos y guarde el resultado en `ETa_torre`.

*Pista:* use `sum()` con `na.rm = TRUE` solamente en la suma final.
*Antes de continuar:* la consola debe mostrar un número finito y positivo. Explique la forma diaria de Rn, H, G y LE en el gráfico.

### Actividad 2A — Selección de ET₀

**Objetivo.** Seleccionar la demanda atmosférica del mismo día observado por torre y satélites.
**Fundamento.** Comparar fechas distintas mezclaría variación meteorológica y diferencias entre sensores.

10. Imprima `tabla_eto` y encuentre la columna `fecha`.
11. Seleccione la fila del 4 de diciembre de 2023.
12. Extraiga `ETo_mm_dia` y guárdela como `ETo`.

*Pista:* use `tabla[condición, ]` para seleccionar filas.
*Antes de continuar:* `nrow()` de `fila_fecha` debe ser uno y `ETo` debe ser un único número.

### Actividad 2B — ETfr de la torre

**Objetivo.** Expresar la ETa observada como fracción de ET₀.
**Fundamento.** La razón elimina la unidad y permite comparar el uso de la demanda atmosférica.

13. Divida `ETa_torre` por `ETo`.
14. Guarde el resultado como `ETfr_torre`.
15. Interprete si la fracción es menor o mayor que uno.

*Antes de continuar:* compruebe que `ETfr_torre` es finita y explique su significado **sin** llamarla «porcentaje de humedad».

### Exploración de las imágenes

Ejecute la sección 3 completa. Compare color verdadero, NDVI y LST. Anote qué
estructuras aparecen con mayor detalle en Sentinel-2 y recuerde que solo Landsat
contiene LST. No avance si los nombres de las bandas o las resoluciones no
coinciden con el inventario de datos.

### Actividad 4 — SAFER Landsat

**Objetivo.** Calcular ETfr y ETa píxel a píxel con variables Landsat.
**Fundamento.** Cada celda combina estado térmico, respuesta espectral y demanda atmosférica diaria.

16. Calcule `x_L89` con LST, albedo y NDVI.
17. Aplique la función exponencial con A y B.
18. Conserve NDVI y albedo positivos y limite ETfr entre 0 y 1.2.
19. Multiplique `ETfr_L89` por `ETo` para obtener `ETa_L89`.

*Pista:* necesitará `exp()`, `ifel()` y `clamp()`. Mantenga el orden de las operaciones dentro del denominador.
*Antes de continuar:* revise primero los mapas y después los promedios. Identifique si los patrones siguen NDVI, LST o ambos.

### Actividad 5 — Producto híbrido

**Objetivo.** Combinar NDVI Sentinel-2 con LST y albedo Landsat.
**Fundamento.** Todas las capas de una operación ráster deben compartir grilla. El remuestreo bilineal interpola variables continuas.

20. Remuestree `LST_L89` hacia `sentinel[["NDVI"]]`.
21. Remuestree `albedo_L89` de la misma forma.
22. Extraiga `NDVI_S2` sin modificarlo.
23. Repita la ecuación SAFER, la máscara, el límite y la multiplicación por ET₀.

*Pista:* use `resample()` con el ráster Landsat como origen, la grilla Sentinel-2 como destino y `method = "bilinear"`.
*Antes de continuar:* escriba en sus resultados que **solo el NDVI** procede de Sentinel-2. No describa el mapa como «SAFER Sentinel-2 puro».

### Actividad 6 — Comparación con la torre

**Objetivo.** Comparar las dos estimaciones satelitales con la observación diaria.
**Fundamento.** El promedio en un radio de 60 m reduce la sensibilidad a un solo píxel sin reproducir exactamente la huella dinámica de la torre.

24. Extraiga la media de `ETa_L89` dentro de `area_torre`.
25. Repita para `ETa_S2_hibrida`.
26. Construya `comparacion` con el nombre del método y `ETa_mm_dia`.
27. Reste `ETa_torre` para obtener `diferencia_con_torre_mm`.

*Pista:* `extract()` devuelve una tabla; el valor medio suele estar en la segunda columna del resultado.
*Antes de continuar:* la tabla debe tener tres métodos y ninguna ETa faltante. Interprete el signo de cada diferencia.

---

## 📋 Registro de resultados

| Resultado | Valor obtenido | Interpretación breve |
|:--|:--|:--|
| ETa de la torre | | |
| ET₀ del día | | |
| ETfr de la torre | | |
| ETa Landsat en el entorno de la torre | | |
| ETa híbrida en el entorno de la torre | | |
| Método más próximo a la torre | | |

---

## 📚 Referencias

- Silva, C. O. F., Teixeira, A. H. C., & Manzione, R. L. (2019). *agriwater: An R package for spatial modelling of energy balance and actual evapotranspiration using satellite images and agrometeorological data*. **Environmental Modelling & Software, 120**, 104497.
- Silva, C. O. F., Manzione, R. L., & Albuquerque Filho, J. L. (2019). *Combining remotely sensed actual evapotranspiration and GIS analysis for groundwater level modeling*. **Environmental Earth Sciences, 78**, 462.
- Teixeira, A. H. C. (2010). *Determining Regional Actual Evapotranspiration of Irrigated Crops and Natural Vegetation in the São Francisco River Basin (Brazil) Using Remote Sensing and Penman-Monteith Equation*. **Remote Sensing, 2**, 1287–1319.

Los coeficientes A y B del caso Casablanca se entregan como parámetros ya
calibrados para esta actividad.
