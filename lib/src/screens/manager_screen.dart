import 'package:flutter/material.dart';
import './login_screen.dart'; // Ensure you import the LoginScreen
import './manager_sales_report.dart';
import './manager_inventory_management.dart';

class ManagerScreen extends StatelessWidget {
  const ManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Dashboard'),
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
            // Manager Dashboard Intro
            const Text(
              'Welcome, Manager! Here are the key operations.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Section for Reports
            _buildSectionTitle('Sales Reports'),
            _buildActionButton(
              context,
              Icons.bar_chart,
              'View Sales Reports',
              () {
                // Navigate to Sales Reports Page (You can create this page)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ManagerSalesReportPage()),
                );
              },
            ),
            const SizedBox(height: 20),

            // Section for Inventory Management
            _buildSectionTitle('Inventory Management'),
            _buildActionButton(
              context,
              Icons.inventory,
              'View Inventory',
              () {
                // Navigate to Inventory Management Page (You can create this page)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InventoryManagementPage()),
                );
              },
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
