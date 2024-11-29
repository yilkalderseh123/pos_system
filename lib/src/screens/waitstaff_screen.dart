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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Intro Text
                const Text(
                  'Welcome, Waitstaff!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Manage your orders and assignments efficiently.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                // Dashboard Grid
                Expanded(
                  child: constraints.maxWidth > 600
                      ? _buildGridDashboardDesktop(context)
                      : _buildListDashboardMobile(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Responsive Grid Dashboard for Desktop
  Widget _buildGridDashboardDesktop(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 columns for desktop
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      children: [
        _buildDashboardCard(
          context,
          Icons.add_shopping_cart,
          'Order Management',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderManagementPage()),
            );
          },
        ),
        _buildDashboardCard(
          context,
          Icons.history,
          'Order History',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderHistoryPage()),
            );
          },
        ),
        _buildDashboardCard(
          context,
          Icons.table_chart,
          'Table Assignment',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TableAssignmentPage()),
            );
          },
        ),
      ],
    );
  }

  // ListView Dashboard for Mobile
  Widget _buildListDashboardMobile(BuildContext context) {
    return ListView(
      children: [
        _buildDashboardCard(
          context,
          Icons.add_shopping_cart,
          'Order Management',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderManagementPage()),
            );
          },
        ),
        _buildDashboardCard(
          context,
          Icons.history,
          'Order History',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderHistoryPage()),
            );
          },
        ),
        _buildDashboardCard(
          context,
          Icons.table_chart,
          'Table Assignment',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TableAssignmentPage()),
            );
          },
        ),
      ],
    );
  }

  // Common Dashboard Card
  Widget _buildDashboardCard(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.blueAccent),
              const SizedBox(height: 16),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
