import 'package:flutter/material.dart';
import './src/routes/app_routes.dart';

void main() {
  runApp(RestaurantPOSApp());
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
