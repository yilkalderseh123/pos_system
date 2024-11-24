import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'admin_screen.dart';
import 'cashier_screen.dart';
import 'kitchen_screen.dart';
import 'manager_screen.dart';
import 'waitstaff_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // List of roles
  final List<String> roles = [
    'Admin',
    'Manager',
    'Cashier',
    'Kitchen',
    'Waitstaff'
  ];

  // Variable to hold selected role
  final ValueNotifier<String?> selectedRole = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.of(context).size.width;

          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Centered Title
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Login Form
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth < 600 ? screenWidth * 0.9 : 400,
                      ),
                      child: Column(
                        children: [
                          // Username TextField
                          TextField(
                            controller: usernameController,
                            decoration: InputDecoration(labelText: 'Username'),
                          ),
                          SizedBox(height: 10),
                          // Password TextField
                          TextField(
                            controller: passwordController,
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                          ),
                          SizedBox(height: 20),
                          // Role Selector Dropdown
                          ValueListenableBuilder<String?>(
                            valueListenable: selectedRole,
                            builder: (context, value, child) {
                              return DropdownButtonFormField<String>(
                                decoration: InputDecoration(labelText: 'Role'),
                                value: value,
                                items: roles.map((role) {
                                  return DropdownMenuItem<String>(
                                    value: role,
                                    child: Text(role),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  selectedRole.value = newValue;
                                },
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          // Login Button
                          ElevatedButton(
                            onPressed: () {
                              if (usernameController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty &&
                                  selectedRole.value != null) {
                                // Redirect based on the role
                                Widget destinationScreen;
                                switch (selectedRole.value) {
                                  case 'Admin':
                                    destinationScreen = AdminScreen();
                                    break;
                                  case 'Manager':
                                    destinationScreen = ManagerScreen();
                                    break;
                                  case 'Cashier':
                                    destinationScreen = CashierScreen();
                                    break;
                                  case 'Kitchen':
                                    destinationScreen = KitchenScreen();
                                    break;
                                  case 'Waitstaff':
                                    destinationScreen = WaitstaffScreen();
                                    break;
                                  default:
                                    destinationScreen = DashboardScreen();
                                }

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => destinationScreen,
                                  ),
                                );
                              } else {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Please fill all fields and select a role.')),
                                );
                              }
                            },
                            child: Text('Login'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
