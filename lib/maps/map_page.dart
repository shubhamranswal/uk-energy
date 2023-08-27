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
                                                            isSatelliteSelected = isHybridSelected=
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
                                                            isSatelliteSelected = isHybridSelected =
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
                  MarkerLayer(
                    markers: baseLayerPoints,
                  ),

                  if(widget.title == 'Power Transmission')
                    PolylineLayer(
                      polylines: [

                        //40
                        Polyline(
                          strokeWidth: 3,
                          points: [const LatLng(30.125014, 78.156698),
                            const LatLng(29.926244, 78.720622),
                            const LatLng(30.251251, 79.215702)],
                          color: Colors.blue,
                        ),

                        //50
                        Polyline(
                          strokeWidth: 3,
                          points: [const LatLng(29.366716,79.54348),
                            const LatLng(29.673391,79.491118)],
                          color: Colors.black,
                        ),

                        //60
                        Polyline(
                          strokeWidth: 3,
                          points: [const LatLng(29.372137, 79.103674),
                            const LatLng(29.5816, 79.670017),
                            const LatLng(30.409586, 78.065982)],
                          color: Colors.green,
                        ),

                        //75
                        Polyline(
                          strokeWidth: 3,
                          points: [const LatLng(30.226147, 78.783589),
                            const LatLng(30.341239, 78.382625)],
                          color: Colors.indigo,
                        ),

                        //80
                        Polyline(
                          strokeWidth: 3,
                          points: [const LatLng(29.272678,78.861455),
                            const LatLng(28.931137,79.733284),
                            const LatLng(28.914753,79.506691),
                            const LatLng(29.022623,79.694114),
                            const LatLng(29.250033,79.533595),
                            const LatLng(30.336158,78.033881),
                            const LatLng(30.06941,78.254154),
                            const LatLng(29.697701,77.98813),
                            const LatLng(29.740303,77.835999),
                            const LatLng(29.882361,77.752347),
                            const LatLng(29.773081,78.42801)],
                          color: Colors.blueGrey,
                        ),

                        //120
                        Polyline(
                          strokeWidth: 3,
                          points: [const LatLng(29.192397, 78.99399),
                            const LatLng(29.191758, 79.12485),
                            const LatLng(30.289667, 77.99599),
                            const LatLng(29.925957, 78.087083),
                            const LatLng(29.969811, 78.167556),
                            const LatLng(29.919956, 77.796807)],
                          color: Colors.cyan,
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
