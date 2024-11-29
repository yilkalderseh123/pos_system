import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/user_management/user_management_bloc.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  final List<String> roles = const [
    'Admin',
    'Manager',
    'Cashier',
    'Waitstaff',
    'Kitchen'
  ];

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
                    title: Text("${user.firstName} ${user.lastName}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Phone: ${user.phoneNumber}"),
                        Text("Email: ${user.email}"),
                        Text("Role: ${user.role}"),
                      ],
                    ),
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
    final firstNameController = TextEditingController(text: user?.firstName);
    final lastNameController = TextEditingController(text: user?.lastName);
    final phoneController = TextEditingController(text: user?.phoneNumber);
    final emailController = TextEditingController(text: user?.email);
    String selectedRole = user?.role ?? roles.first;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user == null ? "Add User" : "Edit User"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: "First Name"),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: "Last Name"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: roles.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (role) {
                  if (role != null) {
                    selectedRole = role;
                  }
                },
                decoration: const InputDecoration(labelText: "Role"),
              ),
            ],
          ),
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
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                phoneNumber: phoneController.text,
                email: emailController.text,
                role: selectedRole,
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
