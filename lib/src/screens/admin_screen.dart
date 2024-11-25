import 'package:flutter/material.dart';
import './login_screen.dart'; // Ensure you import the LoginScreen
import './admin_user_management.dart';
import './admin_system_overview.dart';
import './admin_audit_logs.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Navigate to LoginScreen on logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin Dashboard Intro
            const Text(
              'Welcome, Admin! Manage your system effectively.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // User Management Section
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('User Management'),
                subtitle: const Text('Manage user accounts and permissions'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserManagementScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // System Overview Section
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('System Overview'),
                subtitle: const Text('Key metrics and system health'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminSystemOverviewPage(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Audit Logs Section
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Audit Logs'),
                subtitle: const Text('Track changes to the system'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuditLogsPage(),
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
