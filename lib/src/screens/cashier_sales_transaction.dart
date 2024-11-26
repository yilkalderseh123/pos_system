import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Item extends HiveObject {
  final String name;
  final double price;

  Item({required this.name, required this.price});

  factory Item.fromMap(Map<dynamic, dynamic> map) {
    return Item(
      name: map['name'] as String,
      price: map['price'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }
}

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late Box itemBox;
  late Box settingsBox;
  List<Item> items = [];
  String itemName = '';
  double itemPrice = 0.0;
  String selectedPaymentMethod = 'Cash';
  final paymentMethods = ['Cash', 'Card', 'Mobile Payment'];

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);

    itemBox = await Hive.openBox('items');
    settingsBox = await Hive.openBox('settings');

    setState(() {
      items = itemBox.values
          .map((e) => Item.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      selectedPaymentMethod =
          settingsBox.get('paymentMethod', defaultValue: 'Cash');
    });
  }

  Future<void> _savePaymentMethod(String method) async {
    await settingsBox.put('paymentMethod', method);
  }

  void addItem(String name, double price) {
    final newItem = Item(name: name, price: price);
    setState(() {
      items.add(newItem);
    });
    itemBox.add(newItem.toMap());
  }

  double getTotalAmount() {
    return items.fold(0.0, (sum, item) => sum + item.price);
  }

  void clearItems() {
    setState(() {
      items.clear();
    });
    itemBox.clear();
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
                    children: [
                      Expanded(
                        flex: 1,
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: buildInputSection(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: buildItemListAndSummary(),
                          ),
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: buildInputSection(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: buildItemListAndSummary(),
                          ),
                        ),
                      ],
                    ),
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
        const Text(
          'Add Item',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
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
        const Text(
          'Items List',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text('No items added.'))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(item.name[0].toUpperCase()),
                      ),
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
