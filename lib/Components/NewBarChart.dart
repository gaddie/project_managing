import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:project_manager/Constants.dart';

class BarChartApp extends StatefulWidget {
  BarChartApp({required this.weeklyIncome, required this.weeklyExpense});

  final List<double> weeklyIncome;
  final List<double> weeklyExpense;

  @override
  _BarChartAppState createState() => _BarChartAppState();
}

class _BarChartAppState extends State<BarChartApp> {
  late List<_ChartData> expense;
  late List<_ChartData> income;
  late TooltipBehavior _tooltip;
  late double maxY;
  late double interval;

  final List<String> daysOfWeek = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  @override
  void initState() {
    expense = List.generate(
      widget.weeklyExpense.length,
      (index) => _ChartData(daysOfWeek[index], widget.weeklyExpense[index]),
    );

    income = List.generate(
      widget.weeklyIncome.length,
      (index) => _ChartData(daysOfWeek[index], widget.weeklyIncome[index]),
    );

    double maxExpense =
        widget.weeklyExpense.reduce((curr, next) => curr > next ? curr : next);
    double maxIncome =
        widget.weeklyIncome.reduce((curr, next) => curr > next ? curr : next);
    maxY = (maxExpense > maxIncome) ? maxExpense : maxIncome;
    interval = maxY / 10;

    // Check if maxY or interval is zero, if so, set them to default values
    if (maxY == 0) maxY = 100;
    if (interval == 0) interval = 10;

    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: maxY + 100,
        interval: interval,
      ),
      tooltipBehavior: _tooltip,
      series: <CartesianSeries<_ChartData, String>>[
        ColumnSeries<_ChartData, String>(
          dataSource: expense,
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y,
          name: 'Expense',
          color: kRedColor, // Adjust color as needed
        ),
        ColumnSeries<_ChartData, String>(
          dataSource: income,
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y,
          name: 'Income',
          color: kGreenColor, // Adjust color as needed
        )
      ],
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
