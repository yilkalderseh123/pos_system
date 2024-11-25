import 'package:flutter/material.dart';
import './cashier_view_reciets.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        centerTitle: true,
      ),
      body: TransactionHistoryPage(),
    );
  }
}

class TransactionHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> transactions = [
    {
      'id': '123456',
      'date': '2024-11-25',
      'time': '12:45 PM',
      'total': 37.97,
      'status': 'Completed',
    },
    {
      'id': '123457',
      'date': '2024-11-24',
      'time': '3:15 PM',
      'total': 24.50,
      'status': 'Completed',
    },
    {
      'id': '123458',
      'date': '2024-11-23',
      'time': '5:30 PM',
      'total': 55.80,
      'status': 'Pending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: transaction['status'] == 'Completed'
                    ? Colors.green
                    : Colors.orange,
                child: Icon(
                  transaction['status'] == 'Completed'
                      ? Icons.check_circle
                      : Icons.pending,
                  color: Colors.white,
                ),
              ),
              title: Text(
                "Receipt #${transaction['id']}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Date: ${transaction['date']}\nTime: ${transaction['time']}",
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\$${transaction['total'].toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    transaction['status'],
                    style: TextStyle(
                      color: transaction['status'] == 'Completed'
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
              onTap: () {
                // Navigate to the receipt detail page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReceiptDetailScreen(transaction: transaction),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
