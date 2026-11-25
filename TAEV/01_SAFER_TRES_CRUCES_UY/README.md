# 🌿 Taller 01 — SAFER paso a paso · cuenca del río Tres Cruces (Uruguay)

De la energía electromagnética registrada por Landsat hasta la
**evapotranspiración actual (ETa)**, calculando e interpretando cada variable
intermedia antes de pasar a la siguiente.

| | |
|:--|:--|
| **Sitio** | Cuenca del río Tres Cruces, Uruguay |
| **Período** | 2022–2024, cuatro escenas estacionales |
| **Sensores** | Landsat 8 y 9, Colección 2 Nivel 1 (TOA) |
| **Software** | R con `terra` |
| **Coberturas comparadas** | Pastizal · bosque ribereño · forestación |

---

## 📐 Secuencia conceptual

```
radiación Landsat → NDVI + albedo + temperatura superficial
                  → fracción evapotranspirativa (ETr)
                  → evapotranspiración actual (ETa)
```

```
NDVI = (NIR − rojo) / (NIR + rojo)
ETr  = exp(a + b × [Ts / (albedo × NDVI)])
ETa  = ETr × ET0
```

Parámetros del caso uruguayo: `a = 0.66`, `b = -0.0028`. El script conserva
además los parámetros de Teixeira (`a = 1.80`, `b = -0.008`) únicamente para
comparar la sensibilidad del modelo.

---

## 📄 Archivos

| Archivo | Contenido |
|:--|:--|
| [`01_SAFER_DIDACTICO.R`](01_SAFER_DIDACTICO.R) | Script único, dividido en 10 secciones numeradas, pensado para ejecutarse **por bloques** en RStudio |
| [`DICCIONARIO_DE_DATOS.md`](DICCIONARIO_DE_DATOS.md) | Capas, campos, unidades y clases de cada insumo |

---

## ▶️ Cómo trabajar

1. Obtenga los datos desde sus fuentes oficiales — véase [`../DATOS/FUENTES.md`](../DATOS/FUENTES.md) — o solicite el paquete de la clase.
2. Reconstruya la estructura que el script espera:

```
SAFER_TRC_CLASE.Rproj
01_DATOS/
  01_LANDSAT_ESTACIONAL/   02_INIA/   03_VECTOR/   04_COBERTURA/   05_SERIE_TEMPORAL/
02_SCRIPT/01_SAFER_DIDACTICO.R
03_SALIDAS/
```

3. Abra el proyecto de RStudio y ejecute **una sección completa por vez**,
   observando el gráfico y respondiendo las preguntas escritas bajo cada
   resultado.
4. Cambie `ESCENA` de 1 a 4 y repita las secciones 2 a 9 para recorrer las
   cuatro fechas.
5. `GUARDAR_RASTERS <- FALSE` acelera la ejecución; las figuras se siguen
   generando, pero la sección 10 necesita los rásteres guardados para comparar
   las cuatro fechas.

> El script verifica la presencia del archivo `.Rproj` y de `01_DATOS/` antes de
> empezar, y se detiene con un mensaje explicativo si falta alguno.

---

## 📑 Publicación asociada

Este taller reproduce con fines docentes el enfoque de:

> Santarosa, L. V., de Oliveira Ferreira Silva, C., Hirigoyen, A., &
> Stager Quaggio, C. (2025). *Water Consumption Assessment of Afforestation and
> Natural Vegetation Areas with a Remote Sensing Approach*. **Water, 17**(11),
> 1597. <https://doi.org/10.3390/w17111597>

El artículo no se distribuye en este repositorio: está disponible en acceso
abierto bajo licencia CC BY en el enlace anterior.
