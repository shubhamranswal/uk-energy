import 'dart:ui';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:usac_map_app/maps/solar_projects.dart';
import 'package:usac_map_app/maps/test_map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _title = 'Home';

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
    EasyLoading.dismiss();
    setState(() {
      photoHeight = (MediaQuery.of(context).size.width - 120) / 4;
    });

    Future.delayed(const Duration(seconds: 2)).then((value) {
      setState(() {
        changingHeight = MediaQuery.of(context).size.height -
            (MediaQuery.of(context).padding.top + kToolbarHeight + 60);
        changingWidth = MediaQuery.of(context).size.width - 60;
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
                    const SizedBox(
                      height: 25,
                    ),
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text('Home '),
                      selectedTileColor: Colors.white,
                      selectedColor: Colors.blue,
                      selected: _selectedIndex == 0,
                      onTap: () {
                        _onItemTapped(0, 'Home');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info),
                      selectedTileColor: Colors.white,
                      selectedColor: Colors.blue,
                      title: const Text('About'),
                      selected: _selectedIndex == 1,
                      onTap: () {
                        _onItemTapped(1, 'About');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      selectedTileColor: Colors.white,
                      selectedColor: Colors.blue,
                      leading: const Icon(Icons.person_2),
                      title: const Text('Contact'),
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
                      child: const Center(
                        child: Text(
                          'Copyright @ USAC 2023',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ))),
            )
          ],
        ),
      ),
      body: _buildBody(_selectedIndex),
    );
  }

  void _onItemTapped(int index, String title) {
    setState(() {
      _title = title;
      _selectedIndex = index;
    });
  }

  _buildBody(int position) {
    switch (position) {
      case 0:
        return DoubleBackToCloseApp(
          snackBar: const SnackBar(content: Text('Double tap to exit app!')),
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
                      child: const Center(
                        child: Text(
                          'Uttarakhand Space Application Center',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 13),
                        ),
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
                      child: const Center(
                        child: Text(
                          'Copyright @ U-SAC 2023',
                          textAlign: TextAlign.left,
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
                                    const Text(
                                      "U-SAC\nUttarakhand",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12),
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
                                    const Text("Governor\nUttarakhand",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12))
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
                                    const Text("CM\nUttarakhand",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12))
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
                                      builder: (context) => const TestMap()));
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
                                      ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                  child: Container(
                                    color: Colors.white.withOpacity(0.65),
                                    child: const Center(
                                      child: Text(
                                        'Power Generation',
                                        style: TextStyle(fontSize: 20),
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
                                      ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                  child: Container(
                                    color: Colors.white.withOpacity(0.65),
                                    child: const Center(
                                      child: Text(
                                        'Power Transmission',
                                        style: TextStyle(fontSize: 20),
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
                                      ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                  child: Container(
                                    color: Colors.white.withOpacity(0.65),
                                    child: const Center(
                                      child: Text(
                                        'Power Distribution',
                                        style: TextStyle(fontSize: 20),
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
                                      builder: (context) =>
                                          const SolarPowerPlants()));
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
                                      ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                  child: Container(
                                    color: Colors.white.withOpacity(0.65),
                                    child: const Center(
                                      child: Text(
                                        'Solar Power Plant',
                                        style: TextStyle(fontSize: 20),
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
                      Image.asset('assests/USAC_Bulding_1.jpg'),
                      const SizedBox(height: 10),
                      const Text(
                        'U-SAC',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40),
                      ),
                      const Text(
                        'Uttarakhand Space Application Centre (USAC) is the nodal agency in Uttarakhand state for space-technology related activities and has the mandate to employ space-technology for the benefit of the state and its people. It was constituted as an autonomous organization in 2005, under the Department of Science & Technology, Government of Uttarakhand. The Government of Uttarakhand is acutely concerned about the states vulnerability to the consequences of the fragility of Himalayas and the inexorable intensification of climate change. It is very keen not to let these constraints come in the way of ensuring that the last person of the state gets access to a decent quality of life, without compromising on its responsibility as a trustee of our environment for future generations. To overcome the daunting challenges that Uttarakhand faces due to its formidable terrain and the fragility of Himalayas, enhanced use of technology, especially space technology, is of dire necessity. Hence, the prime objective of USAC is to explore and deploy geospatial technology for the development of the state. Consequently, USAC boasts of a close relationship with the Indian Space Research Organization (ISRO) that has benefited the state immensely and constantly strives to further develop and intensify this productive association.\n',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 16),
                      ),
                      const Text(
                        'USAC works in crucial areas, such as Natural Resource Management, Water Resource Management, Glacier Studies, Environmental Monitoring, Land use & Urban planning, Disaster Mitigation, Web-based School Information System, Health Information System etc. Notable among the programmes that it has been implementing on an ongoing basis are State Natural Resource Management System (SNRMS), Forecasting Agriculture using Space, Agrometeorlogy & Land based observations (FASAL) programme, Coordinated programme on Horticulture Assessment and MAnagement using geoiNfromatics (CHAMAN), Development of National Forest Fire Danger Rating, among others.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 16),
                      )
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
            child: Container(
              color: Colors.blueAccent,
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
                          child: Image.asset('assests/USAC_Bulding_1.jpg'),
                        ),
                        const ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Director'),
                          subtitle:
                              Text('Uttarakhand Space Application Center'),
                        ),
                        const ListTile(
                          leading: Icon(null),
                          title: Text(
                              'Department of IT, Good Governance & Science Technology'),
                          subtitle: Text('Government of Uttarakhand'),
                        ),
                        const ListTile(
                          leading: Icon(Icons.email),
                          title: Text('director-usac@uk.gov.in'),
                        ),
                        const Divider(),
                        const ListTile(
                          leading: Icon(Icons.location_on),
                          title: Text('Uttarakhand Antriksh Bhavan'),
                          subtitle: Text(
                              'Upper Aamwala, Nalapani, Dehradun, Uttarakhand'),
                        ),
                        const ListTile(
                          leading: Icon(Icons.phone),
                          title: Text('+91-135-2762098'),
                        ),
                        const ListTile(
                          leading: Icon(Icons.email),
                          title: Text('usac_hq@yahoo.co.in'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'On send us a message directly!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
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
                            style:
                                const TextStyle(fontSize: 16.0, color: Colors.black),
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
                            style:
                                const TextStyle(fontSize: 16.0, color: Colors.black),
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
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black),
                            maxLines: 3,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: FilledButton(
                            onPressed: validateInputs,
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
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
      EasyLoading.show(status: '$name $organization $email $phone $message');
    } else {
      EasyLoading.dismiss();
    }
  }
}
