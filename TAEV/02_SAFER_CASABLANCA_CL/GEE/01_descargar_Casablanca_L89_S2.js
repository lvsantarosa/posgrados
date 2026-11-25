// ============================================================================
// PRÁCTICA SAFER — CASABLANCA, CHILE
// Descarga de imágenes Landsat 8/9 y Sentinel-2 para el 04-12-2023
// ============================================================================
// 1. Pegue todo el archivo en https://code.earthengine.google.com/
// 2. Pulse Run.
// 3. Espere a que aparezcan dos enlaces en la pestaña Console.
// 4. Pulse el enlace LANDSAT y descargue el archivo ZIP.
// 5. Pulse el enlace SENTINEL-2 y descargue el segundo archivo ZIP.
// 6. Descomprima los dos ZIP.
// 7. Guarde los GeoTIFF en 01_DATOS/03_IMAGENES/ sin cambiar sus nombres.
//
// El script no crea paneles ni agrega capas al mapa. Su única finalidad es
// preparar los datos y generar dos enlaces de descarga directa en la Console.
// Sentinel-2 NO posee banda térmica. El cálculo híbrido se hará después en R.
// Esta práctica no usa ERA5 ni SMAP.
// ============================================================================

// ----------------------------------------------------------------------------
// 1. ÁREA Y FECHA
// ----------------------------------------------------------------------------
var torre = ee.Geometry.Point([-71.354548, -33.237398]);
var aoi = torre.buffer(2000).bounds();

// La fecha final no se incluye en filterDate. Por eso se usa el día siguiente.
var fechaInicial = '2023-12-04';
var fechaFinal = '2023-12-05';

// Casablanca se encuentra en UTM 19 Sur.
var crsSalida = 'EPSG:32719';

// ----------------------------------------------------------------------------
// 2. PREPARAR LANDSAT 8/9
// ----------------------------------------------------------------------------
function prepararLandsat(imagen) {
  // QA_PIXEL identifica nubes, sombras, nieve y otros píxeles no válidos.
  var qa = imagen.select('QA_PIXEL');

  var mascara = qa.bitwiseAnd(1 << 0).eq(0)
    .and(qa.bitwiseAnd(1 << 1).eq(0))
    .and(qa.bitwiseAnd(1 << 2).eq(0))
    .and(qa.bitwiseAnd(1 << 3).eq(0))
    .and(qa.bitwiseAnd(1 << 4).eq(0))
    .and(qa.bitwiseAnd(1 << 5).eq(0));

  // Factores de escala oficiales de Landsat Collection 2 Level 2.
  var opticas = imagen.select(
    ['SR_B2', 'SR_B3', 'SR_B4', 'SR_B5', 'SR_B6', 'SR_B7'],
    ['BLUE', 'GREEN', 'RED', 'NIR', 'SWIR1', 'SWIR2']
  ).multiply(0.0000275).add(-0.2);

  var ndvi = opticas.normalizedDifference(['NIR', 'RED']).rename('NDVI');

  var albedo = opticas.expression(
    '(0.254 * BLUE) + (0.149 * GREEN) + (0.147 * RED) + ' +
    '(0.311 * NIR) + (0.103 * SWIR1) + (0.036 * SWIR2)',
    {
      BLUE: opticas.select('BLUE'),
      GREEN: opticas.select('GREEN'),
      RED: opticas.select('RED'),
      NIR: opticas.select('NIR'),
      SWIR1: opticas.select('SWIR1'),
      SWIR2: opticas.select('SWIR2')
    }
  ).rename('ALBEDO');

  // Temperatura superficial: primero Kelvin y después grados Celsius.
  var lst = imagen.select('ST_B10')
    .multiply(0.00341802)
    .add(149.0)
    .subtract(273.15)
    .rename('LST_C');

  return opticas
    .addBands([ndvi, albedo, lst])
    .updateMask(mascara)
    .clip(aoi);
}

var coleccionLandsat = ee.ImageCollection('LANDSAT/LC08/C02/T1_L2')
  .merge(ee.ImageCollection('LANDSAT/LC09/C02/T1_L2'))
  .filterBounds(aoi)
  .filterDate(fechaInicial, fechaFinal)
  .sort('CLOUD_COVER');

// Se elige la imagen con menor nubosidad dentro de la fecha indicada.
var landsatOriginal = ee.Image(coleccionLandsat.first());
var landsat = prepararLandsat(landsatOriginal);

// ----------------------------------------------------------------------------
// 3. PREPARAR SENTINEL-2
// ----------------------------------------------------------------------------
function prepararSentinel(imagen) {
  // SCL es la clasificación de escena de Sentinel-2.
  var scl = imagen.select('SCL');

  // Se eliminan sombra, nubes, cirros y nieve/hielo.
  var mascara = scl.neq(3)
    .and(scl.neq(8))
    .and(scl.neq(9))
    .and(scl.neq(10))
    .and(scl.neq(11));

  var opticas = imagen.select(
    ['B2', 'B3', 'B4', 'B8', 'B11', 'B12'],
    ['BLUE', 'GREEN', 'RED', 'NIR', 'SWIR1', 'SWIR2']
  ).divide(10000);

  var ndvi = opticas.normalizedDifference(['NIR', 'RED']).rename('NDVI');

  return opticas
    .addBands(ndvi)
    .updateMask(mascara)
    .clip(aoi);
}

var coleccionSentinel = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
  .filterBounds(aoi)
  .filterDate(fechaInicial, fechaFinal)
  .sort('CLOUDY_PIXEL_PERCENTAGE');

// Se elige la imagen con menor nubosidad dentro de la fecha indicada.
var sentinelOriginal = ee.Image(coleccionSentinel.first());
var sentinel = prepararSentinel(sentinelOriginal);

// ----------------------------------------------------------------------------
// 4. COMPROBACIÓN SENCILLA EN LA CONSOLA
// ----------------------------------------------------------------------------
// Después de pulsar Run, estos mensajes aparecen en la pestaña Console.
print('Cantidad de imágenes Landsat encontradas:', coleccionLandsat.size());
print('Imagen Landsat seleccionada:', landsatOriginal);
print('Cantidad de imágenes Sentinel-2 encontradas:', coleccionSentinel.size());
print('Imagen Sentinel-2 seleccionada:', sentinelOriginal);

// ----------------------------------------------------------------------------
// 5. GENERAR LOS DOS ENLACES DE DESCARGA DIRECTA
// ----------------------------------------------------------------------------
// getDownloadURL es apropiado para recortes pequeños como el de esta práctica.
// No crea tareas en Tasks ni utiliza Google Drive. Cada ZIP contendrá un único
// GeoTIFF multibanda.

var enlaceLandsat = landsat.getDownloadURL({
  name: 'LANDSAT89_CASABLANCA_20231204',
  region: aoi,
  scale: 30,
  crs: crsSalida,
  format: 'ZIPPED_GEO_TIFF',
  filePerBand: false
});

var enlaceSentinel = sentinel.getDownloadURL({
  name: 'SENTINEL2_CASABLANCA_20231204',
  region: aoi,
  scale: 10,
  crs: crsSalida,
  format: 'ZIPPED_GEO_TIFF',
  filePerBand: false
});

print('1. DESCARGAR LANDSAT 8/9:', enlaceLandsat);
print('2. DESCARGAR SENTINEL-2:', enlaceSentinel);
print('Descomprima los ZIP y conserve los nombres originales de los GeoTIFF.');
