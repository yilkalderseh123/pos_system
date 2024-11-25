import 'package:flutter/material.dart';

class AuditLogsPage extends StatelessWidget {
  // Sample log data
  final List<Map<String, String>> logs = [
    {
      'date': '2024-11-25',
      'time': '10:30 AM',
      'action': 'Inventory Updated',
      'details': 'Added 50 units of Coffee Beans',
      'user': 'Admin'
    },
    {
      'date': '2024-11-24',
      'time': '3:45 PM',
      'action': 'User Role Changed',
      'details': 'Changed John Doe to Manager role',
      'user': 'Super Admin'
    },
    {
      'date': '2024-11-23',
      'time': '12:15 PM',
      'action': 'Inventory Updated',
      'details': 'Removed 10 units of Milk',
      'user': 'Admin'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audit Logs'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(
                  Icons.event_note,
                  color: Colors.deepOrange,
                ),
                title: Text('${log['action']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: ${log['date']}'),
                    Text('Time: ${log['time']}'),
                    Text('Details: ${log['details']}'),
                    Text('User: ${log['user']}'),
                  ],
                ),
                isThreeLine: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
