import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';
import 'admin_screen.dart';
import 'cashier_screen.dart';
import 'kitchen_screen.dart';
import 'manager_screen.dart';
import 'waitstaff_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
  String? selectedRole;

  @override
  void initState() {
    super.initState();
    initializeHive();
  }

  Future<void> initializeHive() async {
    await Hive.initFlutter(); // Ensure Hive is initialized
    final box = await Hive.openBox('userBox');

    if (box.isEmpty) {
      // Adding sample data for roles
      box.put('Admin', {'username': 'admin', 'password': 'admin123'});
      box.put('Manager', {'username': 'manager', 'password': 'manager123'});
      box.put('Cashier', {'username': 'cashier', 'password': 'cashier123'});
      box.put('Kitchen', {'username': 'kitchen', 'password': 'kitchen123'});
      box.put(
          'Waitstaff', {'username': 'waitstaff', 'password': 'waitstaff123'});
    }
  }

  Future<void> login(BuildContext context) async {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        selectedRole != null) {
      final box = await Hive.openBox('userBox');
      final roleData = box.get(selectedRole);

      if (roleData != null &&
          roleData['username'] == usernameController.text &&
          roleData['password'] == passwordController.text) {
        // Save session to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('role', selectedRole!);

        // Redirect based on the role
        Widget destinationScreen;
        switch (selectedRole) {
          case 'Admin':
            destinationScreen = const AdminScreen();
            break;
          case 'Manager':
            destinationScreen = const ManagerScreen();
            break;
          case 'Cashier':
            destinationScreen = const CashierScreen();
            break;
          case 'Kitchen':
            destinationScreen = KitchenScreen();
            break;
          case 'Waitstaff':
            destinationScreen = const WaitstaffScreen();
            break;
          default:
            destinationScreen = const DashboardScreen();
        }

        // Navigate to the destination screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      } else {
        // Invalid credentials
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
      }
    } else {
      // Missing fields
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select a role.')),
      );
    }
  }

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
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
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
                            decoration:
                                const InputDecoration(labelText: 'Username'),
                          ),
                          const SizedBox(height: 10),
                          // Password TextField
                          TextField(
                            controller: passwordController,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          // Role Selector Dropdown
                          DropdownButtonFormField<String>(
                            decoration:
                                const InputDecoration(labelText: 'Role'),
                            value: selectedRole,
                            items: roles.map((role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(role),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedRole = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          // Login Button
                          ElevatedButton(
                            onPressed: () => login(context),
                            child: const Text('Login'),
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
