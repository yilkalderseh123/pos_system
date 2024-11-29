import 'package:flutter/material.dart';
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
  late Box<Map> userBox;

  @override
  void initState() {
    super.initState();
    initializeHive();
  }

  /// Initialize Hive and create sample data if the database is empty.
  Future<void> initializeHive() async {
    await Hive.initFlutter(); // Initialize Hive
    userBox = await Hive.openBox<Map>('userBox'); // Open the box for users
    if (userBox.isEmpty) {
      print('User box is empty, adding sample data...');
      // Add default sample users with usernames
      await userBox.put('admin', {
        'username': 'admin',
        'password': 'admin123',
        'role': 'Admin',
      });
      await userBox.put('manager', {
        'username': 'manager',
        'password': 'manager123',
        'role': 'Manager',
      });
      await userBox.put('cashier', {
        'username': 'cashier',
        'password': 'cashier123',
        'role': 'Cashier',
      });
      await userBox.put('kitchen', {
        'username': 'kitchen',
        'password': 'kitchen123',
        'role': 'Kitchen',
      });
      await userBox.put('waitstaff', {
        'username': 'waitstaff',
        'password': 'waitstaff123',
        'role': 'Waitstaff',
      });
    } else {
      print('User box already contains data');
    }
  }

  /// Validate login credentials and redirect to the appropriate screen.
  Future<void> login(BuildContext context) async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    try {
      // Check if username exists
      final userEntry = userBox.values.firstWhere(
        (user) =>
            user['username'].toString().toLowerCase() == username.toLowerCase(),
        orElse: () => {}, // Return empty map if user not found
      );

      // Check if userEntry is not empty
      if (userEntry.isNotEmpty) {
        final userPassword = userEntry['password'];
        final userRole = userEntry['role'];
        // Check if password matches
        if (userPassword == password) {
          final storedUsername = userEntry['username'];

          // Save session data
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('role', userRole ?? '');
          await prefs.setString('username', storedUsername ?? '');

          // Redirect based on role
          Widget destinationScreen;
          if (userRole == 'Admin') {
            destinationScreen = const AdminScreen();
          } else if (userRole == 'Manager') {
            destinationScreen = const ManagerScreen();
          } else if (userRole == 'Cashier') {
            destinationScreen = const CashierScreen();
          } else if (userRole == 'Kitchen') {
            destinationScreen = KitchenScreen();
          } else if (userRole == 'Waitstaff') {
            destinationScreen = const WaitstaffScreen();
          } else {
            // Default destination if no valid role is found
            destinationScreen = const DashboardScreen();
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome, $storedUsername!')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => destinationScreen),
          );
        } else {
          // Invalid password
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid password')),
          );
        }
      } else {
        // Username does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username not found')),
        );
      }
    } catch (e) {
      print('Login Error: $e'); // Print the exception to the console
      showError('An error occurred. Please try again.');
    }
  }

  // Show an error message
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                    const Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth < 600 ? screenWidth * 0.9 : 400,
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: usernameController,
                            decoration:
                                const InputDecoration(labelText: 'Username'),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: passwordController,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
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
