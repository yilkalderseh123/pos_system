import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<Map<String, dynamic>> items = [];
  String itemName = '';
  double itemPrice = 0.0;
  String selectedPaymentMethod = 'Cash';

  final paymentMethods = ['Cash', 'Card', 'Mobile Payment'];

  void addItem(String name, double price) {
    setState(() {
      items.add({'name': name, 'price': price});
      itemName = '';
      itemPrice = 0.0;
    });
  }

  double getTotalAmount() {
    return items.fold(0.0, (sum, item) => sum + item['price']);
  }

  void printReceipt() {
    // Logic to print receipt can be added here
    // For now, just show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Receipt'),
        content: Text(
          'Total Amount: \$${getTotalAmount().toStringAsFixed(2)}\nPayment Method: $selectedPaymentMethod',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => itemName = value,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Item Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => itemPrice = double.tryParse(value) ?? 0.0,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (itemName.isNotEmpty && itemPrice > 0) {
                  addItem(itemName, itemPrice);
                }
              },
              child: const Text('Add Item'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text('\$${item['price'].toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${getTotalAmount().toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedPaymentMethod,
                  items: paymentMethods
                      .map((method) =>
                          DropdownMenuItem(value: method, child: Text(method)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: printReceipt,
              child: const Text('Print Receipt'),
            ),
          ],
        ),
      ),
    );
  }
}
