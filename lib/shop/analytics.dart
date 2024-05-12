import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sales Analytics',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Container(
              height: 300.0,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getChartData(),
                      isCurved: true,
                      barWidth: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _getChartData() {
    // Example sales data
    final List<double> salesData = [10, 20, 15, 30, 25];

    // Create chart data
    List<FlSpot> chartData = [];
    for (int i = 0; i < salesData.length; i++) {
      chartData.add(FlSpot(i.toDouble(), salesData[i]));
    }
    return chartData;
  }
}
