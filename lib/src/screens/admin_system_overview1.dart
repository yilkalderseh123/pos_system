import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AdminSystemOverviewPage extends StatefulWidget {
  @override
  _AdminSystemOverviewPageState createState() =>
      _AdminSystemOverviewPageState();
}

class _AdminSystemOverviewPageState extends State<AdminSystemOverviewPage> {
  late Box _metricsBox;
  final String boxName = 'adminMetrics';

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    await Hive.initFlutter(); // Initialize Hive
    _metricsBox = await Hive.openBox(boxName);

    // Add example data to the box if it's empty
    if (_metricsBox.isEmpty) {
      _metricsBox.put('metrics', {
        'totalUsers': 120,
        'activeUsers': 45,
        'uptime': '99.9%',
        'alerts': [
          'Low inventory for Item #123 (Pasta)',
          'Unusual payment activity detected',
        ],
      });
    }
    setState(() {}); // Rebuild UI after initializing Hive
  }

  Map<String, dynamic>? _fetchMetrics() {
    // Fetch metrics from the Hive box and cast it to Map<String, dynamic> if it exists
    var data = _metricsBox.get('metrics');
    if (data != null) {
      return Map<String, dynamic>.from(data); // Cast to Map<String, dynamic>
    }
    return null;
  }

  Future<void> _updateMetrics() async {
    // Simulate updating metrics (in a real app, replace this with an API call or actual data update logic)
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    _metricsBox.put('metrics', {
      'totalUsers': 125,
      'activeUsers': 50,
      'uptime': '99.8%',
      'alerts': [
        'System downtime detected at 3 AM',
        'New user registration spike noticed',
      ],
    });
    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    if (!Hive.isBoxOpen(boxName)) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final data = _fetchMetrics();

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin System Overview'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _updateMetrics();
            },
          ),
        ],
      ),
      body: data == null
          ? Center(child: Text('No data available'))
          : SingleChildScrollView(
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
            ),
    );
  }

  @override
  void dispose() {
    _metricsBox.close(); // Close the Hive box when the widget is disposed
    super.dispose();
  }
}
