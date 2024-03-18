import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/Components/CustomButton.dart';
import 'package:project_manager/Constants.dart';
import 'package:project_manager/ChartData.dart';
import 'package:project_manager/Components/NewChart.dart';
import 'package:project_manager/Components/NewBarChart.dart';

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
  List<double> incomeWeekData = [];
  List<double> expenseWeekData = [];
  List<double> incomeSpotsData = [];
  List<double> expenseSpotsData = [];

  void getCurrentCost() async {
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
    // double maxDataValue = chartData.maxDataValue(matchingCosts);
    // List ChartRange = chartData.calculateRange(maxDataValue);
    // Map Spots = chartData.chartPoints(matchingCosts);

    List<List<List<double>>> days = chartData.getCostOfWeek(matchingCosts);

    int currentWeekNumber = chartData.getISOWeekNumber(DateTime.now());

    // Access the income data for the current week
    List<double> currentWeekIncomeData = days[0][currentWeekNumber];
    List<double> currentWeekExpenseData = days[1][currentWeekNumber];

    // maximumValue = maxDataValue;
    // range = ChartRange;
    // chartSpots = Spots;
    incomeWeekData = currentWeekIncomeData;
    expenseWeekData = currentWeekExpenseData;

    Map<String, List<double>> pointsData = chartData.points(matchingCosts);

    // Access the income spots
    List<double>? incomeSpots = pointsData['incomeSpots'];

    // Access the expense spots
    List<double>? expenseSpots = pointsData['expenseSpots'];

    // Assign the data
    if (incomeSpots != null && expenseSpots != null) {
      // Assign the data
      incomeSpotsData = incomeSpots;
      expenseSpotsData = expenseSpots;
    }
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
              delay: Duration(microseconds: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Text(
                        'Total weekly spend',
                        style: TextStyle(fontSize: 18, color: kChartsTxtColor),
                      ),
                    ),
                  ),
                  BarChartApp(
                    weeklyExpense: expenseWeekData,
                    weeklyIncome: incomeWeekData,
                  ),
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
                  ChartApp(
                    incomeData: incomeSpotsData,
                    expenseData: expenseSpotsData,
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
