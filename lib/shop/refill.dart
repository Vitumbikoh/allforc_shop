import 'package:flutter/material.dart';

class RefillPage extends StatefulWidget {
  const RefillPage({super.key});

  @override
  State<RefillPage> createState() => _RefillPageState();
}

class _RefillPageState extends State<RefillPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gas Refill'),
      ),
      resizeToAvoidBottomInset: true,
      body: const Column(
        children: [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Add Cylinder',
                            style: Theme.of(context).textTheme.titleLarge),
                        const TextField(
                          decoration:
                              InputDecoration(labelText: 'Name/Description'),
                        ),
                        const TextField(
                          decoration:
                              InputDecoration(labelText: 'Tare Mass (kg)'),
                          keyboardType: TextInputType.number,
                        ),
                        const TextField(
                          decoration:
                              InputDecoration(labelText: 'Gas Amount (kg)'),
                          keyboardType: TextInputType.number,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Add Cylinder'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
