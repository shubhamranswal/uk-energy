import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:usac_map_app/data/power_generation/small_hydro_projects.dart';
import '../fontsize.dart';
import '../maps/map_page.dart';

const keyHeadValue = 'smallHydroPowerPlants_';

List<Marker> markersForSmallHydroPowerProjects = [];

List<double> latitudes = latitudes__small_hydro_power_plants;
List<double> longitudes = longitudes__small_hydro_power_plants;

createMarkersForSmallHydroPowerProjects(){
  if (latitudes.length == longitudes.length){
    for (int i = 0; i < latitudes.length; i++){
      Marker marker = Marker(
        point: LatLng(latitudes[i], longitudes[i]),
        width: 80,
        height: 80,
        builder: (context) => GestureDetector(
          child: const Icon(
            Icons.circle_outlined,
            size: 20,
            color: Color(0xFF4AAEFF),
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
      markersForSmallHydroPowerProjects.add(marker);
    }
  }
}