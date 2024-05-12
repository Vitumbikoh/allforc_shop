import 'package:flutter/material.dart';

class InsightsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insights'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildInsightCard('Total Sales', '100', Icons.attach_money),
          _buildInsightCard('Total Gas Refills', '50', Icons.local_gas_station),
          _buildInsightCard('Average Sales Per Day', '10', Icons.show_chart),
          _buildInsightCard('Top Selling Product', 'Product X', Icons.star),
          _buildInsightCard('Busiest Day', 'Monday', Icons.calendar_today),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String value, IconData iconData) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(iconData),
        title: Text(title),
        trailing: Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
