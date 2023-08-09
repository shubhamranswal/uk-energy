import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

class TestMap extends StatefulWidget {
  const TestMap({super.key});

  @override
  State<TestMap> createState() => _TestMapState();
}

class _TestMapState extends State<TestMap> {

  @override
  Widget build(BuildContext context) {

    List<Marker> points = [];

    List<double> latitudes = [30.22555, 30.18092, 29.10461, 29.54198, 30.22177, 30.19089, 30.00466, 30.051, 29.54389, 30.24482, 30.09073, 29.54403, 29.42354, 29.54396, 30.09046, 29.47389, 30.33377, 29.54287, 30.40246, 29.54278, 30.1711, 30.05158, 29.5426, 30.092, 30.34049, 30.33598, 30.3359, 30.09181, 30.37004, 30.19452, 30.2334, 30.00466, 30.00466, 29.55356, 30.01383, 30.40268, 29.54135, 30.40245, 30.19448, 29.54194, 30.19419, 29.18259, 29.18509, 29.54314, 29.12359, 30.25028, 29.55371, 30.31403, 29.54377, 29.55413, 29.54361, 30.33452, 30.25335, 29.54393, 29.55386, 29.55431, 30.19071, 30.19086, 30.19096, 30.25561, 30.11142, 29.58341, 30.35014, 30.42278, 29.58333, 30.22555, 29.40132, 29.40104, 29.40061, 29.40083, 30.03471, 29.39555, 29.42061, 29.47291, 29.40207, 30.11422, 30.37066, 29.52559, 30.29113, 29.43377, 30.22555, 30.22555, 30.37035, 29.54387, 29.54351, 29.54371, 29.54399, 30.22592, 30.22271, 29.53563, 29.54348, 30.01384, 29.18259, 30.12127, 30.40053, 29.54322, 30.05103, 29.54317, 30.09182, 29.23275, 30.19091, 29.54568, 30.09248, 30.28416, 30.09214, 29.24155, 30.32182, 30.32183, 29.54324, 30.18229, 29.53556, 29.17442, 30.17249, 29.54256, 29.54504, 30.09236, 30.19447, 29.5424, 29.53483, 29.18238, 29.54514, 29.54218, 30.12141, 29.18511, 30.36415, 30.36407, 30.32513, 30.17242, 29.53492, 29.54499, 29.59443, 30.041911, 30.22447, 29.53524, 29.59441, 29.54517, 30.05172, 29.12573, 30.40054, 30.40041, 29.54151, 30.40078, 29.54114, 30.18199, 30.18091, 29.54187, 29.54131, 30.34055, 29.54102, 29.54098, 29.54046, 30.33598, 30.34302, 30.34302, 30.34305, 29.39099, 29.39093, 29.54184, 30.20555, 30.01164, 29.43114, 30.22273, 30.24129, 29.28332, 30.27054];
    List<double> longitudes = [79.19587, 78.35257, 79.27336, 78.44449, 77.59431, 78.30521, 78.41097, 78.4823, 78.44439, 77.57022, 78.41499, 78.44427, 79.28516, 78.44368, 78.42331, 78.32493, 78.30011, 78.44303, 78.22425, 78.44307, 79.27097, 78.48382, 78.44395, 78.43198, 77.59442, 77.59512, 77.59405, 78.43234, 78.0536, 78.30152, 78.21058, 78.41097, 78.41097, 78.42592, 78.34455, 78.22547, 78.44501, 78.22494, 78.3015, 78.44436, 78.31191, 79.11081, 79.11504, 78.44372, 79.27547, 78.37096, 78.4305, 78.22171, 78.44302, 78.43103, 78.44231, 78.00571, 77.53212, 78.44432, 78.43018, 78.42598, 78.30448, 78.30485, 78.30469, 77.58401, 78.30091, 79.02535, 78.18509, 77.47326, 79.02413, 79.19587, 79.38036, 79.38311, 79.38072, 79.38003, 78.38544, 79.38049, 79.28138, 79.15486, 79.38223, 78.43145, 77.53171, 79.11414, 78.25305, 79.12108, 79.19587, 79.19587, 77.53107, 78.44171, 78.44224, 78.44284, 78.44383, 78.32354, 78.22255, 79.15307, 78.44455, 78.34454, 79.11087, 78.48361, 78.16554, 78.44303, 78.48224, 78.44377, 78.43231, 79.17019, 78.30517, 79.13091, 78.43228, 78.23038, 78.43231, 78.18256, 78.21007, 78.21031, 78.44377, 79.31111, 79.15483, 79.11318, 78.37242, 78.44373, 79.13019, 78.43205, 78.30154, 78.44492, 79.15375, 78.11068, 78.44288, 78.44341, 78.48355, 79.11507, 78.17182, 78.17179, 78.30038, 78.37287, 79.15363, 79.12586, 78.39562, 78.21554, 79.18514, 79.15389, 78.39565, 79.13069, 78.48353, 79.27179, 78.16567, 78.16557, 78.44361, 78.16388, 78.44445, 75.35033, 78.35258, 78.44261, 78.44269, 77.59429, 78.44311, 78.44267, 78.44301, 77.59512, 78.01061, 78.01061, 78.01009, 79.43553, 79.43553, 78.44466, 78.22035, 78.30121, 79.29348, 78.25434, 78.32024, 79.02481, 77.55593];

    if (latitudes.length == longitudes.length){
      for (int i = 0; i < latitudes.length; i++){
        Marker marker = Marker(
          point: LatLng(latitudes[i], longitudes[i]),
          width: 80,
          height: 80,
          builder: (context) => Icon(Icons.location_on, size: 25, color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),),
        );
        points.add(marker);
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Test Map: U-SAC'),
        backgroundColor: Colors.blue[100],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue[200],
              onPressed: (){
                showDialog(context: context, builder: (context){
                  return Stack(
                    children: [
                      Positioned(
                        top: (MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + kToolbarHeight))  / 3,
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 2),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + kToolbarHeight),
                            color: Colors.blue[100],
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Close')),
                                    const Spacer(),
                                    const Text('Select Layers', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.black, decoration: TextDecoration.none)),
                                    const Spacer(),
                                    TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Apply'))
                                  ],
                                ),
                              ],
                            ),
                          ),),
                      )
                    ],
                  );
                });
              },
              child: const Icon(Icons.menu),
            ),
      body: FlutterMap(
        options: MapOptions(
          onMapReady: ()=>EasyLoading.dismiss(),
          bounds: LatLngBounds(const LatLng(31.75, 77.25), const LatLng(31.75, 81.25)),
          center: const LatLng(30.35, 79.4),
          zoom: kIsWeb ? 5 : 15,
        ),
        nonRotatedChildren: [
          MarkerLayer(
            markers: points,
          ),
        ],
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
        ],
      ),
    );
  }
}
