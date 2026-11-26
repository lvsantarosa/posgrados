# 📂 Fuentes de datos — GEOHIDRO

Los notebooks **no incluyen datos**: acceden a las colecciones directamente
desde **Google Earth Engine** y leen las capas vectoriales desde Google Drive.

---

## 🛰️ Colecciones de Earth Engine

| Colección GEE | Variable | Taller |
|:--|:--|:--:|
| `UCSB-CHG/CHIRPS/DAILY` | Precipitación diaria | 3, 4, 5 |
| `MODIS/061/MOD16A2GF` | Evapotranspiración (ET y PET) | 4, 5 |
| `NASA/GLDAS/V022/CLSM/G025/DA1D` | Variables del balance hídrico terrestre | 5 |
| `ECMWF/ERA5_LAND/MONTHLY_AGGR` | Reanálisis mensual ERA5-Land | 5 |

Requisitos: cuenta habilitada en
[Earth Engine](https://earthengine.google.com/signup/) y un proyecto de Google
Cloud asociado.

---

## 🏞️ Cuencas y subcuencas

| | |
|:--|:--|
| **Fuente oficial** | Mapoteca Digital DGA — <https://dga.mop.gob.cl/mapoteca-digital/> |
| **Descripción** | Cartografía oficial de cuencas, subcuencas y subsubcuencas (BNA) |
| **Uso** | Se carga como archivo `.zip` desde Google Drive montado en Colab |

---

## 🌎 Material complementario

Para productos satelitales globales ya preparados y recortados para Chile:

👉 [**lvsantarosa/gee-global-data-chile**](https://github.com/lvsantarosa/gee-global-data-chile)
