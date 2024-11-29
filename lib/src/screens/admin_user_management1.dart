import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/user_management/user_management_bloc.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management"),
      ),
      body: BlocBuilder<UserManagementBloc, UserManagementState>(
        builder: (context, state) {
          if (state is UserManagementInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserManagementLoaded) {
            if (state.users.isEmpty) {
              return const Center(child: Text("No users found. Add some!"));
            }

            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(user.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(user.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showUserModal(context, user: user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => context
                              .read<UserManagementBloc>()
                              .add(DeleteUser(user.id)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text("Something went wrong."));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showUserModal(BuildContext context, {User? user}) {
    final nameController = TextEditingController(text: user?.name);
    final emailController = TextEditingController(text: user?.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user == null ? "Add User" : "Edit User"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final newUser = User(
                id: user?.id ?? DateTime.now().toIso8601String(),
                name: nameController.text,
                email: emailController.text,
              );

              if (user == null) {
                context.read<UserManagementBloc>().add(AddUser(newUser));
              } else {
                context.read<UserManagementBloc>().add(UpdateUser(newUser));
              }

              Navigator.of(context).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
