# 📖 Diccionario de datos — Taller 01

Descripción de los insumos que el script `01_SAFER_DIDACTICO.R` espera
encontrar en `01_DATOS/`. Las vías de acceso a cada fuente están en
[`../DATOS/FUENTES.md`](../DATOS/FUENTES.md).

---

## 🛰️ Imágenes Landsat

Cada GeoTIFF de `01_LANDSAT_ESTACIONAL/` contiene nueve capas:

| Capa | Región espectral | Uso en el taller |
|:--:|:--|:--|
| B1 | Aerosol costero | Albedo |
| B2 | Azul | Albedo y color verdadero |
| B3 | Verde | Albedo y color verdadero |
| B4 | Rojo | Albedo, color verdadero y NDVI |
| B5 | Infrarrojo cercano | Albedo, falso color y NDVI |
| B6 | SWIR 1 | Albedo y respuesta al agua |
| B7 | SWIR 2 | Albedo y respuesta al agua |
| B10 | Infrarrojo térmico | Temperatura de brillo |
| B11 | Infrarrojo térmico | Temperatura de brillo |

B1–B7 son **reflectancias TOA**; B10–B11 están expresadas en **Kelvin**. No debe
aplicarse una nueva conversión desde números digitales. La resolución de salida
es de 30 m, aunque las bandas térmicas fueron adquiridas a resolución más gruesa
y remuestreadas por el propio producto Landsat.

---

## 🌡️ Datos INIA

Archivo: `02_INIA/INIA_La_Magnolia_diario_2022_2024.csv`

| Campo | Unidad | Descripción |
|:--|:--|:--|
| `fecha` | AAAA-MM-DD | Fecha diaria |
| `ET0_mm_dia` | mm/día | Evapotranspiración de referencia |
| `RG_MJ_m2_dia` | MJ/m²/día | Radiación solar global diaria |
| `Tmedia_C` | °C | Temperatura media diaria |

---

## 🗺️ Vectores

`03_VECTOR/datos_base_TRC_INIA.gpkg` contiene dos capas:

- `cuenca_TRC` — límite de la cuenca del río Tres Cruces.
- `estacion_INIA_La_Magnolia` — localización de la estación.

---

## 🌿 Cobertura

`04_COBERTURA/mapbiomas_TRC_2023.tif` es MapBiomas recortado a la cuenca. Las
clases utilizadas en el taller son:

| Código | Clase |
|:--:|:--|
| 3 | Bosque ribereño |
| 9 | Forestación |
| 12 | Pastizal |

---

## 📈 Serie temporal

`05_SERIE_TEMPORAL/serie_temporal_SAFER_2022_2024.csv` posee **102 filas**: 34
fechas por tres coberturas. Fue recalculada desde los productos Landsat TOA
usando los parámetros `a = 0.66` y `b = -0.0028`.

Variables principales: ETa, ETr, NDVI, temperatura superficial, albedo, ET₀,
radiación global y temperatura de INIA.
