# 📂 Fuentes de datos — TAEV

Este repositorio contiene **únicamente los scripts** de los talleres. Los datos
**no se redistribuyen aquí**: pertenecen a las instituciones y redes de medición
que los producen, y cada una establece sus propias condiciones de acceso y cita.

Esta página indica, para cada insumo, **de dónde proviene y cómo obtenerlo**.

> ⚠️ Antes de ejecutar cualquier script, descargue los datos desde su fuente
> oficial y ajuste las rutas al inicio del archivo.

---

## 🛰️ Datos satelitales — Google Earth Engine

Todas las imágenes se obtienen directamente desde **Google Earth Engine**. No es
necesario descargar escenas completas: los scripts de exportación recortan y
preparan solo lo que cada taller necesita.

| Colección GEE | Contenido | Taller |
|:--|:--|:--:|
| `LANDSAT/LC08/C02/T1_TOA` | Landsat 8, reflectancia TOA (B1–B7) y temperatura de brillo en Kelvin (B10–B11) | 01 |
| `LANDSAT/LC09/C02/T1_TOA` | Landsat 9, mismas bandas | 01 |
| `LANDSAT/LC08/C02/T1_L2` | Landsat 8 Nivel 2; la banda `ST_B10` provee la temperatura superficial | 02 |
| `LANDSAT/LC09/C02/T1_L2` | Landsat 9 Nivel 2, misma banda térmica | 02 |
| `COPERNICUS/S2_SR_HARMONIZED` | Sentinel-2 reflectancia de superficie; NDVI a 10 m e índices SWIR | 02, 03 |
| `ECMWF/ERA5_LAND/HOURLY` | Reanálisis ERA5-Land; insumo de VPD y ETo | 03 |

**Cómo generar los insumos del Taller 02.** El archivo
[`02_SAFER_CASABLANCA_CL/GEE/01_descargar_Casablanca_L89_S2.js`](../02_SAFER_CASABLANCA_CL/GEE/01_descargar_Casablanca_L89_S2.js)
se pega completo en el editor de código de Earth Engine y exporta a Google Drive
los dos GeoTIFF que el script en R espera
(`LANDSAT89_CASABLANCA_20231204.tif` y `SENTINEL2_CASABLANCA_20231204.tif`).

**Cómo generar los insumos del Taller 01.** Las cuatro escenas estacionales
pesan unos 107 MB cada una, de modo que no se distribuyen: se regeneran con
[`01_SAFER_TRES_CRUCES_UY/GEE/00_exportar_TRC.js`](../01_SAFER_TRES_CRUCES_UY/GEE/00_exportar_TRC.js),
que las exporta a su propio Google Drive desde las colecciones TOA. La
composición de bandas de cada GeoTIFF está descrita en
[`01_SAFER_TRES_CRUCES_UY/DICCIONARIO_DE_DATOS.md`](../01_SAFER_TRES_CRUCES_UY/DICCIONARIO_DE_DATOS.md).

Requisitos: cuenta habilitada en [Earth Engine](https://earthengine.google.com/signup/)
y un proyecto de Google Cloud asociado (`PROJECT_ID` en los notebooks).

---

## 🌡️ Datos de estaciones meteorológicas

| Red | Estación | Variables | Taller | Acceso |
|:--|:--|:--|:--:|:--|
| **INIA GRAS — Uruguay** | La Magnolia | ET₀, radiación global, temperatura media diaria | 01 | <https://www.inia.uy/gras/Clima> |
| **Agromet INIA — Chile** | Colliguay | ET₀ diaria | 02, 03 | <https://agrometeorologia.cl/> |

Las coordenadas y el período empleados en cada taller están documentados en el
encabezado de los scripts correspondientes.

---

## 🗼 Torre de flujo — ChileFlux

| | |
|:--|:--|
| **Sitio** | Viñedo de Casablanca, Región de Valparaíso, Chile |
| **Variables** | Radiación neta (Rn), calor sensible (H), tres placas de flujo de calor en el suelo (G), velocidad de fricción (u\*), a intervalos de 30 min |
| **Usado en** | Taller 02 — cierre del balance de energía y cálculo de ETa observada |
| **Red** | **ChileFlux** — <https://www.chileflux.cl/> |

> 🔒 Estos datos **no se redistribuyen** en este repositorio. El acceso y las
> condiciones de uso y cita se gestionan con los responsables de la red y del
> sitio de medición.

---

## 🗺️ Cobertura y vectores

| Insumo | Contenido | Taller | Fuente |
|:--|:--|:--:|:--|
| MapBiomas | Clases de cobertura de la cuenca del río Tres Cruces: bosque ribereño (3), forestación (9), pastizal (12) | 01 | <https://uruguay.mapbiomas.org/> |
| Límite de cuenca y punto de estación | `datos_base_TRC_INIA.gpkg`: contorno de la cuenca del río Tres Cruces y localización de la estación INIA | 01 | Derivado para el taller; descrito en el diccionario de datos |
| Bases vectoriales de Valparaíso | Frutales, usos del suelo, límites comunal y regional (`.gpkg`) | 00 | Derivadas de ICET/ODEPA y BCN — véase [`INTROSIG/DATOS/FUENTES.md`](../../INTROSIG/DATOS/FUENTES.md) |

---

## 📦 Paquete de datos del curso

Para quienes cursan la asignatura existe un paquete con los datos ya preparados
y organizados por taller, que **se solicita al docente**. No es de distribución
abierta: varios de esos conjuntos pertenecen a redes de medición que establecen
sus propias condiciones de acceso.

Ese paquete tampoco incluye las cuatro escenas Landsat del Taller 01 (427 MB en
total): se regeneran con el script de exportación indicado más arriba.

Quien no curse la asignatura puede reconstruir todos los insumos a partir de
las fuentes listadas en esta página: las imágenes con los dos scripts de Earth
Engine incluidos en el repositorio, y las series de estaciones desde los
portales de INIA, Agromet y ChileFlux.
