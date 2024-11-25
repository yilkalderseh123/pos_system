import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// Events
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginUsernameChanged extends LoginEvent {
  final String username;
  const LoginUsernameChanged(this.username);

  @override
  List<Object> get props => [username];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  const LoginPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class LoginSubmitted extends LoginEvent {
  final String role; // Add the role parameter

  const LoginSubmitted(
      {required this.role}); // Constructor to initialize the role

  @override
  List<Object> get props => [role]; // Include role in the props for comparison
}

// States
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;
  const LoginFailure(this.error);

  @override
  List<Object> get props => [error];
}

// Bloc
class LoginBloc extends HydratedBloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginSubmitted) {
      yield LoginLoading();
      // Simulate authentication logic
      await Future.delayed(const Duration(seconds: 2));

      // You can add custom logic based on the role here if needed
      if (event.role == 'Cashier') {
        yield LoginSuccess(); // Handle Cashier role login success
      } else if (event.role == 'Manager') {
        yield LoginSuccess(); // Handle Manager role login success
      } else if (event.role == 'Waitstaff') {
        yield LoginSuccess(); // Handle Waitstaff role login success
      } else {
        yield LoginSuccess(); // Default success case
      }
    }
  }

  @override
  LoginState? fromJson(Map<String, dynamic> json) {
    return LoginInitial();
  }

  @override
  Map<String, dynamic>? toJson(LoginState state) {
    return {};
  }
}
