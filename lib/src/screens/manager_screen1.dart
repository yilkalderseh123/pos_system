import 'package:flutter/material.dart';
import './login_screen.dart';
import './manager_sales_report.dart';
import './manager_add_food_or_beverage.dart';

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
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determine if the layout is for mobile or desktop
          bool isDesktop = constraints.maxWidth > 600;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Text
                  const Text(
                    'Welcome, Manager!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Manage your operations efficiently from this dashboard.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Use GridView for a desktop layout, ListView for mobile
                  isDesktop
                      ? GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildActionCard(
                              context,
                              Icons.bar_chart,
                              'View Sales Reports',
                              'Analyze detailed sales performance.',
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ManagerSalesReportPage(),
                                  ),
                                );
                              },
                            ),
                            _buildActionCard(
                              context,
                              Icons.inventory,
                              'Add Menu',
                              'Add Restaurant menu items.',
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddFoodOrBeveragePage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            _buildActionCard(
                              context,
                              Icons.bar_chart,
                              'View Sales Reports',
                              'Analyze detailed sales performance.',
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ManagerSalesReportPage(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildActionCard(
                              context,
                              Icons.inventory,
                              'Add Menu',
                              'Add Restaurant menu items.',
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddFoodOrBeveragePage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper function to build action cards
  Widget _buildActionCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    VoidCallback onPressed,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.blueAccent),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
