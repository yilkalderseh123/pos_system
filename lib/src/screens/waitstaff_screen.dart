import 'package:flutter/material.dart';

class WaitstaffScreen extends StatelessWidget {
  const WaitstaffScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waitstaff Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Add logout functionality here
              Navigator.pop(context); // For now, just go back
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Waitstaff Dashboard Intro
            const Text(
              'Welcome, Waitstaff! Ready to take orders.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Section to view tables and manage orders
            Expanded(
              child: ListView(
                children: [
                  // Section for tables
                  _buildSectionTitle('Assigned Tables'),
                  _buildTableCard(context, 'Table 1', '2 Orders Pending'),
                  _buildTableCard(context, 'Table 2', '1 Order Pending'),
                  _buildTableCard(context, 'Table 3', 'No Orders'),

                  const SizedBox(height: 20),

                  // Section to manage orders
                  _buildSectionTitle('Manage Orders'),
                  _buildActionButton(
                    context,
                    Icons.add_shopping_cart,
                    'Take Order',
                    () {
                      // Navigate to Order Taking Screen (You can create this page)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TakeOrderScreen()),
                      );
                    },
                  ),
                  _buildActionButton(
                    context,
                    Icons.history,
                    'View Orders',
                    () {
                      // Navigate to Orders History Screen (You can create this page)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OrderHistoryScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper function to create table cards
  Widget _buildTableCard(
      BuildContext context, String tableName, String orderStatus) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(tableName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text(orderStatus),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            // Navigate to Order Status Management for the specific table
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderStatusScreen(tableName: tableName),
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper function to create action buttons
  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.all(16), // You can change the color
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder screen for Take Order
class TakeOrderScreen extends StatelessWidget {
  const TakeOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take Order')),
      body: Center(child: const Text('Order Taking Page')),
    );
  }
}

// Placeholder screen for Order History
class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: Center(child: const Text('Order History Page')),
    );
  }
}

// Placeholder screen for Order Status Management
class OrderStatusScreen extends StatelessWidget {
  final String tableName;

  const OrderStatusScreen({Key? key, required this.tableName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Orders for $tableName')),
      body: Center(child: const Text('Order Status Management Page')),
    );
  }
}
