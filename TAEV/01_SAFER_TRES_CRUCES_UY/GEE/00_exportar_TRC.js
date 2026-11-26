// ============================================================================
// PRÁCTICA SAFER — CUENCA DEL RÍO TRES CRUCES, URUGUAY
// Exportación de las cuatro escenas estacionales Landsat 8/9 (TOA)
// ============================================================================
// Este script reconstruye los cuatro GeoTIFF que el taller necesita en
// 01_DATOS/01_LANDSAT_ESTACIONAL/. Cada archivo pesa cerca de 107 MB, por lo
// que NO puede descargarse con getDownloadURL: se exporta a su propio Google
// Drive mediante tareas.
//
// PASOS
// -----
// 1. Suba la capa cuenca_TRC del archivo 01_DATOS/03_VECTOR/
//    datos_base_TRC_INIA.gpkg como asset de Earth Engine.
//    En Code Editor: pestaña Assets > NEW > Shape files / Table upload.
//    (Si su archivo es .gpkg, expórtelo antes a .shp o .geojson desde QGIS.)
// 2. Escriba la ruta del asset en RUTA_ASSET_CUENCA, más abajo.
//    Alternativa sin asset: deje RUTA_ASSET_CUENCA vacío y complete el
//    rectángulo de RESPALDO_BBOX.
// 3. Pegue todo el archivo en https://code.earthengine.google.com/ y pulse Run.
// 4. Abra la pestaña Tasks y pulse RUN en las cuatro tareas.
// 5. Cuando terminen, descargue los cuatro GeoTIFF desde su Google Drive y
//    guárdelos en 01_DATOS/01_LANDSAT_ESTACIONAL/ SIN cambiar sus nombres.
//
// IMPORTANTE SOBRE LAS COLECCIONES
// --------------------------------
// Se usan las colecciones TOA, no las Nivel 2, porque el script en R espera:
//   - B1 a B7 como reflectancias en el tope de la atmósfera;
//   - B10 y B11 como temperaturas de brillo en KELVIN.
// No se aplica ningún factor de escala ni conversión: las bandas se exportan
// tal como las entrega la colección. Cambiar a T1_L2 rompería los cálculos de
// albedo y de temperatura del taller.
//
// Las fechas y los nombres de archivo siguen 01_DATOS/manifiesto_escenas.csv.
// ============================================================================


// ----------------------------------------------------------------------------
// 1. ÁREA DE INTERÉS
// ----------------------------------------------------------------------------

// Ruta del asset con el polígono de la cuenca. Ejemplo:
// 'projects/mi-proyecto/assets/cuenca_TRC'
var RUTA_ASSET_CUENCA = '';

// Rectángulo de respaldo, usado solamente si RUTA_ASSET_CUENCA está vacío.
// Orden: [oeste, sur, este, norte] en grados decimales.
// Para obtener estos valores desde R:
//   library(terra); ext(vect("datos_base_TRC_INIA.gpkg", layer = "cuenca_TRC"))
var RESPALDO_BBOX = [-56.10, -31.95, -55.55, -31.50];

var cuenca;
var aoi;

if (RUTA_ASSET_CUENCA !== '') {
  cuenca = ee.FeatureCollection(RUTA_ASSET_CUENCA);
  aoi = cuenca.geometry().bounds();
} else {
  print(
    'AVISO: no se indicó un asset de cuenca. Se usa RESPALDO_BBOX. ' +
    'Verifique que el rectángulo cubra toda la cuenca antes de exportar.'
  );
  aoi = ee.Geometry.Rectangle(RESPALDO_BBOX);
}

// La cuenca del río Tres Cruces se encuentra en UTM 21 Sur, el mismo sistema
// que el script en R utiliza al proyectar sus resultados.
var crsSalida = 'EPSG:32721';

// Las nueve bandas que el taller espera, en este orden exacto.
var BANDAS = ['B1', 'B2', 'B3', 'B4', 'B5', 'B6', 'B7', 'B10', 'B11'];


// ----------------------------------------------------------------------------
// 2. LAS CUATRO ESCENAS DEL MANIFIESTO
// ----------------------------------------------------------------------------
var escenas = [
  {
    archivo: 'L9_2023-02-12_verano',
    coleccion: 'LANDSAT/LC09/C02/T1_TOA',
    fecha: '2023-02-12'
  },
  {
    archivo: 'L8_2023-06-12_invierno',
    coleccion: 'LANDSAT/LC08/C02/T1_TOA',
    fecha: '2023-06-12'
  },
  {
    archivo: 'L8_2024-02-23_verano',
    coleccion: 'LANDSAT/LC08/C02/T1_TOA',
    fecha: '2024-02-23'
  },
  {
    archivo: 'L9_2024-07-24_invierno',
    coleccion: 'LANDSAT/LC09/C02/T1_TOA',
    fecha: '2024-07-24'
  }
];


// ----------------------------------------------------------------------------
// 3. SELECCIONAR Y EXPORTAR CADA ESCENA
// ----------------------------------------------------------------------------

// La fecha final no se incluye en filterDate, por eso se avanza un día.
function diaSiguiente(fecha) {
  return ee.Date(fecha).advance(1, 'day');
}

escenas.forEach(function (escena) {
  var coleccion = ee.ImageCollection(escena.coleccion)
    .filterBounds(aoi)
    .filterDate(escena.fecha, diaSiguiente(escena.fecha))
    .sort('CLOUD_COVER');

  // Si una fecha devuelve más de una escena, se conserva la menos nubosa.
  var imagen = ee.Image(coleccion.first()).select(BANDAS).clip(aoi);

  print('Escena ' + escena.archivo + ' — imágenes encontradas:',
        coleccion.size());

  Export.image.toDrive({
    image: imagen,
    description: escena.archivo,
    fileNamePrefix: escena.archivo,
    folder: 'SAFER_TRC_LANDSAT',
    region: aoi,
    scale: 30,
    crs: crsSalida,
    maxPixels: 1e13,
    fileFormat: 'GeoTIFF'
  });
});


// ----------------------------------------------------------------------------
// 4. COMPROBACIÓN ANTES DE EXPORTAR
// ----------------------------------------------------------------------------
// Revise en la Console que las cuatro escenas devuelvan al menos una imagen.
// Un cero indica que la fecha, el área o la colección no coinciden: corrija
// antes de lanzar las tareas.
//
// La capa siguiente permite confirmar visualmente el área antes de exportar.
Map.centerObject(aoi, 10);
Map.addLayer(aoi, {color: 'red'}, 'Área de exportación');

print('Si las cuatro escenas muestran al menos una imagen, abra la pestaña ' +
      'Tasks y ejecute las cuatro tareas.');
