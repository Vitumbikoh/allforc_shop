import 'package:flutter/material.dart';
import 'cart.dart';
import 'products.dart';

class SalesInsightsPage extends StatefulWidget {
  final List<Product> cartItems; // Define _cartItems here

  const SalesInsightsPage({super.key, required this.cartItems}); // Constructor

  @override
  State<SalesInsightsPage> createState() => _SalesInsightsPageState();
}

class _SalesInsightsPageState extends State<SalesInsightsPage> {
  late Widget _currentPage;
  late final List<Product> cartItems;

  @override
  void initState() {
    super.initState();
    // Set the default page to SalesPage
    _currentPage = const SalesPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconButton(
                  icon: Icons.shopping_cart,
                  label: 'Cart',
                  onPressed: () {
                    setState(() {
                      _currentPage = cartPageBuilder(widget.cartItems);
                    });
                  },
                ),
                _buildIconButton(
                  icon: Icons.attach_money,
                  label: 'Sales',
                  onPressed: () {
                    setState(() {
                      _currentPage = const SalesPage();
                    });
                  },
                ),
                _buildIconButton(
                  icon: Icons.bar_chart,
                  label: 'Insights',
                  onPressed: () {
                    setState(() {
                      _currentPage = const InsightsPage();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _currentPage,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }

  Widget cartPageBuilder(List<Product> cartItems) {
    return CartPage(cartItems: cartItems);
  }
}

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Sales Page'),
    );
  }
}

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Insights Page'),
    );
  }
}
