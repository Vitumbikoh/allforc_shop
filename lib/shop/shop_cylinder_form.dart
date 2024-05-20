
import 'package:flutter/material.dart';
import '../models/models.dart';
import 'gas_fill_dao.dart'; // Assuming you saved the DAO in a file named gas_fill_dao.dart

class AddShopCylinderForm extends StatefulWidget {
  final VoidCallback onAdd;

  const AddShopCylinderForm({required this.onAdd, super.key});

  @override
  State<AddShopCylinderForm> createState() => _AddShopCylinderFormState();
}

class _AddShopCylinderFormState extends State<AddShopCylinderForm> {
  final GasFillDao _dao = GasFillDao();
  final _formKey = GlobalKey<FormState>();
  final _tareMassController = TextEditingController();
  final _gasAmountController = TextEditingController();
  final _totalMassController = TextEditingController();

  late String _cylinderName;
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
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Shop Cylinder',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Cylinder Name'),
              onSaved: (value) {
                _cylinderName = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter cylinder name';
                }
                return null;
              },
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
              onPressed: _saveShopCylinder,
              child: const Text('Save Shop Cylinder'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveShopCylinder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final shopCylinder = ShopCylinder(
        cylinderName: _cylinderName,
        tareMass: _tareMass,
        gasAmount: _gasAmount,
        totalMass: _totalMass,
        openingMass: _gasAmount, // Set openingMass to gasAmount initially
        createdAt: DateTime.now().toIso8601String(),
      );
      await _dao.insertShopCylinder(shopCylinder);
      widget.onAdd(); // Trigger the callback to refresh data
      Navigator.pop(context);
    }
  }
}