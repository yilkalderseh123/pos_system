import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  late Box _userBox;
  final String boxName = 'users';
  String _selectedRole = 'User'; // Initialize the default role

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    // Set Hive directory to application documents directory
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    _userBox = await Hive.openBox(boxName);
    setState(() {});
  }

  Future<void> _addUser(String name, String email, String role) async {
    final id = _userBox.length + 1;
    await _userBox
        .put(id, {"id": id, "name": name, "email": email, "role": role});
    setState(() {});
  }

  Future<void> _editUser(int key, Map<String, dynamic> updatedUser) async {
    await _userBox.put(key, updatedUser);
    setState(() {});
  }

  Future<void> _deleteUser(int key) async {
    await _userBox.delete(key);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_userBox.isOpen == false) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () => _showAddUserDialog(),
              icon: const Icon(Icons.add),
              label: const Text("Add User"),
            ),
            const SizedBox(height: 20),
            Expanded(
                child: _userBox.isEmpty
                    ? const Center(child: Text('No users added.'))
                    : ListView.builder(
                        itemCount: _userBox.keys.length,
                        itemBuilder: (context, index) {
                          final key = _userBox.keyAt(index);
                          final user = _userBox.get(key);

                          if (user is Map<String, dynamic>) {
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
                                      _showEditUserDialog(key, user);
                                    } else if (value == 'delete') {
                                      _deleteUser(key);
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
                          } else {
                            return const SizedBox();
                          }
                        },
                      )),
          ],
        ),
      ),
    );
  }

  void _showAddUserDialog() {
    String name = '';
    String email = '';

    showDialog(
      context: context,
      builder: (context) {
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
                value: _selectedRole,
                items: const [
                  DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'Manager', child: Text('Manager')),
                  DropdownMenuItem(value: 'Cashier', child: Text('Cashier')),
                  DropdownMenuItem(value: 'Kitchen', child: Text('Kitchen')),
                  DropdownMenuItem(
                      value: 'Waitstaff', child: Text('Waitstaff')),
                  DropdownMenuItem(value: 'User', child: Text('User')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedRole = value;
                    });
                  }
                },
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
                  _addUser(name, email, _selectedRole);
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

  void _showEditUserDialog(int key, Map<String, dynamic> user) {
    String name = user['name'];
    String email = user['email'];
    String role = user['role'];

    showDialog(
      context: context,
      builder: (context) {
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
                  DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'Manager', child: Text('Manager')),
                  DropdownMenuItem(value: 'Cashier', child: Text('Cashier')),
                  DropdownMenuItem(value: 'Kitchen', child: Text('Kitchen')),
                  DropdownMenuItem(
                      value: 'Waitstaff', child: Text('Waitstaff')),
                  DropdownMenuItem(value: 'User', child: Text('User')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      role = value;
                    });
                  }
                },
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
                _editUser(key,
                    {"id": key, "name": name, "email": email, "role": role});
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
