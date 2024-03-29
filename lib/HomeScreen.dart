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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return SafeArea(
      child: ListView(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    'Home',
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
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Container(
                height: 230,
                child: ReusableCard(
                  label: 'Reports and charts',
                  icon: Icons.analytics,
                  onButtonPressed: () {
                    return ReportsPage();
                  },
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
    );
  }
}
