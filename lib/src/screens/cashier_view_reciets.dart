import 'package:flutter/material.dart';

class ReceiptDetailScreen extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const ReceiptDetailScreen({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Receipt #${transaction['id']}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text("Date: ${transaction['date']}"),
            Text("Time: ${transaction['time']}"),
            const SizedBox(height: 20),
            Text(
              "Total: \$${transaction['total'].toStringAsFixed(2)}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Status: ${transaction['status']}",
              style: TextStyle(
                color: transaction['status'] == 'Completed'
                    ? Colors.green
                    : Colors.orange,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
