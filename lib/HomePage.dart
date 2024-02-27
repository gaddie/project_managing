import 'package:flutter/material.dart';
import 'package:project_manager/Constants.dart';
import 'package:animations/animations.dart';
import 'package:project_manager/Screens/CreateProject.dart';
import 'package:project_manager/Screens/ReportsPage.dart';
import 'package:project_manager/Components/ReusableCard.dart';
import 'package:project_manager/Screens/ExpenseTracking.dart';
import 'package:project_manager/Components/ReusableContainer.dart';
import 'package:project_manager/Screens/ProjectDetails.dart';
import 'package:project_manager/Screens/RiskAnalysis.dart';
import 'package:project_manager/Components/CustomButton.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLightColor,
      extendBody: true,
      floatingActionButton: OpenContainer(
        closedColor: kBottomAppColor,
        transitionType: ContainerTransitionType.fade,
        openBuilder: (BuildContext context, VoidCallback _) {
          return CreateProject(); // Replace with the actual page you want to show
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
          children: List.generate(4, (index) {
            return IconButton(
              icon: Icon(
                index == 0
                    ? Icons.home_filled
                    : index == 1
                        ? Icons.notifications
                        : index == 2
                            ? Icons.person
                            : Icons.settings,
                color: _selectedIndex == index ? kDarkColor : kBgLightColor,
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = index;
                  // Add logic to handle navigation or other actions
                });
              },
            );
          }),
        ),
      ),
      body: SafeArea(
        child: ListView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Image(
                        image: AssetImage('images/logo.png'),
                        height: 30,
                        width: 30,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'John Doe',
                      style: TextStyle(
                          fontSize: kNormalFontSize, color: kBottomAppColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        kDarkColor,
                        kBottomAppColor
                      ], // Adjust colors as needed
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    color: kDarkColor,
                  ),
                  height: 4,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'My Dashboard',
                  style: TextStyle(
                      fontSize: kNormalFontSize, color: kBottomAppColor),
                ),
              ),
              Container(
                height: 230,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 303.0,
                        child: ReusableCard(
                          label: 'Expense Tracking',
                          icon: Icons.account_balance_wallet_sharp,
                          onButtonPressed: () {
                            return ExpenseTracking();
                          },
                        ),
                      ),
                      Container(
                        width: 303.0,
                        child: ReusableCard(
                          label: 'Reports and charts',
                          icon: Icons.analytics,
                          onButtonPressed: () {
                            return ReportsPage();
                          },
                        ),
                      ),
                      Container(
                        width: 303.0,
                        child: ReusableCard(
                          label: 'Risk Analysis',
                          icon: Icons.trending_up,
                          onButtonPressed: () {
                            return RiskAnalysis();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      )
                      // Add more containers or widgets as needed
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        kDarkColor,
                        kBottomAppColor
                      ], // Adjust colors as needed
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    color: kDarkColor,
                  ),
                  height: 4,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'My Projects',
                  style: TextStyle(
                      fontSize: kNormalFontSize, color: kBottomAppColor),
                ),
              ),
              ReusableContainer(
                label: 'Project 1',
                condition: 'In progress',
                onButtonPressed: () {
                  return ProjectDetails();
                },
              ),
              ReusableContainer(
                label: 'Project 2',
                condition: 'In progress',
                onButtonPressed: () {
                  return ProjectDetails();
                },
              ),
              CustomButton(
                txtColor: kLightColor,
                bgColor: kBottomAppColor,
                callBackFunction: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                label: 'Back',
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
