<div align="center">

# 🌎💧 Material de Posgrado — SIG, Hidrología, Teledetección y Geotecnologías

**Laboratorio de Recursos Hídricos y Geotecnologías (LRHG)**
Facultad de Ciencias Agronómicas y de los Alimentos · Escuela de Agronomía
Pontificia Universidad Católica de Valparaíso (PUCV)

[![R](https://img.shields.io/badge/R-terra%20%7C%20tidyterra-276DC3?logo=r&logoColor=white)](https://www.r-project.org/)
[![Python](https://img.shields.io/badge/Python-geemap%20%7C%20geopandas-3776AB?logo=python&logoColor=white)](https://www.python.org/)
[![Google Earth Engine](https://img.shields.io/badge/Google%20Earth%20Engine-API-4285F4?logo=googleearth&logoColor=white)](https://earthengine.google.com/)
[![Colab](https://img.shields.io/badge/Google%20Colab-abrir%20notebooks-F9AB00?logo=googlecolab&logoColor=white)](https://colab.research.google.com/)
[![QGIS](https://img.shields.io/badge/QGIS-3.x-589632?logo=qgis&logoColor=white)](https://qgis.org/)

</div>

---

## 📖 Sobre el repositorio

Este repositorio reúne **scripts, notebooks y documentación** de las asignaturas
de posgrado impartidas en el ámbito de la Facultad de Ciencias Agronómicas y de
los Alimentos y de la Escuela de Agronomía de la **PUCV**.

Su contenido se articula en torno a los temas centrales de investigación del
**Laboratorio de Recursos Hídricos y Geotecnologías**:

| | Línea temática |
|:--:|:--|
| 💧 | **Hidrología** y balance hídrico de cuencas |
| 🛰️ | **Geotecnologías** y teledetección aplicada |
| 🏞️ | **Gestión de cuencas hidrográficas** |
| 🗺️ | **Análisis espacial aplicado** a la agricultura |

El propósito es ofrecer una documentación **organizada, reproducible y
transparente** que facilite a estudiantes e investigadores la ejecución de
análisis, la replicación de ejercicios y la consulta de contenidos teóricos y
prácticos.

---

## 🗂️ Estructura del repositorio

El material está organizado **por asignatura**. Cada una tiene su propio
`README.md` con los talleres, y un `DATOS/FUENTES.md` con el origen de cada
insumo.

```
posgrados/
├── INTROSIG/                      # Introducción a los SIG · R + QGIS
│   ├── INTROSIG_TALLER1_R_VECTOR_DATA.R
│   ├── INTROSIG_TALLER2_R_RASTER_DATA.R
│   ├── INTROSIG_TALLER3_R_EVALUACION_QGIS.R
│   ├── INTROSIG_TALLER4_R_COQUIMBO_DERECHOS.R
│   └── DATOS/FUENTES.md
├── GEOHIDRO/                      # Geohidrología · Python + GEE
│   ├── GEOHIDRO_TALLER3.ipynb
│   ├── GEOHIDRO_TALLER4.ipynb
│   ├── GEOHIDRO_TALLER5.ipynb
│   └── DATOS/FUENTES.md
└── TAEV/                          # Teledetección Aplicada al Estudio de la Vegetación
    ├── 00_GEE_PYTHON_INICIACION/        iniciación a GEE con Python
    ├── 01_SAFER_TRES_CRUCES_UY/         SAFER paso a paso (Uruguay)
    ├── 02_SAFER_CASABLANCA_CL/          SAFER con torre de flujo (Chile)
    ├── 03_SWIR_ETO_VPD_CASABLANCA/      SWIR, ET₀ y VPD con ERA5-Land
    └── DATOS/FUENTES.md
```

---

## 📘 Asignaturas

### 🗺️ [INTROSIG — Introducción a los SIG](INTROSIG/)

Análisis espacial en **R** (`terra`, `tidyterra`) con evaluación en QGIS: datos
vectoriales, integración vector–ráster con Landsat 8, índices espectrales,
estadísticas zonales por especie frutal y vulnerabilidad hídrica en Coquimbo a
partir de los derechos de aprovechamiento de la DGA.

### 💧 [GEOHIDRO — Geohidrología](GEOHIDRO/)

Balance hídrico de cuencas con productos globales en **Google Earth Engine**:
precipitación CHIRPS, evapotranspiración MODIS, GLDAS y ERA5-Land, con series
temporales, detección de quiebres y comparación entre cuencas.

### 🛰️ [TAEV — Teledetección Aplicada al Estudio de la Vegetación](TAEV/)

De la energía registrada por el sensor hasta la **evapotranspiración actual**
mediante el algoritmo **SAFER**, aplicado a dos casos de estudio reales
—la cuenca del río Tres Cruces (Uruguay) y un viñedo con torre de flujo en
Casablanca (Chile)— y extendido al componente atmosférico con ERA5-Land.

---

## 🚀 Cómo utilizar este material

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/lvsantarosa/posgrados.git
   cd posgrados
   ```
2. **Descargar los datos** desde sus fuentes oficiales, siguiendo el archivo
   `DATOS/FUENTES.md` de la asignatura correspondiente.
3. **Ajustar las rutas** al inicio de cada script o notebook (`setwd()`,
   `vect()`, `ruta_zip`, `PROJECT_ID`): las rutas incluidas corresponden al
   equipo del docente y deben adaptarse a su propia estructura de carpetas.
4. **Ejecutar paso a paso**, siguiendo los bloques numerados y comentados de
   cada archivo.

### ✅ Requisitos previos

- [R](https://www.r-project.org/) ≥ 4.2 y [RStudio](https://posit.co/download/rstudio-desktop/)
- [QGIS](https://qgis.org/) 3.x (talleres de evaluación)
- Cuenta de [Google Earth Engine](https://earthengine.google.com/signup/) y acceso a [Google Colab](https://colab.research.google.com/)

---

## 📂 Datos

Los conjuntos de datos **no se distribuyen en este repositorio**: pertenecen a
las instituciones y redes de medición que los producen, y cada una establece sus
propias condiciones de acceso y cita. Esto incluye las series de estaciones
meteorológicas (INIA GRAS Uruguay, Agromet INIA Chile) y los datos de torre de
flujo (ChileFlux).

El origen de cada insumo, con su enlace oficial, está documentado en:

- [`INTROSIG/DATOS/FUENTES.md`](INTROSIG/DATOS/FUENTES.md) — ICET/ODEPA, BCN, DGA
- [`GEOHIDRO/DATOS/FUENTES.md`](GEOHIDRO/DATOS/FUENTES.md) — colecciones GEE y Mapoteca DGA
- [`TAEV/DATOS/FUENTES.md`](TAEV/DATOS/FUENTES.md) — Landsat, Sentinel-2, ERA5-Land, MapBiomas, INIA y ChileFlux

Para datos satelitales preparados para Chile, véase también el repositorio
complementario [**gee-global-data-chile**](https://github.com/lvsantarosa/gee-global-data-chile).

---

## 🔗 Repositorios complementarios

| Repositorio | Lenguaje | Contenido |
|:--|:--:|:--|
| [**gee-global-data-chile**](https://github.com/lvsantarosa/gee-global-data-chile) | GEE | Datos satelitales globales preparados y recortados para **Chile**, listos para su uso en Google Earth Engine. |
| [**NASA-data-download**](https://github.com/lvsantarosa/NASA-data-download) | Python | Descarga **masiva de datos NASA** (GES DISC) con `wget` a partir de una lista de enlaces, ejecutable en Google Colab con Google Drive montado. Incluye el notebook de ejemplo para el conjunto **GRACE**. |
| [**FLDAS_GLDAS_Processing**](https://github.com/lvsantarosa/FLDAS_GLDAS_Processing) | R | Procesamiento de las series hidrológicas **FLDAS**, **GLDAS** y **GRACE**: lectura de los archivos descargados, extracción de variables del balance hídrico y almacenamiento de agua subterránea. |
| [**Geostatistical-analysis-in-R**](https://github.com/lvsantarosa/Geostatistical-analysis-in-R) | R | **Análisis geoestadístico** con `gstat`: organización de los datos de monitoreo del Servicio Geológico de Brasil (RIMAS) con el *tidyverse*, variografía y predicción espacial del nivel del agua subterránea. |

> 💡 Los tres últimos repositorios fueron desarrollados en el contexto de la asignatura *Analysis of hydrological and climatic data obtained by Orbital Sensors* (Posgrado en Geociencias y Medio Ambiente, UNESP) y se mantienen aquí como referencia metodológica complementaria.

---

## 📑 Publicaciones asociadas

Los casos de estudio de la asignatura TAEV provienen de investigación publicada
del laboratorio. Los artículos no se distribuyen en este repositorio.

> Santarosa, L. V., de Oliveira Ferreira Silva, C., Hirigoyen, A., & Stager Quaggio, C. (2025).
> *Water Consumption Assessment of Afforestation and Natural Vegetation Areas with a Remote Sensing Approach*.
> **Water, 17**(11), 1597. <https://doi.org/10.3390/w17111597>

> Santarosa, L. V., & de Oliveira Ferreira Silva, C. (2026).
> *Assessment of structural water stress in semi-arid agricultural basins using high-resolution evapotranspiration mapping*.
> **Ecohydrology & Hydrobiology, 26**, 100843. <https://doi.org/10.1016/j.ecohyd.2026.100843>

---

## 🤖 Nota sobre el uso de inteligencia artificial

Una parte significativa de los materiales ha sido **perfeccionada mediante
herramientas de inteligencia artificial**, con el fin de mejorar la claridad de
los comentarios, optimizar la estructura de los documentos y facilitar el
estudio y uso de estos recursos. La concepción metodológica, la selección de
datos y la validación de los resultados son responsabilidad del autor.

---

## 📑 Cómo citar

> Santarosa, L. V. (2026). *Material de apoyo y scripts para cursos de posgrado — Laboratorio de Recursos Hídricos y Geotecnologías*. Pontificia Universidad Católica de Valparaíso. https://github.com/lvsantarosa/posgrados

---

## 📬 Contacto

| | |
|:--|:--|
| 📷 **Instagram del laboratorio** | [@lrhg.pucv](https://www.instagram.com/lrhg.pucv) |
| 💼 **LinkedIn** | [Lucas Vituri Santarosa](https://www.linkedin.com/in/lucas-vituri-santarosa-321b74a6/) |
| 🏛️ **Institución** | [Pontificia Universidad Católica de Valparaíso](https://www.pucv.cl/) |

<div align="center">

---

*Prof. Lucas Vituri Santarosa · Laboratorio de Recursos Hídricos y Geotecnologías · PUCV*

</div>
