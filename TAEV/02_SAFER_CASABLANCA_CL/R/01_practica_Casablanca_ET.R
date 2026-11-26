# ==============================================================================
# ACTIVIDAD SAFER CASABLANCA CHILE
# Script de trabajo para estudiantes
# ==============================================================================
#
# Este archivo es un ESQUELETO. Los bloques marcados como ACTIVIDAD deben ser
# completados por el estudiante con ayuda de la guía en formato Word.
#
# Forma de trabajo:
# 1. Abra PRACTICA_CASABLANCA.Rproj.
# 2. Abra este script desde la carpeta 02_R.
# 3. Ejecute una sección por vez con Ctrl + Enter.
# 4. Cuando aparezca stop("ACTIVIDAD..."), lea la consigna, escriba el cálculo
#    solicitado y elimine solamente esa línea stop().
# 5. Observe cada gráfico antes de continuar.
#
# La práctica no usa ERA5 ni SMAP.
# ==============================================================================


# ==============================================================================
# 0 PREPARAR EL TRABAJO
# ==============================================================================

rm(list = ls())
options(scipen = 999)

# Permite abrir el script desde 02_R aunque no se haya abierto el .Rproj.
if (!dir.exists("01_DATOS") && dir.exists("../01_DATOS")) {
  setwd("..")
}

if (!dir.exists("01_DATOS")) {
  stop(
    "No se encuentra 01_DATOS. Descomprima el paquete completo en una ruta ",
    "corta y abra PRACTICA_CASABLANCA.Rproj."
  )
}

if (!requireNamespace("terra", quietly = TRUE)) {
  stop('Falta terra. Instálelo una vez con install.packages("terra").')
}
library(terra)

dir.create("04_RESULTADOS", showWarnings = FALSE)


# ==============================================================================
# 1 CALCULAR ETA OBSERVADA EN LA TORRE DE FLUJO
# ==============================================================================

torre <- read.csv(
  "01_DATOS/01_TORRE/ChileFlux_Casablanca_2023-12-04_30min.csv",
  na.strings = c("", "NA", "--")
)

torre$fecha_hora <- as.POSIXct(
  paste(torre$fecha, torre$hora),
  format = "%Y-%m-%d %H:%M:%S",
  tz = "America/Santiago"
)

# Antes de calcular, conozca la tabla.
head(torre)
str(torre)
summary(torre)


# ACTIVIDAD 1A PROMEDIO DEL FLUJO DE CALOR EN EL SUELO
# Calcule, para cada fila, el promedio de G1_W_m2, G2_W_m2 y G3_W_m2.
# Guarde el resultado en torre$G_prom_W_m2.
# Pista: use rowMeans() y na.rm = TRUE.

stop("ACTIVIDAD 1A: calcule G_prom_W_m2 y elimine esta línea stop().")

# Si las tres placas fueran NA, rowMeans produce NaN. Lo convertimos en NA.
torre$G_prom_W_m2[is.nan(torre$G_prom_W_m2)] <- NA


# Control físico sencillo de las variables de energía y turbulencia.
torre$Rn_W_m2[torre$Rn_W_m2 < -200 | torre$Rn_W_m2 > 1100] <- NA
torre$H_W_m2[torre$H_W_m2 < -200 | torre$H_W_m2 > 600] <- NA
torre$G_prom_W_m2[
  torre$G_prom_W_m2 < -100 | torre$G_prom_W_m2 > 200
] <- NA
torre$ustar_m_s[torre$ustar_m_s < 0 | torre$ustar_m_s > 3] <- NA


# ACTIVIDAD 1B BALANCE DE ENERGÍA RESIDUAL
# Calcule el flujo de calor latente como residuo del balance:
# LE = Rn - G - H
# Guarde el resultado en torre$LE_W_m2.

stop("ACTIVIDAD 1B: calcule LE_W_m2 y elimine esta línea stop().")


# Aplicamos los criterios comunes a todos los grupos.
es_dia <- torre$Rn_W_m2 > 50
baja_turbulencia <- torre$ustar_m_s < 0.10
torre$LE_W_m2[es_dia & baja_turbulencia] <- NA
torre$LE_W_m2[!es_dia] <- 0
torre$LE_W_m2[torre$LE_W_m2 < 0] <- 0


# ACTIVIDAD 1C CONVERSIÓN DE ENERGÍA EN LÁMINA DE AGUA
# Cada registro representa 30 minutos, es decir, 1800 segundos.
# Complete tres operaciones:
# a) convierta LE de W m-2 a MJ m-2 por intervalo;
# b) divida por 2.45 MJ kg-1 para obtener mm por intervalo;
# c) sume los intervalos válidos para obtener ETa_torre.
#
# Objetos que debe crear:
# torre$energia_LE_MJ_m2
# torre$ET_intervalo_mm
# ETa_torre

stop("ACTIVIDAD 1C: convierta LE en ETa_torre y elimine esta línea stop().")

n_validos <- sum(!is.na(torre$LE_W_m2))

cat("\nRESULTADO DE LA TORRE\n")
cat("Intervalos válidos:", n_validos, "de", nrow(torre), "\n")
cat("ETa de la torre:", round(ETa_torre, 3), "mm/día\n")

# RESULTADO GRÁFICO 1
matplot(
  torre$fecha_hora,
  cbind(
    torre$Rn_W_m2,
    torre$H_W_m2,
    torre$G_prom_W_m2,
    torre$LE_W_m2
  ),
  type = "l",
  lty = 1,
  lwd = c(2, 1.4, 1.4, 2),
  col = c("#1F1F1F", "#D95F02", "#7570B3", "#1B9E77"),
  xlab = "Hora local",
  ylab = expression("Flujo de energía (W " * m^{-2} * ")"),
  main = "Balance de energía observado en 04-12-2023"
)
legend(
  "topleft",
  legend = c("Rn", "H", "G promedio", "LE residual"),
  col = c("#1F1F1F", "#D95F02", "#7570B3", "#1B9E77"),
  lty = 1,
  lwd = c(2, 1.4, 1.4, 2),
  bty = "n",
  cex = 0.8
)


# ==============================================================================
# 2 SELECCIONAR ETO Y CALCULAR ETFR DE LA TORRE
# ==============================================================================

tabla_eto <- read.csv(
  "01_DATOS/02_ETO/ETo_INIA_Colliguay_2023-12-01_07.csv"
)

print(tabla_eto)


# ACTIVIDAD 2A SELECCIÓN DE LA FECHA
# Seleccione solamente la fila correspondiente a 2023-12-04.
# Guárdela como fila_fecha y extraiga ETo_mm_dia en el objeto ETo.

stop("ACTIVIDAD 2A: seleccione la fecha y cree ETo; elimine esta línea stop().")

if (nrow(fila_fecha) != 1) {
  stop("La selección debe producir exactamente una fila.")
}


# ACTIVIDAD 2B FRACCIÓN DE EVAPOTRANSPIRACIÓN OBSERVADA
# Calcule ETfr_torre como la razón entre ETa_torre y ETo.

stop("ACTIVIDAD 2B: calcule ETfr_torre y elimine esta línea stop().")

cat("\nRESULTADO DE ETo Y ETfr DE LA TORRE\n")
cat("Estación:", fila_fecha$estacion, "\n")
cat("ETo:", ETo, "mm/día\n")
cat("Completitud:", fila_fecha$pct_datos, "%\n")
cat("ETfr de la torre:", round(ETfr_torre, 3), "\n")

# RESULTADO GRÁFICO 2
colores_eto <- rep("#9ECAE1", nrow(tabla_eto))
colores_eto[tabla_eto$fecha == "2023-12-04"] <- "#08519C"

barplot(
  tabla_eto$ETo_mm_dia,
  names.arg = substr(tabla_eto$fecha, 6, 10),
  col = colores_eto,
  border = NA,
  xlab = "Fecha (mes-día)",
  ylab = "ETo (mm/día)",
  main = "ETo diaria en la estación INIA Colliguay"
)
abline(h = ETo, lty = 2, col = "#08519C")


# ==============================================================================
# 3 LEER Y EXPLORAR LAS IMÁGENES
# ==============================================================================

archivo_landsat <-
  "01_DATOS/03_IMAGENES/LANDSAT89_CASABLANCA_20231204.tif"
archivo_sentinel <-
  "01_DATOS/03_IMAGENES/SENTINEL2_CASABLANCA_20231204.tif"

if (!file.exists(archivo_landsat) || !file.exists(archivo_sentinel)) {
  stop(
    "Faltan las imágenes en 01_DATOS/03_IMAGENES. ",
    "Ejecute el código GEE o use los archivos entregados por el docente."
  )
}

landsat <- rast(archivo_landsat)
sentinel <- rast(archivo_sentinel)

names(landsat) <- c(
  "BLUE", "GREEN", "RED", "NIR", "SWIR1", "SWIR2",
  "NDVI", "ALBEDO", "LST_C"
)
names(sentinel) <- c(
  "BLUE", "GREEN", "RED", "NIR", "SWIR1", "SWIR2", "NDVI"
)

cat("\nINFORMACIÓN DE LAS IMÁGENES\n")
print(landsat)
print(sentinel)
cat("Resolución Landsat:", res(landsat)[1], "m\n")
cat("Resolución Sentinel-2:", res(sentinel)[1], "m\n")

# RESULTADO GRÁFICO 3 COLOR VERDADERO
par(mfrow = c(1, 2))
plotRGB(
  landsat,
  r = 3, g = 2, b = 1,
  stretch = "lin",
  main = "Landsat 8/9 a 30 m"
)
plotRGB(
  sentinel,
  r = 3, g = 2, b = 1,
  stretch = "lin",
  main = "Sentinel-2 a 10 m"
)
par(mfrow = c(1, 1))

# RESULTADO GRÁFICO 4 NDVI
par(mfrow = c(1, 2))
plot(
  landsat[["NDVI"]],
  col = hcl.colors(50, "YlGn"),
  range = c(0, 1),
  main = "NDVI Landsat 8/9"
)
plot(
  sentinel[["NDVI"]],
  col = hcl.colors(50, "YlGn"),
  range = c(0, 1),
  main = "NDVI Sentinel-2"
)
par(mfrow = c(1, 1))

# RESULTADO GRÁFICO 5 TEMPERATURA SUPERFICIAL LANDSAT
plot(
  landsat[["LST_C"]],
  col = hcl.colors(50, "Inferno", rev = TRUE),
  main = "Temperatura superficial Landsat en °C"
)


# ==============================================================================
# 4 APLICAR SAFER CON LANDSAT 8 Y 9
# ==============================================================================

# Coeficientes calibrados previamente para el caso de Casablanca.
A <- 0.3663
B <- -0.001117

NDVI_L89 <- landsat[["NDVI"]]
albedo_L89 <- landsat[["ALBEDO"]]
LST_L89 <- landsat[["LST_C"]]


# ACTIVIDAD 4A RELACIÓN ESPECTRAL TÉRMICA
# Calcule x_L89 = LST_L89 / (albedo_L89 * NDVI_L89).

stop("ACTIVIDAD 4A: calcule x_L89 y elimine esta línea stop().")


# ACTIVIDAD 4B ETFR LANDSAT
# Aplique ETfr = exp(A + B * x_L89).
# Después use ifel() para conservar solamente NDVI > 0 y albedo > 0.
# Finalmente limite ETfr entre 0 y 1.2 con clamp().

stop("ACTIVIDAD 4B: calcule y controle ETfr_L89; elimine esta línea stop().")


# ACTIVIDAD 4C ETA LANDSAT
# Calcule ETa_L89 multiplicando ETfr_L89 por ETo.

stop("ACTIVIDAD 4C: calcule ETa_L89 y elimine esta línea stop().")

names(ETfr_L89) <- "ETfr_Landsat"
names(ETa_L89) <- "ETa_Landsat_mm_dia"

cat("\nSAFER LANDSAT\n")
print(global(ETfr_L89, "mean", na.rm = TRUE))
print(global(ETa_L89, "mean", na.rm = TRUE))

# RESULTADO GRÁFICO 6
par(mfrow = c(1, 2))
plot(
  ETfr_L89,
  col = hcl.colors(50, "YlGnBu"),
  range = c(0, 1.2),
  main = "ETfr SAFER Landsat"
)
plot(
  ETa_L89,
  col = hcl.colors(50, "Viridis"),
  range = c(0, 6),
  main = "ETa SAFER Landsat en mm/día"
)
par(mfrow = c(1, 1))


# ==============================================================================
# 5 CONSTRUIR EL PRODUCTO HÍBRIDO SENTINEL 2 Y LANDSAT
# ==============================================================================

# Sentinel-2 aporta NDVI a 10 m, pero no posee una banda térmica.
# LST y albedo proceden de Landsat y se interpolan a la grilla Sentinel-2.


# ACTIVIDAD 5A ARMONIZACIÓN DE GRILLAS
# Use resample(..., method = "bilinear") para llevar LST_L89 y albedo_L89
# a la grilla de sentinel[["NDVI"]]. Cree LST_en_S2 y albedo_en_S2.
# Extraiga también NDVI_S2 desde sentinel.

stop("ACTIVIDAD 5A: armonice las grillas y elimine esta línea stop().")


# ACTIVIDAD 5B ETFR Y ETA DEL PRODUCTO HÍBRIDO
# Repita la lógica SAFER usando:
# LST_en_S2, albedo_en_S2 y NDVI_S2.
# Cree x_S2, ETfr_S2_hibrida y ETa_S2_hibrida.
# Aplique la misma máscara y el mismo límite de 0 a 1.2.

stop("ACTIVIDAD 5B: calcule el producto híbrido y elimine esta línea stop().")

names(ETfr_S2_hibrida) <- "ETfr_S2_hibrida"
names(ETa_S2_hibrida) <- "ETa_S2_hibrida_mm_dia"

cat("\nPRODUCTO HÍBRIDO SENTINEL-2 Y LANDSAT\n")
print(global(ETfr_S2_hibrida, "mean", na.rm = TRUE))
print(global(ETa_S2_hibrida, "mean", na.rm = TRUE))

# RESULTADO GRÁFICO 7
par(mfrow = c(1, 2))
plot(
  ETfr_S2_hibrida,
  col = hcl.colors(50, "YlGnBu"),
  range = c(0, 1.2),
  main = "ETfr híbrida"
)
plot(
  ETa_S2_hibrida,
  col = hcl.colors(50, "Viridis"),
  range = c(0, 6),
  main = "ETa híbrida en mm/día"
)
par(mfrow = c(1, 1))


# ==============================================================================
# 6 COMPARAR LAS ESTIMACIONES CON LA TORRE
# ==============================================================================

torre_punto <- vect(
  data.frame(longitud = -71.354548, latitud = -33.237398),
  geom = c("longitud", "latitud"),
  crs = "EPSG:4326"
)

torre_utm <- project(torre_punto, crs(landsat))
area_torre <- buffer(torre_utm, width = 60)


# ACTIVIDAD 6A EXTRACCIÓN ESPACIAL
# Use extract() para calcular el promedio de ETa_L89 dentro de area_torre.
# Repita para ETa_S2_hibrida.
# Guarde los números en ETa_L89_torre y ETa_S2_torre.

stop("ACTIVIDAD 6A: extraiga las dos medias y elimine esta línea stop().")


# ACTIVIDAD 6B TABLA DE COMPARACIÓN
# Cree un data.frame llamado comparacion con dos columnas:
# metodo y ETa_mm_dia.
# Incluya torre, SAFER Landsat y producto híbrido.
# Después cree diferencia_con_torre_mm restando ETa_torre.

stop("ACTIVIDAD 6B: cree la tabla comparacion y elimine esta línea stop().")

cat("\nCOMPARACIÓN FINAL\n")
print(comparacion)

# RESULTADO GRÁFICO 8
barplot(
  comparacion$ETa_mm_dia,
  names.arg = c("Torre", "Landsat", "S2 híbrido"),
  col = c("#333333", "#2C7FB8", "#41AB5D"),
  border = NA,
  ylab = "ETa en mm/día",
  main = "ETa en el entorno de la torre en 04-12-2023"
)
abline(h = ETa_torre, lty = 2, col = "#333333")


# ==============================================================================
# 7 GUARDAR LOS PRODUCTOS
# ==============================================================================

write.csv(
  comparacion,
  "04_RESULTADOS/comparacion_ETa_Casablanca_2023-12-04.csv",
  row.names = FALSE
)

writeRaster(
  ETfr_L89,
  "04_RESULTADOS/ETfr_Landsat_Casablanca_2023-12-04.tif",
  overwrite = TRUE
)
writeRaster(
  ETa_L89,
  "04_RESULTADOS/ETa_Landsat_Casablanca_2023-12-04.tif",
  overwrite = TRUE
)
writeRaster(
  ETfr_S2_hibrida,
  "04_RESULTADOS/ETfr_S2_hibrida_Casablanca_2023-12-04.tif",
  overwrite = TRUE
)
writeRaster(
  ETa_S2_hibrida,
  "04_RESULTADOS/ETa_S2_hibrida_Casablanca_2023-12-04.tif",
  overwrite = TRUE
)

cat("\nActividad terminada. Revise 04_RESULTADOS y responda las preguntas.\n")
