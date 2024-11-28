// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DisplayFoodBeveragePage extends StatefulWidget {
  const DisplayFoodBeveragePage({super.key});

  @override
  State<DisplayFoodBeveragePage> createState() =>
      _DisplayFoodBeveragePageState();
}

class _DisplayFoodBeveragePageState extends State<DisplayFoodBeveragePage> {
  late final Box<Map> _box;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    _box = await Hive.openBox<Map>('food_beverage_items');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food & Beverages'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: Hive.openBox<Map>('food_beverage_items'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_box.isEmpty) {
              return const Center(
                child: Text(
                  'No items added yet.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isDesktop ? 3 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 4,
              ),
              itemCount: _box.length,
              itemBuilder: (context, index) {
                final rawItem = _box.getAt(index); // Retrieve the raw item
                if (rawItem is Map) {
                  final item = FoodBeverageItem.fromMap(
                      Map<String, dynamic>.from(rawItem));

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.image, size: 40),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Quantity: ${item.quantity}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: () {
                              _deleteItem(index);
                            },
                            icon: const Icon(Icons.delete, size: 16),
                            label: const Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              minimumSize: const Size(double.infinity, 36),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox(); // Return an empty widget if the item is invalid
              },
            );
          },
        ),
      ),
    );
  }

  void _deleteItem(int index) {
    setState(() {
      _box.deleteAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item deleted successfully!')),
    );
  }

  @override
  void dispose() {
    _box.close();
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
