import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import './login_screen.dart'; // Ensure you import the LoginScreen

class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  _KitchenScreenState createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  late Box<Map> ordersBox;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);

    // Open Hive box for orders
    ordersBox = await Hive.openBox<Map>('order_items');

    setState(() {
      isLoading = false; // Data initialization complete
    });
  }

  Future<void> _updateOrderStatus(int index, String newStatus) async {
    final order = ordersBox.getAt(index);
    if (order != null) {
      final updatedOrder = Map<String, dynamic>.from(order)
        ..['status'] = newStatus;
      await ordersBox.putAt(index, updatedOrder);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Order for ${order['item']} has been marked as $newStatus'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Navigate to LoginScreen on logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Welcome to the Kitchen! Here are the current orders.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: ordersBox.listenable(),
                      builder: (context, Box<Map> box, _) {
                        if (box.isEmpty) {
                          return const Center(
                            child: Text('No orders available.'),
                          );
                        }

                        return ListView.builder(
                          itemCount: box.length,
                          itemBuilder: (context, index) {
                            final order = box.getAt(index)!;
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    order['imageUrl'] ??
                                        'https://via.placeholder.com/50',
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 50,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.image);
                                    },
                                  ),
                                ),
                                title: Text(order['item'] ?? 'Unknown Item'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Notes: ${order['notes'] ?? 'None'}'),
                                    Text('Status: ${order['status']}'),
                                  ],
                                ),
                                trailing: ElevatedButton(
                                  onPressed: order['status'] == 'Prepared'
                                      ? null
                                      : () =>
                                          _updateOrderStatus(index, 'Prepared'),
                                  child: Text(order['status'] == 'Prepared'
                                      ? 'Prepared'
                                      : 'Mark as Prepared'),
                                ),
                              ),
                            );
                          },
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
    Hive.close();
    super.dispose();
  }
}
