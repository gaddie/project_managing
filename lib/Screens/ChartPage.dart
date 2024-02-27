import 'package:flutter/material.dart';
import 'package:project_manager/Components/LineGraph.dart';
import 'package:project_manager/Components/CustomButton.dart';
import 'package:project_manager/Constants.dart';
import 'package:project_manager/Components/BarChart.dart';
import 'package:delayed_display/delayed_display.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({Key? key}) : super(key: key);

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLightColor,
      body: SafeArea(
        child: ListView(
          children: [
            DelayedDisplay(
              delay: Duration(milliseconds: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BarChartSample2(),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Text(
                        'Total monthly Income and Expense',
                        style: TextStyle(fontSize: 18, color: kChartsTxtColor),
                      ),
                    ),
                  ),
                  MyLineChart(),
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
