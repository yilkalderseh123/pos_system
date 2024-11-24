import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Add logout functionality here
              Navigator.pop(context); // For now, just go back
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
              'Welcome, Admin! Manage users, view reports, and configure settings.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Manage Users Section
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Manage Users'),
                subtitle: const Text('Add, edit, or remove users'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to the Manage Users page (you can create a user management page)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageUsersScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // View Reports Section
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.report),
                title: const Text('View Reports'),
                subtitle: const Text('Sales reports, order analytics'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to View Reports page (you can create a reports page)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewReportsScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // System Settings Section
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('System Settings'),
                subtitle: const Text('Configure system-level settings'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to the System Settings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SystemSettingsScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
      ),
      body: Center(
        child: const Text('Manage Users Screen'),
      ),
    );
  }
}

class ViewReportsScreen extends StatelessWidget {
  const ViewReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Reports'),
      ),
      body: Center(
        child: const Text('View Reports Screen'),
      ),
    );
  }
}

class SystemSettingsScreen extends StatelessWidget {
  const SystemSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Settings'),
      ),
      body: Center(
        child: const Text('System Settings Screen'),
      ),
    );
  }
}
