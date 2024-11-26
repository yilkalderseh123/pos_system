import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

// TransactionHistoryScreen widget
class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late Box transactionBox;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  // Initialize Hive and open the transactions box
  Future<void> _initializeHive() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      Hive.init(appDir.path); // Initialize Hive

      transactionBox = await Hive.openBox('items'); // Open the shared Hive box

      setState(() {
        isLoading = false; // Loading completed
      });
    } catch (e) {
      debugPrint('Hive initialization error: $e');
    }
  }

  @override
  void dispose() {
    Hive.close(); // Close Hive when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transaction History')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: transactionBox.length,
        itemBuilder: (context, index) {
          final map = transactionBox.getAt(index);
          if (map == null) {
            return const SizedBox(); // Skip null entries
          }

          final transaction = Item.fromMap(map); // Deserialize to Item
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: const Icon(
                  Icons.receipt,
                  color: Colors.white,
                ),
              ),
              title: Text(
                "Item: ${transaction.name}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Price: \$${transaction.price.toStringAsFixed(2)}",
              ),
            ),
          );
        },
      ),
    );
  }
}

// Item class (shared with the TransactionPage)
class Item {
  final String name;
  final double price;

  Item({required this.name, required this.price});

  // Deserialize from a Map
  factory Item.fromMap(Map<dynamic, dynamic> map) {
    return Item(
      name: map['name'] as String,
      price: map['price'] as double,
    );
  }

  // Serialize to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }
}
