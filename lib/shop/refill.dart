import 'package:flutter/material.dart';

class RefillPage extends StatefulWidget {
  @override
  _RefillPageState createState() => _RefillPageState();
}

class _RefillPageState extends State<RefillPage> {
  final TextEditingController _cylinderTypeController = TextEditingController();
  final TextEditingController _initialWeightController =
      TextEditingController();
  final TextEditingController _finalWeightController = TextEditingController();
  final TextEditingController _refilledAmountController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gas Refill'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _cylinderTypeController,
              decoration: InputDecoration(labelText: 'Cylinder Type'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _initialWeightController,
              decoration: InputDecoration(labelText: 'Initial Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _finalWeightController,
              decoration: InputDecoration(labelText: 'Final Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _refilledAmountController,
              decoration: InputDecoration(labelText: 'Refilled Amount (kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _recordRefill();
              },
              child: Text('Record Refill'),
            ),
          ],
        ),
      ),
    );
  }

  void _recordRefill() {
    final String cylinderType = _cylinderTypeController.text;
    final double initialWeight = double.parse(_initialWeightController.text);
    final double finalWeight = double.parse(_finalWeightController.text);
    final double refilledAmount = double.parse(_refilledAmountController.text);

    // You can perform validation and further processing here
    // For now, we'll just print the entered details
    print('Cylinder Type: $cylinderType');
    print('Initial Weight: $initialWeight kg');
    print('Final Weight: $finalWeight kg');
    print('Refilled Amount: $refilledAmount kg');

    // After processing, you can save the refill details to the database
  }
}
