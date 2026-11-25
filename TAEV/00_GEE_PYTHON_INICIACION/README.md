# 🐍 Taller 00 — Iniciación a Google Earth Engine con Python

Primera clase práctica del curso: conectar Earth Engine desde Colab, explorar
colecciones y recortar una parcela de interés. Es la base técnica de los
talleres siguientes.

| | |
|:--|:--|
| **Entorno** | Google Colab |
| **Librerías** | `earthengine-api`, `geemap`, `geopandas` |
| **Área de trabajo** | Región de Valparaíso, Chile |

---

## 📄 Archivos

| Archivo | Contenido |
|:--|:--|
| [`01_GEE_Python_Iniciacion.ipynb`](01_GEE_Python_Iniciacion.ipynb) | Cuaderno principal, con las explicaciones y los ejercicios |

El cuaderno se publica **sin las salidas ejecutadas**, para mantener el
repositorio liviano y los cambios legibles. Ejecútelo en Colab para ver los
mapas y los gráficos.

---

## ▶️ Preparación

1. Ingrese a Colab con una cuenta que tenga **acceso aprobado a Earth Engine**.
2. Abra `01_GEE_Python_Iniciacion.ipynb`.
3. Escriba el identificador de su proyecto de Google Cloud en `PROJECT_ID`.
4. Elija al comienzo entre las rutas **Frutales** y **Uso del suelo** mediante
   las líneas de `TIPO_ANALISIS`: deje una activa y mantenga la otra comentada
   con `#`.
5. Ejecute las celdas en orden.
6. Cuando aparezca el selector de archivos, cargue el GeoPackage de la ruta
   elegida.
7. Elija una especie o categoría en el segundo selector. Para cambiar de
   categoría, seleccione otra opción y vuelva a ejecutar desde la celda que
   define `CATEGORIA_ANALISIS`.

La configuración es correcta cuando aparece el mensaje
`Earth Engine conectado correctamente`. La práctica puede continuar cuando el
cuaderno muestra el resumen de categorías y delimita la parcela de mayor
superficie de la categoría elegida.

> 💡 Si el GeoPackage no carga, el cuaderno incluye una celda de respaldo que
> define un rectángulo en Casablanca: descomente sus dos líneas y continúe con
> los filtros de Sentinel-2.

---

## 🗂️ Bases vectoriales

| Archivo | Contenido |
|:--|:--|
| `FRUTALES_VALPARAISO.gpkg` | 14.070 polígonos y 38 especies frutales |
| `USOS_CASABLANCA.gpkg` | 7.942 polígonos y 33 categorías de uso del suelo |
| `COMUNAS_VALPARAISO.gpkg` | Límite comunal de apoyo |
| `REGION_VALPARAISO.gpkg` | Límite regional de apoyo |

Estos archivos **no se distribuyen en el repositorio**. Derivan de ICET/ODEPA y
de la BCN; véase [`../DATOS/FUENTES.md`](../DATOS/FUENTES.md) y
[`../../INTROSIG/DATOS/FUENTES.md`](../../INTROSIG/DATOS/FUENTES.md).

> La versión regional completa de usos del suelo (`USOS_VALPARAISO.gpkg`) pesa
> cerca de 756 MB. Para la clase se usa `USOS_CASABLANCA.gpkg`, recortado,
> simplificado y reproyectado a EPSG:4326, de unos 6 MB.
