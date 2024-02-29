import 'package:flutter/material.dart';
import 'package:project_manager/Constants.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:project_manager/Components/CustomButton.dart';

class ProjectDetails extends StatefulWidget {
  ProjectDetails(
      {required this.projectName,
      required this.description,
      required this.startDate,
      required this.startUpCost});

  final String projectName;
  String description;
  String startDate;
  String startUpCost;

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLightColor,
      body: SafeArea(
        child: DelayedDisplay(
          delay: Duration(microseconds: 200),
          child: ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    widget.projectName,
                    style: TextStyle(
                      fontSize: kTitleFontSize,
                      color: kBottomAppColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kBgLightColor,
                      borderRadius: BorderRadius.circular(
                          20), // Optionally, set border radius for rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: kBottomAppColor.withOpacity(
                              0.3), // Set shadow color with 30% opacity
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2), // Set shadow offset
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
                            'Start Date: ' + widget.startDate,
                            style: TextStyle(
                              fontSize: kNormalFontSize,
                              color: kBottomAppColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Start Up Cost: ' + widget.startUpCost,
                            style: TextStyle(
                              fontSize: kNormalFontSize,
                              color: kBottomAppColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
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
                CustomButton(
                  txtColor: kLightColor,
                  bgColor: kRedColor,
                  callBackFunction: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  label: 'Delete',
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
      ),
    );
  }
}

// formatting the start up cost to currency
// NumberFormat currencyFormatter =
//     NumberFormat.currency(locale: 'en_US', symbol: '');
// String formattedStartUpCost =
//     currencyFormatter.format(project['startUpCost']);
