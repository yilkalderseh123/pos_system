import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class Item {
  final String name;
  final double price;

  Item({required this.name, required this.price});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transaction Page',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TransactionPage(),
    );
  }
}

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final List<Item> items = [];
  String itemName = '';
  double itemPrice = 0.0;
  String selectedPaymentMethod = 'Cash';
  final paymentMethods = ['Cash', 'Card', 'Mobile Payment'];

  @override
  void initState() {
    super.initState();
    _loadPaymentMethod();
  }

  Future<void> _loadPaymentMethod() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedPaymentMethod = prefs.getString('paymentMethod') ?? 'Cash';
    });
  }

  Future<void> _savePaymentMethod(String method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('paymentMethod', method);
  }

  void addItem(String name, double price) {
    setState(() {
      items.add(Item(name: name, price: price));
      itemName = '';
      itemPrice = 0.0;
    });
  }

  double getTotalAmount() {
    return items.fold(0.0, (sum, item) => sum + item.price);
  }

  void clearItems() {
    setState(() {
      items.clear();
    });
  }

  void printReceipt() {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: clearItems,
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: buildInputSection(),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: buildItemListAndSummary(),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInputSection(),
                      const SizedBox(height: 20),
                      Expanded(child: buildItemListAndSummary()),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget buildInputSection() {
    return Column(
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
      ],
    );
  }

  Widget buildItemListAndSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text('No items added.'))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
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
                _savePaymentMethod(value!);
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
    );
  }
}
