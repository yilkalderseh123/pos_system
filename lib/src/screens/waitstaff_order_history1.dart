import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  // Sample Order History Data
  final List<Map<String, dynamic>> orderHistory = [
    {
      'orderId': '1234',
      'orderDate': '2024-11-20',
      'items': [
        {'name': 'Pizza', 'notes': 'extra spicy', 'status': 'Served'},
        {'name': 'Salad', 'notes': 'no dressing', 'status': 'Served'},
      ]
    },
    {
      'orderId': '1235',
      'orderDate': '2024-11-19',
      'items': [
        {'name': 'Burger', 'notes': 'extra cheese', 'status': 'Ready'},
        {
          'name': 'Ice Cream',
          'notes': 'chocolate flavor',
          'status': 'Preparing'
        },
      ]
    },
    {
      'orderId': '1236',
      'orderDate': '2024-11-18',
      'items': [
        {'name': 'Soup', 'notes': 'no salt', 'status': 'Served'},
        {'name': 'Pizza', 'notes': 'extra olives', 'status': 'Served'},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order History')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: orderHistory.length,
          itemBuilder: (context, index) {
            var order = orderHistory[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: ${order['orderId']}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'Date: ${order['orderDate']}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: order['items']
                          .map<Widget>((item) => ListTile(
                                title: Text(item['name']),
                                subtitle: Text(item['notes']),
                                trailing: Text(item['status']),
                              ))
                          .toList(),
                    ),
                    Divider(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
