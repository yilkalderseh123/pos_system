import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  late Box _userBox; // Use dynamic typing to handle values of any type
  final String boxName = 'users';

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    await Hive.initFlutter(); // Initialize Hive
    _userBox = await Hive.openBox(boxName); // Open the box
    setState(() {}); // Trigger a rebuild after the box is initialized
  }

  Future<void> _addUser(String name, String email, String role) async {
    final id = _userBox.length + 1;
    await _userBox
        .put(id, {"id": id, "name": name, "email": email, "role": role});
    setState(() {}); // Refresh UI after adding user
  }

  Future<void> _editUser(int key, Map<String, dynamic> updatedUser) async {
    await _userBox.put(key, updatedUser);
    setState(() {}); // Refresh UI after editing user
  }

  Future<void> _deleteUser(int key) async {
    await _userBox.delete(key);
    setState(() {}); // Refresh UI after deleting user
  }

  @override
  Widget build(BuildContext context) {
    if (_userBox.isOpen == false) {
      return const Scaffold(
        body: Center(
            child:
                CircularProgressIndicator()), // Show loading while initializing Hive
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
              child: ValueListenableBuilder(
                valueListenable: _userBox.listenable(),
                builder: (context, Box box, _) {
                  if (box.isEmpty) {
                    return const Center(child: Text("No users found."));
                  }

                  return ListView.builder(
                    itemCount: box.keys.length,
                    itemBuilder: (context, index) {
                      final key = box.keyAt(index);
                      final user = box.get(key);

                      // Safe type casting: Check the type before casting
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
                        return const SizedBox(); // Return an empty widget if casting fails
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddUserDialog() {
    String name = '';
    String email = '';
    String role = 'User';

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
                  _addUser(name, email, role);
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
