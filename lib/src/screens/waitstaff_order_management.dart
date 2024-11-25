import 'package:flutter/material.dart';

class OrderManagementPage extends StatefulWidget {
  @override
  _OrderManagementPageState createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  final List<Map<String, String>> menuItems = [
    {'name': 'Pizza', 'category': 'Main'},
    {'name': 'Burger', 'category': 'Main'},
    {'name': 'Salad', 'category': 'Side'},
    {'name': 'Soup', 'category': 'Starter'},
    {'name': 'Ice Cream', 'category': 'Dessert'},
  ];

  List<Map<String, String>> filteredMenuItems = [];
  List<Map<String, dynamic>> orderItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredMenuItems = menuItems;
  }

  void filterMenuItems(String query) {
    setState(() {
      filteredMenuItems = menuItems
          .where((item) =>
              item['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void addToOrder(String itemName) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController noteController = TextEditingController();
        return AlertDialog(
          title: Text('Add Notes for $itemName'),
          content: TextField(
            controller: noteController,
            decoration: InputDecoration(
                hintText: "Enter your notes (e.g., extra spicy)"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  orderItems.add({
                    'item': itemName,
                    'notes': noteController.text,
                    'status': 'Preparing'
                  });
                });
                Navigator.of(context).pop();
              },
              child: Text('Add to Order'),
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
      appBar: AppBar(title: Text('Order Management')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              onChanged: filterMenuItems,
              decoration: InputDecoration(
                labelText: 'Search Menu',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 10),
            // Menu List
            Expanded(
              child: ListView.builder(
                itemCount: filteredMenuItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredMenuItems[index]['name']!),
                    subtitle: Text(filteredMenuItems[index]['category']!),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        addToOrder(filteredMenuItems[index]['name']!);
                      },
                    ),
                  );
                },
              ),
            ),
            Divider(),
            // Order List
            Text('Order Items:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: orderItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(orderItems[index]['item']),
                    subtitle: Text(orderItems[index]['notes']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(orderItems[index]['status']),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () =>
                              updateOrderStatus(index, 'Preparing'),
                        ),
                        IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () => updateOrderStatus(index, 'Ready'),
                        ),
                        IconButton(
                          icon: Icon(Icons.check_circle),
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
}
