import 'package:flutter/material.dart';
import 'package:project_manager/Components/LineGraph.dart';
import 'package:project_manager/Components/CustomButton.dart';
import 'package:project_manager/Constants.dart';
import 'package:project_manager/Components/BarChart.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:project_manager/ChartData.dart';

class ChartsPage extends StatefulWidget {
  // passsing the project name to the line chart
  ChartsPage({required this.projectName, required this.costs});

  final String projectName;

  final dynamic costs;

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  late double maximumValue;
  late List<dynamic> range;
  late Map chartSpots;

  void getCurrentCost() {
    String targetProjectName = widget.projectName;
    List<Map<String, dynamic>> matchingCosts = [];

    // Iterate through the list of maps
    for (var cost in widget.costs) {
      // Access the projectName in the current map
      String projectName = cost['projectName'];

      // Check if the projectName matches the targetProjectName
      if (projectName == targetProjectName) {
        // Add the current cost to the list of matching costs
        matchingCosts.add(cost);
      }
    }

    // Create an instance of ChartData
    ChartData chartData = ChartData();
    // Retrieve the max data value based on the matching costs
    double maxDataValue = chartData.maxDataValue(matchingCosts);
    List ChartRange = chartData.calculateRange(maxDataValue);
    Map Spots = chartData.chartPoints(matchingCosts);

    maximumValue = maxDataValue;
    range = ChartRange;
    chartSpots = Spots;
  }

  @override
  void initState() {
    super.initState();
    // Call getCurrentCost when the state is initialized
    getCurrentCost();
  }

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
                  MyLineChart(
                    projectName: widget.projectName,
                    maxValue: maximumValue ?? 0.0,
                    range: range ?? [],
                    chartSpots: chartSpots,
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
