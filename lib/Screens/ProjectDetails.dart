import 'package:flutter/material.dart';
import 'package:project_manager/Constants.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:project_manager/Components/CustomButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_manager/Components/MessageHandler.dart';

class ProjectDetails extends StatelessWidget {
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

  // Function to delete the project
  void deleteProject(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectId)
          .delete();
      MessageHandler.showMessage(
          context, 'Your project has been deleted', kBottomAppColor);
      Navigator.pop(context); // Navigate back after deletion
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            iconTheme: IconThemeData(
              color: kBottomAppColor, // Change the back arrow color
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              title: Text(
                projectName,
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kBgLightColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: kBottomAppColor.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Date: $startDate',
                              style: TextStyle(
                                fontSize: kNormalFontSize,
                                color: kBottomAppColor,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Start Up Cost: $startUpCost',
                              style: TextStyle(
                                fontSize: kNormalFontSize,
                                color: kBottomAppColor,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Description:',
                              style: TextStyle(
                                fontSize: kNormalFontSize,
                                color: kBottomAppColor,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                description,
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
    );
  }
}
