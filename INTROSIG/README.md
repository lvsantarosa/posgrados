<div align="center">

# 🗺️ INTROSIG — Introducción a los Sistemas de Información Geográfica

**Posgrado · PUCV** · Laboratorio de Recursos Hídricos y Geotecnologías

</div>

---

## 📖 Sobre la asignatura

Fundamentos de análisis espacial aplicados a la agricultura y a los recursos
hídricos de Chile, trabajados íntegramente en **R** con `terra` y `tidyterra`,
con una evaluación práctica en **QGIS**.

---

## 🧪 Talleres

| # | Script | Contenido |
|:--:|:--|:--|
| 1 | [`INTROSIG_TALLER1_R_VECTOR_DATA.R`](INTROSIG_TALLER1_R_VECTOR_DATA.R) | Datos **vectoriales**: carga de coberturas frutícolas y provincias de Valparaíso, geoprocesos de intersección y estadística descriptiva de superficie cultivada. |
| 2 | [`INTROSIG_TALLER2_R_RASTER_DATA.R`](INTROSIG_TALLER2_R_RASTER_DATA.R) | Integración **vector–ráster** con Landsat 8 Nivel 2: recorte a la Provincia de Quillota, conversión a reflectancia de superficie, índices **NDVI, NDWI y NDMI** y estadísticas zonales por especie frutal. |
| 3 | [`INTROSIG_TALLER3_R_EVALUACION_QGIS.R`](INTROSIG_TALLER3_R_EVALUACION_QGIS.R) | **Evaluación práctica**: densidad de riego y superficie frutícola provincial, NDVI estacional y estadísticas zonales. |
| 4 | [`INTROSIG_TALLER4_R_COQUIMBO_DERECHOS.R`](INTROSIG_TALLER4_R_COQUIMBO_DERECHOS.R) | **Vulnerabilidad hídrica y estrés vegetativo (Coquimbo)**: dependencia de aguas subterráneas de la matriz frutícola a partir de los derechos de aprovechamiento de la DGA y mosaicos Landsat 8 de sequía estival. |

---

## 📦 Paquetes

```r
install.packages(c("terra", "tidyterra", "dplyr", "tidyr", "ggplot2", "readxl", "janitor"))
```

---

## 📂 Datos

Las fuentes oficiales de descarga están documentadas en
**[`DATOS/FUENTES.md`](DATOS/FUENTES.md)**.

> ⚠️ Las rutas incluidas al inicio de cada script (`setwd()`, `vect()`,
> `ruta_zip`) corresponden al equipo del docente y deben adaptarse a su propia
> estructura de carpetas.

---

## ✅ Requisitos

- [R](https://www.r-project.org/) ≥ 4.2 y [RStudio](https://posit.co/download/rstudio-desktop/)
- [QGIS](https://qgis.org/) 3.x — taller 3
