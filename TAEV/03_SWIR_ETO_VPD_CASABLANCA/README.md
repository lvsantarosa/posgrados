# 💨 Taller 03 — SWIR, ET₀ y VPD · Casablanca

Del componente atmosférico de la evapotranspiración a la respuesta espectral de
la vegetación: tres formas de calcular el **déficit de presión de vapor (VPD)**,
su validación contra una estación en tierra y su relación con los índices SWIR
de Sentinel-2.

| | |
|:--|:--|
| **Entorno** | Google Colab + Earth Engine |
| **Fuentes** | Estación Agromet INIA Colliguay · ERA5-Land · Sentinel-2 SR |
| **Área** | Casablanca, Región de Valparaíso |

---

## 📄 Archivos

| Archivo | Contenido |
|:--|:--|
| [`01_TP3_SWIR_ETo_VPD_Casablanca.ipynb`](01_TP3_SWIR_ETo_VPD_Casablanca.ipynb) | Cuaderno único, con explicaciones, ecuaciones, gráficos y preguntas de interpretación |

---

## 🔄 Flujo de trabajo

1. Control de calidad de la serie de Colliguay.
2. Cálculo de **tres métodos de VPD** con los datos de la estación.
3. Cálculo de ET₀ y de los mismos tres métodos de VPD con **ERA5-Land**.
4. Validación estación × ERA5-Land en Colliguay.
5. Aplicación de ERA5-Land en Casablanca.
6. Procesamiento Sentinel-2 e índices **NDVI, NDMI, MSI y DWSI**.
7. Análisis del mismo día y de **ventanas antecedentes de 3 y 7 días**.
8. Exportación de tablas.

---

## ▶️ Preparación

1. Abra el cuaderno en Google Colab con una cuenta habilitada en Earth Engine.
2. Edite `PROJECT_ID` y, si corresponde, `CARPETA_DRIVE`.
3. Ejecute las celdas en orden.

Los datos de la estación se descargan desde la red
[Agromet INIA](https://agrometeorologia.cl/); ERA5-Land y Sentinel-2 se acceden
directamente desde Earth Engine. Véase [`../DATOS/FUENTES.md`](../DATOS/FUENTES.md).
