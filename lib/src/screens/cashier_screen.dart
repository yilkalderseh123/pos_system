import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import './cashier_reciets.dart';

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

  Future<void> _printOrder(Map<String, dynamic> order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Receipt',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.Divider(),
            pw.Text('Item: ${order['item']}'),
            pw.Text('Notes: ${order['notes']}'),
            pw.Text('Status: ${order['status']}'),
            pw.Text('Price: \$${order['price']?.toStringAsFixed(2) ?? 'N/A'}'),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '\$${order['price']?.toStringAsFixed(2) ?? '10 Birr'}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.print),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReceiptScreen(order: order),
                                      ),
                                    );
                                  },
                                ),
                              ],
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
