# 🗼 Taller 02 — SAFER con torre de flujo · Casablanca (Chile)

Comparación entre una **medición independiente de evapotranspiración** —el
balance de energía de una torre de flujo— y dos estimaciones satelitales
obtenidas con SAFER.

| | |
|:--|:--|
| **Sitio** | Viñedo ChileFlux Casablanca, Región de Valparaíso |
| **Fecha** | 4 de diciembre de 2023 |
| **Sensores** | Landsat 8/9 Nivel 2 · Sentinel-2 SR |
| **Software** | Google Earth Engine (JavaScript) y R con `terra` |

---

## 📄 Archivos

| Archivo | Contenido |
|:--|:--|
| [`GEE/01_descargar_Casablanca_L89_S2.js`](GEE/01_descargar_Casablanca_L89_S2.js) | Se pega completo en el editor de código de Earth Engine. Exporta a Drive los dos GeoTIFF que el script en R necesita. |
| [`R/01_practica_Casablanca_ET.R`](R/01_practica_Casablanca_ET.R) | **Esqueleto del estudiante.** Cada `stop("ACTIVIDAD...")` marca un cálculo a completar. |
| [`GUIA_DE_TRABAJO_SAFER_CASABLANCA.md`](GUIA_DE_TRABAJO_SAFER_CASABLANCA.md) | Teoría, ecuaciones, inventario de datos y las seis actividades paso a paso. |

> 📌 La **resolución** del ejercicio no se publica aquí; se entrega por el canal
> del curso después de la actividad.

---

## 📐 Lo que se calcula

```
Torre:    Rn = G + H + LE   →   LE = Rn − G − H   →   ETa diaria observada
Satélite: ETfr = exp[A + B × LST / (albedo × NDVI)]   →   ETa = ETfr × ET0
```

Coeficientes del caso Casablanca: `A = 0.3663`, `B = -0.001117`.

Se construyen **tres estimaciones** para el mismo día y se comparan en un radio
de 60 m alrededor de la torre:

1. ETa observada en la torre (balance de energía residual);
2. ETa SAFER con Landsat 8/9 a 30 m;
3. ETa SAFER **híbrida**: NDVI de Sentinel-2 a 10 m, con LST y albedo de Landsat
   remuestreados a esa grilla.

---

## ▶️ Cómo trabajar

1. Ejecute el script de GEE para generar los dos GeoTIFF y descárguelos de Drive.
2. Obtenga los datos de torre y de ET₀ — véase [`../DATOS/FUENTES.md`](../DATOS/FUENTES.md).
   Los datos de la torre **no se redistribuyen**: se solicitan a
   [ChileFlux](https://www.chileflux.cl/).
3. Reconstruya la estructura que el script espera:

```
PRACTICA_CASABLANCA.Rproj
01_DATOS/
  01_TORRE/   02_ETO/   03_IMAGENES/
02_R/01_practica_Casablanca_ET.R
04_RESULTADOS/
```

4. Abra el proyecto, ejecute **un bloque por vez** y complete cada actividad
   antes de eliminar su línea `stop()`.

> ⚠️ No ejecute el archivo completo desde el inicio: el script está diseñado
> para detenerse en cada actividad.

---

## 📑 Publicación asociada

El caso de estudio se inscribe en la línea de trabajo de:

> Santarosa, L. V., & de Oliveira Ferreira Silva, C. (2026). *Assessment of
> structural water stress in semi-arid agricultural basins using high-resolution
> evapotranspiration mapping*. **Ecohydrology & Hydrobiology, 26**, 100843.
> <https://doi.org/10.1016/j.ecohyd.2026.100843>

El artículo no se distribuye en este repositorio.
