import 'package:hive/hive.dart';

class AccountRepository {
  final Box<Map> userBox;

  AccountRepository(this.userBox);

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
      await userBox.put('customer', {
        'username': 'customer',
        'password': 'customer123',
        'role': 'customer',
      });
    }
  }
}
