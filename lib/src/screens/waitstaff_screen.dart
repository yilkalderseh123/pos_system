import 'package:flutter/material.dart';
import './login_screen.dart'; // Ensure you import the LoginScreen
import './waitstaff_order_management.dart';
import './waitstaff_order_history.dart';
import './waitstaff_table_assign.dart';

class WaitstaffScreen extends StatelessWidget {
  const WaitstaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waitstaff Dashboard'),
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
                  // Section to manage orders
                  _buildSectionTitle('Manage Orders'),
                  _buildActionButton(
                    context,
                    Icons.add_shopping_cart,
                    'Order Management',
                    () {
                      // Navigate to Order Taking Screen (You can create this page)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderManagementPage()),
                      );
                    },
                  ),
                  _buildActionButton(
                    context,
                    Icons.history,
                    'Order History Page',
                    () {
                      // Navigate to Orders History Screen (You can create this page)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderHistoryPage()),
                      );
                    },
                  ),
                  _buildActionButton(
                    context,
                    Icons.history,
                    'Table Assignment Page',
                    () {
                      // Navigate to Orders History Screen (You can create this page)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TableAssignmentPage()),
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
