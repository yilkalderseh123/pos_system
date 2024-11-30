import 'package:flutter/material.dart';
import '../screens/admin_screen.dart';
import '../screens/cashier_screen.dart';
import '../screens/login_screen.dart';
import '../screens/kitchen_screen.dart';
import '../screens/manager_screen.dart';
import '../screens/waitstaff_screen.dart';
import '../screens/customer_screen.dart';

/// A utility class for managing app routes.
class AppRoutes {
  // Route names as constants
  static const String login_screen = '/';
  static const String admin_screen = '/admin_screen';
  static const String cashier_screen = '/cashier_screen';
  static const String dashboard_screen = '/dashboard_screen';
  static const String kitchen_screen = '/kitchen_screen';
  static const String manager_screen = '/manager_screen';
  static const String menu_screen = '/menu_screen';
  static const String waitstaff_screen = '/waitstaff_screen';
  static const String customer_screen = '/customer_screen';

  /// Method to configure all routes.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login_screen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case admin_screen:
        return MaterialPageRoute(builder: (_) => const AdminScreen());
      case cashier_screen:
        return MaterialPageRoute(builder: (_) => const CashierScreen());
      case kitchen_screen:
        return MaterialPageRoute(builder: (_) => KitchenScreen());
      case manager_screen:
        return MaterialPageRoute(builder: (_) => const ManagerScreen());
      case waitstaff_screen:
        return MaterialPageRoute(builder: (_) => const WaitstaffScreen());
      case customer_screen:
        return MaterialPageRoute(builder: (_) => const OrderManagementPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
    }
  }
}
