import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProductListingPage extends StatefulWidget {
  final List<Product> cartItems; // Define _cartItems here

  ProductListingPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  _ProductListingPageState createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  late Database _database;
  late Future<void> _databaseInitialized;

  @override
  void initState() {
    super.initState();
    _databaseInitialized = _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'products_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE products(id INTEGER PRIMARY KEY, name TEXT, price REAL)',
        );
      },
      version: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _databaseInitialized,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error initializing database: ${snapshot.error}');
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showAddProductDialog(context);
                    },
                    icon: Icon(Icons.add),
                    label: Text(
                      'Add Products',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                    ),
                  ),
                ),
                FutureBuilder<List<Product>>(
                  future: _getProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final products = snapshot.data!;
                      return Column(
                        children: [
                          DataTable(
                            columnSpacing: 10.0,
                            columns: [
                              DataColumn(label: Text('No.')),
                              DataColumn(label: Text('Product Name')),
                              DataColumn(label: Text('Price'), numeric: true),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: List.generate(products.length, (index) {
                              final product = products[index];
                              return DataRow(cells: [
                                DataCell(Text((index + 1).toString())),
                                DataCell(Text(product.name)),
                                DataCell(Container(
                                  padding: EdgeInsets.all(8.0),
                                  color: Colors.orange,
                                  child: Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                  ),
                                )),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _addToCart(product);
                                        setState(() {}); // Update UI
                                      },
                                      icon: Icon(
                                        Icons.add_shopping_cart,
                                        color: _isInCart(product)
                                            ? Colors.green
                                            : null, // Change color to green if product is in cart
                                      ),
                                    ),
                                    PopupMenuButton(
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 'edit',
                                          child: Text('Edit'),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Text('Delete'),
                                        ),
                                      ],
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          _showEditProductDialog(
                                              context, product);
                                        } else if (value == 'delete') {
                                          _deleteProduct(product);
                                          setState(() {}); // Update UI
                                        }
                                      },
                                    ),
                                  ],
                                )),
                              ]);
                            }),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CartPage(cartItems: widget.cartItems),
                                ),
                              );
                            },
                            child: Text('View Cart'),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<void> _showAddProductDialog(BuildContext context) async {
    _nameController.clear();
    _priceController.clear();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
              ),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Product Price',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final String name = _nameController.text;
              final double price =
                  double.tryParse(_priceController.text) ?? 0.0;
              if (name.isNotEmpty && price > 0) {
                await _insertProduct(Product(name: name, price: price));
                setState(() {}); // Update UI to reflect the newly added product
              }
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditProductDialog(
      BuildContext context, Product product) async {
    _nameController.text = product.name;
    _priceController.text = product.price.toString();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
              ),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Product Price',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final String name = _nameController.text;
              final double price =
                  double.tryParse(_priceController.text) ?? 0.0;
              if (name.isNotEmpty && price > 0) {
                await _updateProduct(product.id!,
                    Product(id: product.id, name: name, price: price));
                setState(() {}); // Update UI to reflect the edited product
              }
              Navigator.pop(context);
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _insertProduct(Product product) async {
    await _database.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _updateProduct(int id, Product product) async {
    await _database.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> _deleteProduct(Product product) async {
    await _database.delete(
      'products',
      where: 'id = ?',
      whereArgs: [product.id],
    );
    setState(() {}); // Update UI to reflect the deleted product
  }

  Future<List<Product>> _getProducts() async {
    final List<Map<String, dynamic>> productsMap =
        await _database.query('products');
    return List.generate(productsMap.length, (index) {
      return Product(
        id: productsMap[index]['id'],
        name: productsMap[index]['name'],
        price: productsMap[index]['price'],
      );
    });
  }

  bool _isInCart(Product product) {
    // Check if the product is in the cart
    return _cartItems.contains(product);
  }

  List<Product> _cartItems = [];

  void _addToCart(Product product) {
    setState(() {
      // Toggle product in cart
      if (_isInCart(product)) {
        _cartItems.remove(product);
      } else {
        _cartItems.add(product);
      }
    });
  }
}

class Product {
  final int? id;
  final String name;
  final double price;

  Product({this.id, required this.name, required this.price});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }
}


class CartPage extends StatelessWidget {
  final List<Product> cartItems;

  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final product = cartItems[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
