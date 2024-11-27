import 'package:flutter/material.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final List<Map<String, dynamic>> _users = [
    {"id": 1, "name": "John Doe", "email": "john@example.com", "role": "Admin"},
    {
      "id": 2,
      "name": "Jane Smith",
      "email": "jane@example.com",
      "role": "Editor"
    },
  ];

  void _addUser() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String email = '';
        String role = 'User';

        return AlertDialog(
          title: const Text("Add User"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Name"),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Email"),
                onChanged: (value) => email = value,
              ),
              DropdownButtonFormField<String>(
                value: role,
                items: const [
                  DropdownMenuItem(value: 'User', child: Text('User')),
                  DropdownMenuItem(value: 'Editor', child: Text('Editor')),
                  DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                ],
                onChanged: (value) => role = value ?? 'User',
                decoration: const InputDecoration(labelText: "Role"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty && email.isNotEmpty) {
                  setState(() {
                    _users.add({
                      "id": _users.length + 1,
                      "name": name,
                      "email": email,
                      "role": role
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _editUser(int index) {
    showDialog(
      context: context,
      builder: (context) {
        String name = _users[index]['name'];
        String email = _users[index]['email'];
        String role = _users[index]['role'];

        return AlertDialog(
          title: const Text("Edit User"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Name"),
                controller: TextEditingController(text: name),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Email"),
                controller: TextEditingController(text: email),
                onChanged: (value) => email = value,
              ),
              DropdownButtonFormField<String>(
                value: role,
                items: const [
                  DropdownMenuItem(value: 'User', child: Text('User')),
                  DropdownMenuItem(value: 'Editor', child: Text('Editor')),
                  DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                ],
                onChanged: (value) => role = value ?? role,
                decoration: const InputDecoration(labelText: "Role"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _users[index] = {
                    "id": _users[index]['id'],
                    "name": name,
                    "email": email,
                    "role": role
                  };
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete User"),
          content: const Text("Are you sure you want to delete this user?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _users.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _addUser,
              icon: const Icon(Icons.add),
              label: const Text("Add User"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(user['name'][0]),
                      ),
                      title: Text(user['name']),
                      subtitle: Text(
                          "Email: ${user['email']}\nRole: ${user['role']}"),
                      isThreeLine: true,
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editUser(index);
                          } else if (value == 'delete') {
                            _deleteUser(index);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                              value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(
                              value: 'delete', child: Text('Delete')),
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
}
