import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usac_map_app/fontsize.dart';
import '../keyheads.dart';

class MapPage extends StatefulWidget {
  final String title;
  final int value;
  final int keyHead;
  final Map<String, Map<String, String>> data;
  final List<double> longitudes;
  final List<double> latitudes;

  const MapPage(
      {super.key,
      required this.title,
      required this.value,
      required this.keyHead,
      required this.data,
      required this.longitudes,
      required this.latitudes});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
      for (var key in widget.data.keys) {
        var encodedData = jsonEncode(widget.data[key]);
        prefs.setString(key, encodedData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyHeadValue = keyHeads[widget.keyHead];

    List<Marker> points = [];

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
              print(key);
              var result = await getData(key);
              var display = '';
              print(result.runtimeType);
              for (var key in result.keys){
                if (result[key].toString().isNotEmpty){
                  display = "$display${key} - ${result[key]}\n";
                }
              }
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return  FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Container(
                        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 10),
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
        points.add(marker);
      }
    }

    var layers = [
      'Roads Only',
      'Standard Roadmap',
      'Terrain',
      'Altered Roadmap',
      'Satellite Only',
      'Hybrid'
    ];

    var urlTemplateList = [
      'https://mt.google.com/vt/lyrs=h&x={x}&y={y}&z={z}',
      'https://mt.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
      'https://mt.google.com/vt/lyrs=p&x={x}&y={y}&z={z}',
      'https://mt.google.com/vt/lyrs=r&x={x}&y={y}&z={z}',
      'https://mt.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
      'https://mt.google.com/vt/lyrs=y&x={x}&y={y}&z={z}'
    ];

    int value = widget.value;
    var tile = urlTemplateList[value];

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
            showDialog(
                context: context,
                builder: (context) {
                  return Stack(
                    children: [
                      Positioned(
                        top: (MediaQuery.of(context).size.height -
                                (MediaQuery.of(context).padding.top +
                                    kToolbarHeight)) /
                            3,
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 2),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height -
                                (MediaQuery.of(context).padding.top +
                                    kToolbarHeight),
                            color: Colors.blue[100],
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
                                          onChanged: (int? value) {
                                            if (value != null) {
                                              setState(() {
                                                Navigator.pop(context);
                                                EasyLoading.show();
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MapPage(
                                                              value: value,
                                                              keyHead: widget
                                                                  .keyHead,
                                                              title:
                                                                  widget.title,
                                                              data: widget.data,
                                                              longitudes: widget
                                                                  .longitudes,
                                                              latitudes: widget
                                                                  .latitudes,
                                                            )));
                                              });
                                            } else {
                                              if (kDebugMode) {
                                                print(
                                                    "Can't perform the action right now!");
                                              }
                                              const SnackBar(
                                                  content: Text(
                                                      "Can't perform the action right now!"));
                                            }
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Positioned(
                      //   top: (MediaQuery.of(context).size.height -
                      //       (MediaQuery.of(context).padding.top +
                      //           kToolbarHeight)) /
                      //       3,
                      //   child: SingleChildScrollView(
                      //     child: Column(
                      //       children: <Widget>[
                      //         for (int i = 0; i < 7; i++)
                      //           ListTile(
                      //             title: Text(
                      //               layers[i],
                      //             ),
                      //             // leading: Radio(
                      //             //   value: i,
                      //             //   groupValue: _value,
                      //             //   activeColor: const Color(0xFF6200EE), onChanged: (int? value) { print(layers[i]); },
                      //             // ),
                      //           ),
                      //       ],
                      //     ),
                      //   ))
                    ],
                  );
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
                    markers: points,
                  ),
                ],
                children: [
                  TileLayer(
                    tileDisplay: const TileDisplay.fadeIn(),
                    urlTemplate: tile,
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

  getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var dataItem = prefs.getString(key);
    var finalData = jsonDecode(dataItem!);
    return finalData;
  }
}

class MapPageForSameLatLong extends StatefulWidget {
  final String title;
  final int value;
  final int keyHead;
  final Map<String, List<Map<String, String>>> sameLatLongData;
  final List<double> longitudes;
  final List<double> latitudes;

  const MapPageForSameLatLong(
      {super.key,
        required this.title,
        required this.value,
        required this.keyHead,
        required this.sameLatLongData,
        required this.longitudes,
        required this.latitudes});

  @override
  State<MapPageForSameLatLong> createState() => _MapPageForSameLatLongState();
}

class _MapPageForSameLatLongState extends State<MapPageForSameLatLong> {
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
      for (var key in widget.sameLatLongData.keys) {
        var encodedData = jsonEncode(widget.sameLatLongData[key]);
        prefs.setString(key, encodedData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyHeadValue = keyHeads[widget.keyHead];

    List<Marker> points = [];

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
              for (var data in result){
                Map object = data as Map;
                for (var key in object.keys){
                  if (object[key].toString().length != 0){
                    display = "$display${key} - ${object[key]}\n";
                  }
                }
                display = "$display\n";
              }
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return  FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Container(
                        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 10),
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
        points.add(marker);
      }
    }

    var layers = [
      'Roads Only',
      'Standard Roadmap',
      'Terrain',
      'Altered Roadmap',
      'Satellite Only',
      'Hybrid'
    ];

    var urlTemplateList = [
      'https://mt.google.com/vt/lyrs=h&x={x}&y={y}&z={z}',
      'https://mt.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
      'https://mt.google.com/vt/lyrs=p&x={x}&y={y}&z={z}',
      'https://mt.google.com/vt/lyrs=r&x={x}&y={y}&z={z}',
      'https://mt.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
      'https://mt.google.com/vt/lyrs=y&x={x}&y={y}&z={z}'
    ];

    int value = widget.value;
    var tile = urlTemplateList[value];

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
            showDialog(
                context: context,
                builder: (context) {
                  return Stack(
                    children: [
                      Positioned(
                        top: (MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).padding.top +
                                kToolbarHeight)) /
                            3,
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 2),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height -
                                (MediaQuery.of(context).padding.top +
                                    kToolbarHeight),
                            color: Colors.blue[100],
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
                                          onChanged: (int? value) {
                                            if (value != null) {
                                              setState(() {
                                                Navigator.pop(context);
                                                EasyLoading.show();
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MapPageForSameLatLong(
                                                              value: value,
                                                              keyHead: widget
                                                                  .keyHead,
                                                              title:
                                                              widget.title,
                                                              sameLatLongData: widget.sameLatLongData,
                                                              longitudes: widget
                                                                  .longitudes,
                                                              latitudes: widget
                                                                  .latitudes,
                                                            )));
                                              });
                                              if (kDebugMode) {
                                                print(layers[value]);
                                              }
                                            } else {
                                              if (kDebugMode) {
                                                print(
                                                    "Can't perform the action right now!");
                                              }
                                              const SnackBar(
                                                  content: Text(
                                                      "Can't perform the action right now!"));
                                            }
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Positioned(
                      //   top: (MediaQuery.of(context).size.height -
                      //       (MediaQuery.of(context).padding.top +
                      //           kToolbarHeight)) /
                      //       3,
                      //   child: SingleChildScrollView(
                      //     child: Column(
                      //       children: <Widget>[
                      //         for (int i = 0; i < 7; i++)
                      //           ListTile(
                      //             title: Text(
                      //               layers[i],
                      //             ),
                      //             // leading: Radio(
                      //             //   value: i,
                      //             //   groupValue: _value,
                      //             //   activeColor: const Color(0xFF6200EE), onChanged: (int? value) { print(layers[i]); },
                      //             // ),
                      //           ),
                      //       ],
                      //     ),
                      //   ))
                    ],
                  );
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
                    markers: points,
                  ),
                ],
                children: [
                  TileLayer(
                    tileDisplay: const TileDisplay.fadeIn(),
                    urlTemplate: tile,
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
                    SizedBox(
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

  getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var dataItem = prefs.getString(key);
    var finalData = jsonDecode(dataItem!);
    return finalData;
  }
}