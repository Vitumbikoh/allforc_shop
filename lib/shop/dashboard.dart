import 'package:flutter/material.dart';
import 'analytics.dart'; 
import 'refill.dart';
import 'sales.dart';
import 'deliveries.dart';
import 'products.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  late Database _database;
  late Future<void> _databaseInitialized;
  List<Product> products = []; // Initialize an empty list of products

  @override
  void initState() {
    super.initState();
    _databaseInitialized = _initializeDatabase();
    _fetchProducts();
  }

  Future<void> _initializeDatabase() async {
    try {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'products_database.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE products(id INTEGER PRIMARY KEY, name TEXT, price REAL)',
          );
        },
        version: 1,
      );
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final List<Map<String, dynamic>> productsMap =
          await _database.query('products');
      setState(() {
        products = productsMap
            .map((productMap) => Product(
                  id: productMap['id'],
                  name: productMap['name'],
                  price: productMap['price'],
                ))
            .toList();
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0), // Add padding to the top
        child: _getBody(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Refill',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining),
            label: 'Deliveries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Selected item color
        unselectedItemColor: Colors.grey, // Unselected item color
        onTap: _onNavigationBarItemTapped,
      ),
    );
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return ProductListingPage(cartItems: products); // Return ProductListingPage widget
      case 1:
        return SalesInsightsPage(cartItems: products);
      case 2: // Corrected index for RefillPage
        return RefillPage();
      case 3: // Corrected index for DeliveriesPage
        return DeliveriesPage();
      case 4: // Corrected index for InsightsPage
        return AnalyticsPage();
      default:
        return Container();
    }
  }

  void _onNavigationBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
