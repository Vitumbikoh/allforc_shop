import 'package:flutter/material.dart';
import 'addshop.dart'; // Import the page for adding a new shop account
import 'financialmanagement.dart';
import 'inventory.dart';
import 'records.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              // Implement functionality for log out
              // For now, let's just print a message
              print('Logout pressed');
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigate to the page for adding a new shop account
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddShopPage()),
                );
              },
              child: Text('Add New Shop Account'), // Updated button text
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the page for managing inventory
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ManageInventoryPage()),
                );
              },
              child: Text('Manage Inventory'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the page for viewing sales and refill records
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewSalesRecordsPage()),
                );
              },
              child: Text('View Sales and Refill Records'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the page for financial and accounting
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FinancialAccountingPage()),
                );
              },
              child: Text('Financial and Accounting'),
            ),
          ],
        ),
      ),
    );
  }
}
