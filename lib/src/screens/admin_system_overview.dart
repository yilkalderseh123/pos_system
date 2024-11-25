import 'package:flutter/material.dart';

class AdminSystemOverviewPage extends StatefulWidget {
  @override
  _AdminSystemOverviewPageState createState() =>
      _AdminSystemOverviewPageState();
}

class _AdminSystemOverviewPageState extends State<AdminSystemOverviewPage> {
  // Example data (Replace this with API calls or database queries)
  Future<Map<String, dynamic>> fetchMetrics() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    return {
      'totalUsers': 120,
      'activeUsers': 45,
      'uptime': '99.9%',
      'alerts': [
        'Low inventory for Item #123 (Pasta)',
        'Unusual payment activity detected',
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin System Overview'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchMetrics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else {
            final data = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Key Metrics',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      title: Text('Total Users'),
                      trailing: Text(data['totalUsers'].toString()),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('Active Users'),
                      trailing: Text(data['activeUsers'].toString()),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('System Uptime'),
                      trailing: Text(data['uptime']),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Alerts',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  if (data['alerts'].isEmpty)
                    Text('No critical issues reported.',
                        style: TextStyle(color: Colors.green, fontSize: 16)),
                  for (var alert in data['alerts'])
                    Card(
                      color: Colors.red[100],
                      child: ListTile(
                        leading: Icon(Icons.warning, color: Colors.red),
                        title: Text(alert),
                      ),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
