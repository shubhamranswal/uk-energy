import 'dart:ui' as ui;
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usac_map_app/data/powerG.dart';
import 'package:usac_map_app/data/solar.dart';
import 'package:usac_map_app/data/text_content.dart';
import 'package:usac_map_app/fontsize.dart';
import 'package:usac_map_app/maps/map_page.dart';
import 'package:usac_map_app/maps/test_map.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _title = 'Home';

  bool isLoading = true;

  double changingHeight = 0;
  double changingWidth = 0;

  double photoHeight = 60;

  var nameController = TextEditingController();
  var organizationController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var messageController = TextEditingController();
  var contactFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    double fontsize = fontSizer(context);

    EasyLoading.dismiss();
    setState(() {
      if(kIsWeb){
        photoHeight = (MediaQuery.of(context).size.shortestSide - 120) / 5;
      }
      else {
        photoHeight = (MediaQuery.of(context).size.width - 120) / 4;
      }
    });

    Future.delayed(const Duration(seconds: 2)).then((value) {
      setState(() {
        changingHeight = MediaQuery.of(context).size.height -
            (MediaQuery.of(context).padding.top + kToolbarHeight + 60);
        changingWidth = MediaQuery.of(context).size.width - 60;

        if (kIsWeb){
          changingHeight = MediaQuery.of(context).size.height -
              (MediaQuery.of(context).padding.top + kToolbarHeight + 120);
          changingWidth = MediaQuery.of(context).size.width - 120;
        }

      });
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[100],
        title: Text(_title),
      ),
      drawer: Drawer(
        backgroundColor: Colors.blue[100],
        child: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height - 40,
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: Text('Home', style: TextStyle(fontSize: fontsize),),
                      selectedTileColor: Colors.white,
                      selectedColor: Colors.blue,
                      selected: _selectedIndex == 0,
                      onTap: () {
                        _onItemTapped(0, 'Home');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      selectedTileColor: Colors.white,
                      selectedColor: Colors.blue,
                      title: Text('About UK Energy', style: TextStyle(fontSize: fontsize),),
                      selected: _selectedIndex == 1,
                      onTap: () {
                        _onItemTapped(1, 'UK Energy');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      selectedTileColor: Colors.white,
                      selectedColor: Colors.blue,
                      leading: const Icon(Icons.map),
                      title: Text('Power Plants PDF Map', style: TextStyle(fontSize: fontsize),),
                      selected: _selectedIndex == 4,
                      onTap: () {
                        _onItemTapped(4, 'Power Plants PDF Map');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      selectedTileColor: Colors.white,
                      selectedColor: Colors.blue,
                      leading: const Icon(Icons.map),
                      title: Text('Power Substations PDF Map', style: TextStyle(fontSize: fontsize),),
                      selected: _selectedIndex == 5,
                      onTap: () {
                        _onItemTapped(5, 'Power Substations PDF Map');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      selectedTileColor: Colors.white,
                      selectedColor: Colors.blue,
                      leading: const Icon(Icons.map),
                      title: Text('Hydro Power PDF Map', style: TextStyle(fontSize: fontsize),),
                      selected: _selectedIndex == 6,
                      onTap: () {
                        _onItemTapped(6, 'Hydro Power PDF Map');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      selectedTileColor: Colors.white,
                      selectedColor: Colors.blue,
                      leading: const Icon(Icons.map),
                      title: Text('Population Heat PDF Map', style: TextStyle(fontSize: fontsize),),
                      selected: _selectedIndex == 7,
                      onTap: () {
                        _onItemTapped(7, 'Population Heat PDF Map');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      selectedTileColor: Colors.white,
                      selectedColor: Colors.blue,
                      leading: const Icon(Icons.map),
                      title: Text('Atlas PDF Map', style: TextStyle(fontSize: fontsize),),
                      selected: _selectedIndex == 9,
                      onTap: () {
                        _onItemTapped(9, 'Atlas PDF Map');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      selectedTileColor: Colors.white,
                      selectedColor: Colors.blue,
                      leading: const Icon(Icons.cloud_outlined),
                      title: Text('Whether Forecast', style: TextStyle(fontSize: fontsize),),
                      selected: _selectedIndex == 8,
                      onTap: () {
                        _onItemTapped(8, 'Whether Forecast');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info),
                      selectedTileColor: Colors.white,
                      selectedColor: Colors.blue,
                      title: Text('About U-SAC', style: TextStyle(fontSize: fontsize),),
                      selected: _selectedIndex == 2,
                      onTap: () {
                        _onItemTapped(2, 'About U-SAC');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      selectedTileColor: Colors.white,
                      selectedColor: Colors.blue,
                      leading: const Icon(Icons.person_2),
                      title: Text('Contact', style: TextStyle(fontSize: fontsize),),
                      selected: _selectedIndex == 3,
                      onTap: () {
                        _onItemTapped(3, 'Contact');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                      color: Colors.blue[300],
                      height: 40,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                              'Copyright @ U-SAC 2023',
                              textAlign: TextAlign.left,
                              maxLines: 1, style: TextStyle(fontSize: fontsize)
                          ),
                        )
                      ))),
            )
          ],
        ),
      ),
      body: _buildBody(_selectedIndex, fontsize),
    );
  }

  void _onItemTapped(int index, String title) {
    setState(() {
      _title = title;
      _selectedIndex = index;
    });
  }

  var maps = [
    'pdf_maps/power.pdf',
    'pdf_maps/power_substations.pdf',
    'pdf_maps/hydro_power_plants.pdf',
    'pdf_maps/population_heat.pdf'
  ];

  _buildBody(int position, double fontsize) {
    switch (position) {
      case 0:
        if (kIsWeb){
          return DoubleBackToCloseApp(
            snackBar: SnackBar(content: Text('Double tap to exit app!', style: TextStyle(fontSize: fontsize),),),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(color: Colors.white),
              child: Stack(
                children: [
                  //Left Container
                  Positioned(
                    left: 40,
                    top: 0,
                    child: Transform(
                      transform: Matrix4.identity(),
                      child: AnimatedContainer(
                        width: 80,
                        height: changingHeight,
                        decoration: const ShapeDecoration(
                          color: Colors.black12,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.50,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                          ),
                        ),
                        duration: const Duration(seconds: 4),
                      ),
                    ),
                  ),
                  //Top Container
                  Positioned(
                    right: 0,
                    top: 40,
                    child: AnimatedContainer(
                        width: changingWidth,
                        height: 80,
                        decoration: const ShapeDecoration(
                          color: Colors.black12,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.50,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                          ),
                        ),
                        duration: const Duration(seconds: 4),
                        padding: const EdgeInsets.only(right: 60, left: 0),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              'Uttarakhand Space Application Center',
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: TextStyle(fontSize: fontsize),
                            ),
                          )
                        )),
                  ),
                  //Right Container
                  Positioned(
                    right: 40,
                    bottom: 0,
                    child: AnimatedContainer(
                      width: 80,
                      height: changingHeight,
                      decoration: const ShapeDecoration(
                        color: Colors.black12,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.50,
                            strokeAlign: BorderSide.strokeAlignCenter,
                          ),
                        ),
                      ),
                      duration: const Duration(seconds: 4),
                    ),
                  ),
                  //Bottom Container
                  Positioned(
                      left: 0,
                      bottom: 40,
                      child: AnimatedContainer(
                        padding: const EdgeInsets.only(left: 60, right: 0),
                        width: changingWidth,
                        height: 80,
                        decoration: const ShapeDecoration(
                          color: Colors.black12,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.50,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                          ),
                        ),
                        duration: const Duration(seconds: 4),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              'Copyright @ U-SAC 2023',
                              textAlign: TextAlign.left,
                              maxLines: 1, style: TextStyle(fontSize: fontsize)
                            ),
                          )
                        ),
                      )),
                  //Home - Options
                  Container(
                      margin: const EdgeInsets.all(130),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  //Logo
                                  Column(
                                    children: [
                                      Image.asset(
                                          'assests/uttarakhand_shasan.jpg',
                                        height: MediaQuery.of(context).size.height / 5,
                                        width: MediaQuery.of(context).size.height / 5,),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "U-SAC\nUttarakhand",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: fontsize),
                                      )
                                    ],
                                  ),
                                  //Governor
                                  Column(
                                    children: [
                                      Image.asset(
                                          'assests/thumbnails/governor.jpg',
                                        height: MediaQuery.of(context).size.height / 5,
                                        width: MediaQuery.of(context).size.height / 5,),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text("Governor\nUttarakhand",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: fontsize))
                                    ],
                                  ),
                                  //CM
                                  Column(
                                    children: [
                                      Image.asset('assests/thumbnails/cm.jpg',
                                        height: MediaQuery.of(context).size.height / 5,
                                        width: MediaQuery.of(context).size.height / 5,),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text("CM\nUttarakhand",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: fontsize))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    EasyLoading.show();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const TestMap()));
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assests/thumbnails/power_generation.webp'),
                                            fit: BoxFit.cover)),
                                    height: MediaQuery.of(context).size.height / 5,
                                    width: MediaQuery.of(context).size.height / 3,
                                    child: ClipRRect(
                                      child: BackdropFilter(
                                        filter:
                                        ui.ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                        child: Container(
                                          color: Colors.white.withOpacity(0.65),
                                          child: Center(
                                            child: Text(
                                              'Power Generation', textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: fontsize),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    EasyLoading.show();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const TestMap()));
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assests/thumbnails/power_transmission.webp'),
                                            fit: BoxFit.cover)),
                                    height: MediaQuery.of(context).size.height / 5,
                                    width: MediaQuery.of(context).size.height / 3,                              child: ClipRRect(
                                      child: BackdropFilter(
                                        filter:
                                        ui.ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                        child: Container(
                                          color: Colors.white.withOpacity(0.65),
                                          child: Center(
                                            child: Text(
                                              'Power Transmission', textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: fontsize),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    EasyLoading.show();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const TestMap()));
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assests/thumbnails/power_distribution.jpg'),
                                            fit: BoxFit.cover)),
                                    height: MediaQuery.of(context).size.height / 5,
                                    width: MediaQuery.of(context).size.height / 3,
                                    child: ClipRRect(
                                      child: BackdropFilter(
                                        filter:
                                        ui.ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                        child: Container(
                                          color: Colors.white.withOpacity(0.65),
                                          child: Center(
                                            child: Text(
                                              'Power Distribution',
                                              style: TextStyle(fontSize: fontsize),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    EasyLoading.show();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MapPage(
                                              title: 'Solar Power Plants',
                                              value: 1,
                                              keyHead: 3,
                                              data: data_powerG,
                                              longitudes: longitudes_powerG,
                                              latitudes: latitudes_powerG
                                            )));
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assests/thumbnails/solar_power_plant.webp'),
                                            fit: BoxFit.cover)),
                                    height: MediaQuery.of(context).size.height / 5,
                                    width: MediaQuery.of(context).size.height / 3,                                   child: ClipRRect(
                                      child: BackdropFilter(
                                        filter:
                                        ui.ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                        child: Container(
                                          color: Colors.white.withOpacity(0.65),
                                          child: Center(
                                            child: Text(
                                              'Solar Power Plant',
                                              style: TextStyle(fontSize: fontsize),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
          );
        }
        else {
          return DoubleBackToCloseApp(
            snackBar: SnackBar(content: Text('Double tap to exit app!', style: TextStyle(fontSize: fontsize),)),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(color: Colors.white),
              child: Stack(
                children: [
                  //Left Container
                  Positioned(
                    left: 20,
                    top: 0,
                    child: Transform(
                      transform: Matrix4.identity(),
                      child: AnimatedContainer(
                        width: 40,
                        height: changingHeight,
                        decoration: const ShapeDecoration(
                          color: Colors.black12,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.50,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                          ),
                        ),
                        duration: const Duration(seconds: 4),
                      ),
                    ),
                  ),
                  //Top Container
                  Positioned(
                    right: 0,
                    top: 20,
                    child: AnimatedContainer(
                        width: changingWidth,
                        height: 40,
                        decoration: const ShapeDecoration(
                          color: Colors.black12,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.50,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                          ),
                        ),
                        duration: const Duration(seconds: 4),
                        padding: const EdgeInsets.only(right: 60, left: 0),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              'Uttarakhand Space Application Center',
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: TextStyle(fontSize: fontsize),
                            ),
                          )
                        )),
                  ),
                  //Right Container
                  Positioned(
                    right: 20,
                    bottom: 0,
                    child: AnimatedContainer(
                      width: 40,
                      height: changingHeight,
                      decoration: const ShapeDecoration(
                        color: Colors.black12,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.50,
                            strokeAlign: BorderSide.strokeAlignCenter,
                          ),
                        ),
                      ),
                      duration: const Duration(seconds: 4),
                    ),
                  ),
                  //Bottom Container
                  Positioned(
                      left: 0,
                      bottom: 20,
                      child: AnimatedContainer(
                        padding: const EdgeInsets.only(left: 60, right: 0),
                        width: changingWidth,
                        height: 40,
                        decoration: const ShapeDecoration(
                          color: Colors.black12,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.50,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                          ),
                        ),
                        duration: const Duration(seconds: 4),
                        child: Center(
                          child: Text(
                            'Copyright @ U-SAC 2023',
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            style: TextStyle(fontSize: fontsize),
                          ),
                        ),
                      )),
                  //Home - Options
                  Container(
                      margin: const EdgeInsets.all(65),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  //Logo
                                  Column(
                                    children: [
                                      Image.asset(
                                          'assests/uttarakhand_shasan.jpg',
                                          height: photoHeight),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "U-SAC\nUttarakhand",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: fontsize * 0.75),
                                      )
                                    ],
                                  ),
                                  //Governor
                                  Column(
                                    children: [
                                      Image.asset(
                                          'assests/thumbnails/governor.jpg',
                                          height: photoHeight),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text("Governor\nUttarakhand",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: fontsize * 0.75))
                                    ],
                                  ),
                                  //CM
                                  Column(
                                    children: [
                                      Image.asset('assests/thumbnails/cm.jpg',
                                          height: photoHeight),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text("CM\nUttarakhand",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: fontsize * 0.75))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                EasyLoading.show();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapPage(
                                            title: 'Power Generation',
                                            value: 1,
                                            keyHead: 0,
                                            data: data_powerG,
                                            longitudes: longitudes_powerG,
                                            latitudes: latitudes_powerG
                                        )));
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assests/thumbnails/power_generation.webp'),
                                        fit: BoxFit.cover)),
                                height: MediaQuery.of(context).size.height / 6,
                                child: ClipRRect(
                                  child: BackdropFilter(
                                    filter:
                                    ui.ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                    child: Container(
                                      color: Colors.white.withOpacity(0.65),
                                      child: Center(
                                        child: Text(
                                          'Power Generation',
                                          style: TextStyle(fontSize: fontsize * 1.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            InkWell(
                              onTap: () {
                                EasyLoading.show();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const TestMap()));
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assests/thumbnails/power_transmission.webp'),
                                        fit: BoxFit.cover)),
                                height: MediaQuery.of(context).size.height / 6,
                                child: ClipRRect(
                                  child: BackdropFilter(
                                    filter:
                                    ui.ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                    child: Container(
                                      color: Colors.white.withOpacity(0.65),
                                      child: Center(
                                        child: Text(
                                          'Power Transmission',
                                          style: TextStyle(fontSize: fontsize * 1.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            InkWell(
                              onTap: () {
                                EasyLoading.show();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const TestMap()));
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assests/thumbnails/power_distribution.jpg'),
                                        fit: BoxFit.cover)),
                                height: MediaQuery.of(context).size.height / 6,
                                child: ClipRRect(
                                  child: BackdropFilter(
                                    filter:
                                    ui.ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                    child: Container(
                                      color: Colors.white.withOpacity(0.65),
                                      child: Center(
                                        child: Text(
                                          'Power Distribution',
                                          style: TextStyle(fontSize: fontsize * 1.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            InkWell(
                              onTap: () {
                                EasyLoading.show();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapPage(
                                          title: 'Solar Power Plants',
                                          value: 1,
                                          keyHead: 3,
                                          data: data_powerG,
                                          longitudes: longitudes_powerG,
                                          latitudes: latitudes_powerG
                                        )));
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assests/thumbnails/solar_power_plant.webp'),
                                        fit: BoxFit.cover)),
                                height: MediaQuery.of(context).size.height / 6,
                                child: ClipRRect(
                                  child: BackdropFilter(
                                    filter:
                                    ui.ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                    child: Container(
                                      color: Colors.white.withOpacity(0.65),
                                      child: Center(
                                        child: Text(
                                          'Solar Power Plant',
                                          style: TextStyle(fontSize: fontsize * 1.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          );
        }
      case 1:
        return WillPopScope(
            child: Scaffold(
              backgroundColor: Colors.orangeAccent,
              body: Card(
                margin: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                    child: Container(
                  margin: const EdgeInsets.all(7.5),
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Image.asset('assests/USAC_Bulding_1.jpg', height: MediaQuery.of(context).size.height / 3,),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'UK Energy',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: fontsize * 2),
                      ),
                      Text(
                        about_uk_energy,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: fontsize),
                      ),
                    ],
                  ),
                )),
              ),
            ),
            onWillPop: () async {
              _onItemTapped(0, 'Home');
              return Future.value(false);
            });
      case 2:
        return WillPopScope(
            child: Scaffold(
              backgroundColor: Colors.orangeAccent,
              body: Card(
                margin: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                    child: Container(
                  margin: const EdgeInsets.all(7.5),
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Image.asset('assests/usac-logo.png'),
                      const SizedBox(height: 10),
                      Text(
                        about_usac,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: fontsize),
                      ),
                    ],
                  ),
                )),
              ),
            ),
            onWillPop: () async {
              _onItemTapped(0, 'Home');
              return Future.value(false);
            });
      case 3:
        return WillPopScope(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Form(
                    key: contactFormKey,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset('assests/USAC_Bulding_1.jpg', height: MediaQuery.of(context).size.height / 3,),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: Text('Director', style: TextStyle(fontSize: fontsize * 1.25),),
                          subtitle:
                              Text('Uttarakhand Space Application Center', style: TextStyle(fontSize: fontsize),),
                        ),
                        ListTile(
                          leading: const Icon(null),
                          title: Text(
                              'Department of IT, Good Governance & Science Technology', style: TextStyle(fontSize: fontsize),),
                          subtitle: Text('Government of Uttarakhand', style: TextStyle(fontSize: fontsize),),
                        ),
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: InkWell(
                            child: Text('director-usac@uk.gov.in', style: TextStyle(fontSize: fontsize),),
                            onTap: (){
                              launchUrl(Uri.parse('mailto:director-usac@uk.gov.in'));
                            },
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.location_on),
                          title: Text('Uttarakhand Antriksh Bhavan', style: TextStyle(fontSize: fontsize),),
                          subtitle: Text(
                              'Upper Aamwala, Nalapani, Dehradun, Uttarakhand', style: TextStyle(fontSize: fontsize),),
                        ),
                        ListTile(
                          leading: const Icon(Icons.phone),
                          title: InkWell(
                            child: Text('+91-135-2762098', style: TextStyle(fontSize: fontsize),),
                            onTap: (){
                              launchUrl(Uri.parse('tel:+911352762098'));
                            },
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: InkWell(
                            child: Text('usac_hq@yahoo.co.in', style: TextStyle(fontSize: fontsize),),
                          ),
                          onTap: (){
                            var emailLink =
                                'mailto:usac_hq@yahoo.co.in';
                            launchUrl(Uri.parse(emailLink));
                          }
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'On send us a message directly!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: fontsize * 1.15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 6.0, left: 1.0, right: 1.0),
                          child: TextFormField(
                            validator: (name) {
                              if (name == null || name.isEmpty) {
                                return 'Invalid Name!';
                              }
                              return null;
                            },
                            controller: nameController,
                            autofocus: false,
                            keyboardType: TextInputType.name,
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Full Name',
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 6.0, left: 1.0, right: 1.0),
                          child: TextFormField(
                            validator: (organization) {
                              if (organization == null ||
                                  organization.isEmpty) {
                                return 'Invalid Organization!';
                              }
                              return null;
                            },
                            controller: organizationController,
                            maxLines: 3,
                            autofocus: false,
                            keyboardType: TextInputType.streetAddress,
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Affiliated Organization (Department)',
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 6.0, left: 1.0, right: 1.0),
                          child: TextFormField(
                            validator: (email) {
                              if (email == null || email.isEmpty) {
                                return 'Invalid Email!';
                              }
                              return null;
                            },
                            controller: emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Contact Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 6.0, left: 1.0, right: 1.0),
                          child: TextFormField(
                            validator: (phoneNumber) {
                              if (phoneNumber == null || phoneNumber.isEmpty) {
                                return 'Invalid Phone Number!';
                              }
                              return null;
                            },
                            controller: phoneController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Phone Number',
                            ),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[()\d -]{1,15}$')),
                            ],
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 6.0, left: 1.0, right: 1.0),
                          child: TextFormField(
                            controller: messageController,
                            validator: (message) {
                              if (message == null || message.isEmpty) {
                                return 'Invalid Message!';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Your Message',
                            ),
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontSize: fontsize, color: Colors.black),
                            maxLines: 3,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: FilledButton(
                            onPressed: validateInputs,
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: fontsize,
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            ),
            onWillPop: () async {
              _onItemTapped(0, 'Home');
              return Future.value(false);
            });
      case 4:
        return WillPopScope(
            child:
                Center(child: SfPdfViewer.asset('assests/pdf_maps/power.pdf')),
            onWillPop: () async {
              _onItemTapped(0, 'Home');
              return Future.value(false);
            });
      case 5:
        return WillPopScope(
            child: Center(
                child: SfPdfViewer.asset(
              'assests/pdf_maps/power_substations.pdf',
            )),
            onWillPop: () async {
              _onItemTapped(0, 'Home');
              return Future.value(false);
            });
      case 6:
        return WillPopScope(
            child: Center(
                child: SfPdfViewer.asset(
                    'assests/pdf_maps/hydro_power_plants.pdf')),
            onWillPop: () async {
              _onItemTapped(0, 'Home');
              return Future.value(false);
            });
      case 7:
        return WillPopScope(
            child: Center(
                child:
                    SfPdfViewer.asset('assests/pdf_maps/population_heat.pdf')),
            onWillPop: () async {
              _onItemTapped(0, 'Home');
              return Future.value(false);
            });
      case 8:
        var url = 'https://mosdac.gov.in/live/index_one.php?url_name=india';
        return WillPopScope(
          onWillPop: () async {
            _onItemTapped(0, 'Home');
            return Future.value(false);
          },
          child: Stack(
            children: [
              WebView(
                initialUrl: url,
                onPageStarted: (start){
                  setState(() {
                    isLoading = true;
                  });
                },
                onPageFinished: (finish) {
                  setState(() {
                    isLoading = false;
                  });
                },
                javascriptMode: JavascriptMode.unrestricted,
              ),
              Visibility(
                visible: isLoading,
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    color: Colors.blueAccent[100],
                  ),
                ),
              )
            ],
          ),
        );
    // if (kIsWeb){
        //   // ignore: undefined_prefixed_name
        //   ui.platformViewRegistry.registerViewFactory(
        //       'webpage',
        //           (int viewId) => IFrameElement()
        //         ..src = url
        //         ..style.border = 'none');
        //   return const Directionality(
        //     textDirection: TextDirection.ltr,
        //     child: SizedBox(
        //       width: 640,
        //       height: 360,
        //       child: HtmlElementView(viewType: 'webpage'),
        //     ),
        //   );
        // }
        // else {
        //   return WillPopScope(
        //     onWillPop: () async {
        //       _onItemTapped(0, 'Home');
        //       return Future.value(false);
        //     },
        //     child: Stack(
        //       children: [
        //         WebView(
        //           initialUrl: url,
        //           onPageStarted: (start){
        //             setState(() {
        //               isLoading = true;
        //             });
        //           },
        //           onPageFinished: (finish) {
        //             setState(() {
        //               isLoading = false;
        //             });
        //           },
        //           javascriptMode: JavascriptMode.unrestricted,
        //         ),
        //         Visibility(
        //           visible: isLoading,
        //           child: Center(
        //             child: CircularProgressIndicator(
        //               backgroundColor: Colors.white,
        //               color: Colors.blueAccent[100],
        //             ),
        //           ),
        //         )
        //       ],
        //     ),
        //   );
        // }
      case 9:
        return WillPopScope(
            child: Center(
                child:
                SfPdfViewer.asset('assests/pdf_maps/atlas.pdf')),
            onWillPop: () async {
              _onItemTapped(0, 'Home');
              return Future.value(false);
            });
    }
  }

  validateInputs() {
    EasyLoading.show();
    if (contactFormKey.currentState!.validate()) {
      var name = nameController.text.toString().trim();
      var organization = organizationController.text.toString().trim();
      var email = emailController.text.toString().trim();
      var phone = phoneController.text.toString().trim();
      var message = messageController.text.toString().trim();
      var emailLink =
          'mailto:aruna.dawre@gmail.com?subject=UK%20Energy%20-%20App%20Support&body=Respectfully%2C%20%0A%0AMyself%20$name%2C%20from%20$organization.%0A%0A$message%0A%0ARegards%2C%0A%0A$name%0A$organization%0A$email%0A$phone';
      launchUrl(Uri.parse(emailLink));
      EasyLoading.dismiss();
    }
  }
}
