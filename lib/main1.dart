import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './src/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open the necessary boxes (you can add more boxes as required)
  await Hive.openBox('transactionsBox');

  runApp(const RestaurantPOSApp());
}

class RestaurantPOSApp extends StatelessWidget {
  const RestaurantPOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login_screen,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
