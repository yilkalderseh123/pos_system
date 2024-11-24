import 'package:flutter/material.dart';

class ManagerScreen extends StatelessWidget {
  const ManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Dashboard'),
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
                      builder: (context) => const SalesReportsScreen()),
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
                      builder: (context) => const InventoryManagementScreen()),
                );
              },
            ),
            _buildActionButton(
              context,
              Icons.add_shopping_cart,
              'Add New Item',
              () {
                // Navigate to Add New Item Page (You can create this page)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddItemScreen()),
                );
              },
            ),
            const SizedBox(height: 20),

            // Section for System Settings
            _buildSectionTitle('System Settings'),
            _buildActionButton(
              context,
              Icons.settings,
              'Manage System Settings',
              () {
                // Navigate to System Settings Page (You can create this page)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SystemSettingsScreen()),
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

// Placeholder screen for Sales Reports
class SalesReportsScreen extends StatelessWidget {
  const SalesReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales Reports')),
      body: Center(child: const Text('Sales Reports Page')),
    );
  }
}

// Placeholder screen for Inventory Management
class InventoryManagementScreen extends StatelessWidget {
  const InventoryManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Management')),
      body: Center(child: const Text('Inventory Management Page')),
    );
  }
}

// Placeholder screen for Add New Item
class AddItemScreen extends StatelessWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Item')),
      body: Center(child: const Text('Add New Item Page')),
    );
  }
}

// Placeholder screen for System Settings
class SystemSettingsScreen extends StatelessWidget {
  const SystemSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('System Settings')),
      body: Center(child: const Text('System Settings Page')),
    );
  }
}
