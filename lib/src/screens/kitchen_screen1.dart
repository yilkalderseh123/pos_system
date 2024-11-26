import 'package:flutter/material.dart';
import './login_screen.dart'; // Ensure you import the LoginScreen

class KitchenScreen extends StatelessWidget {
  KitchenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Navigate to LoginScreen on logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Kitchen Dashboard Intro
            const Text(
              'Welcome to the Kitchen! Here are the current orders.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Orders List
            Expanded(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('Order #${order['orderId']}'),
                      subtitle: Text('Table: ${order['tableNumber']}'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Update order status to "Prepared"
                          _updateOrderStatus(context, order['orderId']);
                        },
                        child: const Text('Mark as Prepared'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List of dummy orders to display
  final List<Map<String, dynamic>> _orders = [
    {'orderId': 101, 'tableNumber': 5, 'status': 'Pending'},
    {'orderId': 102, 'tableNumber': 2, 'status': 'Pending'},
    {'orderId': 103, 'tableNumber': 8, 'status': 'Pending'},
  ];

  // Function to update the order status
  void _updateOrderStatus(BuildContext context, int orderId) {
    // In a real application, you would update the order status in a database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order #$orderId marked as Prepared')),
    );
  }
}
