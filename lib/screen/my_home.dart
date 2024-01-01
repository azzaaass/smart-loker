import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_iot/screen/history.dart';
import 'package:tubes_iot/screen/homepage.dart';
import 'package:tubes_iot/jarnik.dart';
import 'package:tubes_iot/scan_qr.dart';
import 'package:tubes_iot/screen/profile.dart';
import 'package:tubes_iot/style/color.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<IconData> iconList = [
    FontAwesomeIcons.house,
    FontAwesomeIcons.inbox,
    FontAwesomeIcons.book,
    FontAwesomeIcons.solidUser
  ];

  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return Scaffold(
      backgroundColor: smoothGrey,
      body: PageView(
        controller: controller,
        onPageChanged: (value) => setState(() {
          _bottomNavIndex = value;
        }),
        children: const <Widget>[
          Homepage(),
          Homepage(),
          History(),
          // FirebaseImageWidget(imagePath: "testing/KTM GIGIH.jpg"),
          Profile(),
          // ProfileImageUpload(),
          // FirebaseImageUpdater(),
          // QRViewExample(),
        ],
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: brown,
        onPressed: () {
          setState(() {
            Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => QRViewExample(),
                ));
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
        onTap: (index) => setState(() {
          _bottomNavIndex = index;
          controller.animateToPage(_bottomNavIndex,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutQuad);
        }),
        //other params
      ),
    );
  }
}
