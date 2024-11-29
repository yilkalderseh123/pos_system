import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late final Box<Map> _orderBox; // Box for order items
  List<Map<String, dynamic>> orderHistory = [];

  @override
  void initState() {
    super.initState();
    _initializeBoxes();
  }

  Future<void> _initializeBoxes() async {
    _orderBox = await Hive.openBox<Map>('order_items'); // Open order box
    _loadOrderHistory();
  }

  void _loadOrderHistory() {
    final orders = <Map<String, dynamic>>[];

    for (int i = 0; i < _orderBox.length; i++) {
      final rawOrder = _orderBox.getAt(i);
      if (rawOrder != null && rawOrder is Map) {
        orders.add(Map<String, dynamic>.from(rawOrder));
      }
    }

    setState(() {
      orderHistory = orders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: orderHistory.isEmpty
            ? const Center(child: Text('No orders found.'))
            : ListView.builder(
                itemCount: orderHistory.length,
                itemBuilder: (context, index) {
                  final order = orderHistory[index];
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
                    subtitle: Text('Status: ${order['status'] ?? 'Unknown'}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      onPressed: () {
                        _viewOrderDetails(order);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _viewOrderDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order Details - ${order['item']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notes: ${order['notes'] ?? 'No notes'}'),
                    Text('Status: ${order['status'] ?? 'Unknown'}'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _orderBox.close();
    super.dispose();
  }
}
