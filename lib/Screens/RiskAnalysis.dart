import 'package:flutter/material.dart';
import 'package:project_manager/Constants.dart';
import 'package:project_manager/Components/ReusableContainer.dart';
import 'package:project_manager/Screens/ProjectDetails.dart';
import 'package:project_manager/Components/CustomButton.dart';

class RiskAnalysis extends StatefulWidget {
  const RiskAnalysis({Key? key}) : super(key: key);

  @override
  State<RiskAnalysis> createState() => _RiskAnalysisState();
}

class _RiskAnalysisState extends State<RiskAnalysis> {
  List<String> riskProfitability = [
    'Low Risk',
    'High Profit Potential',
    'Moderate Risk',
    'Moderate Profit Potential',
    'High Risk',
    'Low Profit Potential'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLightColor,
      body: SafeArea(
        child: ListView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'Risk Analysis',
                  style: TextStyle(
                    color: kBottomAppColor,
                    fontSize: kTitleFontSize,
                  ),
                ),
              ),
              ReusableContainer(
                label: 'Project 3',
                color: kGreenColor,
                condition: riskProfitability[1],
                onButtonPressed: () {
                  return ProjectDetails();
                },
              ),
              ReusableContainer(
                label: 'Project 2',
                color: kRedColor,
                condition: riskProfitability[4],
                onButtonPressed: () {
                  return ProjectDetails();
                },
              ),
              ReusableContainer(
                label: 'Project 2',
                condition: riskProfitability[5],
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
