import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

class ChartData {
  //get the max data value
  double maxDataValue(costValue) {
    // Initialize lists to hold income and expense data for each month
    List<double> incomeData = List.filled(12, 0.0);
    List<double> expenseData = List.filled(12, 0.0);

    // Parse costs and organize data by month
    for (var cost in costValue) {
      DateTime date = cost['date'].toDate();
      int month = date.month - 1;

      if (cost['expenseType'] == 'Income') {
        incomeData[month] += int.parse(cost['amount']);
      } else {
        expenseData[month] += int.parse(cost['amount']);
      }
    }

    List<FlSpot> incomeSpots = List.generate(
        12, (index) => FlSpot(index.toDouble(), incomeData[index]));
    List<FlSpot> expenseSpots = List.generate(
        12, (index) => FlSpot(index.toDouble(), expenseData[index]));

    double maxDataValue = incomeData.reduce(max);
    maxDataValue = max(maxDataValue, expenseData.reduce(max));
    return maxDataValue;
  }

  // calculating the range of the chart
  List<double> calculateRange(double maxValue) {
    List<double> points = [];
    double roundedMaxValue =
        (maxValue / 100).ceil() * 100; // Round to the nearest hundredth

    double segment = roundedMaxValue / 10;

    for (int i = 1; i <= 10; i++) {
      points.add(segment * i);
    }
    return points;
  }

  // Get the FlSpots for income and expense data
  Map<String, List<FlSpot>> chartPoints(List<dynamic> costValue) {
    List<double> incomeData = List.filled(12, 0.0);
    List<double> expenseData = List.filled(12, 0.0);

    // Parse costs and organize data by month
    for (var cost in costValue) {
      DateTime date = cost['date'].toDate();
      int month = date.month - 1;

      if (cost['expenseType'] == 'Income') {
        incomeData[month] += double.parse(cost['amount']);
      } else {
        expenseData[month] += double.parse(cost['amount']);
      }
    }

    List<FlSpot> incomeSpots = List.generate(
        12, (index) => FlSpot(index.toDouble(), incomeData[index]));
    List<FlSpot> expenseSpots = List.generate(
        12, (index) => FlSpot(index.toDouble(), expenseData[index]));

    return {
      'incomeSpots': incomeSpots,
      'expenseSpots': expenseSpots,
    };
  }
}
