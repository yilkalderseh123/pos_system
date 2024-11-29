import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({super.key});

  @override
  State<OrderManagementPage> createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  late final Box<Map> _menuBox;
  late final Box<Map> _orderBox; // Box for order items
  List<Map<String, dynamic>> orderItems = [];
  List<FoodBeverageItem> filteredItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeBoxes();
  }

  Future<void> _initializeBoxes() async {
    _menuBox = await Hive.openBox<Map>('food_beverage_items');
    _orderBox = await Hive.openBox<Map>('order_items'); // Open order box
    setState(() {
      _filterItems('');
      _loadOrderItems();
    });
  }

  void _filterItems(String query) {
    final items = <FoodBeverageItem>[];

    for (int i = 0; i < _menuBox.length; i++) {
      final rawItem = _menuBox.getAt(i);
      if (rawItem != null && rawItem is Map) {
        // Validate non-null and type
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

  void _loadOrderItems() {
    final items = <Map<String, dynamic>>[];

    for (int i = 0; i < _orderBox.length; i++) {
      final rawItem = _orderBox.getAt(i);
      if (rawItem != null && rawItem is Map) {
        items.add(Map<String, dynamic>.from(rawItem));
      }
    }

    setState(() {
      orderItems = items;
    });
  }

  void _saveOrderItem(Map<String, dynamic> order) {
    _orderBox.add(order); // Save the full order to Hive
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
                final orderItem = {
                  'item': itemName,
                  'imageUrl': imageUrl,
                  'notes': noteController.text.isEmpty
                      ? 'No notes'
                      : noteController.text,
                  'status': 'Preparing',
                };

                setState(() {
                  orderItems.add(orderItem);
                });
                _saveOrderItem(orderItem); // Save to Hive
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
    final updatedOrder = {
      ...orderItems[index],
      'status': status,
    };

    setState(() {
      orderItems[index] = updatedOrder;
      _orderBox.putAt(index, updatedOrder); // Update Hive entry
    });
  }

  void removeOrderItem(int index) {
    setState(() {
      orderItems.removeAt(index);
      _orderBox.deleteAt(index); // Remove from Hive
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
                              item.imageUrl.isNotEmpty
                                  ? item.imageUrl
                                  : 'https://via.placeholder.com/50',
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
                  final order = orderItems[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        order['imageUrl'] ?? 'https://via.placeholder.com/50',
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image);
                        },
                      ),
                    ),
                    title: Text(order['item'] ?? 'Unknown Item'),
                    subtitle: Text(order['notes'] ?? 'No notes'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(order['status'] ?? 'Unknown'),
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
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => removeOrderItem(index),
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
    _menuBox.close();
    _orderBox.close();
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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  factory FoodBeverageItem.fromMap(Map<String, dynamic> map) {
    return FoodBeverageItem(
      name: map['name'] as String? ?? 'Unknown',
      quantity: map['quantity'] as int? ?? 0,
      price: map['price'] as double? ?? 0.0,
      imageUrl: map['imageUrl'] as String? ?? '',
    );
  }
}
