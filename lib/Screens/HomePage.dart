import 'package:flutter/material.dart';
import 'package:project_manager/Constants.dart';
import 'package:animations/animations.dart';
import 'package:project_manager/Screens/CreateProject.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_manager/Screens/SettingsPage.dart';
import 'package:project_manager/Screens/HelpScreen.dart';
import 'package:project_manager/HomeScreen.dart';

class HomePage extends StatefulWidget {
  static const String id = 'homePage';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _auth = FirebaseAuth.instance;
  int smallIcon = 27;
  int largeIcon = 35;

  @override
  Widget build(BuildContext context) {
    PageController _myPage = PageController(initialPage: 0);
    return Scaffold(
      backgroundColor: kBgLightColor,
      extendBody: true,
      floatingActionButton: OpenContainer(
        closedColor: kBottomAppColor,
        transitionType: ContainerTransitionType.fade,
        openBuilder: (BuildContext context, VoidCallback _) {
          return CreateProject();
        },
        closedElevation: 6.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(56)),
        ),
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return FloatingActionButton(
            onPressed: openContainer,
            backgroundColor: kBottomAppColor,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 6.0,
        shadowColor: kDarkColor,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 60,
        color: kBottomAppColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              iconSize: 30.0,
              padding: EdgeInsets.only(left: 28.0),
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? kDarkColor : kLightColor,
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                  _myPage.jumpToPage(0);
                });
              },
            ),
            IconButton(
              iconSize: 30.0,
              padding: EdgeInsets.only(right: 28.0),
              icon: Icon(
                Icons.people,
                color: _selectedIndex == 1 ? kDarkColor : kLightColor,
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                  _myPage.jumpToPage(1);
                });
              },
            ),
            IconButton(
              iconSize: 30.0,
              padding: EdgeInsets.only(left: 28.0),
              icon: Icon(
                Icons.settings,
                color: _selectedIndex == 2 ? kDarkColor : kLightColor,
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                  _myPage.jumpToPage(2);
                });
              },
            ),
            IconButton(
              iconSize: 30.0,
              padding: EdgeInsets.only(right: 28.0),
              icon: Icon(
                Icons.logout,
                color: _selectedIndex == 3 ? kDarkColor : kLightColor,
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = 3;
                  _auth.signOut();
                  Navigator.pop(context);
                });
              },
            )
          ],
        ),
      ),
      body: PageView(
        controller: _myPage,
        children: <Widget>[
          HomeScreen(),
          Help(),
          SettingsPage(),
        ],
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
