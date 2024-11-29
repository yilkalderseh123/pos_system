import 'package:hive/hive.dart';

class UserRepository {
  final Box<Map> userBox;

  UserRepository(this.userBox);

  Future<void> initializeDefaultUsers() async {
    if (userBox.isEmpty) {
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
    }
  }
}
