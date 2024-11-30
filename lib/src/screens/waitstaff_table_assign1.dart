import 'package:flutter/material.dart';

class TableAssignmentPage extends StatefulWidget {
  @override
  _TableAssignmentPageState createState() => _TableAssignmentPageState();
}

class _TableAssignmentPageState extends State<TableAssignmentPage> {
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
            decoration: InputDecoration(
              hintText: "Enter customer's name",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
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

  Widget buildTable(Map<String, dynamic> tableData, int index, double width) {
    return GestureDetector(
      onTap: tableData['isAvailable']
          ? () => assignTable(index)
          : null, // Only allow assigning if the table is available
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: tableData['isAvailable'] ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tableData['isAvailable'] ? Icons.check_circle : Icons.block,
              color: Colors.white,
              size: width * 0.1,
            ),
            SizedBox(height: 8),
            Text(
              'Table ${tableData['tableNumber']}',
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.04,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              tableData['isAvailable'] ? 'Available' : 'Occupied',
              style: TextStyle(
                color: Colors.white70,
                fontSize: width * 0.035,
              ),
              textAlign: TextAlign.center,
            ),
            if (!tableData['isAvailable'])
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Customer: ${tableData['customer']}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: width * 0.03,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis, // Prevent text overflow
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Table Assignment'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = (constraints.maxWidth < 600)
                ? 2
                : (constraints.maxWidth < 900)
                    ? 3
                    : 4;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1, // Ensures square-shaped grid items
              ),
              itemCount: tables.length,
              itemBuilder: (context, index) {
                return buildTable(tables[index], index, width);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            tables.add({
              'tableNumber': tables.length + 1,
              'isAvailable': true,
              'customer': ''
            });
          });
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
    );
  }
}
