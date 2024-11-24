import 'package:flutter/material.dart';

class CashierScreen extends StatelessWidget {
  const CashierScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cashier Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // You can add a logout functionality here
              Navigator.pop(context); // For now, just go back
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
                            builder: (context) => const SaleProcessingScreen()),
                      );
                    },
                  ),
                  _buildActionButton(
                    context,
                    Icons.receipt,
                    'View Receipts',
                    () {
                      // Navigate to Receipts Screen (You can create this page)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReceiptsScreen()),
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
                  _buildActionButton(
                    context,
                    Icons.settings,
                    'Settings',
                    () {
                      // Navigate to Settings Screen (You can create this page)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsScreen()),
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

// Placeholder screen for Sale Processing
class SaleProcessingScreen extends StatelessWidget {
  const SaleProcessingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Process Sale')),
      body: Center(child: const Text('Sale Processing Page')),
    );
  }
}

// Placeholder screen for Receipts
class ReceiptsScreen extends StatelessWidget {
  const ReceiptsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receipts')),
      body: Center(child: const Text('Receipts Page')),
    );
  }
}

// Placeholder screen for Transaction History
class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction History')),
      body: Center(child: const Text('Transaction History Page')),
    );
  }
}

// Placeholder screen for Settings
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(child: const Text('Settings Page')),
    );
  }
}
