import 'package:flutter/material.dart';
import '../models/models.dart';
import 'gas_fill_dao.dart';

class CustomerCylinderForm extends StatefulWidget {
  final ShopCylinder shopCylinder;
  final String cylinderName; // Add cylinderName field
  final VoidCallback onUpdate;

  const CustomerCylinderForm(
      this.shopCylinder, this.cylinderName, // Pass cylinderName
      {required this.onUpdate,
      super.key});

  @override
  State<CustomerCylinderForm> createState() => _CustomerCylinderFormState();
}

class _CustomerCylinderFormState extends State<CustomerCylinderForm> {
  final GasFillDao _dao = GasFillDao();
  final _formKey = GlobalKey<FormState>();
  final _tareMassController = TextEditingController();
  final _gasAmountController = TextEditingController();
  final _totalMassController = TextEditingController();

  late double _tareMass;
  late double _gasAmount;
  late double _totalMass;

  @override
  void initState() {
    super.initState();
    _tareMassController.addListener(_updateTotalMass);
    _gasAmountController.addListener(_updateTotalMass);
  }

  @override
  void dispose() {
    _tareMassController.removeListener(_updateTotalMass);
    _tareMassController.dispose();
    _gasAmountController.removeListener(_updateTotalMass);
    _gasAmountController.dispose();
    _totalMassController.dispose();
    super.dispose();
  }

  void _updateTotalMass() {
    final tareMass = double.tryParse(_tareMassController.text) ?? 0.0;
    final gasAmount = double.tryParse(_gasAmountController.text) ?? 0.0;
    final totalMass = tareMass + gasAmount;
    _totalMassController.text = totalMass.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16.0,
          right: 16.0,
          top: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Refill Customer Cylinder',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Cylinder Name: ${widget.cylinderName}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Tare Mass'),
              keyboardType: TextInputType.number,
              controller: _tareMassController,
              onSaved: (value) {
                _tareMass = double.parse(value!);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter tare mass';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Gas Amount'),
              keyboardType: TextInputType.number,
              controller: _gasAmountController,
              onSaved: (value) {
                _gasAmount = double.parse(value!);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter gas amount';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Total Mass'),
              keyboardType: TextInputType.number,
              controller: _totalMassController,
              readOnly: true,
              onSaved: (value) {
                _totalMass = double.parse(value!);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveCustomerCylinder,
              child: const Text('Save Customer Cylinder'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCustomerCylinder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final shopCylinders = await _dao.getShopCylinders();
      double remainingGasAmount = _gasAmount;
      List<int> usedShopCylinders = [];

      for (var shopCylinder in shopCylinders) {
        if (shopCylinder.gasAmount > 0) {
          final usedGas = shopCylinder.gasAmount >= remainingGasAmount
              ? remainingGasAmount
              : shopCylinder.gasAmount;
          remainingGasAmount -= usedGas;
          shopCylinder.gasAmount -= usedGas;
          usedShopCylinders.add(shopCylinder.id!);

          if (remainingGasAmount <= 0) {
            break;
          }
        }
      }

      if (remainingGasAmount > 0) {
        // Handle error: Not enough gas in all shop cylinders combined
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Not enough gas in shop cylinders.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        final customerCylinder = CustomerCylinder(
          shopCylinderId: widget.shopCylinder.id!,
          tareMass: _tareMass,
          gasAmount: _gasAmount,
          totalMass: _totalMass,
          createdAt: DateTime.now().toIso8601String(),
        );

        await _dao.insertCustomerCylinder(customerCylinder);

        for (var shopCylinderId in usedShopCylinders) {
          final shopCylinder = shopCylinders
              .firstWhere((cylinder) => cylinder.id == shopCylinderId);
          await _dao.updateShopCylinder(shopCylinder);
        }

        widget.onUpdate(); // Trigger the update callback
        Navigator.pop(context);
      }
    }
  }
}
