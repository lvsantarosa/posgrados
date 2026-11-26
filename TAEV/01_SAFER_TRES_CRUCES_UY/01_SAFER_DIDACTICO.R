# =============================================================================
# SAFER PASO A PASO: DE LA ENERGÍA ELECTROMAGNÉTICA A LA ETa
# Caso: cuenca del río Tres Cruces, Uruguay
# =============================================================================
#
# PROPÓSITO DIDÁCTICO
# --------------------
# Este script fue escrito para ejecutarse POR SECCIONES en RStudio. La idea no
# es ocultar el procedimiento dentro de funciones o procesos automáticos. Cada
# variable se calcula, se representa en un mapa y se interpreta antes de pasar
# a la siguiente.
#
# La secuencia conceptual es:
#
# radiación Landsat -> NDVI + albedo + temperatura superficial
#                    -> fracción evapotranspirativa (ETr)
#                    -> evapotranspiración actual (ETa)
#
# ECUACIONES PRINCIPALES
# ----------------------
# NDVI = (NIR - rojo) / (NIR + rojo)
# ETr  = exp(a + b * [Ts / (albedo * NDVI)])
# ETa  = ETr * ET0
#
# IMPORTANTE SOBRE LANDSAT
# ------------------------
# Las imágenes provienen de LANDSAT/LC08/C02/T1_TOA y
# LANDSAT/LC09/C02/T1_TOA. Por tanto:
#   - B1 a B7 ya son reflectancias en el tope de la atmósfera (TOA).
#   - B10 y B11 ya son temperaturas de brillo expresadas en Kelvin.
# No debe aplicarse nuevamente una conversión desde números digitales (DN).
#
# ESTACIÓN DE REFERENCIA
# ----------------------
# INIA La Magnolia: latitud -31.708888889, longitud -55.826666667,
# altitud 115 m. Coordenada verificada de la estación, adoptada en este taller.
#
# FORMA DE TRABAJO
# ----------------
# 1. Abra SAFER_TRC_CLASE.Rproj.
# 2. Ejecute una sección completa y observe el gráfico en RStudio.
# 3. Lea las preguntas escritas debajo de cada resultado.
# 4. Cambie ESCENA de 1 a 4 y repita las secciones 2 a 9.
# =============================================================================


# 0. PREPARAR EL ENTORNO ---------------------------------------------------

if (!requireNamespace("terra", quietly = TRUE)) {
  stop(
    paste0(
      "Falta el paquete 'terra'. Ejecute 02_SCRIPT/00_VERIFICAR_ENTORNO.R ",
      "y luego instale terra con install.packages('terra')."
    )
  )
}

library(terra)

# El proyecto RStudio permite usar rutas relativas. Así, la carpeta puede
# copiarse a otro computador sin modificar el código.
RAIZ <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)

if (!file.exists(file.path(RAIZ, "SAFER_TRC_CLASE.Rproj"))) {
  stop("Abra SAFER_TRC_CLASE.Rproj antes de ejecutar este script.")
}

DIR_DATOS <- file.path(RAIZ, "01_DATOS")
DIR_SALIDAS <- file.path(RAIZ, "03_SALIDAS")
DIR_RASTERS <- file.path(DIR_SALIDAS, "01_RASTERS")

dir.create(DIR_RASTERS, recursive = TRUE, showWarnings = FALSE)

# TRUE permite guardar los seis resultados de la escena elegida. Estos
# archivos son necesarios para comparar las cuatro fechas en la sección 10.
GUARDAR_RASTERS <- TRUE

# Parámetros utilizados en el caso uruguayo, Safre et al. 2022.
PARAMETRO_A <- 0.66
PARAMETRO_B <- -0.0028

# Parámetros de Teixeira conservados solamente para comparar sensibilidad.
PARAMETRO_A_TEIXEIRA <- 1.80
PARAMETRO_B_TEIXEIRA <- -0.008

cat("\nProyecto didáctico SAFER iniciado.\n")
cat("Carpeta activa:", RAIZ, "\n")


# 1. LEER Y CONOCER LOS DATOS ---------------------------------------------

manifiesto <- read.csv(
  file.path(DIR_DATOS, "manifiesto_escenas.csv"),
  stringsAsFactors = FALSE,
  encoding = "UTF-8"
)
manifiesto$fecha <- as.Date(manifiesto$fecha)

meteo <- read.csv(
  file.path(DIR_DATOS, "02_INIA", "INIA_La_Magnolia_diario_2022_2024.csv"),
  stringsAsFactors = FALSE
)
meteo$fecha <- as.Date(meteo$fecha)

serie_temporal <- read.csv(
  file.path(
    DIR_DATOS,
    "05_SERIE_TEMPORAL",
    "serie_temporal_SAFER_2022_2024.csv"
  ),
  stringsAsFactors = FALSE,
  encoding = "UTF-8"
)
serie_temporal$fecha <- as.Date(serie_temporal$fecha)

archivo_gpkg <- file.path(
  DIR_DATOS,
  "03_VECTOR",
  "datos_base_TRC_INIA.gpkg"
)

cuenca <- vect(archivo_gpkg, layer = "cuenca_TRC")
estacion_inia <- vect(archivo_gpkg, layer = "estacion_INIA_La_Magnolia")

cobertura_2023 <- rast(
  file.path(DIR_DATOS, "04_COBERTURA", "mapbiomas_TRC_2023.tif")
)

# Comprobaciones simples para detectar archivos incompletos.
stopifnot(nrow(manifiesto) == 4)
stopifnot(nrow(meteo) == 1096)
stopifnot(length(unique(serie_temporal$fecha)) == 34)
stopifnot(nrow(serie_temporal) == 102)

cat("\nLas cuatro escenas disponibles son:\n")
print(
  manifiesto[, c("fecha", "satelite", "estacion_meteorologica")],
  row.names = FALSE
)

# MAPA 1: contexto territorial.
# Reclasificamos solamente para asignar tres colores fáciles de interpretar.
tabla_reclasificacion <- matrix(
  c(
    3, 1,    # bosque ribereño
    9, 2,    # forestación
    12, 3    # pastizal
  ),
  ncol = 2,
  byrow = TRUE
)

cobertura_clase <- classify(
  cobertura_2023,
  tabla_reclasificacion,
  others = NA
)

cuenca_mapa <- project(cuenca, cobertura_clase)
estacion_mapa <- project(estacion_inia, cobertura_clase)

plot(
  cobertura_clase,
  col = c("#385723", "#77B82A", "#D9A21B"),
  legend = FALSE,
  axes = TRUE,
  main = "Cuenca del río Tres Cruces e INIA La Magnolia"
)
lines(cuenca_mapa, lwd = 1.5)
points(estacion_mapa, pch = 8, cex = 1.5, col = "#C00000")
legend(
  "bottomleft",
  inset = c(0.15, 0.01),
  legend = c(
    "Bosque ribereño",
    "Forestación",
    "Pastizal",
    "INIA La Magnolia"
  ),
  fill = c("#385723", "#77B82A", "#D9A21B", NA),
  border = c("#385723", "#77B82A", "#D9A21B", NA),
  pch = c(NA, NA, NA, 8),
  col = c(NA, NA, NA, "#C00000"),
  bty = "n",
  cex = 0.8
)

# PARA DISCUTIR
# ¿Por qué necesitamos conocer la cobertura antes de interpretar un mapa de
# ETa? ¿Esperamos la misma respuesta en pastizal, bosque y forestación?


# 2. ELEGIR MANUALMENTE UNA ESCENA ----------------------------------------

# Cambie este número para repetir el ejercicio:
#   1 = verano 2023
#   2 = invierno 2023
#   3 = verano 2024
#   4 = invierno 2024
ESCENA <- 1

if (!ESCENA %in% 1:4) {
  stop("ESCENA debe ser un número entero entre 1 y 4.")
}

fecha <- manifiesto$fecha[ESCENA]
fecha_texto <- format(fecha, "%Y-%m-%d")

archivo_landsat <- file.path(
  DIR_DATOS,
  "01_LANDSAT_ESTACIONAL",
  manifiesto$archivo[ESCENA]
)

cat("\nEscena elegida:\n")
print(manifiesto[ESCENA, ], row.names = FALSE)


# 3. ABRIR LA IMAGEN Y OBSERVAR LA SEÑAL ---------------------------------

imagen <- rast(archivo_landsat)

bandas_esperadas <- c(
  "B1", "B2", "B3", "B4", "B5", "B6", "B7", "B10", "B11"
)

if (nlyr(imagen) != 9) {
  stop("La imagen no contiene las nueve bandas esperadas.")
}

if (!all(bandas_esperadas %in% names(imagen))) {
  names(imagen) <- bandas_esperadas
}

# La imagen se recorta con el polígono real de la cuenca, no con un rectángulo.
cuenca_nativa <- project(cuenca, imagen)
imagen <- crop(imagen, cuenca_nativa)
imagen <- mask(imagen, cuenca_nativa)

# GRÁFICO 2: color verdadero.
# Rojo, verde y azul se asignan a los mismos canales de nuestra visión.
plotRGB(
  imagen,
  r = "B4", g = "B3", b = "B2",
  stretch = "lin",
  main = paste("Color verdadero -", fecha_texto)
)

# GRÁFICO 3: falso color infrarrojo.
# Al asignar NIR al canal rojo, la vegetación vigorosa aparece rojiza.
plotRGB(
  imagen,
  r = "B4", g = "B5", b = "B3",
  stretch = "lin",
  main = paste("Falso color NIR -", fecha_texto)
)

# PLOT: comparar rojo y NIR antes de calcular NDVI.
plot(imagen[["B4"]], main = "B4: rojo")
plot(imagen[["B5"]], main = "B5: infrarrojo cercano")

# PARA DISCUTIR
# Localice una zona con vegetación densa. ¿Es más oscura en rojo o en NIR?
# La diferencia se relaciona con absorción por pigmentos y dispersión en la
# estructura interna de hojas y doseles.


# 4. CALCULAR Y OBSERVAR NDVI ---------------------------------------------

# B4 representa rojo y B5 infrarrojo cercano (NIR).
NDVI <- (imagen[["B5"]] - imagen[["B4"]]) /
        (imagen[["B5"]] + imagen[["B4"]])

# SAFER no debe aplicarse donde NDVI es cero o negativo. Esos valores pueden
# representar agua, suelo muy oscuro, sombra u otras superficies no vegetadas.
NDVI[NDVI <= 0] <- NA
names(NDVI) <- "NDVI"

# GRÁFICO 5: resultado de NDVI.
plot(
  NDVI,
  col = hcl.colors(100, "YlGn"),
  range = c(0, 1),
  main = paste("NDVI -", fecha_texto)
)

cat("\nResumen de NDVI:\n")
print(global(NDVI, c("min", "mean", "max"), na.rm = TRUE))

# INTERPRETACIÓN
# Un NDVI alto indica un contraste fuerte entre baja reflectancia roja y alta
# reflectancia NIR. No equivale directamente a biomasa ni a ETa: es un indicador
# espectral que debe analizarse junto con temperatura, albedo y meteorología.


# 5. CALCULAR Y OBSERVAR EL ALBEDO ----------------------------------------

# El albedo planetario combina las reflectancias de las bandas solares. Cada
# coeficiente representa el peso relativo de una región del espectro.
albedo_planetario <-
  0.10 * imagen[["B1"]] +
  0.31 * imagen[["B2"]] +
  0.30 * imagen[["B3"]] +
  0.13 * imagen[["B4"]] +
  0.08 * imagen[["B5"]] +
  0.05 * imagen[["B6"]] +
  0.04 * imagen[["B7"]]

# Las dos ecuaciones siguientes son ajustes empíricos del flujo de trabajo
# empleado en el estudio. El resultado final es el albedo diario de superficie.
albedo_superficie <- 0.6054 * albedo_planetario + 0.0797
albedo_24h <- 1.0223 * albedo_superficie + 0.0149
names(albedo_24h) <- "ALBEDO_24H"

# PLOT: observar cómo cambia el albedo durante las correcciones.
plot(albedo_planetario, main = "Albedo planetario")
plot(albedo_superficie, main = "Albedo superficial")
plot(albedo_24h, main = "Albedo diario")

cat("\nResumen del albedo diario:\n")
print(global(albedo_24h, c("min", "mean", "max"), na.rm = TRUE))

# INTERPRETACIÓN
# El albedo es la fracción de energía solar reflejada. Una superficie con
# albedo 0.15 refleja aproximadamente 15% de la radiación incidente. La energía
# no reflejada puede ser absorbida y repartida entre calor, suelo y evaporación.


# 6. CALCULAR Y OBSERVAR LA TEMPERATURA SUPERFICIAL -----------------------

# B10 y B11 son temperaturas de brillo en Kelvin. Primero obtenemos su media.
temperatura_brillo <- (imagen[["B10"]] + imagen[["B11"]]) / 2
names(temperatura_brillo) <- "TEMPERATURA_BRILLO_K"

# Esta corrección empírica produce temperatura superficial en Kelvin.
LST_K <- 1.0694 * temperatura_brillo - 20.173

# Restamos 273.15 para expresar la temperatura en grados Celsius.
LST_C <- LST_K - 273.15
names(LST_C) <- "LST_C"

# PLOT: temperatura antes y después de la corrección.
plot(temperatura_brillo, main = "Temperatura de brillo (K)")
plot(
  LST_C,
  col = hcl.colors(100, "Inferno"),
  main = "Temperatura superficial (°C)"
)


cat("\nResumen de temperatura superficial en °C:\n")
print(global(LST_C, c("min", "mean", "max"), na.rm = TRUE))

# INTERPRETACIÓN
# LST no es la temperatura del aire medida a 2 m. Es la temperatura radiativa
# de la superficie observada por el sensor. Menor enfriamiento evaporativo suele
# asociarse con una superficie más caliente, pero también influyen radiación,
# humedad, estructura del dosel, suelo y hora de adquisición.


# 7. BUSCAR LA INFORMACIÓN METEOROLÓGICA DEL MISMO DÍA -------------------

met_dia <- meteo[meteo$fecha == fecha, ]

if (nrow(met_dia) != 1) {
  stop("No existe un único registro INIA para ", fecha_texto)
}

ET0 <- met_dia$ET0_mm_dia

cat("\nDatos de INIA La Magnolia para la fecha Landsat:\n")
print(met_dia, row.names = FALSE)

# INTERPRETACIÓN
# ET0 describe la demanda atmosférica de agua de una superficie de referencia.
# SAFER combina esa demanda diaria, medida/estimada con datos meteorológicos,
# con el estado espacial observado por Landsat.


# 8. CALCULAR Y OBSERVAR LA FRACCIÓN EVAPOTRANSPIRATIVA ------------------

# Ts, albedo y NDVI aparecen juntos dentro de la ecuación empírica.
# Por ello no conviene interpretar el efecto de una variable de forma aislada.
ETr <- exp(
  PARAMETRO_A +
    PARAMETRO_B * (LST_C / (albedo_superficie * NDVI))
)
names(ETr) <- "ETR"

# GRÁFICO 8: fracción evapotranspirativa.
plot(
  ETr,
  col = hcl.colors(100, "BluYl"),
  main = paste("Fracción evapotranspirativa -", fecha_texto)
)

cat("\nResumen de ETr:\n")
print(global(ETr, c("min", "mean", "max"), na.rm = TRUE))

# PARA DISCUTIR
# Observe una zona con NDVI alto. ¿Su ETr también es alta? Si no coincide,
# examine su temperatura y albedo antes de formular una explicación.


# 9. CALCULAR Y OBSERVAR LA EVAPOTRANSPIRACIÓN ACTUAL --------------------

ETa <- ETr * ET0
names(ETa) <- "ETA"

# Repetimos la ecuación con los parámetros alternativos para mostrar que una
# ecuación empírica puede cambiar mucho cuando cambia su calibración.
ETr_Teixeira <- exp(
  PARAMETRO_A_TEIXEIRA +
    PARAMETRO_B_TEIXEIRA * (LST_C / (albedo_superficie * NDVI))
)

ETa_Teixeira <- ETr_Teixeira * ET0
names(ETa_Teixeira) <- "ETA_TEIXEIRA"

diferencia_parametros <- ETa - ETa_Teixeira
names(diferencia_parametros) <- "DIFERENCIA_ETA"

# GRÁFICO 9: ETa principal, ETa alternativa y diferencia entre ambas.
par(mfrow = c(3, 1), mar = c(3, 3, 3, 4))
plot(
  ETa,
  col = hcl.colors(100, "GnBu"),
  range = c(0, 7),
  main = "ETa: Safre et al. 2022"
)
plot(
  ETa_Teixeira,
  col = hcl.colors(100, "GnBu"),
  range = c(0, 7),
  main = "ETa: Teixeira 2010"
)
plot(
  diferencia_parametros,
  col = hcl.colors(100, "Blue-Red 3"),
  main = "Diferencia entre estimaciones"
)
par(mfrow = c(1, 1))

cat("\nResumen de ETa en mm/día:\n")
print(global(ETa, c("min", "mean", "max"), na.rm = TRUE))

# RESULTADO FINAL DE LA ESCENA
# ETa conserva la variabilidad espacial de Landsat y queda expresada en mm/día
# porque ETr, sin unidades, se multiplica por ET0, expresada en mm/día.


# 9.1 GUARDAR LOS RESULTADOS DE ESTA ESCENA -------------------------------

# Reproyectamos correctamente a UTM 21 Sur. No cambiamos solamente la etiqueta
# del sistema de coordenadas: terra recalcula la posición de los píxeles.
resultado <- c(NDVI, albedo_24h, LST_C, ETr, ETa, ETa_Teixeira)
resultado_utm <- project(resultado, "EPSG:32721", method = "bilinear")

if (GUARDAR_RASTERS) {
  writeRaster(
    resultado_utm[["NDVI"]],
    file.path(DIR_RASTERS, paste0("NDVI_", fecha_texto, ".tif")),
    overwrite = TRUE
  )
  writeRaster(
    resultado_utm[["ALBEDO_24H"]],
    file.path(DIR_RASTERS, paste0("ALBEDO_", fecha_texto, ".tif")),
    overwrite = TRUE
  )
  writeRaster(
    resultado_utm[["LST_C"]],
    file.path(DIR_RASTERS, paste0("LST_C_", fecha_texto, ".tif")),
    overwrite = TRUE
  )
  writeRaster(
    resultado_utm[["ETR"]],
    file.path(DIR_RASTERS, paste0("ETR_", fecha_texto, ".tif")),
    overwrite = TRUE
  )
  writeRaster(
    resultado_utm[["ETA"]],
    file.path(DIR_RASTERS, paste0("ETA_", fecha_texto, ".tif")),
    overwrite = TRUE
  )
  writeRaster(
    resultado_utm[["ETA_TEIXEIRA"]],
    file.path(DIR_RASTERS, paste0("ETA_TEIXEIRA_", fecha_texto, ".tif")),
    overwrite = TRUE
  )

  cat("\nResultados guardados para", fecha_texto, "\n")
}

# AHORA REPITA MANUALMENTE
# Cambie ESCENA a 2, 3 y 4. Para cada valor, vuelva a ejecutar las secciones
# 2 a 9.1. Observe cada mapa antes de continuar. Esta repetición deliberada
# permite reconocer qué cambia y qué permanece igual en el procedimiento.


# 10. COMPARAR LAS CUATRO ESCENAS -----------------------------------------

# Esta sección se ejecuta después de procesar y guardar las cuatro escenas.
fechas_texto <- format(manifiesto$fecha, "%Y-%m-%d")

archivos_eta <- file.path(
  DIR_RASTERS,
  paste0("ETA_", fechas_texto, ".tif")
)
archivos_ndvi <- file.path(
  DIR_RASTERS,
  paste0("NDVI_", fechas_texto, ".tif")
)
archivos_lst <- file.path(
  DIR_RASTERS,
  paste0("LST_C_", fechas_texto, ".tif")
)

archivos_completos <- all(
  file.exists(c(archivos_eta, archivos_ndvi, archivos_lst))
)

etiquetas <- c(
  "Verano 2023",
  "Invierno 2023",
  "Verano 2024",
  "Invierno 2024"
)

if (!archivos_completos) {
  cat(
    "\nLa comparación espacial todavía no puede realizarse.\n",
    "Procese ESCENA = 1, 2, 3 y 4 y guarde los rasters.\n"
  )
} else {
  # Se leen de forma explícita para que el estudiante vea cada archivo usado.
  eta_1 <- rast(archivos_eta[1])
  eta_2 <- rast(archivos_eta[2])
  eta_3 <- rast(archivos_eta[3])
  eta_4 <- rast(archivos_eta[4])

  par(mfrow = c(2, 2), mar = c(3, 3, 3, 4))
  plot(eta_1, range = c(0, 7), main = etiquetas[1])
  plot(eta_2, range = c(0, 7), main = etiquetas[2])
  plot(eta_3, range = c(0, 7), main = etiquetas[3])
  plot(eta_4, range = c(0, 7), main = etiquetas[4])
  par(mfrow = c(1, 1))

  ndvi_1 <- rast(archivos_ndvi[1])
  ndvi_2 <- rast(archivos_ndvi[2])
  ndvi_3 <- rast(archivos_ndvi[3])
  ndvi_4 <- rast(archivos_ndvi[4])

  par(mfrow = c(2, 2), mar = c(3, 3, 3, 4))
  plot(ndvi_1, range = c(0, 1), main = etiquetas[1])
  plot(ndvi_2, range = c(0, 1), main = etiquetas[2])
  plot(ndvi_3, range = c(0, 1), main = etiquetas[3])
  plot(ndvi_4, range = c(0, 1), main = etiquetas[4])
  par(mfrow = c(1, 1))

  lst_1 <- rast(archivos_lst[1])
  lst_2 <- rast(archivos_lst[2])
  lst_3 <- rast(archivos_lst[3])
  lst_4 <- rast(archivos_lst[4])

  rango_lst <- range(serie_temporal$LST_media_C, na.rm = TRUE)

  par(mfrow = c(2, 2), mar = c(3, 3, 3, 4))
  plot(lst_1, range = rango_lst, main = etiquetas[1])
  plot(lst_2, range = rango_lst, main = etiquetas[2])
  plot(lst_3, range = rango_lst, main = etiquetas[3])
  plot(lst_4, range = rango_lst, main = etiquetas[4])
  par(mfrow = c(1, 1))
}

# PARA DISCUTIR
# 1. ¿Dónde aumenta o disminuye ETa entre verano e invierno?
# 2. ¿El patrón de NDVI explica todo el patrón de ETa?
# 3. ¿Qué cobertura conserva menor temperatura superficial en verano?


# 11. COMPARAR LAS COBERTURAS EN LAS CUATRO FECHAS ------------------------

# La tabla temporal contiene medias calculadas para forestación, bosque
# ribereño y pastizal. Seleccionamos solamente las cuatro fechas del taller.
cuatro_fechas <- serie_temporal[
  serie_temporal$fecha %in% manifiesto$fecha,
]

# Separamos las coberturas explícitamente. Esto permite inspeccionar cada tabla.
forestacion <- cuatro_fechas[cuatro_fechas$cobertura == "Forestación", ]
bosque <- cuatro_fechas[cuatro_fechas$cobertura == "Bosque ribereño", ]
pastizal <- cuatro_fechas[cuatro_fechas$cobertura == "Pastizal", ]

forestacion <- forestacion[order(forestacion$fecha), ]
bosque <- bosque[order(bosque$fecha), ]
pastizal <- pastizal[order(pastizal$fecha), ]

matriz_eta <- rbind(
  "Forestación" = forestacion$ETa_media_mm_dia,
  "Bosque ribereño" = bosque$ETa_media_mm_dia,
  "Pastizal" = pastizal$ETa_media_mm_dia
)

matriz_ndvi <- rbind(
  "Forestación" = forestacion$NDVI_media,
  "Bosque ribereño" = bosque$NDVI_media,
  "Pastizal" = pastizal$NDVI_media
)

matriz_lst <- rbind(
  "Forestación" = forestacion$LST_media_C,
  "Bosque ribereño" = bosque$LST_media_C,
  "Pastizal" = pastizal$LST_media_C
)

colnames(matriz_eta) <- etiquetas
colnames(matriz_ndvi) <- etiquetas
colnames(matriz_lst) <- etiquetas

colores_cobertura <- c("#77B82A", "#385723", "#D9A21B")

# GRÁFICO 10: medias por cobertura para las cuatro escenas.
par(mfrow = c(1, 3), mar = c(8, 4, 3, 1))
barplot(
  matriz_eta,
  beside = TRUE,
  col = colores_cobertura,
  las = 2,
  ylab = "ETa media (mm/día)",
  main = "Evapotranspiración"
)
barplot(
  matriz_ndvi,
  beside = TRUE,
  col = colores_cobertura,
  las = 2,
  ylab = "NDVI medio",
  main = "Vigor vegetal"
)
barplot(
  matriz_lst,
  beside = TRUE,
  col = colores_cobertura,
  las = 2,
  ylab = "Temperatura superficial (°C)",
  main = "Estado térmico"
)
par(mfrow = c(1, 1))

legend(
  "bottom",
  inset = c(0.0, -0.35),
  legend = rownames(matriz_eta),
  fill = colores_cobertura,
  horiz = TRUE,
  bty = "n",
  cex = 0.65,
  xpd = NA
)

# PARA DISCUTIR
# ¿La cobertura con mayor NDVI también tiene siempre mayor ETa? Compare la
# respuesta con LST y recuerde que las cuatro escenas son muestras puntuales.


# 12. ANÁLISIS TEMPORAL POSTERIOR: 2022-2024 ------------------------------

# Las cuatro imágenes permiten una comparación espacial clara, pero no describen
# toda la variabilidad del período. La tabla compacta resume 34 fechas aceptadas.

serie_forestacion <- serie_temporal[
  serie_temporal$cobertura == "Forestación",
]
serie_bosque <- serie_temporal[
  serie_temporal$cobertura == "Bosque ribereño",
]
serie_pastizal <- serie_temporal[
  serie_temporal$cobertura == "Pastizal",
]

serie_forestacion <- serie_forestacion[order(serie_forestacion$fecha), ]
serie_bosque <- serie_bosque[order(serie_bosque$fecha), ]
serie_pastizal <- serie_pastizal[order(serie_pastizal$fecha), ]

# GRÁFICO 11: serie temporal de ETa.
plot(
  serie_forestacion$fecha,
  serie_forestacion$ETa_media_mm_dia,
  type = "o",
  pch = 16,
  col = colores_cobertura[1],
  ylim = c(0, 7),
  xlab = "Fecha",
  ylab = "ETa media (mm/día)",
  main = "Serie temporal de evapotranspiración actual"
)
lines(
  serie_bosque$fecha,
  serie_bosque$ETa_media_mm_dia,
  type = "o",
  pch = 16,
  col = colores_cobertura[2]
)
lines(
  serie_pastizal$fecha,
  serie_pastizal$ETa_media_mm_dia,
  type = "o",
  pch = 16,
  col = colores_cobertura[3]
)
legend(
  "topright",
  legend = c("Forestación", "Bosque ribereño", "Pastizal"),
  col = colores_cobertura,
  lwd = 2,
  pch = 16,
  bty = "n",
  cex = 0.85
)

# GRÁFICO 12: serie temporal de NDVI.
plot(
  serie_forestacion$fecha,
  serie_forestacion$NDVI_media,
  type = "o",
  pch = 16,
  col = colores_cobertura[1],
  ylim = c(0.3, 0.9),
  xlab = "Fecha",
  ylab = "NDVI medio",
  main = "Serie temporal de vigor vegetal"
)
lines(
  serie_bosque$fecha,
  serie_bosque$NDVI_media,
  type = "o",
  pch = 16,
  col = colores_cobertura[2]
)
lines(
  serie_pastizal$fecha,
  serie_pastizal$NDVI_media,
  type = "o",
  pch = 16,
  col = colores_cobertura[3]
)
legend(
  "bottomright",
  legend = c("Forestación", "Bosque ribereño", "Pastizal"),
  col = colores_cobertura,
  lwd = 2,
  pch = 16,
  bty = "n",
  cex = 0.85
)

# GRÁFICO 13: serie temporal de temperatura superficial.
rango_temperatura <- range(serie_temporal$LST_media_C, na.rm = TRUE)

plot(
  serie_forestacion$fecha,
  serie_forestacion$LST_media_C,
  type = "o",
  pch = 16,
  col = colores_cobertura[1],
  ylim = rango_temperatura,
  xlab = "Fecha",
  ylab = "Temperatura superficial media (°C)",
  main = "Serie temporal de temperatura superficial"
)
lines(
  serie_bosque$fecha,
  serie_bosque$LST_media_C,
  type = "o",
  pch = 16,
  col = colores_cobertura[2]
)
lines(
  serie_pastizal$fecha,
  serie_pastizal$LST_media_C,
  type = "o",
  pch = 16,
  col = colores_cobertura[3]
)
legend(
  "bottomleft",
  legend = c("Forestación", "Bosque ribereño", "Pastizal"),
  col = colores_cobertura,
  lwd = 2,
  pch = 16,
  bty = "n",
  cex = 0.65
)


# 13. CIERRE ---------------------------------------------------------------

cat("\nPreguntas finales:\n")
cat("1. ¿Por qué la vegetación absorbe rojo y refleja NIR?\n")
cat("2. ¿Qué representa el albedo?\n")
cat("3. ¿En qué se diferencian LST y temperatura del aire?\n")
cat("4. ¿Cómo se combinan NDVI, albedo, LST y ET0 para estimar ETa?\n")
cat("5. ¿Qué diferencias aparecen entre verano e invierno de 2023?\n")
cat("6. ¿Se repite el mismo patrón en 2024?\n")
cat("7. ¿Qué cambia al utilizar otra parametrización?\n")
cat("8. ¿Cuatro escenas representan adecuadamente las 34 fechas?\n")
cat("9. ¿Cuál es la conclusión principal y qué limitación tiene?\n")
cat("\nVersión para Moodle: 04_ACTIVIDAD/PREGUNTAS_MOODLE.md\n")

# El script termina aquí. Los gráficos aparecen en el panel Plots de RStudio.
# Para conservar uno, use Export > Save as Image después de interpretarlo.
