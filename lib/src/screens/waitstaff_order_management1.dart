import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({super.key});

  @override
  State<OrderManagementPage> createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  late final Box<Map> _box;
  List<Map<String, dynamic>> orderItems = [];
  List<FoodBeverageItem> filteredItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    _box = await Hive.openBox<Map>('food_beverage_items');
    setState(() {
      _filterItems('');
    });
  }

  void _filterItems(String query) {
    final items = <FoodBeverageItem>[];

    for (int i = 0; i < _box.length; i++) {
      final rawItem = _box.getAt(i);
      if (rawItem is Map) {
        final item =
            FoodBeverageItem.fromMap(Map<String, dynamic>.from(rawItem));
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          items.add(item);
        }
      }
    }

    setState(() {
      filteredItems = items;
    });
  }

  void addToOrder(String itemName, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController noteController = TextEditingController();
        return AlertDialog(
          title: Text('Add Notes for $itemName'),
          content: TextField(
            controller: noteController,
            decoration: const InputDecoration(
                hintText: "Enter your notes (e.g., extra spicy)"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  orderItems.add({
                    'item': itemName,
                    'imageUrl': imageUrl,
                    'notes': noteController.text,
                    'status': 'Preparing',
                  });
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add to Order'),
            ),
          ],
        );
      },
    );
  }

  void updateOrderStatus(int index, String status) {
    setState(() {
      orderItems[index]['status'] = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Management')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search Menu',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                _filterItems(query);
              },
            ),
            const SizedBox(height: 10),
            // Display Menu List
            Expanded(
              child: filteredItems.isEmpty
                  ? const Center(
                      child: Text('No items found.'),
                    )
                  : ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image);
                              },
                            ),
                          ),
                          title: Text(item.name),
                          subtitle: Text(
                              'Quantity: ${item.quantity} • \$${item.price.toStringAsFixed(2)}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              addToOrder(item.name, item.imageUrl);
                            },
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            // Display Order List
            const Text(
              'Order Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: orderItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        orderItems[index]['imageUrl'],
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image);
                        },
                      ),
                    ),
                    title: Text(orderItems[index]['item']),
                    subtitle: Text(orderItems[index]['notes']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(orderItems[index]['status']),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              updateOrderStatus(index, 'Preparing'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () => updateOrderStatus(index, 'Ready'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.check_circle),
                          onPressed: () => updateOrderStatus(index, 'Served'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _box.close();
    searchController.dispose();
    super.dispose();
  }
}

class FoodBeverageItem {
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;

  FoodBeverageItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  // Convert FoodBeverageItem to a Map for Hive storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  // Create FoodBeverageItem from a Map
  factory FoodBeverageItem.fromMap(Map<String, dynamic> map) {
    return FoodBeverageItem(
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] as double,
      imageUrl: map['imageUrl'] as String,
    );
  }
}
