import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usac_map_app/data/power_generation/power_generation_projects.dart';
import 'package:usac_map_app/data/power_generation/small_hydro_projects.dart';
import 'package:usac_map_app/data/power_transmission/substations.dart';
import 'package:usac_map_app/data/solar/solar_projects.dart';
import 'package:usac_map_app/home/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configLoading();
  initData();
  runApp(const MyApp());
}

void initData(){
  SharedPreferences.getInstance().then((prefs){
    prefs.clear();

    for (var key in data__power_generation_projects.keys) {
      var encodedData = jsonEncode(data__power_generation_projects[key]);
      prefs.setString(key, encodedData);
    }

    for (var key in data__small_hydro_power_plants.keys) {
      var encodedData = jsonEncode(data__small_hydro_power_plants[key]);
      prefs.setString(key, encodedData);
    }

    for (var key in data__power_transmission_substations.keys) {
      var encodedData = jsonEncode(data__power_transmission_substations[key]);
      prefs.setString(key, encodedData);
    }

    for (var key in data__solar_power_plants.keys) {
      var encodedData = jsonEncode(data__solar_power_plants[key]);
      prefs.setString(key, encodedData);
    }

  });
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.dualRing
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 75.0
    ..radius = 15.0
    ..userInteractions = false
    ..maskColor = Colors.greenAccent[100]
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'U-SAC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: EasyLoading.init(),
      home: const HomePage(),
    );
  }
}