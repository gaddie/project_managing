import 'package:flutter/material.dart';
import 'package:project_manager/Constants.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:project_manager/Screens/ChartPage.dart';
import 'package:project_manager/Components/ReportsCard.dart';
import 'package:project_manager/Components/CustomButton.dart';
import 'package:project_manager/FinancialPerfomance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportsPage extends StatefulWidget {
  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  final _firestore = FirebaseFirestore.instance;
  late List<Map<String, dynamic>> projects = [];
  late List<Map<String, dynamic>> costs = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getProjects();
    getCosts();
  }

  //getting the current user
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

  // fetching the projects from firebase
  void getProjects() async {
    await for (var snapshot in _firestore.collection('projects').snapshots()) {
      List<Map<String, dynamic>> filteredProjects = [];
      for (var project in snapshot.docs) {
        Map<String, dynamic> projectData =
            project.data() as Map<String, dynamic>;
        if (projectData['user'] == loggedInUser.email) {
          filteredProjects.add(projectData);
        }
      }
      setState(() {
        projects = filteredProjects;
      });
    }
  }

  // fetching the costs from the database for the year 2024.
  void getCosts() async {
    await for (var snapshot in _firestore.collection('costs').snapshots()) {
      List<Map<String, dynamic>> filteredCosts = [];
      for (var project in snapshot.docs) {
        Map<String, dynamic> projectData =
            project.data() as Map<String, dynamic>;
        if (projectData['user'] == loggedInUser.email) {
          // Assuming 'date' field is a timestamp
          Timestamp timestamp =
              projectData['date']; // Accessing date field as timestamp
          DateTime date =
              timestamp.toDate(); // Convert Firebase Timestamp to DateTime
          if (date.year == 2024) {
            filteredCosts.add(projectData);
          }
        }
      }
      setState(() {
        costs = filteredCosts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLightColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            floating: true,
            iconTheme: IconThemeData(color: kBottomAppColor),
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              title: Text(
                "Reports",
                style: TextStyle(color: kBottomAppColor),
              ),
              background: Image.asset(
                'images/app.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: DelayedDisplay(
              delay: Duration(microseconds: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (projects.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          "You do not have any projects",
                          style: TextStyle(
                            fontSize: kNormalFontSize,
                            color: kBottomAppColor,
                          ),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: projects.map((project) {
                        // Find costs related to the current project
                        List<Map<String, dynamic>> projectCosts = costs
                            .where((cost) =>
                                cost['projectName'] == project['projectName'])
                            .toList();

                        // Calculate total income and expenses for the project
                        String? startUpCostString = project[
                            'startUpCost']; // assuming 'amount' is a string
                        int? startUpAmount;
                        if (startUpCostString != null) {
                          startUpAmount = int.tryParse(startUpCostString);
                        }

                        int totalIncome = 0;
                        int totalExpense = startUpAmount ?? 0;

                        for (var cost in projectCosts) {
                          String? amountString =
                              cost['amount']; // assuming 'amount' is a string
                          int? amount;
                          if (amountString != null) {
                            amount = int.tryParse(amountString);
                          }

                          if (amount != null) {
                            if (cost['expenseType'] == 'Income') {
                              totalIncome += amount;
                            } else {
                              totalExpense += amount;
                            }
                          }
                        }

                        // Create a ProjectBrain instance for the current project
                        ProjectBrain projectBrain = ProjectBrain(
                          expense: totalExpense,
                          income: totalIncome,
                        );

                        int financialPerformance = projectBrain.performance();
                        String financialPercentage =
                            projectBrain.percentage().toString();

                        return ReportsCard(
                          financialPerfomance: financialPerformance.toString(),
                          label: project['projectName'],
                          icon:
                              financialPerformance >= 0 ? kUpArrow : kDownArrow,
                          financialPercentage: financialPercentage,
                          iconColour: financialPerformance >= 0
                              ? kGreenColor
                              : kRedColor,
                          onButtonPressed: () {
                            return ChartsPage(
                              // passing the project name and startUpCost to the charts screen
                              projectName: project['projectName'],
                              costs: costs,
                            );
                          },
                        );
                      }).toList(),
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
            ),
          ),
        ],
      ),
    );
  }
}
