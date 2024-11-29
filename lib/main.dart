import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/blocs/auth/auth_bloc.dart';
import 'src/blocs/user_management/user_management_bloc.dart';
import 'src/repositories/accounts_repository.dart';
import 'src/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open the necessary boxes
  await Hive.initFlutter();
  // await Hive.deleteBoxFromDisk('accountBox'); // Clear for clean testing
  final accountBox = await Hive.openBox<Map>('accountBox');
  // await Hive.deleteBoxFromDisk('userBox'); // Clear for clean testing
  final userBox = await Hive.openBox<Map>('userBox');

  // Initialize account repository and default users
  final accountRepository = AccountRepository(accountBox);
  await accountRepository.initializeDefaultUsers();

  runApp(RestaurantPOSApp(
    userBox: userBox,
    accountBox: accountBox,
  ));
}

class RestaurantPOSApp extends StatelessWidget {
  final Box<Map> userBox;
  final Box<Map> accountBox;

  const RestaurantPOSApp({
    required this.userBox,
    required this.accountBox,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide the AuthBloc
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(accountBox),
        ),
        // Provide the UserManagementBloc
        BlocProvider<UserManagementBloc>(
          create: (_) => UserManagementBloc(userBox: userBox)..add(LoadUsers()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.login_screen, // Default screen is login
        onGenerateRoute: AppRoutes.generateRoute, // Handle routes dynamically
      ),
    );
  }
}
