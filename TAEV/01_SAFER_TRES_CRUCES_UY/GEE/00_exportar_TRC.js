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
// 1. Pegue todo el archivo en https://code.earthengine.google.com/ y pulse Run.
// 2. Compruebe en el mapa que el polígono rojo corresponde a la cuenca y que
//    la Console informa al menos una imagen por escena.
// 3. Abra la pestaña Tasks y pulse RUN en las cuatro tareas.
// 4. Cuando terminen, descargue los cuatro GeoTIFF desde la carpeta
//    SAFER_TRC_LANDSAT de su Google Drive y guárdelos en
//    01_DATOS/01_LANDSAT_ESTACIONAL/ SIN cambiar sus nombres.
//
// No hace falta subir ningún asset ni disponer de datos previos: el límite de
// la cuenca viene incluido en este archivo.
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
// Límite de la cuenca del río Tres Cruces, tomado de la capa cuenca_TRC del
// archivo 01_DATOS/03_VECTOR/datos_base_TRC_INIA.gpkg (EPSG:4326) y
// simplificado a una tolerancia de unos 200 m para mantener este archivo
// legible. La simplificación afecta solo al encuadre de la exportación: el
// recorte fino con el polígono completo lo realiza después el script en R.
var CUENCA_TRC = ee.Geometry.Polygon([[
  [-55.79675, -31.58996], [-55.77777, -31.59059], [-55.77675, -31.59546],
  [-55.77200, -31.59622], [-55.76810, -31.60430], [-55.77462, -31.61330],
  [-55.76888, -31.61730], [-55.76977, -31.62137], [-55.76020, -31.62777],
  [-55.75917, -31.63345], [-55.74967, -31.63417], [-55.74571, -31.64631],
  [-55.74939, -31.65527], [-55.74169, -31.66251], [-55.73504, -31.66325],
  [-55.73481, -31.68030], [-55.73090, -31.68838], [-55.72233, -31.68992],
  [-55.72034, -31.69639], [-55.73269, -31.69652], [-55.73263, -31.70058],
  [-55.73831, -31.70226], [-55.74116, -31.70229], [-55.74408, -31.69663],
  [-55.74787, -31.69748], [-55.74687, -31.70153], [-55.74972, -31.70156],
  [-55.75153, -31.70807], [-55.75628, -31.70812], [-55.75713, -31.71543],
  [-55.76552, -31.72769], [-55.78450, -31.72950], [-55.78540, -31.73276],
  [-55.79397, -31.73203], [-55.79768, -31.73856], [-55.81757, -31.74361],
  [-55.81754, -31.74605], [-55.82420, -31.74530], [-55.83173, -31.75105],
  [-55.83470, -31.74215], [-55.84517, -31.74062], [-55.84905, -31.73416],
  [-55.86043, -31.73588], [-55.86240, -31.73022], [-55.87377, -31.73276],
  [-55.88047, -31.72875], [-55.88055, -31.72226], [-55.89393, -31.71588],
  [-55.89399, -31.71101], [-55.91492, -31.70794], [-55.92356, -31.69990],
  [-55.92469, -31.68448], [-55.94281, -31.67814], [-55.94575, -31.67004],
  [-55.95338, -31.66685], [-55.95714, -31.67013], [-55.95720, -31.66526],
  [-55.96577, -31.66290], [-55.96677, -31.65803], [-55.97250, -31.65483],
  [-55.98384, -31.65979], [-55.99146, -31.65823], [-55.99436, -31.65338],
  [-56.00196, -31.65263], [-56.00111, -31.64288], [-56.01060, -31.64376],
  [-56.01823, -31.63976], [-56.02119, -31.62923], [-56.03259, -31.62851],
  [-56.03931, -31.62125], [-56.05455, -31.61568], [-56.05843, -31.60759],
  [-56.06792, -31.60766], [-56.06705, -31.59953], [-56.05953, -31.59217],
  [-56.08991, -31.59076], [-56.09284, -31.58185], [-56.10526, -31.57301],
  [-56.10248, -31.56568], [-56.12055, -31.56093], [-56.11776, -31.55442],
  [-56.14245, -31.55215], [-56.14256, -31.53997], [-56.15871, -31.53602],
  [-56.17588, -31.52476], [-56.18631, -31.52483], [-56.18731, -31.51915],
  [-56.20247, -31.51925], [-56.20546, -31.50303], [-56.20074, -31.50056],
  [-56.19983, -31.49568], [-56.21124, -31.49169], [-56.20658, -31.48273],
  [-56.21134, -31.47951], [-56.21702, -31.48036], [-56.22087, -31.47308],
  [-56.22750, -31.47393], [-56.23701, -31.46993], [-56.23991, -31.46263],
  [-56.24370, -31.46185], [-56.24470, -31.45536], [-56.25230, -31.45296],
  [-56.25522, -31.44324], [-56.25901, -31.44326], [-56.25815, -31.43189],
  [-56.25534, -31.42862], [-56.24300, -31.43098], [-56.23641, -31.42607],
  [-56.23545, -31.42850], [-56.22882, -31.42846], [-56.22414, -31.42113],
  [-56.21753, -31.41946], [-56.21757, -31.41459], [-56.21098, -31.40968],
  [-56.21195, -31.40644], [-56.20725, -31.40235], [-56.20156, -31.40312],
  [-56.20171, -31.38607], [-56.19038, -31.38275], [-56.18948, -31.37706],
  [-56.18382, -31.37459], [-56.18197, -31.36971], [-56.17534, -31.36967],
  [-56.17351, -31.36316], [-56.17643, -31.35343], [-56.18024, -31.35102],
  [-56.18320, -31.33642], [-56.18606, -31.33482], [-56.18425, -31.32506],
  [-56.17198, -31.32092], [-56.17298, -31.31525], [-56.16265, -31.30706],
  [-56.15603, -31.30620], [-56.15513, -31.30132], [-56.14280, -31.30530],
  [-56.14372, -31.30775], [-56.13427, -31.30687], [-56.13235, -31.31011],
  [-56.12477, -31.31086], [-56.12567, -31.31574], [-56.11805, -31.32219],
  [-56.11704, -31.32868], [-56.11230, -31.32946], [-56.10844, -31.33755],
  [-56.10275, -31.33913], [-56.09795, -31.34560], [-56.09885, -31.35047],
  [-56.08740, -31.36095], [-56.08822, -31.37395], [-56.08056, -31.38283],
  [-56.07298, -31.38358], [-56.06528, -31.39652], [-56.06618, -31.40059],
  [-56.05953, -31.40297], [-56.04995, -31.41427], [-56.04428, -31.41260],
  [-56.03381, -31.41821], [-56.01864, -31.41972], [-56.02140, -31.42786],
  [-56.01663, -31.43107], [-56.00526, -31.43098], [-55.99004, -31.43736],
  [-55.99568, -31.44146], [-55.98994, -31.44710], [-55.98988, -31.45198],
  [-55.98133, -31.45434], [-55.97844, -31.45838], [-55.97933, -31.46407],
  [-55.96784, -31.47535], [-55.96311, -31.47450], [-55.96117, -31.47854],
  [-55.95073, -31.48008], [-55.94772, -31.49467], [-55.92959, -31.50508],
  [-55.93047, -31.51158], [-55.91324, -31.52605], [-55.91501, -31.53662],
  [-55.91212, -31.54066], [-55.89501, -31.54376], [-55.89686, -31.54783],
  [-55.89307, -31.54780], [-55.89296, -31.55754], [-55.86247, -31.56864],
  [-55.85861, -31.57429], [-55.85006, -31.57503], [-55.84812, -31.57826],
  [-55.82915, -31.57808], [-55.82351, -31.57397], [-55.81309, -31.57306],
  [-55.81208, -31.57793], [-55.80733, -31.57869], [-55.80633, -31.58274],
  [-55.79968, -31.58349], [-55.79675, -31.58996]
]]);

// Se exporta un rectángulo que cubre toda la cuenca, igual que las imágenes
// originales del taller. El script en R recorta con el polígono real.
//
// El margen de 500 m compensa la simplificación del polígono: sin él, el
// rectángulo podría quedar hasta unos 100 m corto en algún borde y el recorte
// posterior en R dejaría una franja sin datos.
var aoi = CUENCA_TRC.bounds().buffer(500).bounds();

// Estación INIA La Magnolia, para comprobar visualmente el encuadre.
var ESTACION_INIA = ee.Geometry.Point([-55.826666667, -31.708888889]);

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
// Las capas siguientes permiten confirmar el área antes de exportar.
Map.centerObject(CUENCA_TRC, 9);
Map.addLayer(CUENCA_TRC, {color: 'red'}, 'Cuenca del río Tres Cruces');
Map.addLayer(aoi, {color: 'orange'}, 'Rectángulo de exportación', false);
Map.addLayer(ESTACION_INIA, {color: 'blue'}, 'Estación INIA La Magnolia');

print('Si las cuatro escenas muestran al menos una imagen, abra la pestaña ' +
      'Tasks y ejecute las cuatro tareas.');
