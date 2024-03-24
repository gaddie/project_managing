import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/Components/CustomButton.dart';
import 'package:project_manager/Constants.dart';
import 'package:project_manager/ChartData.dart';
import 'package:project_manager/Components/NewChart.dart';
import 'package:project_manager/Components/NewBarChart.dart';
import 'package:project_manager/Components/RoundButton.dart';

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
  int weekNumber = 0;

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

    List<List<List<double>>> days = chartData.getCostOfWeek(matchingCosts);

    int currentWeekNumber = chartData.getISOWeekNumber(DateTime.now());

    weekNumber = currentWeekNumber;
    // Access the income data for the current week
    List<double> currentWeekIncomeData = days[0][weekNumber];
    List<double> currentWeekExpenseData = days[1][weekNumber];
    weekNumber = currentWeekNumber;

    incomeWeekData = currentWeekIncomeData;
    expenseWeekData = currentWeekExpenseData;

    setState(() {});

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
                        'weekly spend',
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: CustomButton(
                      txtColor: kLightColor,
                      bgColor: kBottomAppColor,
                      callBackFunction: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      label: 'Back',
                    ),
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

// RoundButton(
// icon: Icons.add,
// callBackFunction: () {
// setState(() {
// weekNumber += 1;
// });
// },
// ),
