import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChartData {
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

  Map<String, List<double>> points(List<dynamic> costValue) {
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

    return {
      'incomeSpots': incomeData,
      'expenseSpots': expenseData,
    };
  }

  List<List<List<double>>> getCostOfWeek(List<Map<String, dynamic>> costValue) {
    List<List<double>> incomeData =
        List.generate(53, (_) => List.filled(7, 0.0));
    List<List<double>> expenseData =
        List.generate(53, (_) => List.filled(7, 0.0));

    for (var cost in costValue) {
      Timestamp timestamp = cost['date'];
      DateTime date = timestamp.toDate();
      int weekNumber = getISOWeekNumber(date); // Calculate the ISO week number

      int day =
          date.weekday - 1; // Get the day of the week (0 - Monday, 6 - Sunday)

      if (cost['expenseType'] == 'Income') {
        incomeData[weekNumber][day] += double.parse(cost['amount']);
      } else {
        expenseData[weekNumber][day] += double.parse(cost['amount']);
      }
    }

    return [incomeData, expenseData];
  }

// Function to calculate the ISO week number
  int getISOWeekNumber(DateTime date) {
    DateTime thursday = date.subtract(Duration(days: date.weekday - 1));
    DateTime firstThursday = DateTime(thursday.year, 1, 4);
    int weekNumber =
        1 + ((thursday.difference(firstThursday).inDays) / 7).floor();

    if (weekNumber == 53 && firstThursday.month != 12) {
      weekNumber = 1;
    }
    return weekNumber;
  }
}

class _SalesData {
  final String year;
  final double sales;

  _SalesData(this.year, this.sales);
}
