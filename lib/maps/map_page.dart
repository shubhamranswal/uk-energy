import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usac_map_app/fontsize.dart';
import '../markers/small_hydro_power_projects.dart';
import '../utils/keyheads.dart';
import '../utils/layers.dart';
import '../utils/url_template_list.dart';

class MapPage extends StatefulWidget {
  final String title;
  final int keyHead;
  final List<double> longitudes;
  final List<double> latitudes;

  const MapPage(
      {super.key,
      required this.title,
      required this.keyHead,
      required this.longitudes,
      required this.latitudes});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool? isSmallHydroPowerPlantsVisible = false;

  bool? isRoadSelected = false;
  bool? isStandardSelected = true;
  bool? isTerrainSelected = false;
  bool? isAlteredRoadSelected = false;
  bool? isSatelliteSelected = false;
  bool? isHybridSelected = false;

  int? value = 1;

  @override
  Widget build(BuildContext context) {
    createMarkersForSmallHydroPowerProjects();

    final keyHeadValue = keyHeads[widget.keyHead];

    List<Marker> baseLayerPoints = [];

    List<double> latitudes = widget.latitudes;
    List<double> longitudes = widget.longitudes;

    if (latitudes.length == longitudes.length) {
      for (int i = 0; i < latitudes.length; i++) {
        Marker marker = Marker(
          point: LatLng(latitudes[i], longitudes[i]),
          width: 80,
          height: 80,
          builder: (context) => GestureDetector(
            child: Icon(
              Icons.location_on_outlined,
              size: 20,
              color: const Color(0xFFFF0000).withOpacity(1.0),
            ),
            onTap: () async {
              final key = "$keyHeadValue${latitudes[i]}____${longitudes[i]}";

              var result = await getData(key);
              var display = '';

              if (['solar_'].contains(keyHeadValue)) {
                for (var data in result) {
                  Map object = data as Map;
                  for (var key in object.keys) {
                    if (object[key].toString().isNotEmpty) {
                      display = "$display${key} - ${object[key]}\n";
                    }
                  }
                  display = "$display\n";
                }
              } else {
                for (var key in result.keys) {
                  if (result[key].toString().isNotEmpty) {
                    display = "$display$key - ${result[key]}\n";
                  }
                }
              }

              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  isDismissible: false,
                  enableDrag: false,
                  context: context,
                  builder: (context) {
                    return FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 20, top: 10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.black,
                                width: 2,
                                style: BorderStyle.solid)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Plant Details',
                                  style: TextStyle(
                                      fontSize: fontSizer(context) * 1.25),
                                ),
                                Spacer(),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.black,
                                    ))
                              ],
                            ),
                            Text(
                              display.toString().toUpperCase(),
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: fontSizer(context)),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
        );
        baseLayerPoints.add(marker);
      }
    }

    var smallPowerPlantsOptionVisiblity = widget.title == 'Power Generation';

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
          backgroundColor: Colors.blue[100],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[200],
          onPressed: () {
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                isDismissible: false,
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter mystate) {
                    return Container(
                        padding: const EdgeInsets.only(
                            left: 5, right: 15, bottom: 10, top: 10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.black,
                                width: 2,
                                style: BorderStyle.solid)),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Close')),
                                  const Spacer(),
                                  Text('Select Layers',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: fontSizer(context) * 1.15,
                                          color: Colors.black,
                                          decoration: TextDecoration.none)),
                                  const Spacer(),
                                  TextButton(
                                      onPressed: () {
                                        // Navigator.pop(context);
                                      },
                                      child: const Text(''))
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  for (int i = 0; i < layers.length; i++)
                                    ListTile(
                                      title: Text(
                                        layers[i],
                                      ),
                                      leading: Radio(
                                        value: i,
                                        groupValue: value,
                                        activeColor: const Color(0xFF6200EE),
                                        onChanged: (int? newValue) {
                                          mystate(() {
                                            value = newValue;
                                            switch (newValue) {
                                              case 0:
                                                isRoadSelected = true;
                                                isStandardSelected =
                                                    isTerrainSelected =
                                                        isAlteredRoadSelected =
                                                            isSatelliteSelected =
                                                                isHybridSelected =
                                                                    false;
                                                break;
                                              case 1:
                                                isStandardSelected = true;
                                                isRoadSelected =
                                                    isTerrainSelected =
                                                        isAlteredRoadSelected =
                                                            isSatelliteSelected =
                                                                isHybridSelected =
                                                                    false;
                                                break;
                                              case 2:
                                                isTerrainSelected = true;
                                                isRoadSelected =
                                                    isStandardSelected =
                                                        isAlteredRoadSelected =
                                                            isSatelliteSelected =
                                                                isHybridSelected =
                                                                    false;
                                                break;
                                              case 3:
                                                isAlteredRoadSelected = true;
                                                isRoadSelected =
                                                    isStandardSelected =
                                                        isTerrainSelected =
                                                            isSatelliteSelected =
                                                                isHybridSelected =
                                                                    false;
                                                break;
                                              case 4:
                                                isSatelliteSelected = true;
                                                isRoadSelected = isStandardSelected =
                                                    isTerrainSelected =
                                                        isAlteredRoadSelected =
                                                            isHybridSelected =
                                                                false;
                                                break;
                                              case 5:
                                                isHybridSelected = true;
                                                isRoadSelected = isStandardSelected =
                                                    isTerrainSelected =
                                                        isAlteredRoadSelected =
                                                            isSatelliteSelected =
                                                                false;
                                                break;
                                            }
                                          });
                                          setState(() {
                                            value = newValue;
                                            switch (newValue) {
                                              case 0:
                                                isRoadSelected = true;
                                                isStandardSelected =
                                                    isTerrainSelected =
                                                        isAlteredRoadSelected =
                                                            isSatelliteSelected =
                                                                isHybridSelected =
                                                                    false;
                                                break;
                                              case 1:
                                                isStandardSelected = true;
                                                isRoadSelected =
                                                    isTerrainSelected =
                                                        isAlteredRoadSelected =
                                                            isSatelliteSelected =
                                                                isHybridSelected =
                                                                    false;
                                                break;
                                              case 2:
                                                isTerrainSelected = true;
                                                isRoadSelected =
                                                    isStandardSelected =
                                                        isAlteredRoadSelected =
                                                            isSatelliteSelected =
                                                                isHybridSelected =
                                                                    false;
                                                break;
                                              case 3:
                                                isAlteredRoadSelected = true;
                                                isRoadSelected =
                                                    isStandardSelected =
                                                        isTerrainSelected =
                                                            isSatelliteSelected =
                                                                isHybridSelected =
                                                                    false;
                                                break;
                                              case 4:
                                                isSatelliteSelected = true;
                                                isRoadSelected = isStandardSelected =
                                                    isTerrainSelected =
                                                        isAlteredRoadSelected =
                                                            isHybridSelected =
                                                                false;
                                                break;
                                              case 5:
                                                isHybridSelected = true;
                                                isRoadSelected = isStandardSelected =
                                                    isTerrainSelected =
                                                        isAlteredRoadSelected =
                                                            isSatelliteSelected =
                                                                false;
                                                break;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              ),
                              Visibility(
                                visible: smallPowerPlantsOptionVisiblity,
                                child: Row(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          // Navigator.pop(context);
                                        },
                                        child: const Text('')),
                                    const Spacer(),
                                    Text('Sub Maps',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: fontSizer(context) * 1.15,
                                            color: Colors.black,
                                            decoration: TextDecoration.none)),
                                    const Spacer(),
                                    TextButton(
                                        onPressed: () {
                                          // Navigator.pop(context);
                                        },
                                        child: const Text(''))
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: smallPowerPlantsOptionVisiblity,
                                child: Column(
                                  children: [
                                    CheckboxListTile(
                                        title: Text(
                                            'Small Hydro Power Projects',
                                            style: TextStyle(
                                                fontSize: fontSizer(context))),
                                        value: isSmallHydroPowerPlantsVisible,
                                        onChanged: (bool? value) {
                                          mystate(() {
                                            isSmallHydroPowerPlantsVisible =
                                                value!;
                                          });
                                          setState(() {
                                            isSmallHydroPowerPlantsVisible =
                                                value!;
                                          });
                                        }),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ));
                  });
                });
          },
          child: const Icon(Icons.layers_outlined),
        ),
        body: Stack(
          children: [
            GestureDetector(
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  maxZoom: 18,
                  minZoom: 1,
                  interactiveFlags:
                      InteractiveFlag.doubleTapZoom | InteractiveFlag.drag,
                  onMapReady: () => EasyLoading.dismiss(),
                  center: currentCenter,
                  zoom: zoomLevel,
                ),
                nonRotatedChildren: [

                  if (widget.title == 'Power Transmission')
                    PolylineLayer(
                      polylines: [
                        //40
                        Polyline(
                          strokeWidth: 3,
                          points: [
                            const LatLng(30.125014, 78.156698),
                            const LatLng(29.926244, 78.720622),
                            const LatLng(30.251251, 79.215702)
                          ],
                          color: Colors.blue,
                        ),

                        //50
                        Polyline(
                          strokeWidth: 3,
                          points: [
                            const LatLng(29.366716, 79.54348),
                            const LatLng(29.673391, 79.491118)
                          ],
                          color: Colors.black,
                        ),

                        //60
                        Polyline(
                          strokeWidth: 3,
                          points: [
                            const LatLng(29.372137, 79.103674),
                            const LatLng(29.5816, 79.670017),
                            const LatLng(30.409586, 78.065982)
                          ],
                          color: Colors.green,
                        ),

                        //75
                        Polyline(
                          strokeWidth: 3,
                          points: [
                            const LatLng(30.226147, 78.783589),
                            const LatLng(30.341239, 78.382625)
                          ],
                          color: Colors.indigo,
                        ),

                        //80
                        Polyline(
                          strokeWidth: 3,
                          points: [
                            const LatLng(29.272678, 78.861455),
                            const LatLng(28.931137, 79.733284),
                            const LatLng(28.914753, 79.506691),
                            const LatLng(29.022623, 79.694114),
                            const LatLng(29.250033, 79.533595),
                            const LatLng(30.336158, 78.033881),
                            const LatLng(30.06941, 78.254154),
                            const LatLng(29.697701, 77.98813),
                            const LatLng(29.740303, 77.835999),
                            const LatLng(29.882361, 77.752347),
                            const LatLng(29.773081, 78.42801)
                          ],
                          color: Colors.blueGrey,
                        ),

                        //120
                        Polyline(
                          strokeWidth: 3,
                          points: [
                            const LatLng(29.192397, 78.99399),
                            const LatLng(29.191758, 79.12485),
                            const LatLng(30.289667, 77.99599),
                            const LatLng(29.925957, 78.087083),
                            const LatLng(29.969811, 78.167556),
                            const LatLng(29.919956, 77.796807)
                          ],
                          color: Colors.cyan,
                        ),
                      ],
                    ),

                  if (widget.title == 'Power Distribution')
                    PolylineLayer(
                      polylines: [
                        //
                        Polyline(
                          strokeWidth: 3,
                          points: [
                            const LatLng(30.374684, 79.433889),
                            const LatLng(30.437329, 79.394038),
                            const LatLng(30.394415, 79.306545),
                            const LatLng(29.584179, 79.669371),
                            const LatLng(30.387299, 79.385024),
                            const LatLng(30.251385, 79.215519),
                            const LatLng(30.514412, 79.294073),
                            const LatLng(29.668585, 77.866996),
                            const LatLng(29.822933, 78.066056)
                          ],
                          color: Colors.blue,
                        ),

                        //
                        Polyline(
                          strokeWidth: 3,
                          points: [
                            const LatLng(29.891383, 77.831556),
                            const LatLng(29.654347, 77.922038),
                            const LatLng(29.069174, 78.916402),
                            const LatLng(29.139562, 78.970661),
                            const LatLng(29.038593, 79.002217)
                          ],
                          color: Colors.black,
                        ),

                        //
                        Polyline(
                          strokeWidth: 3,
                          points: [
                            const LatLng(30.111498, 78.732916),
                            const LatLng(30.269702, 79.208202),
                            const LatLng(30.230827, 79.257742),
                            const LatLng(29.827219, 79.759747),
                            const LatLng(29.41192, 80.074039),
                            const LatLng(30.202022, 78.6982),
                            const LatLng(30.183862, 78.003901),
                            const LatLng(29.578156, 80.215134),
                            const LatLng(30.226, 78.784129),
                            const LatLng(29.581287, 79.670217),
                            const LatLng(29.673531, 79.491846),
                            const LatLng(29.211653, 79.464142),
                            const LatLng(29.272431, 78.862744),
                            const LatLng(28.920397, 80.019188),
                            const LatLng(29.925636, 78.087229),
                            const LatLng(30.456629, 77.73632),
                            const LatLng(30.40964, 78.065904),
                            const LatLng(30.336233, 78.038904),
                            const LatLng(30.456777, 77.736838),
                            const LatLng(30.435478, 77.666021),
                            const LatLng(30.06894, 78.254281),
                            const LatLng(29.491092, 78.765796),
                            const LatLng(29.973179, 78.218558),
                            const LatLng(29.830757, 79.770358),
                            const LatLng(29.366644, 79.543504),
                            const LatLng(29.25013, 79.533848),
                            const LatLng(29.372212, 79.103957),
                            const LatLng(29.192406, 78.993477),
                            const LatLng(29.19143, 79.124782),
                            const LatLng(28.965235, 79.41045),
                            const LatLng(29.022796, 79.695003),
                            const LatLng(28.914158, 79.506984),
                            const LatLng(29.96985, 78.168049),
                            const LatLng(29.919962, 77.795981),
                            const LatLng(30.47541, 77.615665),
                            const LatLng(29.177113, 78.867957),
                            const LatLng(28.82341, 79.511209),
                            const LatLng(28.837588, 79.778668),
                            const LatLng(28.695659, 79.950941),
                            const LatLng(30.289433, 77.99559),
                            const LatLng(30.428244, 77.623761),
                            const LatLng(30.124893, 78.157555),
                            const LatLng(29.773085, 78.428046),
                            const LatLng(29.926946, 78.720854),
                            const LatLng(28.931664, 79.732953),
                            const LatLng(29.740174, 77.835605),
                            const LatLng(29.697706, 77.987937),
                            const LatLng(29.915178, 77.729486),
                            const LatLng(29.592999, 78.115027)
                          ],
                          color: Colors.green,
                        ),

                        //
                        Polyline(
                          strokeWidth: 3,
                          points: [
                            const LatLng(30.258769, 78.505488),
                            const LatLng(30.252008, 78.733298),
                            const LatLng(30.098227, 79.254023),
                            const LatLng(29.580654, 79.250697),
                            const LatLng(29.537961, 79.880514),
                            const LatLng(29.959999, 80.030012),
                            const LatLng(30.044586, 79.894101),
                            const LatLng(29.743436, 80.046607),
                            const LatLng(29.722587, 79.93305),
                            const LatLng(29.958264, 80.59879),
                            const LatLng(29.5957, 79.336812),
                            const LatLng(28.979577, 79.822262),
                            const LatLng(28.945773, 79.627635),
                            const LatLng(29.727878, 78.070791),
                            const LatLng(29.408401, 80.083863),
                            const LatLng(29.370517, 80.012518),
                            const LatLng(29.409483, 79.868873),
                            const LatLng(29.453361, 80.069634),
                            const LatLng(29.167939, 80.136304),
                            const LatLng(29.329947, 80.100973),
                            const LatLng(28.938363, 79.490896),
                            const LatLng(30.760178, 78.617342),
                            const LatLng(30.727863, 78.432673),
                            const LatLng(30.904532, 78.342364),
                            const LatLng(30.675134, 78.355217),
                            const LatLng(30.803898, 78.191439),
                            const LatLng(31.021619, 78.042426),
                            const LatLng(30.879743, 78.072466),
                            const LatLng(30.655283, 78.308462),
                            const LatLng(30.764867, 78.454105),
                            const LatLng(30.799677, 78.631738),
                            const LatLng(30.829327, 78.432487),
                            const LatLng(30.496255, 78.164052),
                            const LatLng(30.571451, 78.004975),
                            const LatLng(30.147788, 78.284694),
                            const LatLng(30.132916, 78.325978),
                            const LatLng(30.341971, 78.50797),
                            const LatLng(30.496649, 78.49059),
                            const LatLng(30.383659, 78.545478),
                            const LatLng(30.119234, 78.302659),
                            const LatLng(30.126135, 78.28517),
                            const LatLng(30.334099, 78.769228),
                            const LatLng(30.277821, 78.538245),
                            const LatLng(30.39208, 78.093173),
                            const LatLng(30.387514, 78.129522),
                            const LatLng(30.448616, 78.07033),
                            const LatLng(30.456423, 78.100988),
                            const LatLng(30.458517, 78.069008),
                            const LatLng(30.571649, 77.972416),
                            const LatLng(30.733906, 78.067956),
                            const LatLng(30.349535, 78.061764),
                            const LatLng(30.335805, 78.035906),
                            const LatLng(30.326587, 78.047559),
                            const LatLng(30.326382, 78.02577),
                            const LatLng(30.321447, 78.04299),
                            const LatLng(30.324555, 78.002641),
                            const LatLng(30.315674, 78.02577),
                            const LatLng(30.281044, 78.031569),
                            const LatLng(30.302373, 78.093815),
                            const LatLng(30.299946, 78.102667),
                            const LatLng(30.283917, 77.992879),
                            const LatLng(30.302825, 78.014919),
                            const LatLng(30.279039, 77.989072),
                            const LatLng(30.307227, 78.051128),
                            const LatLng(30.330585, 78.077272),
                            const LatLng(30.335725, 78.09707),
                            const LatLng(30.472929, 77.774033),
                            const LatLng(30.445177, 77.86057),
                            const LatLng(30.434846, 77.748055),
                            const LatLng(30.388507, 77.808761),
                            const LatLng(30.616224, 77.871694),
                            const LatLng(30.686861, 77.874356),
                            const LatLng(30.819825, 77.861355),
                            const LatLng(30.943117, 77.849103),
                            const LatLng(30.12535, 78.155099),
                            const LatLng(30.197772, 78.155001),
                            const LatLng(30.194441, 78.123402),
                            const LatLng(30.226451, 78.212201),
                            const LatLng(30.073971, 78.28577),
                            const LatLng(30.106617, 78.281677),
                            const LatLng(30.104143, 78.295954),
                            const LatLng(30.114802, 78.280249),
                            const LatLng(30.104333, 78.246556),
                            const LatLng(30.035224, 78.212977),
                            const LatLng(30.003672, 78.191063),
                            const LatLng(30.303589, 77.910898),
                            const LatLng(30.364055, 77.848019),
                            const LatLng(30.361318, 77.846175),
                            const LatLng(30.37387, 77.858132),
                            const LatLng(30.345991, 78.009823),
                            const LatLng(30.347919, 78.015177),
                            const LatLng(30.17412, 78.125556),
                            const LatLng(30.192537, 78.163281),
                            const LatLng(30.079328, 78.283812),
                            const LatLng(30.065709, 78.258001),
                            const LatLng(29.74299, 78.486412),
                            const LatLng(29.790951, 78.411665),
                            const LatLng(29.77916, 78.445947),
                            const LatLng(29.755101, 78.490705),
                            const LatLng(29.751204, 78.516403),
                            const LatLng(30.295338, 78.627037),
                            const LatLng(29.756982, 78.537432),
                            const LatLng(29.806181, 78.608167),
                            const LatLng(29.929319, 79.099571),
                            const LatLng(30.117034, 78.925156),
                            const LatLng(30.024245, 78.69193),
                            const LatLng(29.895532, 79.023846),
                            const LatLng(29.922208, 78.709179),
                            const LatLng(29.917008, 78.928122),
                            const LatLng(29.961183, 78.834058),
                            const LatLng(29.749742, 79.010082),
                            const LatLng(29.771695, 78.87161),
                            const LatLng(29.921454, 78.473784),
                            const LatLng(29.868745, 78.67941),
                            const LatLng(29.964291, 78.594676),
                            const LatLng(30.070225, 78.772927),
                            const LatLng(30.087874, 78.421089),
                            const LatLng(30.157352, 78.60031),
                            const LatLng(30.22656, 78.678644),
                            const LatLng(30.230545, 78.823883),
                            const LatLng(30.223035, 78.785226),
                            const LatLng(30.220327, 78.748872),
                            const LatLng(30.153895, 78.763798),
                            const LatLng(30.118638, 78.801712),
                            const LatLng(30.145204, 78.694797),
                            const LatLng(29.710392, 78.524102),
                            const LatLng(29.810538, 78.532891),
                            const LatLng(29.831016, 78.517606),
                            const LatLng(30.262971, 78.884448),
                            const LatLng(29.816965, 78.486424),
                            const LatLng(30.128254, 79.389179),
                            const LatLng(30.06134, 79.576194),
                            const LatLng(30.041533, 79.285618),
                            const LatLng(30.203289, 79.196535),
                            const LatLng(30.275969, 79.166561),
                            const LatLng(30.360757, 79.183253),
                            const LatLng(30.262825, 79.452886),
                            const LatLng(30.33341, 79.320214),
                            const LatLng(30.563233, 79.550911),
                            const LatLng(30.634167, 79.54579),
                            const LatLng(30.401579, 79.312322),
                            const LatLng(30.294428, 78.983091),
                            const LatLng(30.387939, 78.901395),
                            const LatLng(30.477116, 79.113408),
                            const LatLng(30.354301, 78.970373),
                            const LatLng(30.390344, 79.023227),
                            const LatLng(30.524721, 79.080078),
                            const LatLng(29.753214, 79.424392),
                            const LatLng(29.720216, 79.476805),
                            const LatLng(29.616706, 79.411493),
                            const LatLng(29.662516, 79.455983),
                            const LatLng(29.643768, 79.442324),
                            const LatLng(29.554727, 79.481009),
                            const LatLng(29.865114, 79.240708),
                            const LatLng(29.813586, 79.281807),
                            const LatLng(29.658345, 79.21022),
                            const LatLng(29.824145, 79.164379),
                            const LatLng(29.702719, 79.264202),
                            const LatLng(29.732148, 79.202993),
                            const LatLng(29.610337, 79.666322),
                            const LatLng(29.594063, 79.63668),
                            const LatLng(29.596869, 79.669052),
                            const LatLng(29.788383, 79.601453),
                            const LatLng(29.628267, 79.626555),
                            const LatLng(29.513883, 79.750035),
                            const LatLng(29.640752, 79.782268),
                            const LatLng(29.696249, 79.830003),
                            const LatLng(29.830757, 79.770358),
                            const LatLng(29.753362, 79.737874),
                            const LatLng(29.844737, 79.593502),
                            const LatLng(29.924722, 79.61319),
                            const LatLng(29.839816, 79.916913),
                            const LatLng(29.937041, 79.895397),
                            const LatLng(29.937155, 79.935889),
                            const LatLng(29.910672, 80.094081),
                            const LatLng(29.793364, 80.264036),
                            const LatLng(29.834685, 80.523162),
                            const LatLng(29.833919, 80.145821),
                            const LatLng(29.903997, 80.163898),
                            const LatLng(29.75843, 80.358804),
                            const LatLng(30.067863, 80.231099),
                            const LatLng(30.085827, 80.258154),
                            const LatLng(29.577474, 80.209802),
                            const LatLng(29.684136, 80.271798),
                            const LatLng(29.574792, 80.236817),
                            const LatLng(29.512749, 80.13598),
                            const LatLng(29.589777, 80.297584),
                            const LatLng(29.652547, 80.042717),
                            const LatLng(29.239822, 80.204046),
                            const LatLng(29.367507, 79.54007),
                            const LatLng(29.34649, 79.565023),
                            const LatLng(29.329689, 79.729587),
                            const LatLng(29.392797, 79.444144),
                            const LatLng(29.451673, 79.570146),
                            const LatLng(29.386138, 79.481998),
                            const LatLng(29.37861, 79.524532),
                            const LatLng(29.43942, 79.64544),
                            const LatLng(29.483672, 79.476858),
                            const LatLng(29.554992, 79.335368),
                            const LatLng(29.133003, 79.508568),
                            const LatLng(29.073567, 79.5151),
                            const LatLng(29.293186, 79.544359),
                            const LatLng(29.201739, 79.55912),
                            const LatLng(29.392929, 79.12495),
                            const LatLng(29.370376, 79.100581),
                            const LatLng(29.307951, 79.192479),
                            const LatLng(29.41128, 79.313866),
                            const LatLng(29.283411, 79.349441),
                            const LatLng(29.183939, 79.487406),
                            const LatLng(29.193028, 79.514722),
                            const LatLng(29.266069, 79.35286),
                            const LatLng(29.235822, 79.480323),
                            const LatLng(29.143154, 79.471004),
                            const LatLng(29.012242, 79.408868),
                            const LatLng(29.00495, 79.40442),
                            const LatLng(29.015297, 79.415061),
                            const LatLng(28.993826, 79.429645),
                            const LatLng(29.003303, 79.42087),
                            const LatLng(28.987663, 79.402434),
                            const LatLng(29.202385, 78.921039),
                            const LatLng(29.279268, 78.789723),
                            const LatLng(29.195616, 79.07568),
                            const LatLng(29.210109, 78.971226),
                            const LatLng(29.180674, 79.009486),
                            const LatLng(29.186742, 79.118847),
                            const LatLng(29.09894, 79.167844),
                            const LatLng(29.043454, 79.230331),
                            const LatLng(29.133044, 79.120071),
                            const LatLng(29.031469, 79.276119),
                            const LatLng(28.978733, 79.40357),
                            const LatLng(28.987741, 79.349173),
                            const LatLng(28.977623, 79.355168),
                            const LatLng(29.035181, 79.235453),
                            const LatLng(28.962622, 79.410113),
                            const LatLng(28.934775, 79.703767),
                            const LatLng(28.865922, 79.607483),
                            const LatLng(28.939557, 79.821217),
                            const LatLng(29.029331, 79.688089),
                            const LatLng(28.981725, 79.653179),
                            const LatLng(28.984128, 79.64269),
                            const LatLng(29.04509, 79.687221),
                            const LatLng(28.998898, 79.632165),
                            const LatLng(29.012159, 79.512112),
                            const LatLng(28.914802, 79.511503),
                            const LatLng(28.893393, 79.53904),
                            const LatLng(29.233112, 78.963437),
                            const LatLng(29.29061, 78.828841),
                            const LatLng(29.331875, 78.870772),
                            const LatLng(29.280984, 78.943957),
                            const LatLng(29.218018, 78.953615),
                            const LatLng(29.340638, 78.967743),
                            const LatLng(28.918787, 79.980683),
                            const LatLng(28.927499, 79.964463),
                            const LatLng(28.832675, 79.898868),
                            const LatLng(29.160515, 78.927912),
                            const LatLng(29.07575, 79.278662),
                            const LatLng(29.061015, 79.663771),
                            const LatLng(28.969391, 79.686911),
                            const LatLng(29.037892, 79.625201),
                            const LatLng(28.98034, 79.310385),
                            const LatLng(29.750629, 77.9358),
                            const LatLng(29.852133, 77.849467),
                            const LatLng(29.876325, 77.820562),
                            const LatLng(29.882141, 77.753067),
                            const LatLng(29.836709, 77.729593),
                            const LatLng(29.852702, 77.801812),
                            const LatLng(29.846069, 77.876242),
                            const LatLng(30.064899, 77.862078),
                            const LatLng(29.981161, 77.800617),
                            const LatLng(29.943054, 77.881925),
                            const LatLng(29.772706, 77.756913),
                            const LatLng(29.822603, 77.792387),
                            const LatLng(29.701366, 77.782909),
                            const LatLng(29.912127, 77.948122),
                            const LatLng(29.927452, 77.939353),
                            const LatLng(29.928263, 77.979646),
                            const LatLng(29.948198, 78.037877),
                            const LatLng(29.957713, 78.036334),
                            const LatLng(29.893776, 77.981082),
                            const LatLng(29.948339, 78.049516),
                            const LatLng(29.939933, 78.05521),
                            const LatLng(29.936247, 78.063261),
                            const LatLng(29.932486, 78.052548),
                            const LatLng(29.922756, 78.023864),
                            const LatLng(29.915431, 78.068975),
                            const LatLng(29.896976, 78.082292),
                            const LatLng(29.910074, 77.9895),
                            const LatLng(29.91206, 78.025175),
                            const LatLng(29.910536, 78.024331),
                            const LatLng(29.907935, 78.081946),
                            const LatLng(29.908371, 78.098963),
                            const LatLng(29.905593, 78.094316),
                            const LatLng(29.962974, 78.12262),
                            const LatLng(29.932357, 78.131428),
                            const LatLng(29.94128, 78.130945),
                            const LatLng(29.931255, 78.140827),
                            const LatLng(29.948366, 78.15499),
                            const LatLng(29.967415, 78.166869),
                            const LatLng(29.933692, 78.155384),
                            const LatLng(29.906976, 78.135115),
                            const LatLng(29.74102, 77.835451),
                            const LatLng(29.750587, 77.840036),
                            const LatLng(29.699162, 77.908085),
                            const LatLng(29.786566, 77.886606),
                            const LatLng(29.815246, 78.071287),
                            const LatLng(29.685602, 78.026982),
                            const LatLng(29.64844, 78.038121),
                            const LatLng(29.589514, 77.977586),
                            const LatLng(29.695735, 77.989903),
                            const LatLng(29.728533, 77.99851),
                            const LatLng(29.91939, 77.798423),
                            const LatLng(29.938953, 77.779307),
                            const LatLng(29.920001, 78.189292),
                            const LatLng(30.574963, 78.325943),
                            const LatLng(30.477421, 78.379023),
                            const LatLng(30.342956, 78.386129),
                            const LatLng(30.267037, 78.41888),
                            const LatLng(30.432371, 78.656679),
                            const LatLng(30.376487, 78.433483),
                            const LatLng(30.361242, 78.084607),
                            const LatLng(30.371093, 78.05848),
                            const LatLng(30.280387, 78.049272),
                            const LatLng(30.265874, 78.083502),
                            const LatLng(30.288196, 77.998157),
                            const LatLng(30.176547, 78.159379),
                            const LatLng(29.248826, 79.530272),
                            const LatLng(29.228983, 79.52337),
                            const LatLng(29.160332, 79.148868),
                            const LatLng(28.92855, 79.4573)
                          ],
                          color: Colors.indigo,
                        ),

                        //
                        Polyline(
                          strokeWidth: 3,
                          points: [
                            const LatLng(29.85665, 80.361331),
                            const LatLng(29.053973, 79.346406),
                            const LatLng(29.84353, 77.849062),
                            const LatLng(29.9437, 78.066445),
                            const LatLng(30.717806, 78.414952),
                            const LatLng(30.428244, 77.623761),
                            const LatLng(30.066269, 78.255738),
                            const LatLng(29.904376, 77.931093),
                            const LatLng(29.635581, 77.904052),
                            const LatLng(30.520239, 77.719596),
                            const LatLng(28.916898, 79.37107),
                            const LatLng(28.850812, 79.476108),
                            const LatLng(29.128721, 78.886939),
                            const LatLng(29.21025, 79.45802),
                            const LatLng(28.991143, 79.414999),
                            const LatLng(30.338288, 77.908842),
                            const LatLng(30.616189, 78.328407),
                            const LatLng(30.341243, 78.382703),
                            const LatLng(30.442201, 78.659629),
                            const LatLng(30.653854, 78.759977),
                            const LatLng(30.494298, 77.801345),
                            const LatLng(30.531593, 77.825516),
                            const LatLng(29.987608, 80.575017),
                            const LatLng(29.544539, 80.136391),
                            const LatLng(29.224493, 80.210433),
                            const LatLng(29.13815, 78.95786),
                            const LatLng(28.985344, 79.752416),
                            const LatLng(30.29733, 77.73969)
                          ],
                          color: Colors.blueGrey,
                        ),
                      ],
                    ),

                  //Small Hydro Power Plants
                  Visibility(
                    visible: isSmallHydroPowerPlantsVisible!,
                    child: MarkerLayer(
                      markers: markersForSmallHydroPowerProjects,
                    ),
                  ),

                  MarkerLayer(
                    markers: baseLayerPoints,
                  ),
                ],
                children: [
                  Visibility(
                    visible: isRoadSelected!,
                    child: TileLayer(
                      tileDisplay: const TileDisplay.fadeIn(),
                      urlTemplate: urlTemplateList[0],
                    ),
                  ),
                  Visibility(
                    visible: isStandardSelected!,
                    child: TileLayer(
                      tileDisplay: const TileDisplay.fadeIn(),
                      urlTemplate: urlTemplateList[1],
                    ),
                  ),
                  Visibility(
                    visible: isTerrainSelected!,
                    child: TileLayer(
                      tileDisplay: const TileDisplay.fadeIn(),
                      urlTemplate: urlTemplateList[2],
                    ),
                  ),
                  Visibility(
                    visible: isAlteredRoadSelected!,
                    child: TileLayer(
                      tileDisplay: const TileDisplay.fadeIn(),
                      urlTemplate: urlTemplateList[3],
                    ),
                  ),
                  Visibility(
                    visible: isSatelliteSelected!,
                    child: TileLayer(
                      tileDisplay: const TileDisplay.fadeIn(),
                      urlTemplate: urlTemplateList[4],
                    ),
                  ),
                  Visibility(
                    visible: isHybridSelected!,
                    child: TileLayer(
                      tileDisplay: const TileDisplay.fadeIn(),
                      urlTemplate: urlTemplateList[5],
                    ),
                  ),
                ],
              ),
              onScaleStart: (details) {
                EasyLoading.showToast('Use buttons to zoom!');
              },
              onScaleEnd: (details) {
                EasyLoading.showToast('Use buttons to zoom!');
              },
              onScaleUpdate: (details) {
                EasyLoading.showToast('Use buttons to zoom!');
              },
            ),
            Positioned(
                right: 20,
                top: 20,
                child: Column(
                  children: [
                    InkWell(
                      onTap: _zoomIn,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5)),
                        height: 40,
                        width: 40,
                        child: const Center(
                          child: Icon(Icons.add),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: _zoomOut,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5)),
                        height: 40,
                        width: 40,
                        child: const Center(
                          child: Icon(Icons.remove),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }

  MapController mapController = MapController();
  double zoomLevel = 7;
  LatLng currentCenter = const LatLng(30.09373636046939, 79.01442398762491);

  void _zoomOut() {
    zoomLevel = zoomLevel - 0.5;
    zoomLevel = max(zoomLevel, 1);
    currentCenter = mapController.center;
    mapController.move(currentCenter, zoomLevel);
  }

  void _zoomIn() {
    zoomLevel = zoomLevel + 0.5;
    zoomLevel = min(zoomLevel, 18);
    currentCenter = mapController.center;
    mapController.move(currentCenter, zoomLevel);
  }
}

getData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  var dataItem = prefs.getString(key);
  var finalData = jsonDecode(dataItem!);
  return finalData;
}
