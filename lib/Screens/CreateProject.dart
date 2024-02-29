import 'package:flutter/material.dart';
import 'package:project_manager/Constants.dart';
import 'package:project_manager/Components/InputField.dart';
import 'package:project_manager/Components/TextField.dart';
import 'package:project_manager/Components/CustomButton.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_manager/Components/DateField.dart';
import 'package:project_manager/Components/MessageHandler.dart';

class CreateProject extends StatefulWidget {
  const CreateProject({Key? key}) : super(key: key);

  @override
  State<CreateProject> createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  final _firestore = FirebaseFirestore.instance;

  String projectName = '';
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  DateTime? startDate;
  String startUpCost = '';
  String description = '';
  bool errorMessage = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        // print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLightColor,
      appBar: AppBar(
        backgroundColor: kBgLightColor,
        title: Text(
          'Create Project',
          style: TextStyle(color: kBottomAppColor),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kDarkColor,
          ),
          onPressed: () {
            Navigator.pop(
                context); // This will pop the current page off the stack
          },
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: DelayedDisplay(
                delay: Duration(microseconds: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InputField(
                      label: 'Project Name',
                      errorText: errorMessage ? 'This field is required' : null,
                      onChanged: (value) {
                        projectName = value;
                      },
                    ),
                    InputField(
                      label: 'Start Up cost',
                      errorText: errorMessage ? 'This field is required' : null,
                      integerOnly: true,
                      onChanged: (value) {
                        startUpCost = value;
                      },
                    ),
                    DateField(
                      label: 'Start Date',
                      onChanged: (DateTime selectedDate) {
                        setState(() {
                          startDate = selectedDate;
                        });
                      },
                    ),
                    ProjectForm(
                      onChanged: (value) {
                        setState(() {
                          description = value;
                        });
                      },
                    ),
                    CustomButton(
                      txtColor: kLightColor,
                      bgColor: kBottomAppColor,
                      callBackFunction: () {
                        setState(() {
                          if (projectName.isNotEmpty ||
                              startUpCost.isNotEmpty ||
                              description.isNotEmpty) {
                            if (startDate == null) {
                              startDate = DateTime.now();
                            }
                            errorMessage = false;
                            _firestore.collection('projects').add({
                              'user': loggedInUser.email,
                              'projectName': projectName,
                              'description': description,
                              'startUpCost': startUpCost,
                              'startDate': startDate,
                            });
                            MessageHandler.showMessage(context,
                                'Your has been created', kBottomAppColor);
                            Navigator.pop(context);
                          } else {
                            errorMessage = true;
                          }
                        });
                      },
                      label: 'Create Project',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
