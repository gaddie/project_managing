import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_manager/Constants.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:project_manager/Components/CustomButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_manager/Components/MessageHandler.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_manager/Components/ExpenseCard.dart';

class ProjectDetails extends StatefulWidget {
  ProjectDetails({
    required this.projectId,
    required this.projectName,
    required this.description,
    required this.startDate,
    required this.startUpCost,
  });

  final String projectId;
  final String projectName;
  final String description;
  final String startDate;
  final String startUpCost;

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late List<Map<String, dynamic>> costs = [];
  final _firestore = FirebaseFirestore.instance;

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

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getCosts();
  }

  // getting the costs from firebase
  void getCosts() async {
    await for (var snapshot in _firestore.collection('costs').snapshots()) {
      List<Map<String, dynamic>> filteredCosts = [];
      for (var project in snapshot.docs) {
        Map<String, dynamic> projectData =
            project.data() as Map<String, dynamic>;
        if (projectData['user'] == loggedInUser.email &&
            projectData['projectName'] == widget.projectName) {
          // Include document ID along with other cost details
          Map<String, dynamic> costDetails = {...projectData, 'id': project.id};
          filteredCosts.add(costDetails);
        }
      }
      setState(() {
        costs = filteredCosts;
      });
    }
  }

  // Function to delete the project
  void deleteProject(BuildContext context) async {
    setState(() {
      showSpinner = true;
    });
    try {
      // Delete project
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .delete();

      // Delete costs associated with the project
      QuerySnapshot costSnapshot = await FirebaseFirestore.instance
          .collection('costs')
          .where('user', isEqualTo: loggedInUser.email)
          .where('projectName', isEqualTo: widget.projectName)
          .get();
      costSnapshot.docs.forEach((doc) async {
        await doc.reference.delete();
      });

      // Check if the context is still valid before showing the message
      if (Navigator.canPop(context)) {
        MessageHandler.showMessage(
            context, 'Your project has been deleted', kBottomAppColor);
        Navigator.pop(context); // Navigate back after deletion
      }
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      print('Error deleting project: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error in deleting this project'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void deleteCost(String costId) async {
    try {
      await FirebaseFirestore.instance.collection('costs').doc(costId).delete();
      setState(() {
        costs.removeWhere((cost) => cost['id'] == costId);
      });
      print('Cost deleted successfully');
    } catch (e) {
      print('Error deleting cost: $e');
      // Handle error, show message, etc.
    }
  }

  void editCost(String costId, Map<String, dynamic> newData) async {
    try {
      await FirebaseFirestore.instance
          .collection('costs')
          .doc(costId)
          .update(newData);
      int index = costs.indexWhere((cost) => cost['id'] == costId);
      if (index != -1) {
        setState(() {
          costs[index].addAll(newData);
        });
        print('Cost edited successfully');
      } else {
        print('Cost not found');
      }
    } catch (e) {
      print('Error editing cost: $e');
      // Handle error, show message, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLightColor,
      appBar: AppBar(
        title: Text(
          widget.projectName,
          style: TextStyle(color: kBottomAppColor),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: DelayedDisplay(
          delay: Duration(microseconds: 200),
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: kBgLightColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: kGreyColor.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Start Date',
                                style: TextStyle(color: kDarkGrey),
                              ),
                              Text('${widget.startDate}'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Start up cost',
                                style: TextStyle(color: kDarkGrey),
                              ),
                              Text('${widget.startUpCost}'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (widget.description.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: kLightColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: kGreyColor.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 10, left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    'Description',
                                    style: TextStyle(
                                      fontSize: kNormalFontSize,
                                      color: kDarkGrey,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 10, bottom: 20),
                                  child: Text(
                                    widget.description,
                                    style: TextStyle(
                                      fontSize: kNormalFontSize,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var cost in costs)
                    ExpenseCard(
                      color: kDarkGrey,
                      amount: cost['amount'],
                      date:
                          '${cost['date'].toDate().day}/${cost['date'].toDate().month}/${cost['date'].toDate().year}',
                      label: cost['expenseType'],
                      iconColor: cost['expenseType'] == 'Income'
                          ? kGreenColor
                          : kRedColor,
                      icon: cost['expenseType'] == 'Income'
                          ? kUpTrend
                          : kDownTrend,
                      onDelete: () {
                        deleteCost(cost['id']);
                      },
                      cost: costs,
                      costId: cost['id'],
                      expenseType: cost['expenseType'],
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 2.5),
                          child: CustomButton(
                            txtColor: kLightColor,
                            bgColor: kRedColor,
                            callBackFunction: () {
                              // Call deleteProject function when delete button is pressed
                              deleteProject(context);
                            },
                            label: 'Delete Project',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 2.5, right: 10),
                          child: CustomButton(
                            txtColor: kLightColor,
                            bgColor: kBottomAppColor,
                            callBackFunction: () {
                              Navigator.pop(context);
                            },
                            label: 'Back',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
