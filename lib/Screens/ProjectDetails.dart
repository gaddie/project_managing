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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLightColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 100,
              pinned: true,
              iconTheme: IconThemeData(
                color: kBottomAppColor, // Change the back arrow color
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                title: Text(
                  widget.projectName,
                  style: TextStyle(color: kBottomAppColor),
                ),
                background: Container(
                  color: kLightColor,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: DelayedDisplay(
                delay: Duration(microseconds: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // start date
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 10, left: 10, right: 10),
                            child: Container(
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            'Start Date',
                                            style: TextStyle(
                                              fontSize: kNormalFontSize,
                                              color: kBottomAppColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Center(
                                          child: Text(
                                            ' ${widget.startDate}',
                                            style: TextStyle(
                                              fontSize: kNormalFontSize,
                                              color: kBottomAppColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // start up cost
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, right: 10),
                            child: Container(
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Start Up Cost',
                                        style: TextStyle(
                                          fontSize: kNormalFontSize,
                                          color: kBottomAppColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Center(
                                      child: Text(
                                        '${widget.startUpCost}',
                                        style: TextStyle(
                                          fontSize: kNormalFontSize,
                                          color: kBottomAppColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // description
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Container(
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
                                    color: kBottomAppColor,
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
                                    color: kBottomAppColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // delete button
                    CustomButton(
                      txtColor: kLightColor,
                      bgColor: kRedColor,
                      callBackFunction: () {
                        // Call deleteProject function when delete button is pressed
                        deleteProject(context);
                      },
                      label: 'Delete',
                    ),
                    CustomButton(
                      txtColor: kLightColor,
                      bgColor: kBottomAppColor,
                      callBackFunction: () {
                        Navigator.pop(context);
                      },
                      label: 'Back',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
