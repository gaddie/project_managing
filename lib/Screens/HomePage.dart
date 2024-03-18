import 'package:flutter/material.dart';
import 'package:project_manager/Constants.dart';
import 'package:animations/animations.dart';
import 'package:project_manager/Screens/CreateProject.dart';
import 'package:project_manager/Screens/ReportsPage.dart';
import 'package:project_manager/Components/ReusableCard.dart';
import 'package:project_manager/Screens/ExpenseTracking.dart';
import 'package:project_manager/Components/ReusableContainer.dart';
import 'package:project_manager/Screens/ProjectDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/Components/CustomButton.dart';

class HomePage extends StatefulWidget {
  static const String id = 'homePage';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  final _firestore = FirebaseFirestore.instance;
  late List<Map<String, dynamic>> projects = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getProjects();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void getProjects() async {
    await for (var snapshot in _firestore.collection('projects').snapshots()) {
      List<Map<String, dynamic>> filteredProjects = [];
      for (var project in snapshot.docs) {
        Map<String, dynamic> projectData =
            project.data() as Map<String, dynamic>;
        if (projectData['user'] == loggedInUser.email) {
          // Add projectId to the projectData map
          projectData['projectId'] = project.id;
          filteredProjects.add(projectData);
        }
      }
      setState(() {
        projects = filteredProjects;
      });
    }
  }

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
                        ? Icons.people
                        : index == 2
                            ? Icons.settings
                            : Icons.logout,
                color: _selectedIndex == index ? kDarkColor : kBgLightColor,
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = index;
                  if (_selectedIndex == 3) {
                    _auth.signOut();
                    Navigator.pop(context);
                  } else if (_selectedIndex == 1) {}
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
              if (projects.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      "You do not have any projects",
                      style: TextStyle(
                          fontSize: kNormalFontSize, color: kBottomAppColor),
                    ),
                  ),
                )
              else
                Column(
                  children: projects.map((project) {
                    // formatting the date to string
                    Timestamp timestamp = project['startDate'];
                    DateTime startDate = timestamp.toDate();
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(startDate);

                    return ReusableContainer(
                      label: project['projectName'] ?? '',
                      date: 'Start Date: ' + formattedDate,
                      onButtonPressed: () {
                        // Navigate to project details or any action you want
                        return ProjectDetails(
                          projectId: project['projectId'],
                          projectName: project['projectName'],
                          startDate: formattedDate,
                          startUpCost: project['startUpCost'],
                          description: project['description'],
                        );
                      },
                    );
                  }).toList(),
                ),
            ],
          ),
        ]),
      ),
    );
  }
}
