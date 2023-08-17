import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usac_map_app/data/solar.dart';
import 'package:usac_map_app/keyheads.dart';

class MapPage extends StatefulWidget {
  final int value;
  final int keyHead;

  const MapPage(
      {super.key, required this.value, required this.keyHead});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final data = data_solar_power_plants;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
      for (var key in data.keys) {
        var encodedData = jsonEncode(data[key]);
        prefs.setString(key, encodedData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyHeadValue = keyHeads[widget.keyHead];

    List<Marker> points = [];

    List<double> latitudes = latitudes_solar_power_plants;
    List<double> longitudes = longitudes_solar_power_plants;

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
              // result = result as Map<String, String>;
              // for (var x in result.keys){
              //   print(result[x].runtimeType);
              // }
              showDialog(
                  context: context,
                  builder: (context) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 2,
                          left: 20,
                          right: 20,
                          bottom: 20),
                      padding: const EdgeInsets.all(10),
                      width: 2.75 * MediaQuery.of(context).size.width / 3,
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
                              const Text(
                                'Plant Details',
                                style: TextStyle(fontSize: 16),
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
                            result
                                .toString()
                                .toUpperCase()
                                .substring(2, result.toString().length - 2),
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
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

    int _value = widget.value;
    var tile = urlTemplateList[_value];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Solar Power Plants'),
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
                                  const Text('Select Layers',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
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
                                        groupValue: _value,
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
                                                            keyHead:
                                                                widget.keyHead,
                                                          )));
                                            });
                                            print(layers[value]);
                                          } else {
                                            print(
                                                "Can't perform the action right now!");
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
      body: FlutterMap(
        options: MapOptions(
          onMapReady: () => EasyLoading.dismiss(),
          center: const LatLng(30.09373636046939, 79.01442398762491),
          zoom: 7,
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
    );
  }

  getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var data_item = prefs.getString(key);
    var final_data = jsonDecode(data_item!);
    return final_data;
  }
}
