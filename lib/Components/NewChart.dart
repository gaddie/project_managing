import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:project_manager/Constants.dart';

class ChartApp extends StatefulWidget {
  ChartApp({required this.incomeData, required this.expenseData});
  final List incomeData;
  final List expenseData;

  @override
  _ChartAppState createState() => _ChartAppState();
}

class _ChartAppState extends State<ChartApp> {
  late List<_SalesData> income;
  late List<_SalesData> expense;

  @override
  void initState() {
    super.initState();
    // Update the income list
    income = List<_SalesData>.generate(
      widget.incomeData.length,
      (index) => _SalesData(
        _getMonthName(index + 1),
        widget.incomeData[index],
      ),
    );

    // Update the expense list
    expense = List<_SalesData>.generate(
      widget.expenseData.length,
      (index) => _SalesData(
        _getMonthName(index + 1),
        widget.expenseData[index],
      ),
    );
  }

  String _getMonthName(int month) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      tooltipBehavior: TooltipBehavior(enable: true, color: kBottomAppColor),
      series: <CartesianSeries<_SalesData, String>>[
        LineSeries<_SalesData, String>(
          name: 'Income',
          color: kGreenColor,
          dataSource: income,
          xValueMapper: (_SalesData sales, _) => sales.year,
          yValueMapper: (_SalesData sales, _) => sales.sales,
          dataLabelSettings: DataLabelSettings(isVisible: false),
        ),
        LineSeries<_SalesData, String>(
          name: 'Expense',
          color: kRedColor,
          dataSource: expense,
          xValueMapper: (_SalesData sales, _) => sales.year,
          yValueMapper: (_SalesData sales, _) => sales.sales,
          dataLabelSettings: DataLabelSettings(isVisible: false),
        ),
      ],
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
