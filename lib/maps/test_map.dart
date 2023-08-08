import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TestMap extends StatefulWidget {
  const TestMap({super.key});

  @override
  State<TestMap> createState() => _TestMapState();
}

class _TestMapState extends State<TestMap> {

  @override
  Widget build(BuildContext context) {

    List<Marker> points = [];
    // List<Polyline> lines = [];

    List<double> latitudes = [30.3632, 29, 31, 30.3421, 30.3522, 30.3535, 31.3645, 30.3925, 30.3729, 30.3037];
    List<double> longitudes = [79, 80, 79, 78.5869, 80, 80, 78.8082, 78.6970, 80, 78.4085];

    if (latitudes.length == longitudes.length){
      for (int i = 0; i < latitudes.length; i++){
        Marker marker = Marker(
          point: LatLng(latitudes[i], longitudes[i]),
          width: 80,
          height: 80,
          builder: (context) => const Icon(Icons.location_on, size: 50,),
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
          PolylineLayer(
            polylines: [
              Polyline(
                points: [
                  const LatLng(31.00, 79),
                  const LatLng(30.00, 78.6),
                  const LatLng(29, 80),
                ],
                strokeWidth: 4,
                color: Colors.purple,
              ),
              Polyline(
                points: [
                  const LatLng(29.5, 79),
                  const LatLng(30.00, 80.4),
                  const LatLng(31, 78.6),
                  const LatLng(30.00, 79),
                ],
                strokeWidth: 4,
                color: Colors.red,
              ),
              Polyline(
                points: [
                  const LatLng(31.00, 78.5),
                  const LatLng(30.00, 79),
                  const LatLng(29, 80),
                  const LatLng(30, 80.5),
                ],
                strokeWidth: 4,
                color: Colors.green,
              ),
            ],
          )
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
