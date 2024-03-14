import 'package:flutter/material.dart';
import 'package:project_manager/Components/LineGraph.dart';
import 'package:project_manager/Components/CustomButton.dart';
import 'package:project_manager/Constants.dart';
import 'package:project_manager/Components/BarChart.dart';
import 'package:project_manager/ChartData.dart';
import 'package:project_manager/NewChart.dart';

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
  bool isLoading = false;
  List incomeWeekData = [];
  List expenseWeekData = [];
  List<double> incomeSpotsData = [];
  List<double> expenseSpotsData = [];

  void getCurrentCost() async {
    setState(() {
      isLoading = true;
    });
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

    List<List<List<double>>> days = chartData.getCostOfWeek(matchingCosts);
    // Access the income data
    // List<List<double>> incomeData = days[0];
    //
    // // Access the expense data
    // List<List<double>> expenseData = days[1];

    // Now you can use incomeData and expenseData separately
    // print('Income Data:');
    // print(incomeData);
    //
    // print('Expense Data:');
    // print(expenseData);
    // // print(days[1]);

    int currentWeekNumber = chartData.getISOWeekNumber(DateTime.now());

    // Access the income data for the current week
    List<double> currentWeekIncomeData = days[0][currentWeekNumber];
    List<double> currentWeekExpenseData = days[1][currentWeekNumber];

    maximumValue = maxDataValue;
    range = ChartRange;
    chartSpots = Spots;
    incomeWeekData = currentWeekIncomeData.cast<List<double>>();
    expenseWeekData = currentWeekExpenseData.cast<List<double>>();

    Map<String, List<double>> pointsData = chartData.points(matchingCosts);
    // Access the income spots
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

    // Introduce a slight delay before setting isLoading to false
    await Future.delayed(Duration(milliseconds: 1200));

    // Set isLoading to false after the data processing is completed
    setState(() {
      isLoading = false;
    });
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BarChartSample2(
                  incomeData: incomeWeekData,
                  expenseData: expenseWeekData,
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
                // Show a loading indicator
                // MyLineChart(
                //   projectName: widget.projectName,
                //   maxValue: maximumValue ?? 0.0,
                //   range: range ?? [],
                //   chartSpots: chartSpots,
                //   isLoading: isLoading,
                // ),
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
            )
          ],
        ),
      ),
    );
  }
}
