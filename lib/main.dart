
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_iot/firebase_options.dart';
import 'package:tubes_iot/screen/homepage.dart';
import 'package:tubes_iot/jarnik.dart';
import 'package:tubes_iot/scan_qr.dart';
import 'package:tubes_iot/screen/profile.dart';
import 'package:tubes_iot/style/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(home: MyHome()));
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<IconData> iconList = [
    FontAwesomeIcons.house,
    FontAwesomeIcons.book,
    FontAwesomeIcons.inbox,
    FontAwesomeIcons.solidUser
  ];

  List<Widget> widgetList = [
    const Homepage(),
    const Homepage(),
    const Jarnik(),
    // FirebaseImageWidget(imagePath: "testing/KTM GIGIH.jpg"),
    const ProfileImageUpload(),
    const QRViewExample(),
  ];

  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: smoothGrey,
      body: widgetList[_bottomNavIndex],
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: brown,
        onPressed: () {
          setState(() {
            _bottomNavIndex = 4;
          });
        },
        child: const FaIcon(
          FontAwesomeIcons.qrcode,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (index, isActive) {
          return Icon(
            iconList[index],
            size: 18,
            color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
          );
        },
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 15,
        rightCornerRadius: 15,
        height: 60,
        backgroundGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lightBrown,
              brown,
            ]),
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),
    );
  }
}
