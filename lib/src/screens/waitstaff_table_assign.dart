import 'package:flutter/material.dart';

class TableAssignmentPage extends StatefulWidget {
  @override
  _TableAssignmentPageState createState() => _TableAssignmentPageState();
}

class _TableAssignmentPageState extends State<TableAssignmentPage> {
  // Sample Table Data with availability and assigned customer names
  List<Map<String, dynamic>> tables = [
    {'tableNumber': 1, 'isAvailable': true, 'customer': ''},
    {'tableNumber': 2, 'isAvailable': false, 'customer': 'John Doe'},
    {'tableNumber': 3, 'isAvailable': true, 'customer': ''},
    {'tableNumber': 4, 'isAvailable': false, 'customer': 'Jane Smith'},
    {'tableNumber': 5, 'isAvailable': true, 'customer': ''},
    {'tableNumber': 6, 'isAvailable': false, 'customer': 'Alice Brown'},
  ];

  void assignTable(int tableIndex) {
    TextEditingController customerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              'Assign Customer to Table ${tables[tableIndex]['tableNumber']}'),
          content: TextField(
            controller: customerController,
            decoration: InputDecoration(hintText: "Enter customer's name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  tables[tableIndex]['isAvailable'] = false;
                  tables[tableIndex]['customer'] = customerController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Assign'),
            ),
          ],
        );
      },
    );
  }

  Widget buildTable(Map<String, dynamic> tableData, int index) {
    return GestureDetector(
      onTap: tableData['isAvailable']
          ? () => assignTable(index)
          : null, // Only allow assigning if the table is available
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: tableData['isAvailable'] ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Table ${tableData['tableNumber']}',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 5),
              Text(
                tableData['isAvailable'] ? 'Available' : 'Occupied',
                style: TextStyle(color: Colors.white70),
              ),
              if (!tableData['isAvailable'])
                Text(
                  'Customer: ${tableData['customer']}',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Table Assignment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: tables.length,
          itemBuilder: (context, index) {
            return buildTable(tables[index], index);
          },
        ),
      ),
    );
  }
}
