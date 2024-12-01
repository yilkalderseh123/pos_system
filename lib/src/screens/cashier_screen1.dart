import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  State<CashierScreen> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierScreen> {
  late final Box<Map> _orderBox;
  List<Map<String, dynamic>> allOrders = [];
  List<Map<String, dynamic>> filteredOrders = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeOrders();
  }

  Future<void> _initializeOrders() async {
    _orderBox = await Hive.openBox<Map>('order_items');
    _loadOrders('');
  }

  void _loadOrders(String query) {
    final orders = <Map<String, dynamic>>[];

    for (int i = 0; i < _orderBox.length; i++) {
      final rawOrder = _orderBox.getAt(i);
      if (rawOrder != null && rawOrder is Map) {
        final order = Map<String, dynamic>.from(rawOrder);
        if (order['item']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          orders.add(order);
        }
      }
    }

    setState(() {
      allOrders = orders;
      filteredOrders = orders;
    });
  }

  void _printOrders() {
    // Replace with actual print logic if needed
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Print Orders'),
        content: const Text('Printing orders...'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
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
        title: const Text('Order Management'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Redirect to the '/' route
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
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
                labelText: 'Search Orders',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                _loadOrders(query);
              },
            ),
            const SizedBox(height: 10),
            // Order List
            Expanded(
              child: filteredOrders.isEmpty
                  ? const Center(
                      child: Text(
                        'No orders found.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: Image.network(
                              order['imageUrl'] ??
                                  'https://via.placeholder.com/50',
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(order['item'] ?? 'Unknown Item'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Notes: ${order['notes'] ?? 'No notes'}'),
                                Text(
                                    'Status: ${order['status'] ?? 'Preparing'}'),
                              ],
                            ),
                            trailing: Text(
                              '\$${order['price']?.toStringAsFixed(2) ?? 'N/A'}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
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
    _orderBox.close();
    searchController.dispose();
    super.dispose();
  }
}
