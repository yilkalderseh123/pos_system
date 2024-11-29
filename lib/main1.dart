import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/blocs/auth/auth_bloc.dart';
import 'src/repositories/accounts_repository.dart';
import 'src/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  final userBox = await Hive.openBox<Map>('userBox');
  final userRepository = AccountRepository(userBox);
  await userRepository.initializeDefaultUsers();

  runApp(RestaurantPOSApp(userBox: userBox));
}

class RestaurantPOSApp extends StatelessWidget {
  final Box<Map> userBox;

  const RestaurantPOSApp({required this.userBox, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(userBox), // Now it matches the constructor
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.login_screen,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
