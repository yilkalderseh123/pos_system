import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({super.key});

  @override
  State<OrderManagementPage> createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  late final Box<Map> _menuBox;
  late final Box<Map> _orderBox;
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
    _orderBox = await Hive.openBox<Map>('order_items');
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
    _orderBox.add(order);
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
                _saveOrderItem(orderItem);
                Navigator.of(context).pop();
              },
              child: const Text('Add to Order'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200
        ? 4
        : screenWidth > 800
            ? 3
            : screenWidth > 500
                ? 2
                : 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
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
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: screenWidth > 800 ? 3 / 4 : 2 / 3,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10)),
                                child: Image.network(
                                  item.imageUrl.isNotEmpty
                                      ? item.imageUrl
                                      : 'https://via.placeholder.com/150',
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Price: \$${item.price.toStringAsFixed(2)}',
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  addToOrder(item.name, item.imageUrl);
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Order'),
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                ),
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
  final double price;
  final String imageUrl;

  FoodBeverageItem({
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  factory FoodBeverageItem.fromMap(Map<String, dynamic> map) {
    return FoodBeverageItem(
      name: map['name'] ?? 'Unknown',
      price: map['price'] ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
