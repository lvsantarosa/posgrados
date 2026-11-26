<div align="center">

# 🛰️🌿 TAEV — Teledetección Aplicada al Estudio de la Vegetación

**Semestre 02/2026 · Posgrado · PUCV**
Laboratorio de Recursos Hídricos y Geotecnologías

</div>

---

## 📖 Sobre la asignatura

El curso aborda el flujo completo de información que conecta la **energía registrada por el
sensor** energía registrada por sensores remotos con la estimación de la **evapotranspiración actual (ETa)**
A lo largo del proceso se analizan la fenología de la vegetación y otros mecanismos 
biofísicos que condicionan la respuesta espectral y el uso del agua.  El hilo conductor
es el algoritmo **SAFER** (*Simple Algorithm For Evapotranspiration Retrieving*), aplicado 
a dos casos de estudio reales, y su extensión hacia variables atmosféricas de
reanálisis.

Las prácticas combinan **Google Earth Engine** (JavaScript y Python) con **R**
(`terra`), porque cada etapa se resuelve mejor en una herramienta distinta: la
nube para acceder y recortar imágenes, el escritorio para el cálculo paso a paso
y la interpretación.

---

## 🧪 Talleres

| # | Taller | Herramientas | Contenido |
|:--:|:--|:--:|:--|
| 00 | [**Iniciación a GEE con Python**](00_GEE_PYTHON_INICIACION/) | Colab · `geemap` | Autenticación, colecciones, filtros espaciales y temporales, carga de GeoPackage y recorte por parcela. Base técnica para los talleres siguientes. |
| 01 | [**SAFER paso a paso — río Tres Cruces (Uruguay)**](01_SAFER_TRES_CRUCES_UY/) | R · `terra` | De la reflectancia a la ETa, variable por variable: NDVI, albedo, temperatura superficial, fracción evapotranspirativa y ETa. Comparación estacional entre pastizal, bosque ribereño y forestación. |
| 02 | [**SAFER con torre de flujo — Casablanca (Chile)**](02_SAFER_CASABLANCA_CL/) | GEE (JS) · R · `terra` | Cierre del balance de energía de una torre de flujo, cálculo de ET₀, ETfr y ETa, aplicación de SAFER a Landsat 8/9 y construcción de un producto híbrido con NDVI Sentinel-2. |
| 03 | [**SWIR, ET₀ y VPD — Casablanca**](03_SWIR_ETO_VPD_CASABLANCA/) | Colab · GEE · ERA5-Land | Tres métodos de cálculo de VPD, validación estación × ERA5-Land, índices NDVI, NDMI, MSI y DWSI, y análisis de ventanas antecedentes de 3 y 7 días. |

Orden sugerido: **00 → 01 → 02 → 03**. El taller 01 explica la teoría de SAFER
con todos los pasos a la vista; el 02 la aplica contra una medición
independiente; el 03 abre el componente atmosférico.

---

## 📂 Datos

Este repositorio contiene **solo los scripts**. Las imágenes, las series de
estaciones meteorológicas y los datos de torre de flujo pertenecen a las
instituciones que los producen y **no se redistribuyen aquí**.

Cada insumo, con su fuente oficial y su vía de acceso, está documentado en
**[`DATOS/FUENTES.md`](DATOS/FUENTES.md)**.

**Las imágenes se generan solas.** Los dos scripts de Earth Engine incluidos
aquí —[`00_exportar_TRC.js`](01_SAFER_TRES_CRUCES_UY/GEE/00_exportar_TRC.js) y
[`01_descargar_Casablanca_L89_S2.js`](02_SAFER_CASABLANCA_CL/GEE/01_descargar_Casablanca_L89_S2.js)—
traen el área de estudio ya configurada: se pegan en el editor de código, se
pulsa Run y las imágenes se exportan al Drive de cada estudiante. No hace falta
subir assets ni partir de datos previos.

Las series de estaciones se descargan de las redes INIA, Agromet y ChileFlux.
Las capas auxiliares preparadas para los talleres se **solicitan al docente**.

> 💡 Los scripts de R esperan una estructura de carpetas determinada
> (`01_DATOS/`, `03_SALIDAS/`, un archivo `.Rproj` en la raíz). Al ejecutarlos
> desde una copia de este repositorio, ajuste las rutas o reconstruya esa
> estructura.

---

## ✅ Requisitos

- Cuenta de [Google Earth Engine](https://earthengine.google.com/signup/) con un proyecto de Google Cloud asociado
- [Google Colab](https://colab.research.google.com/) para los talleres 00 y 03
- [R](https://www.r-project.org/) ≥ 4.2 y [RStudio](https://posit.co/download/rstudio-desktop/) para los talleres 01 y 02

```r
install.packages("terra")
```

Los notebooks instalan sus propias dependencias (`earthengine-api`, `geemap`,
`geopandas`, `pandas`, `numpy`, `matplotlib`) en la primera celda.

---

## 📑 Publicaciones asociadas

Los dos casos de estudio provienen de investigación publicada del laboratorio.
Los artículos **no se incluyen** en este repositorio; se citan por DOI.

| Taller | Referencia |
|:--:|:--|
| 01 | Santarosa, L. V., de Oliveira Ferreira Silva, C., Hirigoyen, A., & Stager Quaggio, C. (2025). *Water Consumption Assessment of Afforestation and Natural Vegetation Areas with a Remote Sensing Approach*. **Water, 17**(11), 1597. <https://doi.org/10.3390/w17111597> |
| 02 | Santarosa, L. V., & de Oliveira Ferreira Silva, C. (2026). *Assessment of structural water stress in semi-arid agricultural basins using high-resolution evapotranspiration mapping*. **Ecohydrology & Hydrobiology, 26**, 100843. <https://doi.org/10.1016/j.ecohyd.2026.100843> |

Referencias metodológicas de SAFER citadas en las guías: Teixeira (2010),
*Remote Sensing* 2, 1287–1319; Silva, Teixeira & Manzione (2019),
*Environmental Modelling & Software* 120, 104497.
