import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/Constants.dart';
import 'package:project_manager/Screens/ChartPage.dart';
import 'package:project_manager/Components/ReportsCard.dart';
import 'package:project_manager/Components/CustomButton.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLightColor,
      body: SafeArea(
        child: ListView(
          children: [
            DelayedDisplay(
              delay: Duration(microseconds: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ReportsCard(
                    financialPerfomance: '20,000',
                    label: 'Project Name',
                    icon: kUpArrow,
                    financialPercentage: '5',
                    iconColour: kGreenColor,
                    onButtonPressed: () {
                      return ChartsPage();
                    },
                  ),
                  ReportsCard(
                    financialPerfomance: '5,000',
                    label: 'Project Name',
                    icon: kDownArrow,
                    financialPercentage: '20',
                    iconColour: kRedColor,
                    onButtonPressed: () {
                      return ChartsPage();
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
            )
          ],
        ),
      ),
    );
  }
}
