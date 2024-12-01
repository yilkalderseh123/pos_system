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

  void addToOrder(String itemName, String imageUrl) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        TextEditingController noteController = TextEditingController();
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Notes for $itemName',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  hintText: "Enter your notes (e.g., extra spicy)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add to Order'),
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
                    _orderBox.add(orderItem);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Management'),
        backgroundColor: Colors.deepOrange,
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
            // Menu Items in a Responsive Grid
            Expanded(
              flex: 2,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 600 ? 3 : 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            item.imageUrl.isNotEmpty
                                ? item.imageUrl
                                : 'https://via.placeholder.com/150',
                            height: 100,
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
                                style: Theme.of(context).textTheme.titleMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: TextStyle(color: Colors.green[700]),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Add'),
                          onPressed: () {
                            addToOrder(item.name, item.imageUrl);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            // Order List
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: orderItems.length,
                itemBuilder: (context, index) {
                  final order = orderItems[index];
                  return ListTile(
                    leading: Image.network(
                      order['imageUrl'] ?? 'https://via.placeholder.com/50',
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(order['item'] ?? 'Unknown'),
                    subtitle: Text(order['notes'] ?? 'No notes'),
                    trailing: Text(order['status'] ?? 'Preparing'),
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

  factory FoodBeverageItem.fromMap(Map<String, dynamic> map) {
    return FoodBeverageItem(
      name: map['name'] as String,
      price: map['price'] as double,
      imageUrl: map['imageUrl'] as String,
    );
  }
}
