import 'package:flutter/material.dart';
import './cashier_sales_transaction.dart';
import './cashier_transaction_history.dart';
import './login_screen.dart'; // Ensure you import the LoginScreen

class CashierScreen extends StatelessWidget {
  const CashierScreen({super.key});

  get transaction => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cashier Dashboard'),
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
            // Cashier Dashboard Intro
            const Text(
              'Welcome, Cashier! Ready to process sales.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons for Sales, Receipts, and Settings
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildActionButton(
                    context,
                    Icons.shopping_cart,
                    'Process Sale',
                    () {
                      // Navigate to Sale Processing Screen (You can create this page)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransactionPage()),
                      );
                    },
                  ),
                  _buildActionButton(
                    context,
                    Icons.history,
                    'Transaction History',
                    () {
                      // Navigate to Transaction History Screen (You can create this page)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const TransactionHistoryScreen()),
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
