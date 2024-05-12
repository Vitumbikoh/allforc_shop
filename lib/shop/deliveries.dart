import 'package:flutter/material.dart';

class DeliveriesPage extends StatefulWidget {
  @override
  _DeliveriesPageState createState() => _DeliveriesPageState();
}

class _DeliveriesPageState extends State<DeliveriesPage> {
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _deliveryAddressController =
      TextEditingController();
  final TextEditingController _deliveryFeeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deliveries'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _customerNameController,
              decoration: InputDecoration(labelText: 'Customer Name'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _deliveryAddressController,
              decoration: InputDecoration(labelText: 'Delivery Address'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _deliveryFeeController,
              decoration: InputDecoration(labelText: 'Delivery Fee'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _recordDelivery();
              },
              child: Text('Record Delivery'),
            ),
          ],
        ),
      ),
    );
  }

  void _recordDelivery() {
    final String customerName = _customerNameController.text;
    final String deliveryAddress = _deliveryAddressController.text;
    final double deliveryFee = double.parse(_deliveryFeeController.text);

    // You can perform validation and further processing here
    // For now, we'll just print the entered details
    print('Customer Name: $customerName');
    print('Delivery Address: $deliveryAddress');
    print('Delivery Fee: $deliveryFee');

    // After processing, you can save the delivery details to the database
  }
}
