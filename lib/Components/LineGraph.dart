import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/Constants.dart';

class MyLineChart extends StatefulWidget {
  const MyLineChart({Key? key}) : super(key: key);

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  List<Color> gradientColors = [
    kGreenColor,
    kGreenColor,
  ];

  List<Color> expenseColor = [
    kRedColor,
    kRedColor,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.40,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 20,
              left: 10,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              showAvg ? avgData() : mainData(),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                fontSize: 12,
                //used to change the color of avg when pressed
                color: showAvg ? kDarkColor : Color(0xFFFF0075),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: kChartsTxtColor,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('JAN', style: TextStyle(fontSize: 10));
        break;
      case 2:
        text = const Text('FEB', style: TextStyle(fontSize: 10));
        break;
      case 3:
        text = const Text('MAR', style: TextStyle(fontSize: 10));
        break;
      case 4:
        text = const Text('APR', style: TextStyle(fontSize: 10));
        break;
      case 5:
        text = const Text('MAY', style: TextStyle(fontSize: 10));
        break;
      case 6:
        text = const Text('JUN', style: TextStyle(fontSize: 10));
        break;
      case 7:
        text = const Text('JUL', style: TextStyle(fontSize: 10));
        break;
      case 8:
        text = const Text('AUG', style: TextStyle(fontSize: 10));
        break;
      case 9:
        text = const Text('SEP', style: TextStyle(fontSize: 10));
        break;
      case 10:
        text = const Text('OCT', style: TextStyle(fontSize: 10));
        break;
      case 11:
        text = const Text('NOV', style: TextStyle(fontSize: 10));
        break;
      case 12:
        text = const Text('DEC', style: TextStyle(fontSize: 10));
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 10, color: kChartsTxtColor);
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 2:
        text = '20k';
        break;
      case 3:
        text = '30k';
        break;
      case 4:
        text = '40k';
        break;
      case 5:
        text = '50k';
      case 6:
        text = '60K';
        break;
      case 7:
        text = '70k';
        break;
      case 8:
        text = '80k';
        break;
      case 9:
        text = '90k';
        break;
      case 10:
        text = '100k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  // income and expense charts
  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      // used for changing the size of the graph before Return on Investment
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: 11,
      lineBarsData: [
        // Income Data
        LineChartBarData(
          spots: const [
            FlSpot(0, 7),
            FlSpot(1, 6),
            FlSpot(2, 8),
            FlSpot(3, 7.5),
            FlSpot(4, 2),
            FlSpot(5, 4),
            FlSpot(6, 5),
            FlSpot(7, 3),
            FlSpot(8, 8),
            FlSpot(9, 1),
            FlSpot(10, 5),
            FlSpot(11, 1),
            FlSpot(12, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
        // Expense Data
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(1, 2),
            FlSpot(2, 5),
            FlSpot(3, 3.1),
            FlSpot(4, 4),
            FlSpot(5, 3),
            FlSpot(6, 4),
            FlSpot(7, 3),
            FlSpot(8, 2),
            FlSpot(9, 5),
            FlSpot(10, 3.1),
            FlSpot(11, 4),
            FlSpot(12, 3),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: expenseColor,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors:
                  expenseColor.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: 11,
      lineBarsData: [
        // Income Data
        LineChartBarData(
          spots: const [
            FlSpot(0, 5.44),
            FlSpot(1, 5.44),
            FlSpot(2, 5.44),
            FlSpot(3, 5.44),
            FlSpot(4, 5.44),
            FlSpot(5, 5.44),
            FlSpot(6, 5.44),
            FlSpot(7, 5.44),
            FlSpot(8, 5.44),
            FlSpot(9, 5.44),
            FlSpot(10, 5.44),
            FlSpot(11, 5.44),
            FlSpot(12, 5.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
        // Expense Data
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(1, 3.44),
            FlSpot(2, 3.44),
            FlSpot(3, 3.44),
            FlSpot(4, 3.44),
            FlSpot(5, 3.44),
            FlSpot(6, 3.44),
            FlSpot(7, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9, 3.44),
            FlSpot(10, 3.44),
            FlSpot(11, 3.44),
            FlSpot(12, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: expenseColor[0], end: expenseColor[1])
                  .lerp(0.2)!,
              ColorTween(begin: expenseColor[0], end: expenseColor[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: expenseColor[0], end: expenseColor[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: expenseColor[0], end: expenseColor[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
