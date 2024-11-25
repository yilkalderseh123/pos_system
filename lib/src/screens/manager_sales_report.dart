import 'package:flutter/material.dart';

class ManagerSalesReportPage extends StatefulWidget {
  @override
  _ManagerSalesReportPageState createState() => _ManagerSalesReportPageState();
}

class _ManagerSalesReportPageState extends State<ManagerSalesReportPage> {
  // Sample Sales Data
  final List<Map<String, dynamic>> salesData = [
    {
      'period': 'Daily',
      'sales': 1500,
      'topItem': 'Pizza',
      'busiestTime': '7 PM'
    },
    {
      'period': 'Weekly',
      'sales': 10500,
      'topItem': 'Burger',
      'busiestTime': '8 PM'
    },
    {
      'period': 'Monthly',
      'sales': 45000,
      'topItem': 'Pasta',
      'busiestTime': '6 PM'
    },
  ];

  // Sample Metrics Data
  final List<Map<String, dynamic>> keyMetrics = [
    {'title': 'Top-Selling Item', 'value': 'Burger'},
    {'title': 'Total Sales Today', 'value': '\$1,500'},
    {'title': 'Busiest Time', 'value': '7 PM'},
  ];

  String selectedPeriod = 'Daily';

  @override
  Widget build(BuildContext context) {
    // Find the sales data for the selected period
    final currentSalesData =
        salesData.firstWhere((data) => data['period'] == selectedPeriod);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manager Sales Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            DropdownButton<String>(
              value: selectedPeriod,
              onChanged: (value) {
                setState(() {
                  selectedPeriod = value!;
                });
              },
              items: salesData
                  .map((data) => DropdownMenuItem<String>(
                        value: data['period'],
                        child: Text(data['period']),
                      ))
                  .toList(),
            ),
            SizedBox(height: 20),

            // Sales Overview
            Card(
              color: Colors.blue.shade50,
              margin: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${currentSalesData['period']} Sales Overview',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text('Total Sales: \$${currentSalesData['sales']}'),
                    Text('Top-Selling Item: ${currentSalesData['topItem']}'),
                    Text('Busiest Time: ${currentSalesData['busiestTime']}'),
                  ],
                ),
              ),
            ),

            // Key Metrics
            Text(
              'Key Metrics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: keyMetrics.length,
                itemBuilder: (context, index) {
                  var metric = keyMetrics[index];
                  return ListTile(
                    leading: Icon(Icons.analytics, color: Colors.blue),
                    title: Text(metric['title']),
                    trailing: Text(
                      metric['value'],
                      style: TextStyle(fontWeight: FontWeight.bold),
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
