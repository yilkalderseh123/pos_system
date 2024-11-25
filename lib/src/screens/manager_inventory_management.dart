import 'package:flutter/material.dart';

class InventoryItem {
  String name;
  int stock;
  int reorderThreshold;

  InventoryItem({
    required this.name,
    required this.stock,
    required this.reorderThreshold,
  });
}

class InventoryManagementPage extends StatefulWidget {
  @override
  _InventoryManagementPageState createState() =>
      _InventoryManagementPageState();
}

class _InventoryManagementPageState extends State<InventoryManagementPage> {
  final List<InventoryItem> inventory = [
    InventoryItem(name: 'Tomatoes', stock: 50, reorderThreshold: 20),
    InventoryItem(name: 'Cheese', stock: 10, reorderThreshold: 5),
    InventoryItem(name: 'Chicken', stock: 30, reorderThreshold: 10),
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController reorderController = TextEditingController();

  void _addOrEditItem({InventoryItem? existingItem}) {
    nameController.text = existingItem?.name ?? '';
    stockController.text =
        existingItem != null ? existingItem.stock.toString() : '';
    reorderController.text =
        existingItem != null ? existingItem.reorderThreshold.toString() : '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existingItem == null ? 'Add Item' : 'Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: stockController,
              decoration: InputDecoration(labelText: 'Stock Level'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: reorderController,
              decoration: InputDecoration(labelText: 'Reorder Threshold'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text;
              final stock = int.tryParse(stockController.text) ?? 0;
              final reorderThreshold =
                  int.tryParse(reorderController.text) ?? 0;

              setState(() {
                if (existingItem != null) {
                  // Edit existing item
                  existingItem.name = name;
                  existingItem.stock = stock;
                  existingItem.reorderThreshold = reorderThreshold;
                } else {
                  // Add new item
                  inventory.add(InventoryItem(
                    name: name,
                    stock: stock,
                    reorderThreshold: reorderThreshold,
                  ));
                }
              });
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteItem(InventoryItem item) {
    setState(() {
      inventory.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: inventory.length,
                itemBuilder: (context, index) {
                  final item = inventory[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(
                          'Stock: ${item.stock}, Reorder Threshold: ${item.reorderThreshold}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _addOrEditItem(existingItem: item),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteItem(item),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _addOrEditItem(),
              child: Text('Add New Item'),
            ),
          ],
        ),
      ),
    );
  }
}
