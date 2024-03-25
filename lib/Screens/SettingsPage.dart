import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_manager/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_manager/Components/MessageHandler.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => SettingsState();
}

class SettingsState extends State<SettingsPage> {
  bool Dark = false;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late List<Map<String, dynamic>> projects = [];
  final _firestore = FirebaseFirestore.instance;
  late List<Map<String, dynamic>> costs = [];
  bool showSpinner = false;
  bool isDelete = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getProjects();
    getCosts();
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

  // getting all the projects of the current user
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

  // getting all the costs of the current user
  void getCosts() async {
    await for (var snapshot in _firestore.collection('costs').snapshots()) {
      List<Map<String, dynamic>> filteredCosts = [];
      for (var project in snapshot.docs) {
        Map<String, dynamic> projectData =
            project.data() as Map<String, dynamic>;
        if (projectData['user'] == loggedInUser.email) {
          filteredCosts.add(projectData);
        }
      }
      setState(() {
        costs = filteredCosts;
      });
    }
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(
          Icons.brightness_2,
          color: Colors.white,
        );
      }
      return const Icon(Icons.sunny);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLightColor,
      body: SafeArea(
        child: ListView(children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: kBottomAppColor,
                        size: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: kTitleFontSize,
                          color: kBottomAppColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Account Management',
                  style: TextStyle(color: kDarkGrey),
                ),
              ),
              // Account management tab
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: kLightColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: kGreyColor,
                        blurRadius: 10.0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: kDarkGrey,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Username',
                                  style: TextStyle(
                                      fontSize: kNormalFontSize,
                                      color: kDarkGrey),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: kDarkGrey,
                              ),
                              onPressed: () {},
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.security,
                                  color: kDarkGrey,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Change Password',
                                  style: TextStyle(
                                      fontSize: kNormalFontSize,
                                      color: kDarkGrey),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: kDarkGrey,
                              ),
                              onPressed: () {},
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: kDarkGrey,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Delete Account',
                                  style: TextStyle(
                                      fontSize: kNormalFontSize,
                                      color: kDarkGrey),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: kDarkGrey,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Account'),
                                      content: Text(
                                          'Are you sure you want to delete your account?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () async {
                                            // Delete all projects associated with the current user
                                            for (var project in projects) {
                                              await _firestore
                                                  .collection('projects')
                                                  .doc(project['projectId'])
                                                  .delete();
                                            }

                                            // Delete all costs associated with the current user
                                            for (var cost in costs) {
                                              await _firestore
                                                  .collection('costs')
                                                  .doc(cost['id'])
                                                  .delete();
                                            }

                                            // Delete the current user
                                            try {
                                              await loggedInUser.delete();
                                              Navigator.pop(context);
                                              print(
                                                  'User deleted successfully.');
                                            } catch (e) {
                                              print('Error deleting user: $e');
                                            }
                                            MessageHandler.showMessage(
                                                context,
                                                'Your have deleted your account',
                                                kBottomAppColor);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Delete'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Back'),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // dark mode tab
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: kLightColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: kGreyColor,
                        blurRadius: 10.0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.mode,
                                  color: kDarkGrey,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Dark Mode',
                                  style: TextStyle(
                                      fontSize: kNormalFontSize,
                                      color: kDarkGrey),
                                ),
                              ],
                            ),
                            Switch(
                              activeColor: Colors.grey,
                              activeTrackColor: kGreyColor,
                              thumbIcon: thumbIcon,
                              value: Dark,
                              onChanged: (bool value) {
                                setState(() {
                                  Dark = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Help tab
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: kLightColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: kGreyColor,
                        blurRadius: 10.0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.question_mark,
                                  color: kDarkGrey,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Help',
                                  style: TextStyle(
                                      fontSize: kNormalFontSize,
                                      color: kDarkGrey),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: kDarkGrey,
                              ),
                              onPressed: () {},
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Settings is not yet available')
            ],
          ),
        ]),
      ),
    );
  }
}
