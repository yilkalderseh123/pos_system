import 'package:flutter/material.dart';
import './src/routes/app_routes.dart';

void main() {
  runApp(RestaurantPOSApp());
}

class RestaurantPOSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login_screen,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
